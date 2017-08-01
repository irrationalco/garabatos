class ProductsController < ApplicationController
  before_action :set_product, except: [:index]

  # GET /products
  def index
    respond_to do |format|
      format.html
      format.json { render json: ProductDatatable.new(view_context) }
    end
  end

  # GET /products/1
  def show
     subquery = ProductTicket.select('unit_id, SUM(ammount) as sum_ammount')
                              .where(product_id: @product.id)
                              .joins(:ticket)
                              .group(:unit_id)

    @top_units = Unit.select('name, id')
                      .joins("INNER JOIN (#{subquery.to_sql}) p ON p.unit_id = id")
                      .order('p.sum_ammount DESC')
                      .limit(10)
    if just_one
      @ammount = ammount_info
      @utilities = utilities_info
      @price = price_info
    end
  end

  def ammount_chart
    render json: ammount_info
  end

  def utilities_chart
    render json: utilities_info
  end

  def price_chart
    render json: price_info
  end

  def units_chart
    if just_one
      render json: ProductTicket.where(product_id: @product.id)
                    .joins(:ticket => :unit)
                    .group("units.name")
                    .order('sum_ammount DESC')
                    .sum(:ammount)
    else
      render json: ProductTicket.where(product_id: @product.id)
                    .joins(:ticket => :unit)
                    .group("units.name")
                    .group_by_month(:time)
                    .order('sum_ammount DESC')
                    .sum(:ammount).chart_json
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def ammount_info
      @ammount_info ||= ProductTicket.where(product_id: @product.id)
                              .joins(:ticket)
                              .group_by_month(:time)
                              .sum(:ammount)
    end

    def utilities_info
      @utilities_info ||= ProductTicket.where(product_id: @product.id)
                              .joins(:ticket)
                              .group_by_month(:time)
                              .sum(:price)
                              .transform_values {|v| v*(1-@product.cost_ratio)}
    end

    def price_info
      @price_info ||= ProductTicket.where(product_id: @product.id)
                              .joins(:ticket)
                              .group_by_month(:time)
                              .average(:price)
    end

    def just_one
      @just_one ||= ProductTicket.where(product_id: @product.id)
                              .joins(:ticket)
                              .group_by_month(:time)
                              .count.length == 1
    end
end
