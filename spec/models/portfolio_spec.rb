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
    it 'returns total market value under market_value key' do
      expect(portfolio.as_of(today)[:total_market_value]).to eq(515826.88)
    end
  end

  describe 'position' do
    it 'returns a position hash for specified cid with specified date' do
      expect(portfolio.position(:aapl, '2012-12-31').cid).to eq(:aapl)
    end

    it 'returns nil if position does not exist' do
      expect(portfolio.position(:gdp, '2012-12-31')).to be_nil
    end
  end

  describe '#rebalance' do
    it 'automatically removes hashes for delisted positions' do
      portfolio.rebalance(target: target, new_period: '2013-12-31')
      expect(portfolio.periods['2013-12-31'][:positions].keys).not_to include(:flo)
    end

    # the rest is tested in component method specs
  end
  
  describe '#sell' do
    it 'increases cash balance by correct amount' do
      portfolio.sell(stock: :aapl, date: today, amount: 5)
      expect(portfolio.periods[today][:cash]).to eq(3075)
    end

    it 'decreases share count by specified amount' do
      portfolio.sell(stock: :aapl, date: today, amount: 5)
      expect(portfolio.periods[today][:positions][:aapl].share_count).to eq(1595)
    end

    it 'sells out entire position when passed amount of "all" ' do
      portfolio.sell(stock: :aapl, date: today, amount: :all)
      expect(portfolio.periods[today][:positions][:aapl]).to be_nil
    end

    it 'does not sell more than current share count' do
      expect{ portfolio.sell(stock: :aapl, date: today, amount: 10000) }.to raise_error('cannot decrease a 1600-share position by 10000 shares (aapl)')
    end
  end

  describe '#buy' do
    context 'when the stock being added in not in portfolio' do
      before { portfolio.buy(stock: :bbry, date: today, amount: 500) }

      it 'creates a new position' do
        expect(portfolio.periods[today][:positions][:bbry]).to be_kind_of(Position)
      end

      it 'new position has correct share count' do
        expect(portfolio.periods[today][:positions][:bbry].share_count).to eq(500)
      end

      it 'new position has correct market value' do
        expect(portfolio.periods[today][:positions][:bbry].market_value).to eq(39575)
      end 
    end

    context 'when the stock being added is already in portfolio' do
      before { portfolio.buy(stock: :aapl, date: today, amount: 5) }

      it 'updated position has correct share count' do
        expect(portfolio.periods[today][:positions][:aapl].share_count).to eq(1605)
      end

      it 'updated position has correct market value' do
        expect(portfolio.periods[today][:positions][:aapl].market_value).to eq(24075)
      end
    end

    it 'decreases cash balance by correct amount' do
      portfolio.buy(stock: :aapl, date: today, amount: 5)
      expect(portfolio.periods[today][:cash]).to eq(2925)
    end
  end

  describe '#delete_position' do
    it 'removes position if position is empty' do
      apple = portfolio.periods[today][:positions][:aapl]
      portfolio.delete_position(apple)
      expect(portfolio.periods[today][:positions].keys).not_to include(:aapl)
    end
  end

  describe '#sell_non_target_stocks' do
    it 'sells a position which is not in target portfolio' do
      portfolio.sell_non_target_stocks(new_period: today, target: target)
      expect(portfolio.periods[today][:positions].keys).not_to include(:nok)
    end
  end

  describe '#adjust_target_stocks_already_held' do
    before { portfolio.adjust_target_stocks_already_held(new_period: today, target: target) }

    it 'sells extra shares if portfolio is above target' do
      expect(portfolio.periods[today][:positions][:aapl].share_count).to eq(50)
    end

    it 'buys additional shares if portfolio is below target' do
      expect(portfolio.periods[today][:positions][:msft].share_count).to eq(350879)
    end

    it 'makes no change if portfolio is equal to target' do
      expect(portfolio.periods[today][:positions][:mhr].share_count).to eq(8000)
    end
  end

  describe '#add_target_stocks_not_already_held' do
    before { portfolio.add_target_stocks_not_already_held(new_period: today, target: target) }

    it 'adds correct positions' do
      expect(portfolio.periods[today][:positions][:bbry]).to be_present
      expect(portfolio.periods[today][:positions][:xom]).to be_present
    end

    it 'adds a position with correct entry price' do
      expect(portfolio.periods[today][:positions][:bbry].pieces.first[1][:entry_price]).to eq(79.15)
    end

    it 'adds a position with correct share count' do
      expect(portfolio.periods[today][:positions][:bbry].pieces.first[1][:share_count]).to eq(13449)
    end
  end

  describe '#carry_forward' do
    before { portfolio.carry_forward('2013-12-31') }

    it 'creates next period in the portfolio' do
      expect(portfolio.periods['2013-12-31']).to be_present
    end

    it 'copies all existing positions to the newly created period' do
      portfolio.periods['2013-12-31'][:positions].each { |cid, position| expect(position.share_count).to eq(portfolio.periods['2012-12-31'][:positions][cid].share_count) }
    end

    it 'updates current_date for all new positions' do
      portfolio.periods['2013-12-31'][:positions].each { |cid, position| expect(position.current_date).to eq('2013-12-31') }
    end
  end
end
