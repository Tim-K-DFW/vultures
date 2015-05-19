require 'spec_helper'

describe Position do
  let(:today) { '2011-12-31' }

  describe '#share_count' do
    it 'correctly adds share count of one piece' do
     apple = fabricate_apple_position(one_piece: true)
     expect(apple.share_count).to eq(300)
    end

    it 'correctly adds share count of multiple pieces' do
      apple = fabricate_apple_position
      expect(apple.share_count).to eq(1600)
    end
  end

  describe '#market_value' do
    before { Fabricate(:price_point, cid: 'aapl', price: 15, period: '2011-12-31') }

    it 'correctly calculates total market value for one piece' do
      apple = fabricate_apple_position(one_piece: true)
      expect(apple.market_value).to eq(4500.00)
    end

    it 'correctly calculates total market value for multiple pieces' do
      apple = fabricate_apple_position
      expect(apple.market_value).to eq(24000.00)
    end
  end

  describe '#cost' do
    it 'correctly calculates total cost for one piece' do
      apple = fabricate_apple_position(one_piece: true)
      expect(apple.cost).to eq(4515.00)
    end

    it 'correctly calculates total cost for multiple pieces' do
      apple = fabricate_apple_position
      expect(apple.cost).to eq(18049)
    end
  end

  describe '#average_entry_price' do
    it 'correctly calculates average entry price for one piece' do
      apple = fabricate_apple_position(one_piece: true)
      expect(apple.average_entry_price).to eq(15.05)
    end

    it 'correctly calculates average entry price for multiple pieces' do
      apple = fabricate_apple_position
      expect(apple.average_entry_price).to eq(11.28)
    end
  end

  describe '#profit' do
    before { Fabricate(:price_point, cid: 'aapl', price: 15, period: '2011-12-31') }

    it 'correctly calculates profit for one piece' do
      apple = fabricate_apple_position(one_piece: true)
      expect(apple.profit).to eq(-15)
    end

    it 'correctly calculates profit for multiple pieces' do
      apple = fabricate_apple_position
      expect(apple.profit).to eq(5951)
    end
  end

  describe '#delisted?' do
    let(:apple) { fabricate_apple_position }

    it 'returns false if stock is not delisted as of initialization date' do
      Fabricate(:price_point, cid: 'aapl', price: 15, period: '2011-12-31')
      expect(apple.delisted?).to be_falsey
    end

    it 'returns true if stock is delisted as of initialization date' do
      Fabricate(:price_point, cid: 'aapl', price: 15, period: '2011-12-31', delisted: true, delisting_date: '2011-07-15')
      expect(apple.delisted?).to be_truthy
    end
  end

  describe '#delisting_info' do
    let(:apple) { fabricate_apple_position }

    it 'returns nil if stock is not delisted as of initialization date' do
      Fabricate(:price_point, cid: 'aapl', price: 15, period: '2011-12-31')
      expect(apple.delisting_info).to be_nil
    end

    it 'returns delisting date' do
      Fabricate(:price_point, cid: 'aapl', price: 15, period: '2011-12-31', delisted: true, delisting_date: '2011-07-15')
      expect(apple.delisting_info[:date]).to eq('2011-07-15')
    end

    it 'returns last listing price' do
      Fabricate(:price_point, cid: 'aapl', price: 15, period: '2011-12-31', delisted: true, delisting_date: '2011-07-15')
      expect(apple.delisting_info[:last_price]).to eq(15)
    end
  end

  describe '#decrease' do
    let(:apple){ fabricate_apple_position }

    it 'understands amount of "all"' do
      apple.decrease(:all)
      expect(apple.share_count).to eq(0)
    end

    it 'decreases total share count by specified amount' do
      apple.decrease(1500)
      expect(apple.share_count).to eq(100)
    end

    it 'removes empty pieces' do
      apple.decrease(1500)
      expect(apple.pieces['2009-12-31']).to be_nil
      expect(apple.pieces['2010-12-31']).to be_nil
    end

    it 'raises exception if amount exceeds total share count'
    it 'uses :fifo sell method if none is specified'
    it 'with sell method of :fifo, it decreases oldest pieces first'
    it 'with sell method of :lifo, it decreases newest pieces first'
  end

  
end


# ================================================


# 3. replace current methods with news accessors
# 4. change 'buy'
# 5. change 'sell'
