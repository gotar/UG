require 'spec_helper'

describe 'Exchange money' do
  let(:m) { 10 }
  subject{ Exchange.new(m, 'PLN').call }

  context 'valid params' do
    context 'for currency outside the file' do
      let(:m) { Money.new(10, 'EUR')}
      subject{ Exchange.new(m, 'RUB').call }

      xit 'return hash with error message' do
      end
    end

    context 'for currency from file' do
      let(:m) { Money.new(10, 'EUR')}
      subject{ Exchange.new(m, 'PLN').call }

      it 'return recalculated value' do
        expect( subject.to_s ).to eq("42.20 PLN")
      end
    end
  end
end
