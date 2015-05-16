class TargetPortfolio
  attr_accessor :positions

  def initialize(args)
    @current_portfolio = args[:current_portfolio]
    @market_data = args[:current_market_data]
    @parameters = args[:parameters]
    @positions = []
  end

  def build
    build_initial_positions
    spend_balance
  end

  def cost
    positions.inject(0) { |total, element| total + element["cost"] }.round(2)
  end

  def cash_balance
    @current_portfolio.balance - cost
  end

  def hold_list
    positions.map { |v| v["cid"] }
  end

  # private

  def build_initial_positions
    max_allocation_per_position = @current_portfolio.balance / @current_portfolio.position_count
    @market_data.sort_by! {|h| h["total_score"] }
    @current_portfolio.position_count.times do |i|
      this_position = @market_data[i]
      this_position["share_count"] = (max_allocation_per_position / this_position["price"]).floor
      this_position["cost"] = (this_position["share_count"] * this_position["price"]).round(2)
      positions << this_position
    end
  end

  def spend_balance
    positions.each do |position|
      if cash_balance > position["price"]
        additional_shares = (cash_balance / position["price"]).floor
        position["share_count"] += additional_shares
        position["cost"] = (position["cost"] + additional_shares * position["price"]).round(2)
      end
    end
  end # spend_balance
end
