class PagesController < ApplicationController
  before_action :get_data, except: [:home, :top_units_chart]
  def home
  end

  def dashboard
    @top_products = @top_ids.map {|id| Product.find(id) }
    @bottom_products = @bottom_ids.map { |id| Product.find(id) }
    @best_products = @best_ids.map {|id| Product.find(id) }
    @worst_products = @worst_ids.map { |id| Product.find(id) }
    # no esta jalando
    last_month = Ticket.group_by_month(:time).count.keys.sort[-1]
    @trending_products = ProductTicket.joins(:ticket).where('time >= ?', last_month)
                                      .where('NOT ("product_tickets"."product_id" IN (?))',@top_ids)
                                      .top(:product_id, 10).map do |id, count|
      Product.find(id)
    end
    @declining_products = ProductTicket.joins(:ticket).where('time >= ?', last_month)
                                      .where('NOT ("product_tickets"."product_id" IN (?))',@bottom_ids)
                                      .group(:product_id)
                                      .order("count_all, product_id")
                                      .limit(10)
                                      .count.map do |id, count|
      Product.find(id)
    end
  end

  def top_products_chart
    chart = Hash[ProductTicket.where(product_id: @top_ids).chartify(:ammount)]
    render json: chart.chart_json
  end

  def bottom_products_chart
    chart = Hash[ProductTicket.where(product_id: @bottom_ids).chartify(:ammount)]
    render json: chart.chart_json
  end

  def best_products_chart
    chart = Hash[ProductTicket.where(product_id: @best_ids).chartify(:price)]
    render json: chart.chart_json
  end

  def worst_products_chart
    chart = Hash[ProductTicket.where(product_id: @worst_ids).chartify(:price)]
    render json: chart.chart_json
  end

  def units_chart
    render json: Hash[ProductTicket.joins(:ticket).group(:unit_id)
                                            .group_by_month(:time)
                                            .count
                                            .map do |key, cnt|
                                              [[Unit.where(id: key[0]).pluck(:name),key[1]],
                                              cnt]
                                            end
                                            ].chart_json
  end

private

  def get_data
    @top_ids ||= ProductTicket.top_by_ammount(:product_id, 10).map {|id, cnt| id}
    @bottom_ids ||= ProductTicket.bottom_by_ammount(:product_id, 10).map {|id, cnt| id}

    @best_ids ||= ProductTicket.top_by_price(:product_id, 10).map {|id, cnt| id}
    @worst_ids ||= ProductTicket.bottom_by_price(:product_id, 10).map {|id, cnt| id}
  end

end
