Fabricator(:price_point) do
  cid { Faker::Company.ein }
  period {"2012-12-31"}
  market_cap { 500.1 }
  roc { 0.1 }
  earnings_yield { 0.15 }
  price { 30.05 }
  delisted { false }
  ltm_ebit { 500 }
end
