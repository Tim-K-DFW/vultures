class PricePoint < ActiveRecord::Base
  belongs_to :company, foreign_key: :cid, primary_key: :cid
end
