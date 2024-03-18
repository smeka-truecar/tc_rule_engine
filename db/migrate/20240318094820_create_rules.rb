class CreateRules < ActiveRecord::Migration[7.1]
  def change
    create_table :rules do |t|
      t.string :rule_type
      t.integer :adjustment_value
      t.float :adjustment_percentage
      t.belongs_to :dealer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
