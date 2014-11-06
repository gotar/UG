require_relative '../../lib/order'
require_relative '../../lib/extend_enumerable'

describe Order do
  let(:full_name) { 'FOO' }
  let(:date) { Date.new.to_s }

  context '#products' do
    subject { Order.new(full_name, date, products).products }
    context 'without products' do
      let(:products) { [] }
      it 'returns empty array' do
        expect(subject).to eq []
      end
    end

    context 'with products' do
      let(:product1) { double }
      let(:product2) { double }
      let(:products) { [product1, product2] }
      it 'returns array of objects' do
        expect(subject).to eq products
      end
    end
  end

  context '#total_amount' do
    subject { Order.new(full_name, date, products).total_amount }

    context 'without products' do
      let(:products) { [] }
      it 'returns 0' do
        expect(subject).to eq 0
      end
    end

    context 'with products' do
      let(:money2) { instance_double('Money', value: 10, currency: 'EUR') }
      let(:money) { instance_double('Money', value: 10, currency: 'EUR', :+ => money2) }
      let(:product1) { instance_double('Product', price: money) }
      let(:product2) { instance_double('Product', price: money) }
      let(:products) { [product1, product2] }

      xit 'returns sum of product prices' do
      end
    end
  end
end
