class CreateShifts < ActiveRecord::Migration[5.1]
  def change
    create_table :shifts do |t|
      t.text :name

      t.timestamps
    end
  end
end
