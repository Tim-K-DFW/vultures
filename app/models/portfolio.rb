class Portfolio
  attr_reader :position_count
  attr_accessor :periods

  def initialize(args)
    @position_count = args[:position_count]
    @initial_balance = args[:initial_balance]
    @periods = {}
    @periods[args[:start_date]] = {}
    @periods[args[:start_date]][:positions] = {}
    @periods[args[:start_date]][:cash] = @initial_balance
  end

  def as_of(date)
    result = {}
    result[:delisted_positions] = delisted_positions(date)
    result[:positions] = periods[date][:positions].dup
    result[:positions].delete_if{|k,v| result[:delisted_positions].keys.include?(k)}
    result[:cash] = (periods[date][:cash] + delisting_proceeds(result[:delisted_positions], date)).round(2)
    result[:market_value] = positions_value(result[:positions], date) + result[:cash]
    result
  end

  def rebalance(args)
    #   # only stocks that are in target portfolio will remain at this point

    #   for each stock in existing portfolio do |current_stock|
    #     if current_stock.share_count > target share count
    #       sell excess
    #     elsif current_stock.share_count < target share count
    #       buy 
    #     end
    #     in target portfolio, mark "already in porfolio"
    #   end

    #   for each stock in target porfolio which are not "already in porfolio" do |stock|
    #     in portfolio, buy assigned number of shares of stock
    #   end

    sell_non_target_stocks(args)
    adjust_target_stocks_already_held(args)    
    add_target_stocks_not_already_held(args)
  end

  # private

  def sell_non_target_stocks(args)
    today = args[:date]
    target = args[:target]
    full_sell_list = as_of(today)[:positions].keys - target.keys
    full_sell_list.each do |stock|
      sell(stock: stock, amount: :all, date: today)
    end
  end

  def adjust_target_stocks_already_held(args)
    as_of(args[:date])[:positions].each do |cid, current_position|
      excess_holdings = current_position[:share_count] - (args[:target][cid].present? ? args[:target][cid][:share_count] : 0)
      if excess_holdings > 0
        sell(date: args[:date], stock: cid, amount: excess_holdings)
      elsif excess_holdings < 0
        buy(date: args[:date], stock: cid, amount: -excess_holdings)
      end
    end
  end

  def sell(args)
    position = periods[args[:date]][:positions][args[:stock]]
    amount = args[:amount] == :all ? position[:share_count] : [args[:amount], position[:share_count]].min
    position[:share_count] -= amount
    periods[args[:date]][:cash] = (periods[args[:date]][:cash] + args[:amount] * PricePoint.where(period: args[:date], cid: args[:stock]).first.price).round(2)
  end

  def buy(args)
    position = periods[args[:date]][:positions][args[:stock]]
    position[:share_count] += args[:amount]
    periods[args[:date]][:cash] = (periods[args[:date]][:cash] - args[:amount] * PricePoint.where(period: args[:date], cid: args[:stock]).first.price).round(2)
  end

  def delisted_positions(date)
    result = {}
    periods[date][:positions].each do |cid, position|
      price_point = PricePoint.where(period: date, cid: cid).first
      if price_point["delisted"] == true
        position[:delisting_date] = price_point["delisting_date"]
        result[cid] = position
      end
    end
    result
  end

  def delisting_proceeds(delisted_positions, date)
    result = 0
    delisted_positions.each do |cid, position|
      result += (position[:share_count] * PricePoint.where(period: date, cid: cid).first.price).round(2)
    end
    result
  end

  def positions_value(survived_positions, date)
    result = 0
    survived_positions.each do |cid, position|
      result += (position[:share_count] * PricePoint.where(period: date, cid: cid).first.price).round(2)
    end
    result
  end
end
