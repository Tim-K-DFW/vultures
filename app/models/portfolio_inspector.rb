class PortfolioInspector
  attr_reader :portfolio, :report_date

  def initialize(portfolio, report_date)
    @portfolio = portfolio
    @report_date = report_date
  end

  def snapshot
    result = {}
    binding.pry
    result[:delisted_positions] = delisted_positions
    result[:positions] = portfolio.periods[report_date][:positions].dup
    result[:positions].delete_if{|k,v| result[:delisted_positions].keys.include?(k)}
    result[:cash] = (portfolio.periods[report_date][:cash] + delisting_proceeds(result[:delisted_positions])).round(2)
    result[:market_value] = positions_value(result[:positions]) + result[:cash]
    result
  end

  def delisted_positions
    portfolio.periods[report_date][:positions].select{ |k, v| v.delisted? }
  end

  def delisting_proceeds(delisted_positions)
    result = 0
    delisted_positions.each do |cid, position|
      result += (position[:share_count] * PricePoint.where(period: report_date, cid: cid).first.price).round(2)
    end
    result
  end

  def positions_value(survived_positions)
    result = 0
    survived_positions.each do |cid, position|
      result += (position[:share_count] * PricePoint.where(period: report_date, cid: cid).first.price).round(2)
    end
    result
  end
end
