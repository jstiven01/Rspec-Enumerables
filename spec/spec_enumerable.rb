# frozen_string_literal: true

require_relative '../lib/enumerable'

RSpec.describe Enumerable do
  let(:array_numbers) { [5, 2, 4, 3, 8, 9, 4, 3] }
  describe '#my_each' do
    it 'returns an iteration of each element of an array' do
      result_my = 0
      block_my = proc { |x| result_my += x }
      array_numbers.my_each(&block_my)

      result = 0
      block = proc { |x| result += x }
      array_numbers.each(&block)

      expect(result_my).to eq(result)
    end

    it "returns an enumerable if block wasn't given" do
      expect(array_numbers.my_each).to be_an(Enumerator)
    end
  end

  describe '#my_each_with_index' do
    it 'returns a hash using the item, index of the iteration my_each' do
      my_each_hash = {}
      my_each_block = proc { |item, index| my_each_hash[item] = index }
      %w[cat dog wombat].my_each_with_index(&my_each_block)
      each_hash = {}
      each_block = proc { |item, index| each_hash[item] = index }
      %w[cat dog wombat].each_with_index(&each_block)

      expect(my_each_hash).to eq(each_hash)
    end

    it "returns an enumerable if block wasn't given" do
      expect(array_numbers.my_each_with_index).to be_an(Enumerator)
    end
  end
end
