require 'spec_helper'

describe Engine do
  describe 'run' do
    before { set_up_trial_data }
    let(:engine){ Engine.new.run }

    it 'creates required number of periods in Portfolio' do
      expect(engine.portfolio.periods.count).to eq(4)
    end

    it 'for each period, puts correct stocks in portfolio' do
      expect(engine.portfolio.periods['2012-12-31'][:positions].keys).to match_array([:gs, :emes, :pxd, :msft, :xom])
      expect(engine.portfolio.periods['2013-12-31'][:positions].keys).to match_array([:xom, :emes, :aapl, :gs, :gdp])
      expect(engine.portfolio.periods['2014-12-31'][:positions].keys).to match_array([:emes, :pxd, :ms, :msft, :xom])
      expect(engine.portfolio.periods['2015-12-31'][:positions].keys).to match_array([:gs, :pxd, :xom, :emes, :nok])
    end

    it 'for each period, buys correct portfolios' do
      test_2012 = engine.portfolio.periods['2012-12-31'][:positions]
      expect(test_2012[:gs].share_count).to eq(2382)
      expect(test_2012[:emes].share_count).to eq(13335)
      expect(test_2012[:pxd].share_count).to eq(13333)
      expect(test_2012[:msft].share_count).to eq(2857142)
      expect(test_2012[:xom].share_count).to eq(1652)

      test_2013 = engine.portfolio.periods['2013-12-31'][:positions]
      expect(test_2013[:xom].share_count).to eq(2346709)
      expect(test_2013[:emes].share_count).to eq(2781530)
      expect(test_2013[:aapl].share_count).to eq(622563)
      expect(test_2013[:gs].share_count).to eq(694578)
      expect(test_2013[:gdp].share_count).to eq(1282355)

      test_2014 = engine.portfolio.periods['2014-12-31'][:positions]
      expect(test_2014[:emes].share_count).to eq(1149539)
      expect(test_2014[:pxd].share_count).to eq(825260)
      expect(test_2014[:ms].share_count).to eq(8972356)
      expect(test_2014[:msft].share_count).to eq(928612)
      expect(test_2014[:xom].share_count).to eq(28340549)

      
      test_2015 = engine.portfolio.periods['2015-12-31'][:positions]
      expect(test_2015[:gs].share_count).to eq(4023635)
      expect(test_2015[:pxd].share_count).to eq(5912878)
      expect(test_2015[:xom].share_count).to eq(8969505)
      expect(test_2015[:emes].share_count).to eq(11932382)
      expect(test_2015[:nok].share_count).to eq(1990089)
    end

    it 'for each period, does not buy delisted stocks' do
      expect(engine.portfolio.periods['2014-12-31'][:positions].keys).not_to include(:aapl)
      expect(engine.portfolio.periods['2015-12-31'][:positions].keys).not_to include(:ms)
    end

    it 'for each period, maintains non-negative cash balance' do
      engine.portfolio.periods.each do |date, data|
        expect(engine.portfolio.as_of(date)[:cash_ex_delisting_proceeds]).to be >= 0
      end
    end

    it 'for each period, uses up all available cash' do
      engine.portfolio.periods.each do |date, data|
        minimum_share_price = PricePoint.where(period: date, cid: data[:positions].keys).map(&:price).min
        expect(engine.portfolio.as_of(date)[:cash_ex_delisting_proceeds]).to be < minimum_share_price
      end
    end

    it 'for each period, correctly calculates market value' do
      expect(engine.portfolio.as_of('2012-12-31')[:total_market_value]).to eq(1000000)
      expect(engine.portfolio.as_of('2013-12-31')[:total_market_value]).to eq(240185150.58)
      expect(engine.portfolio.as_of('2014-12-31')[:total_market_value]).to eq(294741692.76)
      expect(engine.portfolio.as_of('2015-12-31')[:total_market_value]).to eq(727875318.99)
    end
  end
end
