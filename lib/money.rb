class Money
  attr_reader :value, :currency

  def initialize(value, currency)
    @value = value.to_f.round(2)
    @currency = currency
  end

  def to_s
    "%.2f %s" % [value, currency]
  end

  def *(num)
    Money.new(value * num, currency)
  end

  def +(other)
    if other.currency != currency
      raise ArgumentError.new("Can't add monies due to different currency: #{other.inspect} and #{self.inspect}.")
    end

    Money.new(value + other.value, currency)
  end

  def -(other)
    if other.currency != currency
      raise ArgumentError.new("Can't substract monies due to different currency: #{other.inspect} and #{self.inspect}.")
    end
    Money.new(value - other.value, @currency)
  end

  def ==(other)
    currency == other.currency && @value == other.value
  end

  def positive?
    @value > 0
  end

  # This is a version of sum that works with different currencies.
  # Returns an array of Money instances, one for each currency that appeared
  # in the input array.
  def self.sum(moneys)
    moneys.group_by(&:currency).values.map(&:sum)
  end
end
