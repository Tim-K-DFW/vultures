require 'spec_helper'

describe ScoreCalculator do
  describe '#initialize' do
    it 'pulls all stocks from specified period range'
    it 'ignores stocks with 0 closing price'
    it 'ignores stocks which were delisted'
    it 'ignores stocks outside of specified market cap range'
  end

  describe '#assign_earnings_yield_scores' do
    it 'assigns correct EY scores'
  end

  describe '#assign_roc_scores' do
    it 'assigns correct roc scores'
  end

  describe '#assign_total_scores' do
    it 'assigns correct total scores'
  end
end
