require_relative 'order'
require_relative 'exchange'
require_relative 'mail'

class Report
  attr_reader :orders

  def self.send!(e)
    p 'should working still'
    3.times { Mail.new(e).send! }
  end
end
