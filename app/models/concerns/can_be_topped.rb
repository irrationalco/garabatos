module CanBeTopped
  extend ActiveSupport::Concern

  module ClassMethods
    def top_by_price(limit=nil)

      prices = group(:product_id).select('"product_tickets"."product_id", SUM("product_tickets"."price") as sum_price')
      result = Product.select('id, p.sum_price*(1-cost_ratio) as utilities')
                      .where('cost_ratio IS NOT NULL')
                      .joins("INNER JOIN (#{prices.to_sql}) p ON p.product_id = id")
                      .order('utilities DESC, product_id')
      if limit
        result = result.limit(limit)
      end
      result.map {|x| x.id}
    end

    def bottom_by_price(limit=nil)
      prices = group(:product_id).select('"product_tickets"."product_id", SUM("product_tickets"."price") as sum_price')
      result = Product.select('id, p.sum_price*(1-cost_ratio) as utilities')
                      .where('cost_ratio IS NOT NULL')
                      .joins("INNER JOIN (#{prices.to_sql}) p ON p.product_id = id")
                      .order('utilities, product_id')
      if limit
        result = result.limit(limit)
      end
      result.map {|x| x.id}
    end

    def top_by_ammount(column, limit=nil)
      relation = group(column).order('sum_ammount DESC')
      if limit
        relation = relation.limit(limit)
      end
      relation.sum(:ammount).map {|id, cnt| id}
    end

    def bottom_by_ammount(column, limit=nil)
      relation = group(column).order('sum_ammount')
      if limit
        relation = relation.limit(limit)
      end
      relation.sum(:ammount).map {|id, cnt| id}
    end

  end
end