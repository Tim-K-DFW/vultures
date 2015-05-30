class Portfolio
  attr_reader :position_count
  attr_accessor :periods, :pusher_channel

  def initialize(args)
    @sell_method = args[:sell_method]
    @position_count = args[:position_count]
    @initial_balance = args[:initial_balance]
    @periods = {}
    @periods[args[:start_date]] = {}
    @periods[args[:start_date]][:positions] = {}
    @periods[args[:start_date]][:cash] = @initial_balance
    @pusher_channel = args[:pusher_channel]
  end

  def position(cid, as_of_date)
    if as_of_date
      periods[as_of_date][:positions][cid]
    else
      periods.select {|date, content| }
    end
  end

  def as_of(report_date)
    PortfolioInspector.new(self, report_date).snapshot
  end

  def carry_forward(new_period)
    old_period = (Date.strptime(new_period, '%Y-%m-%d') - 1.year).to_s
    periods[new_period] = {}
    periods[new_period][:positions] = {}
    periods[old_period][:positions].each do |cid, old_position|
      new_position = periods[new_period][:positions][cid] = Position.new(stock: cid, current_date: new_period)
      old_position.pieces.each do |date, piece_data|
        new_position.pieces[date] = piece_data.dup
      end
    end
    periods[new_period][:cash] = periods[old_period][:cash]
  end

  def rebalance(args)
    sell_non_target_stocks(args)
    adjust_target_stocks_already_held(args)
    add_target_stocks_not_already_held(args)
  end

  # private

  def sell_non_target_stocks(args)
    today = args[:new_period]
    Pusher.trigger(pusher_channel, 'update', { message: "Processing #{today} - selling off old stocks" })
    target = args[:target]
    full_sell_list = periods[today][:positions].keys - target.keys
    full_sell_list.each do |stock|
      sell(stock: stock, amount: :all, date: today)
    end
  end

  def adjust_target_stocks_already_held(args)
    periods[args[:new_period]][:positions].each do |cid, current_position|
      excess_holdings = current_position.share_count - (args[:target][cid].present? ? args[:target][cid][:share_count] : 0)
      if excess_holdings > 0
        sell(date: args[:new_period], stock: cid, amount: excess_holdings)
      elsif excess_holdings < 0
        buy(date: args[:new_period], stock: cid, amount: -excess_holdings)
      end
    end
  end

  def add_target_stocks_not_already_held(args)
    target = args[:target]
    Pusher.trigger(pusher_channel, 'update', { message: "Processing #{args[:new_period]} - buying new stocks" })
    stocks_to_add = target.select { |cid, position| periods[args[:new_period]][:positions].keys.exclude? cid }
    stocks_to_add.each{ |cid, position| buy(date: args[:new_period], stock: cid, amount: position[:share_count]) }
  end

  def sell(args)
    today = args[:date]
    position = periods[today][:positions][args[:stock]]
    amount = args[:amount] == :all ? position.share_count : args[:amount]
    periods[today][:cash] = (periods[today][:cash] + amount * PricePoint.where(period: today, cid: position.cid).first.price).round(2)
    
    if args[:amount] == :all
      position.pieces = {}
      delete_position(position)
    else
      position.decrease(args[:amount], @sell_method)
    end
  end

  def buy(args)
    today = args[:date]
    this_stock = args[:stock]
    if periods[today][:positions].keys.include? this_stock
      this_position = periods[today][:positions][this_stock]
    else
      this_position = periods[today][:positions][this_stock] = Position.new(stock: this_stock, current_date: today)
    end
    this_position.increase(args[:amount], today)
    periods[today][:cash] = (periods[today][:cash] - this_position.pieces[today][:share_count] * this_position.pieces[today][:entry_price]).round(2)
  end

  def delete_position(position)
    periods[position.current_date][:positions].delete_if{ |cid, pos| pos == position }
  end
end
