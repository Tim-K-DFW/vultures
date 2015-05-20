require 'spec_helper'

describe PortfolioInspector do
  before { fabricate_price_points }

  let(:portfolio) { fabricate_portfolio('2012-12-31') }
  let(:inspector) { PortfolioInspector.new(portfolio, "2012-12-31") }
  let(:output) { inspector.snapshot }
  

  describe '#snapshot' do
    it 'returns a hash of Position objects' do
      expect(output).to be_kind_of(Hash)
      expect(output[:positions].first[1]).to be_kind_of(Position)
    end

    it 'returns total market value under martket_value key' do
      expect(output[:total_market_value]).to eq(515826.88)
    end

    it 'returns cash balance under cash_balance key' do
      expect(output[:cash_total]).to eq(20600)
    end

    it 'does not dislplay positions that were delisted' do
      expect(output[:positions].keys).not_to include(:flo)
    end
  end 
end
