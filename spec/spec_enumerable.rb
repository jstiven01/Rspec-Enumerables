# frozen_string_literal: true

require_relative '../lib/enumerable'

RSpec.describe Enumerable do
  let(:array_numbers) { [5, 2, 4, 3, 8, 9, 4, 3] }
  let(:false_array) { [false, nil, false, nil] }
  let(:true_array) { [1, true, 'hi', []] }
  let(:words_array) { %w[dog door rod blade] }
  let(:three_array) { [3, 3, 3, 3] }
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

  describe '#my_select' do
    it 'returns a copy of the array that matches the given parameters or given block' do
      block = proc { |x| x > 4 }
      expect(array_numbers.my_select(&block)).to eq(array_numbers.select(&block))
    end

    it "returns an enumerable if block wasn't given" do
      expect(array_numbers.my_select).to be_an(Enumerator)
    end
  end

  describe '#my_all' do
    it 'returns true if ALL elements match the block given' do
      true_block = proc { |num| num >= 0 }
      expect(array_numbers.my_all(&true_block)).to eq(true)
    end

    it "returns false if at least one element doesn't match the block given" do
      false_block = proc { |num| num <= 5 }
      expect(array_numbers.my_all(&false_block)).to eq(false)
    end

    it "returns true when the array has ALL elements of the different type (Truthy value) and if block wasn't given" do
      expect(true_array.my_all).to eq(true)
    end

    it 'returns true when the array has ALL elements of the same type of the class given as a parameter' do
      expect(array_numbers.my_all(Integer)).to eq(true)
    end

    it 'returns false when the array has at least one different element of the type of the class given as a param' do
      expect(true_array.my_all(Integer)).to eq(false)
    end

    it 'returns true when the array has ALL elements with the word given as a Regex parameter' do
      expect(words_array.my_all(/d/)).to eq(true)
    end

    it 'returns false when the array has at least one element without the word given as a Regex parameter' do
      expect(words_array.my_all(/z/)).to eq(false)
    end

    it 'returns true when the array has ALL elements equal to the number given as a parameter' do
      expect(three_array.my_all(3)).to eq(true)
    end

    it 'returns false when the array has at least one element different to the number given as a parameter' do
      expect(three_array.my_all(5)).to eq(false)
    end
  end

  describe '#my_any' do
    it 'returns true if any element matches the block given' do
      true_block = proc { |num| num <= 5 }
      expect(array_numbers.my_any(&true_block)).to eq(true)
    end

    it "returns false if all the elements doesn't match the block given" do
      false_block = proc { |num| num <= -150 }
      expect(array_numbers.my_any(&false_block)).to eq(false)
    end

    it "returns true if block wasn't given and any of the elements are true" do
      expect(array_numbers.my_any).to eq(true)
    end

    it "returns false if block wasn't given and all the elements are false" do
      expect(false_array.my_any).to eq(false)
    end

    it 'return true if any of the elements are the type of class given as a parameter' do
      expect(array_numbers.my_any(Integer)).to eq(true)
    end

    it 'returns false if all of the elements are no the type of class given as a parameter' do
      expect(words_array.my_any(Integer)).to eq(false)
    end

    it 'return true if any of the elemnts matches the Regex given as a parameter' do
      expect(words_array.my_any(/d/)).to eq(true)
    end

    it 'return false if all the elemnts does not matches the Regex given as a parameter' do
      expect(words_array.my_any(/z/)).to eq(false)
    end

    it 'return true if any of the elements is equal to a given value as a parameter' do
      expect(three_array.my_any(3)).to eq(true)
    end

    it "return true if all of elements aren't equal to a given value as a parameter" do
      expect(three_array.my_any(-150)).to eq(false)
    end
  end

  describe '#my_none' do
    it 'returns true if NONE elements match the block given' do
      true_block = proc { |num| num <= 0 }
      expect(array_numbers.my_none(&true_block)).to eq(true)
    end

    it "returns false if at least one element doesn't match the block given" do
      false_block = proc { |num| num <= 5 }
      expect(array_numbers.my_none(&false_block)).to eq(false)
    end

    it "returns true when the array has NONE elements of the different type (Truthy value) and if block wasn't given" do
      expect(false_array.my_none).to eq(true)
    end

    it 'returns true when the array has NONE elements of the same type of the class given as a parameter' do
      expect(words_array.my_none(Integer)).to eq(true)
    end

    it 'returns false when the array has at least one different element of the type of the class given as a param' do
      expect(true_array.my_none(Integer)).to eq(false)
    end

    it 'returns true when the array has NONE elements with the word given as a Regex parameter' do
      expect(words_array.my_none(/z/)).to eq(true)
    end

    it 'returns false when the array has at least one element without the word given as a Regex parameter' do
      expect(words_array.my_none(/d/)).to eq(false)
    end

    it 'returns true when the array has NONE elements equal to the number given as a parameter' do
      expect(three_array.my_none(5)).to eq(true)
    end

    it 'returns false when the array has at least one element different to the number given as a parameter' do
      expect(three_array.my_none(3)).to eq(false)
    end
  end
end
