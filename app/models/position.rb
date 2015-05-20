class Position
  attr_reader :cid
  attr_accessor :pieces, :current_date

  def initialize(args)
    @cid = args[:stock]
    @current_date = args[:current_date]
    @pieces = {}
    self
  end

  def share_count
    pieces.values.inject(0) { |total, piece| total + piece[:share_count] }
  end

  def market_value
    pieces.inject(0) { |total, piece| total + (piece[1][:share_count] * PricePoint.where(cid: cid, period: current_date).first.price).round(2) }
  end

  def cost
    pieces.inject(0) { |total, piece| total + (piece[1][:share_count] * piece[1][:entry_price]).round(2) }
  end

  def average_entry_price
    (cost / share_count).round(2)
  end

  def profit
    pieces.inject(0) { |total, piece| total + (piece[1][:share_count] * (PricePoint.where(cid: cid, period: current_date).first.price - piece[1][:entry_price])).round(2) }
  end

  def delisted?
    PricePoint.where(cid: cid, period: current_date).first.delisted == true
  end

  def delisting_info
    price_data = PricePoint.where(cid: cid, period: current_date).first
    delisted? ? { date: price_data.delisting_date.to_s, last_price: price_data.price } : nil
  end

  def decrease(amount, method=nil)
    raise "cannot decrease a #{share_count}-share position by #{amount} shares (#{cid})" if amount > share_count
    pieces = method == :lifo ? pieces_sort(:desc) : pieces_sort(:asc)
    shares_to_remove = amount
    pieces.each do |piece|
      if piece[1][:share_count] >= shares_to_remove
        piece[1][:share_count] -= shares_to_remove
        shares_to_remove = 0
      else
        shares_to_remove -= piece[1][:share_count]
        piece[1][:share_count] = 0
      end
      break if shares_to_remove == 0
    end
    @pieces.delete_if{|k,v| v[:share_count] == 0}
  end

  def increase(amount, date)
    pieces[date] = {}
    pieces[date][:share_count] = amount
    pieces[date][:entry_price] = (PricePoint.where(cid: cid, period: date).first.price).round(2)
  end

  def pieces_sort(order)
    if order == :asc
      temp = pieces.sort_by {|h| h[0]}
    else
      temp = pieces.sort_by {|h| h[0]}.reverse
    end
    result = {}
    temp.each { |t| result[t[0]] = t[1] }
    result
  end
end
