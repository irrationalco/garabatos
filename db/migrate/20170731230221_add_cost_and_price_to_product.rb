class AddCostAndPriceToProduct < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.float :avg_price
      t.float :cost_ratio
    end
  end
end
