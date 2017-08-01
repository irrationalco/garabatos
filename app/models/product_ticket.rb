class ProductTicket < ApplicationRecord
  include CanBeTopped
  belongs_to :product
  belongs_to :ticket

  def self.chartify sum_column, relation
    res = relation.joins(:ticket)
                  .group(:product_id)
                  .group_by_month(:time)
                  .order("sum_#{sum_column} DESC, product_id")
                  .sum(sum_column)
    if sum_column == :price
      product_ids = relation.where_values_hash["product_id"]
      product_info = Hash[Product.select(:id, :cost_ratio, :name)
                                  .where(id: product_ids)
                                  .map {|x| [x.id, {name: x.name, ratio: x.cost_ratio}]}]
      res.map do |key, sum|
        [[product_info[key[0]][:name], key[1]],
        sum*(1-product_info[key[0]][:ratio])]
      end
    else
      names = Product.select(:id,:name).where(id: (res.keys.map {|x| x[0]}).uniq).index_by(&:id)
      res.map do |key, cnt|
        [[names[key[0]][:name],key[1]],
        cnt]
      end
    end
  end
end
