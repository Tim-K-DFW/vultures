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
