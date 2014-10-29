require 'csv'

class Exchange
  attr_reader :currency

  def initialize(money, currency)
    @money = money
    @currency = currency
  end

  def call
    Money.new((@money*find_exchange_rate).value, currency)
  end

  private
  def find_exchange_rate
    read_file.find{|x| x['currency'] == currency}['exchange_rate'].to_f
  end

  def read_file
    CSV.open(File.expand_path('../../exchange_rate.csv', __FILE__), headers: true)
  end
end
