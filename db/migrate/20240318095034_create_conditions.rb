class CreateConditions < ActiveRecord::Migration[7.1]
  def change
    create_table :conditions do |t|
      t.belongs_to :rule, null: false, foreign_key: true
      t.string :vehicle_attribute
      t.string :operator
      t.string :value

      t.timestamps
    end
  end
end
