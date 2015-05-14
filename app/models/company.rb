class Company < ActiveRecord::Base
  has_many :price_points, foreign_key: :cid, primary_key: :cid
end
