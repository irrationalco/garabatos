json.extract! ticket, :id, :unit_id, :time, :number, :shift_id, :service_type_id, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
