class Condition < ApplicationRecord
  belongs_to :rule

  def evaluate(vehicle_info)
    field_value = vehicle_info[field_name.to_sym]

    operator_lambda.call(field_value, value)
  end

  private

  def field_name
    case vehicle_attribute
    when 'make', 'model', 'year', 'mileage', 'base_price', 'trim', 'engine_type', 'body_type', 'title_type'
      vehicle_attribute.to_sym
    else
      nil
    end
  end

  def operator_lambda
    case operator
    when '=='
      ->(field_value, value) { field_value.to_s == value }
    when '!='
      ->(field_value, value) { field_value.to_s != value }
    when '>='
      ->(field_value, value) { field_value.to_f >= value.to_f }
    when '<='
      ->(field_value, value) { field_value.to_f <= value.to_f }
    when '>'
      ->(field_value, value) { field_value.to_f > value.to_f }
    when '<'
      ->(field_value, value) { field_value.to_f < value.to_f }
    when 'in'
      ->(field_value, value) { value.split(",").map(&:strip).include?(field_value) }
    when 'nin'
      ->(field_value, value) { !value.split(",").map(&:strip).include?(field_value) }
    else
      ->(field_value, value) { false }
    end
  end
end
