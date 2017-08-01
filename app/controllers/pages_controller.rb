class PagesController < ApplicationController

  def home
  end

  def dashboard
    # top_ids.map {find} vs Product.where(id: top_ids)
    @top_products = Product.get_ordered(top_ids)
    @bottom_products = Product.get_ordered(bottom_ids)
    @best_products = Product.get_ordered(best_ids)
    @worst_products = Product.get_ordered(worst_ids)
    @top_products_sales = Product.get_ordered(top_ids_sales)
    @bottom_products_sales = Product.get_ordered(bottom_ids_sales)
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

  def top_products_sales_chart
    chart = Hash[ProductTicket.chartify(:ammount, ProductTicket.where(product_id: top_ids_sales))]
    render json: chart.chart_json
  end

  def bottom_products_sales_chart
    chart = Hash[ProductTicket.chartify(:ammount, ProductTicket.where(product_id: bottom_ids_sales))]
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

  def top_ids_sales
    @top_ids_sales ||= ProductTicket.top_by_sales(:product_id, 10)
  end
  def bottom_ids_sales
    @bottom_ids_sales ||= ProductTicket.bottom_by_sales(:product_id, 10)
  end

end
