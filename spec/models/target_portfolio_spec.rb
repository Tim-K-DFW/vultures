require 'spec_helper'

describe TargetPortfolio do
  # before { allow(:porfolio).to recieve(:balance).with('2012-12-31').and return(1000000) }
  let(:portfolio) { double(balance: 1000000) }
  let(:current_market_data) { Fabricate(:current_market_data, period: '2012-12-31') }

  # use 5 stocks; 7 in market_data

  # describe '#build' do
  #   it 'contains assigned number of stocks'
  #   it 'allocates assigned number of stocks in close proportions'
  #   it 'does not include stocks under below cut-off score'
  #   it 'does not have balance remaining enough to by one share of any stock within target group'
  # end

  describe '#build_initial_positions' do
    it 'has total expected cost of less than or equal to portfolio balance'
    it 'contains assigned number of positions'
    it 'has no stocks with score of less than the highest score in non-included stocks????'
    it 'has no single position with value exceeding its proportion'
    it 'has the maximum possible number of shares for every position'
  end

end
