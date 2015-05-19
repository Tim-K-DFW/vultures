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
end
