class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.references :unit, foreign_key: true
      t.datetime :time
      t.integer :number
      t.references :shift, foreign_key: true
      t.references :service_type, foreign_key: true

      t.timestamps
    end
  end
end
