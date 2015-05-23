class PricePoint < ActiveRecord::Base
  belongs_to :company, foreign_key: :cid, primary_key: :cid

  def self.all_periods(development=nil)
    # select(:period).map(&:period).uniq
    if development
      ['1952-12-31', '1953-12-31', '1954-12-31', '1955-12-31']
    else
      # need to hard-code, query every time is too long
    end
  end
end
