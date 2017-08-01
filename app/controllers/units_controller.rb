class UnitsController < ApplicationController
  before_action :set_unit, except: [:index, :ammount_chart]

  # GET /units
  # GET /units.json
  def index
    @units = Unit.all.order(:name)
    ids = ProductTicket.joins(:ticket => :unit)
                              .group(:unit_id)
                              .order('sum_ammount DESC')
                              .limit(10)
                              .sum(:ammount)
                              .map {|k,v| k}
    @top_units = Unit.where(id: ids).order("array_position(array#{ids}, (id :: int) )")
  end

  # GET /units/1
  # GET /units/1.json
  def show
    @top_products = Product.get_ordered(top_ids)
    @bottom_products = Product.get_ordered(bottom_ids)
    @best_products = Product.get_ordered(best_ids)
    @worst_products = Product.get_ordered(worst_ids)
  end

  def ammount_chart
    render json: ProductTicket.joins(:ticket => :unit)
                        .group("units.name")
                        .group_by_month(:time)
                        .order('sum_ammount DESC')
                        .sum(:ammount).chart_json
  end

  def top_products_chart
    chart = Hash[ProductTicket.chartify(:ammount, ProductTicket.where(product_id: top_ids)
                                            .where(tickets: {unit_id: @unit.id}))]
    render json: chart.chart_json
  end

  def bottom_products_chart
    chart = Hash[ProductTicket.chartify(:ammount, ProductTicket.where(product_id: bottom_ids)
                                                .where(tickets: {unit_id: @unit.id}))]
    render json: chart.chart_json
  end

  def best_products_chart
    chart = Hash[ProductTicket.chartify(:price, ProductTicket.where(product_id: best_ids)
                                                .where(tickets: {unit_id: @unit.id}))]
    render json: chart.chart_json
  end

  def worst_products_chart
    chart = Hash[ProductTicket.chartify(:price, ProductTicket.where(product_id: worst_ids)
                                                .where(tickets: {unit_id: @unit.id}))]
    render json: chart.chart_json
  end

  private

    def top_ids
      @top_ids ||= ProductTicket.joins(:ticket).where('"tickets"."unit_id" = ?', @unit.id)
                                                .top_by_ammount(:product_id, 10)
    end
    def bottom_ids
      @bottom_ids ||= ProductTicket.joins(:ticket).where('"tickets"."unit_id" = ?', @unit.id)
                                                  .bottom_by_ammount(:product_id, 10)
    end

    def best_ids
      @best_ids ||= ProductTicket.joins(:ticket).where('"tickets"."unit_id" = ?', @unit.id)
                                                .top_by_price(10)
    end
    def worst_ids
      @worst_ids ||= ProductTicket.joins(:ticket).where('"tickets"."unit_id" = ?', @unit.id)
                                                  .bottom_by_price(10)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end
end
