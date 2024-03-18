class QuoteCalculator
  attr_reader :vehicle_info

  def initialize(vehicle_info)
    @vehicle_info = vehicle_info.with_indifferent_access
  end

  def calculate
    dealer_ids = exclude_rules.each_with_object([]) do |rule, dealer_ids|
      dealer_ids << rule.dealer_id if rule.conditions_met?(vehicle_info)
    end

    selected_rules = include_rules(dealer_ids)
    return no_quote if selected_rules.blank?

    quotes = selected_rules.each_with_object([]) do |rule, quotes|
      next unless rule.conditions_met?(vehicle_info)

      quotes << rule.calc_price(vehicle_info[:base_price])
    end
    return no_quote if quotes.blank?

    { quote: calculate_price(quotes) }
  end

  private

  def no_quote
    { quote: nil, message: "No Quote found" }
  end

  def exclude_rules
    Rule.where(rule_type: 'exclude').includes(:conditions)
  end

  def include_rules(dealer_ids)
    Rule.where(rule_type: 'include').where.not(dealer_id: dealer_ids).includes(:conditions)
  end

  def calculate_price(quotes)
    min_prices = Hash.new(Float::INFINITY)

    quotes.each do |quote|
      price, dealer_id = quote
      min_prices[dealer_id] = price if price < min_prices[dealer_id]
    end

    min_prices.values.max
  end
end
