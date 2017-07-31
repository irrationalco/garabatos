class ProductTicket < ApplicationRecord
  include CanBeTopped
  belongs_to :product
  belongs_to :ticket

  def self.chartify sum_column
    res = joins(:ticket)
    .group(:product_id)
    .group_by_month(:time)
    .order("sum_#{sum_column} DESC, product_id")
    .sum(sum_column)
    names = Product.select(:id,:name).where(id: res.keys.map {|x| x[0]}).index_by(&:id)
    res.map do |key, cnt|
      [[names[key[0]][:name],key[1]],
      cnt]
    end
  end
end
