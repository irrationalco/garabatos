class Ticket < ApplicationRecord
  belongs_to :unit
  belongs_to :shift
  belongs_to :service_type
end
