require_relative '../../../lib/extend_enumerable'
require_relative '../../../models/money'

describe Money do
  it "should be initialized with two arguments" do
    expect {
      Money.new(10, 'EUR')
    }.to_not raise_error
  end

  describe "#value" do
    it "should convert it to a number" do
      Money.new('100', 'EUR').value.should == 100
    end

    it "should work for numbers with fractional digits" do
      Money.new('123.45', 'EUR').value.should == 123.45
    end

    it "should allow for negativ numbers" do
      Money.new(-123.45, 'EUR').value.should == -123.45
    end
  end

  describe "#currency" do
    it "should save it as it was passed" do
      Money.new(10, 'PLN').currency.should == 'PLN'
    end
  end

  describe "#to_s" do
    it "should return value with currency" do
      Money.new('123.45', 'PLN').to_s.should == "123.45 PLN"
    end

    it "should always return two fractional digits" do
      Money.new('1.6', 'EUR').to_s.should == '1.60 EUR'
    end

    it "should keep negative value" do
      Money.new('-1.6', 'EUR').to_s.should == '-1.60 EUR'
    end
  end

  describe "#*" do
    let(:money) { Money.new('12.34', 'EUR') }
    let(:result) { money * 0.1 }

    it "should return a new money" do
      result.should be_a(Money)
      result.should_not == money
    end

    it "should multiplicate value of the money" do
      result.value.should == 1.23
    end

    it "should keep the currency of the original money" do
      result.currency.should == 'EUR'
    end

    it "should calculate negative value in proper way" do
     ( Money.new('-12.34', 'EUR') * 0.1).value.should == -1.23
    end

    it "should allow to multiple for negativ value" do
     ( Money.new('12.34', 'EUR') * (-1)).value.should == -12.34
    end
  end

  describe "#+" do
    let(:money) { Money.new('12.34', 'EUR') }
    let(:result) { money + Money.new('5.6', 'EUR') }

    it "should return a new money" do
      result.should be_a(Money)
      result.should_not == money
    end

    it "should add values of both monies" do
      result.value.should == 17.94
    end

    it "should keep currency of the money" do
      result.currency.should == 'EUR'
    end

    it "should raise error when monies have different currency" do
      expect {
        money + Money.new('5.6', 'PLN')
      }.to raise_error(ArgumentError)
    end
  end

  describe "#-" do
    let(:money) { Money.new('12.34', 'EUR') }
    let(:result) { money - Money.new('5.6', 'EUR') }

    it "should return a new money" do
      result.should be_a(Money)
      result.should_not == money
    end

    it "should minus values of both monies" do
      result.value.should == 6.74
    end

    it "should keep currency of the money" do
      result.currency.should == 'EUR'
    end

    it "should raise error when monies have different currency" do
      expect {
        money - Money.new('5.6', 'PLN')
      }.to raise_error(ArgumentError)
    end
  end
  
  describe "#positive?" do
    context "for money with positive value" do
      subject { Money.new('12.34', 'EUR') }

      its(:positive?) { should be_true }
    end

    context "for money with negative value" do
      subject { Money.new('-12.34', 'EUR') }

      its(:positive?) { should be_false }
    end

    context "for money with zero value" do
      subject { Money.new('0.00', 'EUR') }

      its(:positive?) { should be_false }
    end
  end

  describe ".sum" do
    let(:little_euro) { Money.new('1.23', 'EUR') }
    let(:more_euro) { Money.new('9.87', 'EUR') }
    let(:neg_euro) { Money.new('-2.87', 'EUR') }
    let(:little_pln) { Money.new('2.33', 'PLN') }
    let(:more_pln) { Money.new('8.99', 'PLN') }
    let(:neg_pln) { Money.new('-2.99', 'PLN') }

    it "should return empty array for empty array" do
      Money.sum([]).should == []
    end

    it "should return array with one element for one element array" do
      Money.sum([little_euro]).should == [little_euro]
    end

    it "should return two elements array when two different currencies are passed" do
      Money.sum([little_euro, little_pln]).should == [little_euro, little_pln]
    end

    it "should sum all moneys matching currencies" do
      Money.sum([little_euro, more_euro, neg_euro, little_pln, more_pln, neg_pln]).should ==
        [Money.new('8.23', 'EUR'), Money.new('8.33', 'PLN')]
    end
  end
end
