require 'pg'
require 'sequel'
require 'pry'

DB = Sequel.connect 'postgres://localhost/sequel-single-table'

def currency_format(numeric)
  format("$%0.2f", numeric)
end

result = DB[:menu_items].select do
  labor_calc = prep_time / 60.0 * 12
  profit_calc = menu_price - ingredient_cost - labor_calc
  [item, menu_price, ingredient_cost, prep_time,
   labor_calc.as(labor), profit_calc.as(profit)]
end

result.each do |item|
  puts item[:item]
  puts "menu price: #{currency_format(item[:menu_price])}"
  puts "ingredient cost: #{currency_format(item[:ingredient_cost])}"
  puts "prep time: #{item[:prep_time]}"
  puts "labor: #{currency_format(item[:labor].to_f)}"
  puts "profit: #{currency_format(item[:profit])}"
  puts ''
end
