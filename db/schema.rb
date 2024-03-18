# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_18_095034) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conditions", force: :cascade do |t|
    t.bigint "rule_id", null: false
    t.string "vehicle_attribute"
    t.string "operator"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rule_id"], name: "index_conditions_on_rule_id"
  end

  create_table "dealers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rules", force: :cascade do |t|
    t.string "rule_type"
    t.integer "adjustment_value"
    t.float "adjustment_percentage"
    t.bigint "dealer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dealer_id"], name: "index_rules_on_dealer_id"
  end

  add_foreign_key "conditions", "rules"
  add_foreign_key "rules", "dealers"
end
