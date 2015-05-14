class TargetPortfolio
  def initialize(args)
    @current_portfolio = args[:current_portfolio]
    @market_data = args[:current_market_data]
    @parameters = args[:parameters]
  end

  # def build
  #   build_initial_positions
  #   spend_balance
  # end

  # private

  def build_initial_positions
    for stocks with rating [1..30] do
      share count = round_down(allocation_per_stock / current price)
      add this stock (share count)
      balance -= stare_count * current_price
    end
  end

  # def spend_balance
  #   for each rating [1..30] do |rating|
  #       if balance > per_share_price
  #         share count = round_down(balance / current price)
  #         add this stock (share_count)
  #         balance -= stare_count * current_price
  #       end
  #     end
  # end
end
