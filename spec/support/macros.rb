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

# for comprehensive trial

def set_up_trial_data
  PricePoint.create(period: '2012-12-31', cid: 'gs', market_cap: 874, earnings_yield: 0.4, roc: 0.5, price: 84, delisted: false)
  PricePoint.create(period: '2012-12-31', cid: 'emes', market_cap: 1397, earnings_yield: 0.05, roc: 0.7, price: 15, delisted: false)
  PricePoint.create(period: '2012-12-31', cid: 'aapl', market_cap: 15, earnings_yield: 0.3, roc: 0.15, price: 321, delisted: false)
  PricePoint.create(period: '2012-12-31', cid: 'pxd', market_cap: 1900, earnings_yield: 0.16, roc: 0.2, price: 15, delisted: false)
  PricePoint.create(period: '2012-12-31', cid: 'msft', market_cap: 500, earnings_yield: 0.01, roc: 0.3, price: 0.07, delisted: false)
  PricePoint.create(period: '2012-12-31', cid: 'xom', market_cap: 1413, earnings_yield: 0.2, roc: 0.01, price: 121, delisted: false)
  PricePoint.create(period: '2012-12-31', cid: 'gdp', market_cap: 1517, earnings_yield: 0.15, roc: 0.15, price: 20, delisted: false)
  PricePoint.create(period: '2013-12-31', cid: 'xom', market_cap: 1900, earnings_yield: 0.05, roc: 0.79, price: 20.47, delisted: false)
  PricePoint.create(period: '2013-12-31', cid: 'emes', market_cap: 1800, earnings_yield: 0.45, roc: 0.51, price: 17.27, delisted: false)
  PricePoint.create(period: '2013-12-31', cid: 'msft', market_cap: 190, earnings_yield: 0.6, roc: 0.42, price: 83.51, delisted: false)
  PricePoint.create(period: '2013-12-31', cid: 'aapl', market_cap: 205, earnings_yield: 0.7, roc: 0.29, price: 77.16, delisted: false)
  PricePoint.create(period: '2013-12-31', cid: 'gs', market_cap: 1500, earnings_yield: 0.3, roc: 0.54, price: 69.16, delisted: false)
  PricePoint.create(period: '2013-12-31', cid: 'gdp', market_cap: 906, earnings_yield: 0.01, roc: 0.64, price: 37.46, delisted: false)
  PricePoint.create(period: '2013-12-31', cid: 'pxd', market_cap: 2300, earnings_yield: 0.35, roc: 0.23, price: 86.73, delisted: false)
  PricePoint.create(period: '2014-12-31', cid: 'gs', market_cap: 2100, earnings_yield: 0.83, roc: 0.56, price: 51.2, delisted: false)
  PricePoint.create(period: '2014-12-31', cid: 'nok', market_cap: 2432, earnings_yield: 0.27, roc: 0.92, price: 43.15, delisted: false)
  PricePoint.create(period: '2014-12-31', cid: 'emes', market_cap: 1900, earnings_yield: 0.92, roc: 0.15, price: 51.28, delisted: false)
  PricePoint.create(period: '2014-12-31', cid: 'pxd', market_cap: 202, earnings_yield: 0.26, roc: 0.69, price: 71.43, delisted: false)
  PricePoint.create(period: '2014-12-31', cid: 'ms', market_cap: 1500, earnings_yield: 0.29, roc: 0.53, price: 6.57, delisted: false)
  PricePoint.create(period: '2014-12-31', cid: 'msft', market_cap: 202, earnings_yield: 0.47, roc: 0.14, price: 63.48, delisted: false)
  PricePoint.create(period: '2014-12-31', cid: 'xom', market_cap: 1950, earnings_yield: 0.26, roc: 0.55, price: 2.08, delisted: false)
  PricePoint.create(period: '2014-12-31', cid: 'aapl', market_cap: 500, earnings_yield: 0.43, roc: 0.08, price: 52, delisted: true, delisting_date: '2014-09-20')
  PricePoint.create(period: '2014-12-31', cid: 'gdp', market_cap: 3614, earnings_yield: 0.23, roc: 0.36, price: 61.83, delisted: true, delisting_date: '2014-09-20')
  PricePoint.create(period: '2015-12-31', cid: 'geos', market_cap: 2347, earnings_yield: 0.94, roc: 0.41, price: 10.47, delisted: false)
  PricePoint.create(period: '2015-12-31', cid: 'gs', market_cap: 1378, earnings_yield: 0.45, roc: 0.66, price: 36.18, delisted: false)
  PricePoint.create(period: '2015-12-31', cid: 'xom', market_cap: 1800, earnings_yield: 0.75, roc: 0.4, price: 16.23, delisted: false)
  PricePoint.create(period: '2015-12-31', cid: 'pxd', market_cap: 674, earnings_yield: 0.31, roc: 0.88, price: 24.62, delisted: false)
  PricePoint.create(period: '2015-12-31', cid: 'emes', market_cap: 1980, earnings_yield: 0.46, roc: 0.45, price: 12.2, delisted: false)
  PricePoint.create(period: '2015-12-31', cid: 'ms', market_cap: 1700, earnings_yield: 0.57, roc: 0.19, price: 18.7, delisted: true, delisting_date: '2015-03-15')
  PricePoint.create(period: '2015-12-31', cid: 'flo', market_cap: 278, earnings_yield: 0.18, roc: 0.53, price: 87.95, delisted: false)
  PricePoint.create(period: '2015-12-31', cid: 'nok', market_cap: 528, earnings_yield: 0.53, roc: 0.19, price: 73.15, delisted: false)
  PricePoint.create(period: '2015-12-31', cid: 'msft', market_cap: 3000, earnings_yield: 0.34, roc: 0.35, price: 70.84, delisted: false)
end