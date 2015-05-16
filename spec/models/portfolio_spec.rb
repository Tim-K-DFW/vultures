require 'spec_helper'

describe Portfolio do
  let(:target) { fabricate_target_portfolio }
  let(:portfolio) { fabricate_portfolio('12/31/2012') }

  before do
    Fabricate(:price_point, cid: 'aapl', price: 15)
    Fabricate(:price_point, cid: 'flo', price: 22)
    Fabricate(:price_point, cid: 'mhr', price: 0.01)
    Fabricate(:price_point, cid: 'nok', price: 157)
    Fabricate(:price_point, cid: 'msft', price: 0.01, delisted: true, delisting_date: '2012-07-08')
  end

  describe '#as_of' do
    it 'returns total market value under martket_value key' do
      expect(portfolio.as_of('12/31/2012')["market_value"]).to eq(156881.77)
    end

    it 'returns cash balance under cash_balance key' do
      expect(portfolio.as_of('12/31/2012')["cash"]).to eq(3001.77)
    end

    it 'does not dislplay positions that were delisted' do
      current_stock_list = portfolio.as_of('12/31/2012')["positions"].map { |v| v["cid"] }
      expect(current_stock_list).not_to include('msft')
    end

    it 'returns all delisting information under delistings key' do
       expect(portfolio.as_of('12/31/2012')["delisted_positions"].first.keys).to include('delisting_date')
      end
  end # #as_of

  
  # describe '#buy'
  describe '#sell' do
    before { portfolio.sell(stock: 'aapl', date: '12/31/2012', amount: 5) }

    it 'decreases share count by specified amount' do
      expect(portfolio.as_of('12/31/2012')["positions"].select {|v| v["cid"] == 'aapl'}.first["share_count"]
).to eq(95)
    end

    it 'increases cash balance by correct amount' do
      expect(portfolio.as_of('12/31/2012')["cash"]).to eq(3076.77)
    end

    it 'undstands amount of "all" '
    it 'does not sell more than current share count'

  end

  describe '#rebalance' do
    it '' do
      portfolio
      binding.pry
    end
  end

end
