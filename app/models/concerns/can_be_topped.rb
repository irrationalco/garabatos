module CanBeTopped
  extend ActiveSupport::Concern

  module ClassMethods
    def top_by_price(column, limit)
      group(column).order('sum_price DESC').limit(limit).sum(:price)
    end

    def bottom_by_price(column, limit)
      group(column).order('sum_price').limit(limit).sum(:price)
    end

    def top_by_ammount(column, limit)
      group(column).order('sum_ammount DESC').limit(limit).sum(:ammount)
    end

    def bottom_by_ammount(column, limit)
      group(column).order('sum_ammount').limit(limit).sum(:ammount)
    end
  end

end