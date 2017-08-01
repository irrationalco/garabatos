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

  def info_chart
    info = ProductTicket.select('SUM(ammount) as sum_ammount, SUM(price) as sum_price,'\
                                ' AVG(price) as avg_price,'\
                                "  (DATE_TRUNC('month', (time::timestamptz - INTERVAL '0 second') AT TIME ZONE 'Etc/UTC') + INTERVAL '0 second') AT TIME ZONE 'Etc/UTC' as time")
                        .where(product_id: @product.id)
                        .joins(:ticket)
                        .group_by_month(:time)
    result = {}
    info.each do |i|
      time = i.time.strftime("%a, %d %b %Y")
      result[['Ventas', time]] = i.sum_ammount
      result[['Utilidades', time]] = i.sum_price*(1-@product.cost_ratio)
      result[['Precio', time]] = i.avg_price
    end
    p result
    render json: result.chart_json
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
