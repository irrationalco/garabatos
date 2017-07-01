class CreateProductTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :product_tickets do |t|
      t.references :product, foreign_key: true
      t.references :ticket, foreign_key: true
      t.float :ammount
      t.float :price

      t.timestamps
    end
  end
end
