class Backtest
  attr_reader :paramemeters

  def initialize(parameters)
    @parameters = parameters
  end

  def execute
    portfolio = Portfolio.new
    HistoricalData.all_periods.each do |period|
      ranked_stocks = ScoreCalculator.new(parameters: parameters, period: period).assign
      target_portfolio = PortfolioBuilder.new(stocks: ranked_stocks, parameters: parameters).build
      portfolio.rebalance(period: period, target: target_portfolio, parameters: parameters)
    end
    OutputGenerator.new(portfolio: portfolio, parameters: parameters).prepare
  end

  
end
