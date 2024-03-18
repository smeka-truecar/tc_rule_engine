require 'minitest/autorun'
require 'minitest/spec'
require_relative '../test_helper.rb'

describe QuoteCalculator do
  let(:vehicle) do
    {
      make: 'Toyota',
      model: 'Camry',
      year: 2022,
      mileage: 50000,
      base_price: 20000
    }
  end

  before do
    setup_dealer_rules
  end

  describe '#calculate' do
    describe 'when there are exclude rules' do
      describe 'and if matched with vehicle info it returns no quote' do
        it 'rule1 condition' do
          result = calculate(vehicle.merge(mileage: 150000))
          assert_equal "No Quote found", result[:message]
        end

        it 'rule2 condition' do
          result = calculate(vehicle.merge(year: 2023))
          assert_equal "No Quote found", result[:message]
        end

        it 'rule3 condition' do
          result = calculate(vehicle.merge(base_price: 75000))
          assert_equal "No Quote found", result[:message]
        end

        it 'rule4 condition' do
          result = calculate(vehicle.merge(title_type: "dirty"))
          assert_equal "No Quote found", result[:message]
        end

        it 'rule5 condition' do
          result = calculate(vehicle.merge(body_type: "CCT"))
          assert_equal "No Quote found", result[:message]
        end

        it 'rule6 condition' do
          result = calculate(vehicle.merge(engine_type: "EV"))
          assert_equal "No Quote found", result[:message]
        end

        it 'rule7 condition' do
          result = calculate(vehicle.merge(make: "LandRover", model: "RangeRover", trim: "AutoBiography"))
          assert_equal "No Quote found", result[:message]
        end

        it 'no rule matches it returns quote' do
          result = calculate(vehicle)
          assert_instance_of Integer, result[:quote]
        end
      end
    end

    describe 'when there are include rules' do
      describe 'and if matched with vehicle info it returns quote' do
        it 'rule1 condition' do
          result = calculate(vehicle.merge(make: "Ford", body_type: "SUV"))
          assert_equal 19000, result[:quote]
        end

        it 'rule2 condition' do
          result = calculate(vehicle.merge(make: "GMC", body_type: "SEDON"))
          assert_equal 20500, result[:quote]
        end

        it 'rule3 condition' do
          result = calculate(vehicle.merge(make: "Dodge"))
          assert_equal 19000, result[:quote]
        end

        it 'rule4 condition' do
          result = calculate(vehicle.merge(make: "Honda"))
          assert_equal 21000, result[:quote]
        end

        it 'rule4 condition' do
          result = calculate(vehicle.merge(make: "Hyundai"))
          assert_equal 20500, result[:quote]
        end

        it 'rule5 condition' do
          result = calculate(vehicle.merge(make: "Nissan"))
          assert_equal 20750, result[:quote]
        end

        it 'rule6 condition' do
          result = calculate(vehicle.merge(make: "Kia", body_type: "SUV"))
          assert_equal 19000, result[:quote]
        end

        it 'rule7 condition' do
          result = calculate(vehicle.merge(make: "Kia"))
          assert_equal 20500, result[:quote]
        end
      end
    end
  end

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

  def calculate(vehicle)
    calculator = QuoteCalculator.new(vehicle)
    calculator.calculate
  end
end