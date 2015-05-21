class PricePoint < ActiveRecord::Base
  belongs_to :company, foreign_key: :cid, primary_key: :cid

  def self.all_periods
    select(:period).map(&:period).uniq
  end
end
