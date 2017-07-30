class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.text :name
      t.text :types, array: true
      t.text :categories, array: true
      t.text :sets, array: true
      t.text :codes, array: true

      t.timestamps
    end
  end
end
