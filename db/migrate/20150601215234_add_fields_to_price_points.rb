class AddFieldsToPricePoints < ActiveRecord::Migration
  def change
    add_column :price_points, :ltm_ebit, :float
    add_column :price_points, :nwc, :float
    add_column :price_points, :ev, :float
    add_column :price_points, :net_ppe, :float
  end
end
