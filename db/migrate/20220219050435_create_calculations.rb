class CreateCalculations < ActiveRecord::Migration[7.0]
  def change
    create_table :calculations do |t|
      t.string :calculation_type
      t.integer :start_value
      t.integer :end_value
      t.string :solution
      t.string :error

      t.timestamps
    end
  end
end
