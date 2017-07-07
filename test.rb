require 'csv'
require 'date'


CSV.foreach('db/tickets.csv') do |line|
  time = DateTime.strptime(line[1], "%m/%d/%Y %H:%M")
  next if time.in_time_zone("Mexico City").year != 2017
  
end