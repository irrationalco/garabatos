class CreateUnits < ActiveRecord::Migration[5.1]
  def change
    create_table :units do |t|
      t.text :name

      t.timestamps
    end
  end
end
