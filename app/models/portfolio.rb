class Portfolio
  attr_reader :position_count
  attr_accessor :periods

  def initialize(args)
    @sell_method = args[:sell_method]
    @position_count = args[:position_count]
    @initial_balance = args[:initial_balance]
    @periods = {}
    @periods[args[:start_date]] = {}
    @periods[args[:start_date]][:positions] = {}
    @periods[args[:start_date]][:cash] = @initial_balance
  end

  def position(cid, as_of_date)
    periods[as_of_date][:positions][cid]
  end

  def as_of(report_date)
    PortfolioInspector.new(self, report_date).snapshot
  end

  def rebalance(args)
    sell_non_target_stocks(args)
    adjust_target_stocks_already_held(args)
    add_target_stocks_not_already_held(args)
    # remove_blank_positions(args[:date])
    carry_forward(args[:date])
  end

  # private

  def sell_non_target_stocks(args)
    today = args[:date]
    target = args[:target]
    full_sell_list = periods[today][:positions].keys - target.keys
    full_sell_list.each do |stock|
      sell(amount: :all, date: today)
    end
  end

  def adjust_target_stocks_already_held(args)
    periods[args[:date]][:positions].each do |cid, current_position|
      excess_holdings = current_position[:share_count] - (args[:target][cid].present? ? args[:target][cid][:share_count] : 0)
      if excess_holdings > 0
        sell(date: args[:date], stock: cid, amount: excess_holdings)
      elsif excess_holdings < 0
        buy(date: args[:date], stock: cid, amount: -excess_holdings)
      end
    end
  end

  def add_target_stocks_not_already_held(args)
    target = args[:target]
    stocks_to_add = target.select { |cid, position| periods[args[:date]][:positions].keys.exclude? cid }
    stocks_to_add.each do |cid, position|
      periods[args[:date]][:positions][cid] = { share_count: 0, entry_price: 0 }
      buy(date: args[:date], stock: cid, amount: position[:share_count])
    end
  end

  # def remove_blank_positions(date)
  #   periods[date][:positions].delete_if{ |k,v| v[:share_count] == 0 }
  # end

  def carry_forward(date)
    next_period = (Date.strptime(date, '%Y-%m-%d') + 1.year).to_s
    periods[next_period] = periods[date]
    # adjust current_date for positions
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
