require 'spec_helper'

describe Portfolio do
  let(:target) { fabricate_target_portfolio }
  let(:today) { '12/31/2012' }
  let(:portfolio) { fabricate_portfolio(today) }

  before do
    Fabricate(:price_point, cid: 'aapl', price: 15)
    Fabricate(:price_point, cid: 'flo', price: 22, delisted: true, delisting_date: '2012-07-08')
    Fabricate(:price_point, cid: 'mhr', price: 0.01)
    Fabricate(:price_point, cid: 'nok', price: 157)
    Fabricate(:price_point, cid: 'msft', price: 0.01)
  end

  describe '#as_of' do
    it 'returns total market value under martket_value key' do
      expect(portfolio.as_of('12/31/2012')[:market_value]).to eq(156881.77)
    end

    it 'returns cash balance under cash_balance key' do
      expect(portfolio.as_of('12/31/2012')[:cash]).to eq(14000)
    end

    it 'does not dislplay positions that were delisted' do
      current_stock_list = portfolio.as_of('12/31/2012')[:positions].keys
      expect(current_stock_list).not_to include(:flo)
    end

    it 'returns all delisting information under delistings key' do
       expect(portfolio.as_of('12/31/2012')[:delisted_positions][:flo]).to be_present
      end
  end # #as_of

  
  # describe '#buy'


  describe '#sell' do
    it 'decreases share count by specified amount' do
      portfolio.sell(stock: :aapl, date: '12/31/2012', amount: 5)
      expect(portfolio.as_of('12/31/2012')[:positions][:aapl][:share_count]).to eq(95)
    end

    it 'increases cash balance by correct amount' do
      portfolio.sell(stock: :aapl, date: '12/31/2012', amount: 5)
      expect(portfolio.as_of('12/31/2012')[:cash]).to eq(14075)
    end

    it 'undstands amount of "all" ' do
      portfolio.sell(stock: :aapl, date: '12/31/2012', amount: :all)
      expect(portfolio.as_of('12/31/2012')[:positions][:aapl][:share_count]).to eq(0)
    end

    it 'does not sell more than current share count' do
      portfolio.sell(stock: :aapl, date: '12/31/2012', amount: 1000)
      expect(portfolio.as_of('12/31/2012')[:positions][:aapl][:share_count]).to eq(0)
    end
  end

  describe '#buy' do
    it 'decreases share count by specified amount' do
      portfolio.buy(stock: :aapl, date: '12/31/2012', amount: 5)
      expect(portfolio.as_of('12/31/2012')[:positions][:aapl][:share_count]).to eq(105)
    end

    it 'increases cash balance by correct amount' do
      portfolio.buy(stock: :aapl, date: '12/31/2012', amount: 5)
      expect(portfolio.as_of('12/31/2012')[:cash]).to eq(13925)
    end
  end

  describe '#sell_non_target_stocks' do
    it 'removes a current position which is not in target portfolio' do
      portfolio.sell_non_target_stocks(date: today, target: target)
      expect(portfolio.as_of(today)[:positions][:nok][:share_count]).to eq(0)
    end
  end

  describe '#adjust_target_stocks_already_held' do
    before { portfolio.adjust_target_stocks_already_held(date: today, target: target) }

    it 'sells extra shares if portfolio is above target' do
      expect(portfolio.as_of(today)[:positions][:aapl][:share_count]).to eq(50)
    end

    it 'buys additional shares if portfolio is below target' do
      expect(portfolio.as_of(today)[:positions][:msft][:share_count]).to eq(350879)
    end

    it 'makes no change if portfolio is equal to target' do
      expect(portfolio.as_of(today)[:positions][:mhr][:share_count]).to eq(8000)
    end
  end

  describe '#rebalance' do
    it '' do
      portfolio
    end
  end

end
