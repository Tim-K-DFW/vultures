require 'pry'
require 'csv'

CSV.foreach("data - annual since 1993.csv") do |row|
  binding.pry
  # use row here...
end


# 0 company
# 1 exchange
# 2 id
# 3 ticker

# 4 market cap
# 5 EBIT
# 6 EV
# 7 net PPE
# 8 NWC
# 9 price