def fabricate_market_data
  apple = { "cid" => 'aapl', "total_score" => 15, "price" => 11.00 }
  blackberry = { "cid" => 'bbry', "total_score" => 17, "price" => 14.87 }
  magnum = { "cid" => 'mhr', "total_score" => 18, "price" => 2.02 }
  exxon = { "cid" => 'xom', "total_score" => 19, "price" => 98.00 }
  microsoft = { "cid" => 'msft', "total_score" => 22, "price" => 0.57 }
  samsung = { "cid" => 'sams', "total_score" => 29, "price" => 11.00 }
  philips = { "cid" => 'phil', "total_score" => 38, "price" => 11.00 }
  [apple, blackberry, magnum, exxon, microsoft, samsung, philips].shuffle
end

def fabricate_target_portfolio
  {:aapl=>{:price=>11.0, :total_score=>15, :share_count=>50, :cost=>750},
  :bbry=>{:price=>14.87, :total_score=>17, :share_count=>13449, :cost=>199986.63},
  :mhr=>{:price=>2.02, :total_score=>18, :share_count=>8000, :cost=>200002.22},
  :xom=>{:price=>98.0, :total_score=>19, :share_count=>2040, :cost=>199920.0},
  :msft=>{:price=>0.57, :total_score=>22, :share_count=>350879, :cost=>200001.03}
  }
end

def fabricate_portfolio(current_date)
  portfolio = Portfolio.new(sell_method: :fifo, position_count: 5, initial_balance: 1000000, start_date: '2009-12-31')
  portfolio.periods[current_date] = {}

  apple = Position.new(stock: :aapl)
  apple.pieces = {
      "2011-12-31" => { share_count: 300, entry_price: 15.05 },
      "2010-12-31" => { share_count: 500, entry_price: 12.54 },
      "2009-12-31" => { share_count: 800, entry_price: 9.08 }
    }

  fluor = Position.new(stock: :flo)
  fluor.pieces = {
      "2011-12-31" => { share_count: 300, entry_price: 105.05 },
      "2010-12-31" => { share_count: 500, entry_price: 154.54 }
    }

  magnum = Position.new(stock: :mhr)
  magnum.pieces = {
      "2011-12-31" => { share_count: 30, entry_price: 1.05 },
      "2010-12-31" => { share_count: 50, entry_price: 105 },
      "2009-12-31" => { share_count: 8, entry_price: 300 }
    }

  nokia = Position.new(stock: :nok)
  nokia.pieces = {
      "2009-12-31" => { share_count: 3000, entry_price: 95.78 },
    }

  msft = Position.new(stock: :msft)
  msft.pieces = {
      "2011-12-31" => { share_count: 7300, entry_price: 115.05 },
      "2010-12-31" => { share_count: 8500, entry_price: 112.54 },
      "2009-12-31" => { share_count: 6800, entry_price: 119.08 }
    }

  [apple, fluor, magnum, nokia, msft].each {|p| p.current_date = current_date }

  portfolio.periods[current_date][:positions] = {
    aapl: apple,
    flo: fluor,
    mhr: magnum,
    nok: nokia,
    msft: msft
  }
  portfolio.periods[current_date][:cash] = 3000
  portfolio
end

def fabricate_price_points(date = nil)
  period = date || '2012-12-31'
  Fabricate(:price_point, cid: 'aapl', price: 15, period: period)
  Fabricate(:price_point, cid: 'flo', price: 22, delisted: true, delisting_date: '2012-07-08', period: period)
  Fabricate(:price_point, cid: 'mhr', price: 0.01, period: period)
  Fabricate(:price_point, cid: 'nok', price: 157, period: period)
  Fabricate(:price_point, cid: 'msft', price: 0.01, period: period)
  Fabricate(:price_point, cid: 'bbry', price: 79.15, period: period)
  Fabricate(:price_point, cid: 'xom', price: 7.15, period: period)
end

def fabricate_apple_position(args=nil)
  apple = Position.new(stock: :aapl, current_date: '2011-12-31')
  if args && args[:one_piece]
    apple.pieces = { "2011-12-31" => { share_count: 300, entry_price: 15.05 } }
  else
    apple.pieces = {
      "2011-12-31" => { share_count: 300, entry_price: 15.05 },
      "2010-12-31" => { share_count: 500, entry_price: 12.54 },
      "2009-12-31" => { share_count: 800, entry_price: 9.08 }
    }
  end
  apple
end
