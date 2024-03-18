class Rule < ApplicationRecord
  has_many :conditions, dependent: :destroy
  belongs_to :dealer

  def conditions_met?(vehicle_info)
    conditions.present? &&conditions.all? { |condition| condition.evaluate(vehicle_info) }
  end

  def calc_price(base_price)
    if adjustment_value
      base_price += adjustment_value
    elsif adjustment_percentage
      base_price += (adjustment_percentage / 100.0) * base_price
    end
    [base_price, dealer_id]
  end
end
