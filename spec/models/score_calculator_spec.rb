require 'spec_helper'

describe ScoreCalculator do
  describe '#initialize' do
    before do
      Fabricate(:hist_data, period: '2012-12-31')
      Fabricate(:hist_data, period: '2012-12-31')
      Fabricate(:hist_data, period: '2012-12-31')
      Fabricate(:hist_data, period: '2013-12-31')
    end

    it 'pulls all stocks from specified period range' do
      test = ScoreCalculator.new(period: '2012-12-31')
      expect(test.stocks.size).to eq(3)
    end

    it 'ignores stocks with 0 closing price' do
      Fabricate(:hist_data, period: '2012-12-31', price: 0)
      test = ScoreCalculator.new(period: '2012-12-31')
      expect(test.stocks.size).to eq(3)
    end

    it 'ignores stocks which were delisted' do
      Fabricate(:hist_data, period: '2012-12-31', price: 10, delisted: true)
      test = ScoreCalculator.new(period: '2012-12-31')
      expect(test.stocks.size).to eq(3)
    end

    it 'ignores stocks below defaul market cap floor' do
      Fabricate(:hist_data, period: '2012-12-31', price: 10, market_cap: 25)
      test = ScoreCalculator.new(period: '2012-12-31')
      expect(test.stocks.size).to eq(3)
    end

    it 'ignores stocks below explicit market cap floor' do
      Fabricate(:hist_data, period: '2012-12-31', price: 10, market_cap: 75)
      test = ScoreCalculator.new(period: '2012-12-31', market_cap_floor: 100)
      expect(test.stocks.size).to eq(3)
    end

    it 'ignores stocks above explicit market cap ceiling' do
      Fabricate(:hist_data, period: '2012-12-31', price: 10, market_cap: 20000)
      test = ScoreCalculator.new(period: '2012-12-31', market_cap_ceiling: 1000)
      expect(test.stocks.size).to eq(3)
    end
  end

  # describe '#assign_earnings_yield_scores' do
  #   it 'assigns correct EY scores' do
  #     car_wash = Fabricate(:hist_data, earnings_yield: 0.02)
  #     cartel = Fabricate(:hist_data, earnings_yield: 0.5)
  #     apple = Fabricate(:hist_data, earnings_yield: 0.2)
  #     test = ScoreCalculator.new(period: '2012-12-31')
  #     test.assign_earnings_yield_scores
  #     expect(test.stocks.select{|stock| stock["earnings_yield"] == 0.5}.first["ey_score"]).to eq(1)
  #     expect(test.stocks.select{|stock| stock["earnings_yield"] == 0.2}.first["ey_score"]).to eq(2)
  #     expect(test.stocks.select{|stock| stock["earnings_yield"] == 0.02}.first["ey_score"]).to eq(3)
  #   end
  # end

  # describe '#assign_roc_scores' do
  #   it 'assigns correct roc scores' do
  #     car_wash = Fabricate(:hist_data, roc: 0.02)
  #     cartel = Fabricate(:hist_data, roc: 0.7)
  #     apple = Fabricate(:hist_data, roc: 0.5)
  #     test = ScoreCalculator.new(period: '2012-12-31')
  #     test.assign_roc_scores
  #     expect(test.stocks.select{|stock| stock["roc"] == 0.7}.first["roc_score"]).to eq(1)
  #     expect(test.stocks.select{|stock| stock["roc"] == 0.5}.first["roc_score"]).to eq(2)
  #     expect(test.stocks.select{|stock| stock["roc"] == 0.02}.first["roc_score"]).to eq(3)
  #   end
  # end

  describe '#assign_scores' do
    it 'assigns correct total scores' do
      car_wash = Fabricate(:hist_data, roc: 0.02, earnings_yield: 0.8, cid: 'car_wash')
      cartel = Fabricate(:hist_data, roc: 0.7, earnings_yield: 0.15, cid: 'cartel')
      apple = Fabricate(:hist_data, roc: 0.5, earnings_yield: 0.01, cid: 'apple')
      test = ScoreCalculator.new(period: '2012-12-31')
      test.assign_scores
      expect(test.stocks.select{|stock| stock["cid"] == 'cartel'}.first["total_score"]).to eq(3)
      expect(test.stocks.select{|stock| stock["cid"] == 'apple'}.first["total_score"]).to eq(5)
      expect(test.stocks.select{|stock| stock["cid"] == 'car_wash'}.first["total_score"]).to eq(4)      
    end
  end
end
