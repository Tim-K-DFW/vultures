class CreateHistData < ActiveRecord::Migration
  def change
    create_table :hist_data do |t|
      t.string :cid
      t.date :period, :delisting_date
      t.float :market_cap, :earnings_yield, :roc, :price
      t.boolean :delisted
    end
  end
end