require 'spec_helper'

describe Engine do
  describe 'run' do
    before { set_up_trial_data }

    it 'creates required number of periods in Portfolio' do
      engine = Engine.new
      engine.run
      binding.pry
      expect(engine.portfolio.periods.count).to eq(4)
    end

    it 'for each period, puts correct stocks in portfolio'
    it 'for each period, puts stocks in correct proportions'
    it 'for each period, does not put delisted stocks in portfolio'
    it 'for each period, maintains non-negative cash balance'
    it 'for each period, uses up all available cash'
    it 'for each period, correctly calculates market value'
    it 'for each period, correctly carries over portfolio to next period'
  end
end
