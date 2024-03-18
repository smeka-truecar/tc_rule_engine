class RulesController < ApplicationController
  before_action :set_dealer

  def index
    @rules = @dealer.rules
    render json: @rules, include: :conditions
  end

  def show
    @rule = @dealer.rules.find(params[:id])
    render json: @rule, include: :conditions
  end

  def create
    @rule = @dealer.rules.new(rule_params)

    if @rule.save
      render json: @rule, include: :conditions, status: :created
    else
      render json: @rule.errors, status: :unprocessable_entity
    end
  end

  def update
    @rule = @dealer.rules.find(params[:id])

    if @rule.update(rule_params)
      render json: @rule, include: :conditions
    else
      render json: @rule.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @rule = @dealer.rules.find(params[:id])
    @rule.destroy
  end

  private

  def set_dealer
    @dealer = Dealer.find(params[:dealer_id])
  end

  def rule_params
    params.require(:rule).permit(:rule_type, :adjustment_value, :adjustment_percentage, conditions_attributes: [:id, :vehicle_attribute, :operator, :value, :_destroy])
  end
end
