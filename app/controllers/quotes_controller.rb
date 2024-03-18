class QuotesController < ApplicationController
  def calculate_quote
    data = JSON.parse(request.body.read)
    result = QuoteCalculator.new(data).calculate
    render json: result
  end
end
  