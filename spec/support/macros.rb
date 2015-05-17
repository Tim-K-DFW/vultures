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
  portfolio = Portfolio.new(position_count: 5, initial_balance: 1000000, start_date: '12/31/2011')
  portfolio.periods[current_date] = {}
  portfolio.periods[current_date][:positions] = {
    aapl: { entry_price: 11.05, share_count: 100},
    flo: { entry_price: 12, share_count: 500},
    mhr: { entry_price: 2.02, share_count: 8000},
    nok: { entry_price: 98.0, share_count: 900},
    msft: { entry_price: 0.57, share_count: 177 }
  }
  portfolio.periods[current_date][:cash] = 3000
  portfolio
end
