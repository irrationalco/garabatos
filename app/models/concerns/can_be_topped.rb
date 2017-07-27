module CanBeTopped
  extend ActiveSupport::Concern

  module ClassMethods
    def top_by_price(column, limit=nil)
      relation = group(column).order('sum_price DESC')
      if limit
        relation = relation.limit(limit)
      end
      relation.sum(:price)
    end

    def bottom_by_price(column, limit=nil)
      relation = group(column).order('sum_price')
      if limit
        relation = relation.limit(limit)
      end
      relation.sum(:price)
    end

    def top_by_ammount(column, limit=nil)
      relation = group(column).order('sum_ammount DESC')
      if limit
        relation = relation.limit(limit)
      end
      relation.sum(:ammount)
    end

    def bottom_by_ammount(column, limit=nil)
      relation = group(column).order('sum_ammount')
      if limit
        relation = relation.limit(limit)
      end
      relation.sum(:ammount)
    end
  end

end