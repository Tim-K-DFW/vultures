class ScoreCalculator
  attr_accessor :stocks

  def initialize(args)
    @stocks = Data.find_stocks(period: args[:period])
  end

  def assign
    assign_scores(stocks)
    stocks
  end

  private

  def assign_scores
    assign_EY_scores
    assign_ROC_scores
    assign_total_scores
  end

  def assign_ey_scores
    for each stock do
        reverse sort by earnings yield
        assign ratings: stock with highest earnings yield has EY rating = 1, etc.
      end
  end

  def assign_ROC_scores
    for each stock do
        reverse sort by ROC
        assign ratings: stock with highest earnings yield has ROC rating = 1, etc.
      end
  end

  def assign_total_scores
    for each stock do
        total rating = EY rating + ROC rating
      end
  end
end