require 'spec_helper'

describe ReportGenerator do
  let(:initial_balance) { 1000000 }

  describe '#max_drawdown' do
    it 'returns 0 when there were no losses' do
      price_points = [100, 120, 140]
      expect(max_drawdown(price_points)).to eq(0)
    end


    it 'returns the only loss if there was only one'
    it 'returns the largest loss if there were multiple'
    it 'does not consider a loss when a low preceeded a high'

  end
end
