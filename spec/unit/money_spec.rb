require_relative '../../lib/extend_enumerable'
require_relative '../../lib/money'

describe Money do
  it "be initialized with two arguments" do
    expect {
      Money.new(10, 'EUR')
    }.to_not raise_error
  end

  describe "#value" do
    it "convert it to a number" do
      expect(Money.new('100', 'EUR').value).to eq(100)
    end

    it "work for numbers with fractional digits" do
      expect(Money.new('123.45', 'EUR').value).to eq(123.45)
    end

    it "allow for negativ numbers" do
      expect(Money.new(-123.45, 'EUR').value).to eq(-123.45)
    end
  end

  describe "#currency" do
    it "save it as it was passed" do
      expect(Money.new(10, 'PLN').currency).to eq('PLN')
    end
  end

  describe "#to_s" do
    it "return value with currency" do
      expect(Money.new('123.45', 'PLN').to_s).to eq("123.45 PLN")
    end

    it "always return two fractional digits" do
      expect(Money.new('1.6', 'EUR').to_s).to eq('1.60 EUR')
    end

    it "keep negative value" do
      expect(Money.new('-1.6', 'EUR').to_s).to eq('-1.60 EUR')
    end
  end

  describe "#*" do
    let(:money) { Money.new('12.34', 'EUR') }
    let(:result) { money * 0.1 }

    it "return a new money" do
      expect(result).to be_a(Money)
      expect(result).not_to eq(money)
    end

    it "multiplicate value of the money" do
      expect(result.value).to eq(1.23)
    end

    it "keep the currency of the original money" do
      expect(result.currency).to eq('EUR')
    end

    it "calculate negative value in proper way" do
     expect(( Money.new('-12.34', 'EUR') * 0.1).value).to eq(-1.23)
    end

    it "allow to multiple for negativ value" do
     expect(( Money.new('12.34', 'EUR') * (-1)).value).to eq(-12.34)
    end
  end

  describe "#+" do
    let(:money) { Money.new('12.34', 'EUR') }
    let(:result) { money + Money.new('5.6', 'EUR') }

    it "return a new money" do
      expect(result).to be_a(Money)
      expect(result).not_to eq(money)
    end

    it "add values of both monies" do
      expect(result.value).to eq(17.94)
    end

    it "keep currency of the money" do
      expect(result.currency).to eq('EUR')
    end

    it "raise error when monies have different currency" do
      expect {
        money + Money.new('5.6', 'PLN')
      }.to raise_error(ArgumentError)
    end
  end

  describe "#-" do
    let(:money) { Money.new('12.34', 'EUR') }
    let(:result) { money - Money.new('5.6', 'EUR') }

    it "return a new money" do
      expect(result).to be_a(Money)
      expect(result).not_to eq(money)
    end

    it "minus values of both monies" do
      expect(result.value).to eq(6.74)
    end

    it "keep currency of the money" do
      expect(result.currency).to eq('EUR')
    end

    it "raise error when monies have different currency" do
      expect {
        money - Money.new('5.6', 'PLN')
      }.to raise_error(ArgumentError)
    end
  end

  describe "#positive?" do
    context "for money with positive value" do
      subject { Money.new('12.34', 'EUR') }

      describe '#positive?' do
        subject { super().positive? }
        it { is_expected.to be_truthy }
      end
    end

    context "for money with negative value" do
      subject { Money.new('-12.34', 'EUR') }

      describe '#positive?' do
        subject { super().positive? }
        it { is_expected.to be_falsey }
      end
    end

    context "for money with zero value" do
      subject { Money.new('0.00', 'EUR') }

      describe '#positive?' do
        subject { super().positive? }
        it { is_expected.to be_falsey }
      end
    end
  end

  describe ".sum" do
    let(:little_euro) { Money.new('1.23', 'EUR') }
    let(:more_euro) { Money.new('9.87', 'EUR') }
    let(:neg_euro) { Money.new('-2.87', 'EUR') }
    let(:little_pln) { Money.new('2.33', 'PLN') }
    let(:more_pln) { Money.new('8.99', 'PLN') }
    let(:neg_pln) { Money.new('-2.99', 'PLN') }

    it "return empty array for empty array" do
      expect(Money.sum([])).to eq([])
    end

    it "return array with one element for one element array" do
      expect(Money.sum([little_euro])).to eq([little_euro])
    end

    it "return two elements array when two different currencies are passed" do
      expect(Money.sum([little_euro, little_pln])).to eq([little_euro, little_pln])
    end

    it "sum all moneys matching currencies" do
      expect(Money.sum([little_euro, more_euro, neg_euro, little_pln, more_pln, neg_pln])).to eq(
        [Money.new('8.23', 'EUR'), Money.new('8.33', 'PLN')]
      )
    end
  end
end
