# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


def setup_dealer_rules
  Dealer.destroy_all
  @dealer = Dealer.create(name: "Dealer 1")

  exclude_rules = [
    {
      conditions: [ vehicle_attribute: "mileage", value: "120000", operator: ">=" ]
    },
    {
      conditions: [ vehicle_attribute: "year", value: "2023", operator: ">=" ]
    },
    {
      conditions: [ vehicle_attribute: "base_price", value: "60000", operator: ">=" ]
    },
    {
      conditions: [ vehicle_attribute: "title_type", value: "dirty", operator: "==" ]
    },
    {
      conditions: [ vehicle_attribute: "engine_type", value: "EV, CNG, P, D", operator: "in" ]
    },
    {
      conditions: [ vehicle_attribute: "body_type", value: "CV, CCT", operator: "in" ]
    },
    {
      conditions: [
        { vehicle_attribute: "make", value: "LandRover", operator: "==" },
        { vehicle_attribute: "model", value: "RangeRover", operator: "==" },
        { vehicle_attribute: "trim", value: "AutoBiography", operator: "==" }
      ]
    }
  ]

  include_rules = [
    { adjustment_value: -1000, conditions: [
        { vehicle_attribute: "make", value: "Chevrolet, Ford, GMC", operator: "in" },
        { vehicle_attribute: "body_type", value: "T,SUV", operator: "in" }
      ]
    },
    { adjustment_value: 500, conditions: [
        { vehicle_attribute: "make", value: "Chevrolet, Ford, GMC", operator: "in" },
        { vehicle_attribute: "body_type", value: "T,SUV", operator: "nin" }
      ]
    },
    { adjustment_value: -1000, conditions: [
        { vehicle_attribute: "make", value: "Dodge", operator: "==" }
      ]
    },
    { adjustment_value: 1000, conditions: [
        { vehicle_attribute: "make", value: "Honda, Toyota", operator: "in" }
      ]
    },
    { adjustment_value: 500, conditions: [
        { vehicle_attribute: "make", value: "Hyundai, Volkswagen", operator: "in" }
      ]
    },
    { adjustment_value: 750, conditions: [
        { vehicle_attribute: "make", value: "Jeep, Mazda, Nissan, Subaru", operator: "in" }
      ]
    },
    { adjustment_value: -1000, conditions: [
        { vehicle_attribute: "make", value: "Kia", operator: "==" },
        { vehicle_attribute: "body_type", value: "SUV", operator: "in" }
      ]
    },
    { adjustment_value: 500, conditions: [
        { vehicle_attribute: "make", value: "Kia", operator: "==" },
        { vehicle_attribute: "body_type", value: "SUV", operator: "!=" }
      ]
    }
  ]

  setup_rules(exclude_rules, "exclude")
  setup_rules(include_rules, "include")
end

def setup_rules(rules, rule_type)
  rules.each do |rule_data|
    rule = @dealer.rules.create(rule_type: rule_type, adjustment_value: rule_data[:adjustment_value])
    rule_data[:conditions].each do |condition_data|
      rule.conditions.create(condition_data)
    end
  end
end

setup_dealer_rules if Dealer.count > 0
