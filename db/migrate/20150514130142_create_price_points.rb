class CreatePricePoints < ActiveRecord::Migration
  def change
    create_table :price_points do |t|
      t.string :cid
      t.date :period, :delisting_date
      t.float :market_cap, :earnings_yield, :roc, :price
      t.boolean :delisted
    end
  end
end
