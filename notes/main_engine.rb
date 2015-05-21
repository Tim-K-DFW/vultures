class Engine
  attr_reader :parameters

  def initialize(parameters=nil)
    @parameters = parameters
  end

  def run
    portfolio = Portfolio.new(position_count: 5, initial_balance: 1000000)
    PricePoints.all_periods.each do |period|
      current_market_data = ScoreCalculator.new(parameters: parameters, period: period).assign_scores
      previous_period = (Date.strptime(new_period, '%Y-%m-%d') - 1.year).to_s
      target_portfolio = TargetPortfolio.new(
        current_porfoliio_balance: portfolio.as_of(previous_period)[:total_market_value]
        position_count: portfolio.position_count
        current_market_data: current_market_data,
        parameters: parameters
        ).build
      portfolio.rebalance(new_period: period, target: target_portfolio, parameters: parameters)
    end
    binding.pry
    # OutputGenerator.new(portfolio: portfolio, parameters: parameters).prepare
  end
end
