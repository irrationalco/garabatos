class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.text :name
      t.integer :types, array: true
      t.integer :categories, array: true
      t.integer :sets, array: true
      t.text :codes, array: true

      t.timestamps
    end
  end
end
