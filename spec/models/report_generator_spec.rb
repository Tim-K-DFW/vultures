require 'spec_helper'

describe ReportGenerator do
  let(:initial_balance) { 1000000 }
  let(:engine) { double(portfolio: 'fake_response') }
  let(:generator) { ReportGenerator.new(engine, '') }

  describe '#max_drawdown' do
    it 'returns 0 when there were no losses' do
      price_points = [100, 120, 140, 160]
      expect(generator.max_drawdown(price_points)).to eq(0)
    end

    it 'returns the only loss if there was only one' do
      price_points = [100, 50, 60, 180]
      expect(generator.max_drawdown(price_points)).to eq(-0.5)
    end

    it 'returns the largest loss if there were multiple' do
      price_points = [100, 50, 60, 250, 200, 20]
      expect(generator.max_drawdown(price_points)).to eq(-0.92)
    end
  end
end
