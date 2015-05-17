require 'spec_helper'

describe TargetPortfolio do
  let(:current_portfolio) { double(balance: 1000000, position_count: 5) }
  let(:current_market_data) { fabricate_market_data }
  let(:target) { TargetPortfolio.new(current_portfolio: current_portfolio, current_market_data: current_market_data) }

  describe '#cost' do
    it 'returns correct total cost of all positions' do
      target.positions[:appl] = { cost: 100 }
      target.positions[:msft] = { cost: 300 }
      expect(target.cost).to eq(400)
    end
  end

  describe '#build_initial_positions' do
    
    before { target.build_initial_positions }

    it 'contains assigned number of positions' do
      expect(target.positions.count).to eq(current_portfolio.position_count)
    end

    it 'has no stocks with score worse than the best score among non-included stocks' do
      excluded_stocks = []
      current_market_data.each {|position| excluded_stocks << position unless target.positions.keys.include?(position["cid"].to_sym) }
      best_score_among_excluded = excluded_stocks.map{ |v| v["total_score"] }.min
      worst_score_among_target = target.positions.map{ |k, v| v[:total_score] }.max
      expect(worst_score_among_target).to be <= best_score_among_excluded
    end

    it 'has no single position with value over its proportion' do
      max_allocation_per_position = current_portfolio.balance / current_portfolio.position_count
      target.positions.each { |k, v| expect(v[:cost]).to be <= max_allocation_per_position }
    end

    it 'has the maximum possible number of shares for every position' do
      max_allocation_per_position = current_portfolio.balance / current_portfolio.position_count
      target.positions.each { |k, v| expect(v[:cost] + v[:price]).to be > max_allocation_per_position }
    end

    it 'has total cost of less than or equal to portfolio balance' do
      expect(target.cost).to be <= current_portfolio.balance
    end
  end

  describe '#spend_balance' do
    before do
      target.build_initial_positions
      target.spend_balance
    end

    it 'does not have enough balance to add a single share to any position' do
      target
      target.positions.each { |k, v| expect(target.cost + v[:price]).to be > current_portfolio.balance }
    end

    it 'has total cost of less than or equal to portfolio balance' do
      expect(target.cost).to be <= current_portfolio.balance
    end
  end

  describe '#hold_list' do
    it 'returns an array of IDs only for all positions' do
      target.build_initial_positions
      target.spend_balance
      expect(target.hold_list).to match_array([:aapl, :msft, :xom, :bbry, :mhr])
    end
  end
end
