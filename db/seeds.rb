# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Shift.create(name: 'Cena')
Shift.create(name: 'Comida')
Shift.create(name: 'Desayuno')

ServiceType.create(name: 'Mostrador')
ServiceType.create(name: 'Salon')

ProductType.create(name: 'Principal')
ProductType.create(name: 'Modificador')

ProductSet.create(name: 'Alimentos')
ProductSet.create(name: 'Pasteleria')
ProductSet.create(name: 'Bebidas')

require 'csv'

CSV.foreach('db/units.csv') do |line|
  Unit.create(name: line[0])
end

CSV.foreach('db/productCategories.csv') do |line| 
  ProductCategory.create(name: line[0])
end

CSV.foreach('db/products.csv') do |line|
  types = line[1].split('##').map do |t|
    t.strip.to_i
  end
  categories = line[2].split('##').map do |t|
    t.strip.to_i
  end
  sets = line[3].split('##').map do |t|
    t.strip.to_i
  end
  codes = line[4].split('##').map do |t|
    t.strip
  end
  Product.create(name: line[0], types: types, categories: categories, sets: sets, codes: codes)
end