class PricePoint < ActiveRecord::Base
  belongs_to :company, foreign_key: :cid, primary_key: :cid

  def self.all_periods(args)
    # select(:period).map(&:period).uniq
    if args[:single_period] == '1'
      start_date = Date.strptime(args[:start_date], '%Y-%m-%d')
      [start_date.to_s, (start_date+1.year).to_s]
    else
      range = args[:development] == true ? (1993..2001).to_a : (1993..2014).to_a
      result = []
      range.each { |year| result << "#{year}-12-31" }
      result
    end
  end
end
