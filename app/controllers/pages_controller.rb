class PagesController < ApplicationController

  def dashboard
    # top_ids.map {find} vs Product.where(id: top_ids)
    @top_products = Product.where(id: top_ids)
    @bottom_products = Product.where(id: bottom_ids)
    @best_products = Product.where(id: best_ids)
    @worst_products = Product.where(id: worst_ids)

    last_month = Ticket.group_by_month(:time).count.keys.sort[-1]
    @trending_products = ProductTicket.joins(:ticket).where('time >= ?', last_month)
                                      .where('NOT ("product_tickets"."product_id" IN (?))',top_ids)
                                      .top_by_ammount(:product_id, 10).map do |id, count|
      Product.find(id)
    end
    @declining_products = ProductTicket.joins(:ticket).where('time >= ?', last_month)
                                      .where('NOT ("product_tickets"."product_id" IN (?))',bottom_ids)
                                      .bottom_by_ammount(:product_id, 10).map do |id, count|
      Product.find(id)
    end
  end

  def top_products_chart
    chart = Hash[ProductTicket.where(product_id: top_ids).chartify(:ammount)]
    render json: chart.chart_json
  end

  def bottom_products_chart
    chart = Hash[ProductTicket.where(product_id: bottom_ids).chartify(:ammount)]
    render json: chart.chart_json
  end

  def best_products_chart
    chart = Hash[ProductTicket.where(product_id: best_ids).chartify(:price)]
    render json: chart.chart_json
  end

  def worst_products_chart
    chart = Hash[ProductTicket.where(product_id: worst_ids).chartify(:price)]
    render json: chart.chart_json
  end

private
  def top_ids
    @top_ids ||= ProductTicket.top_by_ammount(:product_id, 10).map {|id, cnt| id}
  end
  def bottom_ids
    @bottom_ids ||= ProductTicket.bottom_by_ammount(:product_id, 10).map {|id, cnt| id}
  end

  def best_ids
    @best_ids ||= ProductTicket.top_by_price(:product_id, 10).map {|id, cnt| id}
  end
  def worst_ids
    @worst_ids ||= ProductTicket.bottom_by_price(:product_id, 10).map {|id, cnt| id}
  end

  def get_data
    # @pareto ||= ProductTicket.joins(:ticket).top_by_price(:product_id)
    # percent = @pareto.values.reduce(:+) * 0.8
    # sum = 0
    # @pareto = @pareto.keys.take_while {|k| sum+=@pareto[k];sum<percent}
    # p @pareto
    # units = ProductTicket.joins(:ticket).group(:unit_id)
    #               .group_by_month(:time)
    #               .order('sum_ammount DESC, unit_id')
    #               .sum(:ammount)
    # p units
  end

end
