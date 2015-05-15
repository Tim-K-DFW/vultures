require 'spec_helper'

describe TargetPortfolio do
  let(:current_portfolio) { double(balance: 1000000, position_count: 5) }
  let(:current_market_data) { fabricate_market_data }

  describe '#cost' do
    it 'returns correct total cost of all positions' do
      target = TargetPortfolio.new(current_portfolio: current_portfolio, market_data: current_market_data)
      apple = { "cid" => 'aapl', "cost" => 100 }
      msft = { "cid" => 'msft', "cost" => 300 }
      target.positions << apple
      target.positions << msft
      expect(target.cost).to eq(400)
    end
  end

  describe '#build_initial_positions' do
    let(:target) { TargetPortfolio.new(current_portfolio: current_portfolio, current_market_data: current_market_data) }
    before { target.build_initial_positions }

    it 'contains assigned number of positions' do
      expect(target.positions.count).to eq(current_portfolio.position_count)
    end

    it 'has no stocks with score worse than the best score among non-included stocks' do
      excluded_stocks = []
      current_market_data.each {|position| excluded_stocks << position unless target.positions.include?(position) }
      best_score_among_excluded = excluded_stocks.map{ |v| v["total_score"] }.min
      worst_score_among_target = target.positions.map{ |v| v["total_score"] }.max
      expect(worst_score_among_target).to be <= best_score_among_excluded
    end

    it 'has no single position with value over its proportion' do
      max_allocation_per_position = current_portfolio.balance / current_portfolio.position_count
      target.positions.each { |pos| expect(pos["cost"]).to be <= max_allocation_per_position }
    end

    it 'has the maximum possible number of shares for every position' do
      max_allocation_per_position = current_portfolio.balance / current_portfolio.position_count
      target.positions.each { |pos| expect(pos["cost"] + pos["price"]).to be > max_allocation_per_position }
    end

    it 'has total cost of less than or equal to portfolio balance' do
      expect(target.cost).to be <= current_portfolio.balance
    end
  end

  describe '#spend_balance' do
    let(:target) { TargetPortfolio.new(current_portfolio: current_portfolio, current_market_data: current_market_data) }

    before do
      target.build_initial_positions
      target.spend_balance
    end

    it 'does not have enough balance to add a single share to any position' do
      target.positions.each { |pos| expect(target.cost + pos["price"]).to be > current_portfolio.balance }
    end

    it 'has total cost of less than or equal to portfolio balance' do
      expect(target.cost).to be <= current_portfolio.balance
    end
  end
end
