class Product < ApplicationRecord
  def self.get_ordered(ids)
    where(id: ids).order("array_position(array#{ids}, (id :: int) )")
  end
end
