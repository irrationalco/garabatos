# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Shift.create(name: 'Cena')
Shift.create(name: 'Comida')
Shift.create(name: 'Desayuno')

ServiceType.create(name: 'Mostrador')
ServiceType.create(name: 'Salon')

require 'csv'

CSV.foreach('db/units.csv') do |line|
  Unit.create(name: line[0])
end

product_categories = [nil]
CSV.foreach('db/productCategories.csv') do |line|
  product_categories << line[0]
end

product_types = [nil,'Principal', 'Modificador']
product_sets = [nil,'Alimentos', 'Pasteleria', 'Bebidas']
CSV.foreach('db/products.csv') do |line|
  types = line[1].split('##').map do |t|
    product_types[t.strip.to_i]
  end
  categories = line[2].split('##').map do |t|
    product_categories[t.strip.to_i]
  end
  sets = line[3].split('##').map do |t|
    product_sets[t.strip.to_i]
  end
  codes = line[4].split('##').map do |t|
    t.strip
  end
  Product.create(name: line[0], types: types, categories: categories, sets: sets, codes: codes)
end

require 'date'

CSV.foreach('db/tickets.csv') do |line|
  time = DateTime.strptime(line[1], "%m/%d/%Y %H:%M")
  #next if time.in_time_zone("Mexico City").year != 2017
  Ticket.create(unit_id: line[0].to_i, time: time, number: line[2].to_i, shift_id: line[3].to_i, service_type_id: line[4].to_i)
end

CSV.foreach('db/productTickets.csv') do |line|
  ProductTicket.create(product_id: line[0].to_i, ticket_id: line[1].to_i, ammount: line[2].to_f, price: line[3].to_f)
end