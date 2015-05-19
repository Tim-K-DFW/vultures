require 'spec_helper'

describe Portfolio do
  let(:target) { fabricate_target_portfolio }
  let(:today) { '2012-12-31' }
  let(:portfolio) { fabricate_portfolio(today) }

  before do
    fabricate_price_points
    fabricate_price_points('2013-12-31')
  end

  describe '#as_of' do
    it 'returns total market value under martket_value key' do
      expect(portfolio.as_of(today)[:market_value_total]).to eq(515826.88)
    end
  end

  describe 'position' do
    it 'returns a position hash for specified cid' do
      expect(portfolio.position(:aapl, '2012-12-31').cid).to eq(:aapl)
    end

    it 'returns nil if position does not exist'
  end

  describe '#rebalance' do
    it 'automatically removes hashes for delisted positions' do
      portfolio.rebalance(target: target, date: today)
      expect(portfolio.periods[today][:positions].keys).not_to include(:flo)
    end
    # rest is tested in component methods
  end
  
  describe '#sell' do
    it 'decreases share count by specified amount' do
      portfolio.sell(stock: :aapl, date: today, amount: 5)
      expect(portfolio.as_of(today)[:positions][:aapl][:share_count]).to eq(95)
    end

    it 'increases cash balance by correct amount' do
      portfolio.sell(stock: :aapl, date: today, amount: 5)
      expect(portfolio.as_of(today)[:cash]).to eq(14075)
    end

    it 'understands amount of "all" ' do
      portfolio.sell(stock: :aapl, date: today, amount: :all)
      expect(portfolio.as_of(today)[:positions][:aapl][:share_count]).to eq(0)
    end

    it 'does not sell more than current share count' do
      portfolio.sell(stock: :aapl, date: today, amount: 1000)
      expect(portfolio.as_of(today)[:positions][:aapl][:share_count]).to eq(0)
    end
  end

  describe '#buy' do
    it 'decreases share count by specified amount' do
      portfolio.buy(stock: :aapl, date: today, amount: 5)
      expect(portfolio.as_of(today)[:positions][:aapl][:share_count]).to eq(105)
    end

    it 'increases cash balance by correct amount' do
      portfolio.buy(stock: :aapl, date: today, amount: 5)
      expect(portfolio.as_of(today)[:cash]).to eq(13925)
    end

    it 'creates a new position'
    it 'sets correct entry price for the new position'
    it 'sets correct share count for the new position'
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

  describe '#add_target_stocks_not_already_held' do
    before { portfolio.add_target_stocks_not_already_held(date: today, target: target) }

    it 'adds correct positions' do
      expect(portfolio.as_of(today)[:positions][:bbry]).to be_present
      expect(portfolio.as_of(today)[:positions][:xom]).to be_present
    end

    it 'adds a position with correct entry price' do
      expect(portfolio.as_of(today)[:positions][:bbry][:entry_price]).to eq(79.15)
    end

    it 'adds a position with correct share count' do
      expect(portfolio.as_of(today)[:positions][:bbry][:share_count]).to eq(13449)
    end
  end

  describe '#remove_blank_positions' do
    before do 
      portfolio.sell_non_target_stocks(date: today, target: target)
      portfolio.remove_blank_positions(today)
    end

    it 'removes all positions with share_count of 0' do
      expect(portfolio.as_of(today)[:positions].keys).not_to include(:nok)
    end
  end

  describe '#carry_forward' do
    before { portfolio.carry_forward(today) }

    it 'creates next period in the portfolio' do
      expect(portfolio.as_of('2013-12-31')).to be_present
    end

    it 'moves all existing positions to the next period' do
      expect(portfolio.periods['2013-12-31'][:positions]).to eq(portfolio.periods[today][:positions])
    end
  end
end
