class PagesController < ApplicationController
  before_action :get_data, except: [:home]
  def home
  end

  def dashboard
    @top_products = @top_ids.map {|id| Product.find(id) }
    @bottom_products = @bottom_ids.map { |id| Product.find(id) }
    # no esta jalando
    ids = Ticket.where('time > ?', 2.months.ago).ids
    @trending_products = ProductTicket.where(ticket_id: ids).top(:product_id, 10).map do |id, count|
      Product.find(id)
    end
  end

  def top_products_chart
    @top_products_chart = Hash[ProductTicket.where(product_id: @top_ids)
                                            .joins(:ticket)
                                            .group(:product_id)
                                            .group_by_month(:time)
                                            .count
                                            .map do |key, cnt|
                                              [[Product.where(id: key[0]).pluck(:name),key[1]],
                                              cnt]
                                            end
                                            ]
    render json: @top_products_chart.chart_json
  end

  def bottom_products_chart
    @bottom_products_chart = Hash[ProductTicket.where(product_id: @bottom_ids)
                                                .joins(:ticket)
                                                .group(:product_id)
                                                .group_by_month(:time)
                                                .count
                                                .map do |key, cnt|
                                                  [[Product.where(id: key[0]).pluck(:name),key[1]],
                                                  cnt]
                                                end
                                                                          ]
    render json: @bottom_products_chart.chart_json
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
    @top_ids ||= ProductTicket.top(:product_id, 10).map {|id, cnt| id}
    @bottom_ids ||= ProductTicket.group(:product_id).order("count_all, product_id")
                                                    .limit(10)
                                                    .count
                                                    .map {|id, cnt| id}
  end

end
