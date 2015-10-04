require 'csv'
require 'date'

PricePoint.destroy_all
Company.destroy_all

start_time = Time.now
counter = 0

periods = []
(1993..2014).each { |year| periods << "12/31/#{year}" }

CSV.foreach("db/data - annual since 1993.csv", headers: true, encoding: 'ISO-8859-1') do |row|
  for i in 0..periods.size - 1
    ebit = row[i * 6 + 5].to_f.round(3)
    ev = row[i * 6 + 6].to_f.round(3)
    net_ppe = row[i * 6 + 7].to_f.round(3)
    nwc = row[i * 6 + 8].to_f.round(3)
    market_cap = row[i * 6 + 4].to_f.round(3)
    price = row[i * 6 + 9].to_f.round(2)
    new_entry = PricePoint.create(
      cid: row[2],
      period: Date.strptime(periods[i], '%m/%d/%Y'),
      market_cap: market_cap,
      net_ppe: net_ppe,
      nwc: nwc,
      ltm_ebit: ebit,
      ev: ev,
      earnings_yield: ebit > 0 ? (ebit / ev).round(3) : 0,
      roc: ebit > 0 ? (ebit / (net_ppe + nwc)).round(3) : 0,
      price: price,
      delisted: false
    )
    delisted_check = /(\d+\/\d+\/\d+)/.match(row[i * 6 + 9])
    if delisted_check
      new_entry.update(
        delisted: true,
        delisting_date: Date.strptime(delisted_check[1], '%m/%d/%Y')
      )
    end
  end
  Company.create(name: row[0], cid: row[2], ticker: row[3])
  counter += 1
  printf "%-80s %-25s %-22s\n", "Added #{row[0]}", "#{counter} companies total", "#{(Time.now - start_time).round(2)} seconds spent."
end

PricePoint.where(cid: 'sp500').each { |item| item.update(delisted: true) }
puts 'All SP500 entries set to DELISTED.'

# 0 company
# 1 exchange no need
# 2 id
# 3 ticker

# 4 market cap
# 5 EBIT
# 6 EV
# 7 net PPE
# 8 NWC
# 9 price (including delisting info, if any)
