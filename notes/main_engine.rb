class Backtest
  attr_reader :parameters

  def initialize(parameters)
    @parameters = parameters
  end

  def execute
    portfolio = Portfolio.new(portfolio_params)

    PricePoints.all_periods.each do |period|
      current_market_data = ScoreCalculator.new(parameters: parameters, period: period).assign_scores
      target_portfolio = TargetPortfolio.new(current_porfoliio: portfolio, current_market_data: current_market_data, parameters: parameters).build
      portfolio.rebalance(period: period, target: target_portfolio, parameters: parameters)
    end
    
    OutputGenerator.new(portfolio: portfolio, parameters: parameters).prepare
  end

  
end
