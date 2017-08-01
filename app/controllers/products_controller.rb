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
                      .order('p.sum_ammount')
                      .limit(10)
  end

  def ammount_chart
    render json: ProductTicket.where(product_id: @product.id)
                              .joins(:ticket)
                              .group_by_month(:time)
                              .sum(:ammount)
  end

  def utilities_chart
    render json: ProductTicket.where(product_id: @product.id)
                              .joins(:ticket)
                              .group_by_month(:time)
                              .sum(:price)
                              .transform_values {|v| v*(1-@product.cost_ratio)}
  end

  def price_chart
    p ProductTicket.where(product_id: @product.id)
                              .joins(:ticket)
                              .group_by_month(:time)
                              .average(:price)
    render json: ProductTicket.where(product_id: @product.id)
                              .joins(:ticket)
                              .group_by_month(:time)
                              .average(:price)
  end

  def units_chart
    render json: ProductTicket.where(product_id: @product.id)
                  .joins(:ticket => :unit)
                  .group("units.name")
                  .group_by_month(:time)
                  .order('sum_ammount DESC')
                  .sum(:ammount).chart_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end
end
