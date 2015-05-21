class Engine
  attr_reader :parameters, :portfolio

  def initialize(parameters=nil)
    @parameters = parameters
  end

  def run
    @portfolio = Portfolio.new(position_count: 5, initial_balance: 1000000, start_date: '2012-12-31')
    PricePoint.all_periods.each do |period|
      period = period.to_s
      current_market_data = ScoreCalculator.new(
        market_cap_floor: 200, 
        market_cap_ceiling: 2000,
        period: period
      ).assign_scores

      @portfolio.carry_forward(period) unless period == '2012-12-31'
      target_portfolio = TargetPortfolio.new(
        current_portfolio_balance: @portfolio.as_of(period)[:total_market_value],
        position_count: @portfolio.position_count,
        current_market_data: current_market_data,
        parameters: parameters
        ).build
      @portfolio.rebalance(new_period: period, target: target_portfolio, parameters: parameters)
    end
    self
  end

  def generate_report
    OutputGenerator.new(portfolio: portfolio, parameters: parameters).prepare
  end
end
