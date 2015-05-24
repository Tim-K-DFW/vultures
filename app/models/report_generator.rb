class ReportGenerator
  attr_reader :engine, :portfolio
  attr_accessor :resuts

  def initialize(engine)
    @engine = engine
    @portfolio = engine.portfolio
    @results = {}
  end

  def generate
    @results[:parameters] = @engine.parameters
    @results[:performance] = generate_performance
    @results[:aggregated] = aggregated_performance(@results[:performance])
    @results[:positions] = generate_positions
    @results
  end

  def generate_performance
    result = []
    portfolio.periods.each do |end_date, state|
      next if end_date == portfolio.periods.first[0]
      this_period = {}
      this_period[:date] = end_date
      this_period[:balance] = portfolio.as_of(end_date)[:total_market_value]
      this_period[:sp500_value] = PricePoint.where(cid: 'sp500', period: end_date).first.price

      this_period[:by_period] = relative_return(single_period_start(end_date), end_date)
      this_period[:annualized] = annualized_return(this_period[:by_period])
      this_period[:cumulative_cy] = relative_return(cumulative_cy_start(end_date), end_date)
      this_period[:rolling_12_months] = relative_return(rolling_12_months_start(end_date), end_date)
      result << this_period
    end
    result
  end

  def aggregated_performance(by_period_results)
    result = {}
    start_date = result[:start_date] = portfolio.periods.first[0]
    end_date = result[:end_date] = portfolio.periods.keys.last
    result[:table] = {}

    result[:table][:geometric] = geometric_average(start_date, end_date)
    result[:table][:arithmetic] = arithmetic_average(start_date, end_date, by_period_results)
    result[:table][:st_deviation_by_period] = st_deviation_by_period(start_date, end_date, by_period_results)
    result[:table][:st_deviation_annualized] = st_deviation_annualized(start_date, end_date, by_period_results)
    result[:table][:sharpe] = sharpe(result[:table])
    result[:table][:max_drawdown] = max_drawdown_hash(engine.parameters[:initial_balance], by_period_results)

    result
  end

  def generate_positions

  end

  def relative_return(beginning, ending)
    result = {}
    current_balance = portfolio.as_of(ending)[:total_market_value]
    previous_period_balance = portfolio.as_of(beginning)[:total_market_value]
    result[:return] = (current_balance / previous_period_balance - 1).round(4)
    result[:sp500_return] = (sp500_return(beginning, ending)).round(4)
    result
  end

  def annualized_return(by_period_results)
    result = {}
    compounding = case engine.parameters[:rebalance_frequency]
    when 'annual'
      1
    when 'semi-annual'
      2
    when 'quarterly'
      4
    when 'monthly'
      12
    end
    result[:return] = (((by_period_results[:return] + 1) ** compounding) - 1).round(4)
    result[:sp500_return] = (((by_period_results[:sp500_return] + 1) ** compounding) - 1).round(4)
    result
  end

  def sp500_return(beginning, ending)
    beginning_value = PricePoint.where(cid: 'sp500', period: beginning).first.price
    ending_value = PricePoint.where(cid: 'sp500', period: ending).first.price
    (ending_value / beginning_value - 1).round(4)
  end

  def single_period_start(ending_date)
    case engine.parameters[:rebalance_frequency]
    when 'annual'
      (Date.strptime(ending_date, '%Y-%m-%d') - 1.year).to_s
    end
  end

  def cumulative_cy_start(ending_date)
    case engine.parameters[:rebalance_frequency]
    when 'annual'
      (Date.strptime(ending_date, '%Y-%m-%d') - 1.year).to_s
    end
  end

  def rolling_12_months_start(ending_date)
    case engine.parameters[:rebalance_frequency]
    when 'annual'
      (Date.strptime(ending_date, '%Y-%m-%d') - 1.year).to_s
    end
  end

  def geometric_average(start_date, end_date)
    result = {}
    result[:description] = 'Geometric average return'

    beginning_balance = portfolio.as_of(start_date)[:total_market_value]
    ending_balance = portfolio.as_of(end_date)[:total_market_value]
    result[:portfolio] = ((ending_balance / beginning_balance) ** (1.0 / portfolio.periods.count) - 1).round(4)

    sp500_beginning_balance = PricePoint.where(cid: 'sp500', period: start_date).first.price
    sp500_ending_balance = PricePoint.where(cid: 'sp500', period: end_date).first.price
    result[:sp500] = ((sp500_ending_balance / sp500_beginning_balance) ** (1.0 / portfolio.periods.count) - 1).round(4)
    result
  end

  def arithmetic_average(start_date, end_date, by_period_results)
    result = {}
    result[:description] = 'Arithmetic average return'

    returns = by_period_results.map{|v| v[:by_period]}.map{|v| v[:return]}
    result[:portfolio] = (returns.inject{ |sum, el| sum + el }.to_f / returns.size).round(4)

    returns = by_period_results.map{|v| v[:by_period]}.map{|v| v[:sp500_return]}
    result[:sp500] = (returns.inject{ |sum, el| sum + el }.to_f / returns.size).round(4)

    result
  end

  def st_deviation_by_period(start_date, end_date, by_period_results)
    result = {}
    result[:description] = 'Standard deviation of returns, by period'
    result[:portfolio] = by_period_results.map{|v| v[:by_period]}.map{|v| v[:return]}.standard_deviation.round(4)
    result[:sp500] = by_period_results.map{|v| v[:by_period]}.map{|v| v[:sp500_return]}.standard_deviation.round(4)
    result
  end

   def st_deviation_annualized(start_date, end_date, by_period_results)
    result = {}
    result[:description] = 'Standard deviation of returns, annualized'
    result[:portfolio] = by_period_results.map{|v| v[:annualized]}.map{|v| v[:return]}.standard_deviation.round(4)
    result[:sp500] = by_period_results.map{|v| v[:annualized]}.map{|v| v[:sp500_return]}.standard_deviation.round(4)
    result
  end

  def sharpe(inputs)
    result = {}
    result[:description] = 'Sharpe ratio (based on geometric average and rf = 4%)'
    result[:portfolio] = ((inputs[:geometric][:portfolio] - 0.04) / inputs[:st_deviation_annualized][:portfolio]).round(3)
    result[:sp500] = ((inputs[:geometric][:sp500] - 0.04) / inputs[:st_deviation_annualized][:sp500]).round(3)
    result
  end

  def max_drawdown_hash(initial_balance, by_period_results)
    result = {}
    result[:portfolio] = max_drawdown(by_period_results.map{|k| k[:balance]})
    result[:sp500] = max_drawdown(by_period_results.map{|k| k[:sp500_value]})
    result
  end

  def max_drawdown(price_points)
    555
  end
end
