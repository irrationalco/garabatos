class CreateProductSets < ActiveRecord::Migration[5.1]
  def change
    create_table :product_sets do |t|
      t.text :name

      t.timestamps
    end
  end
end
