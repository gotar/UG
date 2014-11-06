require_relative 'product'

class Order
  attr_accessor :full_name, :date, :products

  def initialize(full_name, date, products)
    @full_name = full_name
    @date = date
    @products = products
  end

  def total_amount
    return 0 if products.empty?
    Money.sum(products.map(&:price))
  end
end
