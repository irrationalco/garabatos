class PagesController < ApplicationController

  def dashboard
    # top_ids.map {find} vs Product.where(id: top_ids)
    @top_products = Product.where(id: top_ids)
    @bottom_products = Product.where(id: bottom_ids)
    @best_products = Product.where(id: best_ids)
    @worst_products = Product.where(id: worst_ids)
  end

  def top_products_chart
    chart = Hash[ProductTicket.chartify(:ammount, ProductTicket.where(product_id: top_ids))]
    render json: chart.chart_json
  end

  def bottom_products_chart
    chart = Hash[ProductTicket.chartify(:ammount, ProductTicket.where(product_id: bottom_ids))]
    render json: chart.chart_json
  end

  def best_products_chart
    chart = Hash[ProductTicket.chartify(:price, ProductTicket.where(product_id: best_ids))]
    render json: chart.chart_json
  end

  def worst_products_chart
    chart = Hash[ProductTicket.chartify(:price, ProductTicket.where(product_id: worst_ids))]
    render json: chart.chart_json
  end

private
  def top_ids
    @top_ids ||= ProductTicket.top_by_ammount(:product_id, 10)
  end
  def bottom_ids
    @bottom_ids ||= ProductTicket.bottom_by_ammount(:product_id, 10)
  end

  def best_ids
    @best_ids ||= ProductTicket.top_by_price(10)
  end
  def worst_ids
    @worst_ids ||= ProductTicket.bottom_by_price(10)
  end

end
