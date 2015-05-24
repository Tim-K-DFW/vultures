module ApplicationHelper
  def pretty_percentage(arg)
    number_to_percentage((arg.to_f * 100).round(4), precision: 2, delimiter: ',')
  end

  def fill_trial_data
    PricePoint.create(period: '1952-12-31', cid: 'gs', market_cap: 874, earnings_yield: 0.4, roc: 0.5, price: 84, delisted: false)
    PricePoint.create(period: '1952-12-31', cid: 'emes', market_cap: 1397, earnings_yield: 0.05, roc: 0.7, price: 15, delisted: false)
    PricePoint.create(period: '1952-12-31', cid: 'aapl', market_cap: 15, earnings_yield: 0.3, roc: 0.15, price: 321, delisted: false)
    PricePoint.create(period: '1952-12-31', cid: 'pxd', market_cap: 1900, earnings_yield: 0.16, roc: 0.2, price: 15, delisted: false)
    PricePoint.create(period: '1952-12-31', cid: 'msft', market_cap: 500, earnings_yield: 0.01, roc: 0.3, price: 0.07, delisted: false)
    PricePoint.create(period: '1952-12-31', cid: 'xom', market_cap: 1413, earnings_yield: 0.2, roc: 0.01, price: 121, delisted: false)
    PricePoint.create(period: '1952-12-31', cid: 'gdp', market_cap: 1517, earnings_yield: 0.15, roc: 0.15, price: 20, delisted: false)
    PricePoint.create(period: '1953-12-31', cid: 'xom', market_cap: 1900, earnings_yield: 0.05, roc: 0.79, price: 20.47, delisted: false)
    PricePoint.create(period: '1953-12-31', cid: 'emes', market_cap: 1800, earnings_yield: 0.45, roc: 0.51, price: 17.27, delisted: false)
    PricePoint.create(period: '1953-12-31', cid: 'msft', market_cap: 190, earnings_yield: 0.6, roc: 0.42, price: 83.51, delisted: false)
    PricePoint.create(period: '1953-12-31', cid: 'aapl', market_cap: 205, earnings_yield: 0.7, roc: 0.29, price: 77.16, delisted: false)
    PricePoint.create(period: '1953-12-31', cid: 'gs', market_cap: 1500, earnings_yield: 0.3, roc: 0.54, price: 69.16, delisted: false)
    PricePoint.create(period: '1953-12-31', cid: 'gdp', market_cap: 906, earnings_yield: 0.01, roc: 0.64, price: 37.46, delisted: false)
    PricePoint.create(period: '1953-12-31', cid: 'pxd', market_cap: 2300, earnings_yield: 0.35, roc: 0.23, price: 86.73, delisted: false)
    PricePoint.create(period: '1954-12-31', cid: 'gs', market_cap: 2100, earnings_yield: 0.83, roc: 0.56, price: 51.2, delisted: false)
    PricePoint.create(period: '1954-12-31', cid: 'nok', market_cap: 2432, earnings_yield: 0.27, roc: 0.92, price: 43.15, delisted: false)
    PricePoint.create(period: '1954-12-31', cid: 'emes', market_cap: 1900, earnings_yield: 0.92, roc: 0.15, price: 51.28, delisted: false)
    PricePoint.create(period: '1954-12-31', cid: 'pxd', market_cap: 202, earnings_yield: 0.26, roc: 0.69, price: 71.43, delisted: false)
    PricePoint.create(period: '1954-12-31', cid: 'ms', market_cap: 1500, earnings_yield: 0.29, roc: 0.53, price: 6.57, delisted: false)
    PricePoint.create(period: '1954-12-31', cid: 'msft', market_cap: 202, earnings_yield: 0.47, roc: 0.14, price: 63.48, delisted: false)
    PricePoint.create(period: '1954-12-31', cid: 'xom', market_cap: 1950, earnings_yield: 0.26, roc: 0.55, price: 2.08, delisted: false)
    PricePoint.create(period: '1954-12-31', cid: 'aapl', market_cap: 500, earnings_yield: 0.43, roc: 0.08, price: 52, delisted: true, delisting_date: '1954-09-20')
    PricePoint.create(period: '1954-12-31', cid: 'gdp', market_cap: 3614, earnings_yield: 0.23, roc: 0.36, price: 61.83, delisted: true, delisting_date: '1954-09-20')
    PricePoint.create(period: '1955-12-31', cid: 'geos', market_cap: 2347, earnings_yield: 0.94, roc: 0.41, price: 10.47, delisted: false)
    PricePoint.create(period: '1955-12-31', cid: 'gs', market_cap: 1378, earnings_yield: 0.45, roc: 0.66, price: 36.18, delisted: false)
    PricePoint.create(period: '1955-12-31', cid: 'xom', market_cap: 1800, earnings_yield: 0.75, roc: 0.4, price: 16.23, delisted: false)
    PricePoint.create(period: '1955-12-31', cid: 'pxd', market_cap: 674, earnings_yield: 0.31, roc: 0.88, price: 24.62, delisted: false)
    PricePoint.create(period: '1955-12-31', cid: 'emes', market_cap: 1980, earnings_yield: 0.46, roc: 0.45, price: 12.2, delisted: false)
    PricePoint.create(period: '1955-12-31', cid: 'ms', market_cap: 1700, earnings_yield: 0.57, roc: 0.19, price: 18.7, delisted: true, delisting_date: '1955-03-15')
    PricePoint.create(period: '1955-12-31', cid: 'flo', market_cap: 278, earnings_yield: 0.18, roc: 0.53, price: 87.95, delisted: false)
    PricePoint.create(period: '1955-12-31', cid: 'nok', market_cap: 528, earnings_yield: 0.53, roc: 0.19, price: 73.15, delisted: false)
    PricePoint.create(period: '1955-12-31', cid: 'msft', market_cap: 3000, earnings_yield: 0.34, roc: 0.35, price: 70.84, delisted: false)
  end

  def fill_sp500_trial_data
    PricePoint.create(period: '1952-12-31', cid: 'sp500', price: 100, delisted: false)
    PricePoint.create(period: '1953-12-31', cid: 'sp500', price: 60, delisted: false)
    PricePoint.create(period: '1954-12-31', cid: 'sp500', price: 120, delisted: false)
    PricePoint.create(period: '1955-12-31', cid: 'sp500', price: 20, delisted: false)
  end
end
