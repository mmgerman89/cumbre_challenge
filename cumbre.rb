# This code assumes that shoppings are loaded in a file called "shopping_carts.rb" in the same folder than this file
# Each shopping cart should finish with a line with three hyphen: ---
# Author: German Martinez

class Receipt
  def initialize(shopping_basket)
    process_input(shopping_basket)
  end

  def print_receipt
    total = 0
    sales_taxes = 0
    @items.each do |item|
      total_line = (item[:qty] * (item[:price] + item[:taxes])).round(2)
      total += total_line
      sales_taxes += item[:qty] * item[:taxes]
      puts "#{item[:qty]} #{item[:product]}: #{'%.2f' % total_line}"
    end
    puts "Sales Taxes: #{'%.2f' % sales_taxes}"
    puts "Total: #{'%.2f' % total}"
  end

  private

  def exempt?(product)
    exempted_basic_tax = %w[book food chocolate medical pills]
    exempted_basic_tax.any? { |exempt_product| product.include?(exempt_product) }
  end

  def imported?(product)
    product.include?('imported')
  end

  def process_input(input)
    @items = []
    input.each_line do |line|
      qty, product, price = process_line(line)
      taxes = calculate_taxes(product, price)

      @items << { qty: qty, product: product, price: price, taxes: taxes }
    end
  end

  def calculate_taxes(product, price)
    taxes = 0
    taxes += price * 0.1 unless exempt?(product)
    taxes += price * 0.05 if imported?(product)
    (taxes * 20).ceil / 20.0
  end

  def process_line(line)
    qty = line[/\d+ /, 0]
    qty = qty.to_i
    product = line[/(\D* at)/, 0]
    product = product[1..product.length - 3].strip
    price = line.split(/(\d+ \D*)/).last
    price = price.to_f

    [qty, product, price]
  end

  def round_up(value)
    (value * 20).ceil / 20.0
  end
end

shopping_basket = ''
count = 0
file = File.open('shopping_carts.txt')
file.each_line do |line|
  if line.include? '---'
    count += 1
    puts "\nReceipt ##{count}:"
    receipt = Receipt.new(shopping_basket)
    receipt.print_receipt
    shopping_basket = ''
  else
    shopping_basket += line
  end
end
