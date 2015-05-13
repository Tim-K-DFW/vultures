class MainEngine

  def execute
    Data.all_periods.each do |period|
      scores = ScoreCalculator.new(period: period).assign
      build_target_portfolio(period)
      rebalance_portfolio(period)
      store_returns(period)
    end
    display_results
  end

  
end
