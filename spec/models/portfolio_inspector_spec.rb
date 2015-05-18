require 'spec_helper'

describe PortfolioInspector do
  before { fabricate_price_points }

  let(:portfolio) { fabricate_portfolio('2012-12-31') }
  let(:inspector) { PortfolioInspector.new(portfolio, "2012-12-31") }
  let(:output) { inspector.snapshot }
  

  describe '#snapshot' do
    it 'returns total market value under martket_value key' do
      expect(output[:market_value]).to eq(156881.77)
    end

    it 'returns cash balance under cash_balance key' do
      expect(output[:cash]).to eq(14000)
    end

    it 'does not dislplay positions that were delisted' do
      expect(output[:positions].keys).not_to include(:flo)
    end

    it 'returns all delisting information under delistings key' do
       expect(output[:delisted_positions][:flo]).to be_present
    end
  end 
end
