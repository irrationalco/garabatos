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

  def pareto_chart
    prices = ProductTicket.group(:product_id).select('product_id, SUM(price) as sum_price')
    result = Product.select('name, p.sum_price*(1-cost_ratio) as utilities')
                    .where('cost_ratio IS NOT NULL')
                    .joins("INNER JOIN (#{prices.to_sql}) p ON p.product_id = id")
                    .order('utilities DESC, product_id')
    total = result.sum {|r| r.utilities} / 100
    sum = 0
    info = {}
    result.each do |r|
      if sum >= 80
        break
      end
      sum += r.utilities / total
      info[r.name] = sum
    end

    render json: info
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
