class ProductTicket < ApplicationRecord
  include CanBeTopped
  belongs_to :product
  belongs_to :ticket

  def self.chartify sum_column
    joins(:ticket)
    .group(:product_id)
    .group_by_month(:time)
    .order("sum_#{sum_column} DESC, product_id")
    .sum(sum_column)
    .map do |key, cnt|
      [[Product.where(id: key[0]).pluck(:name),key[1]],
      cnt]
    end
  end
end
