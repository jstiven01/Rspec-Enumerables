require_relative '../lib/enumerable'

RSpec.describe Enumerable do
  let(:array_numbers) {[5,2,4,3,8,9,4,3]}
  describe "#my_each" do
    it "returns an iteration of each element of an array"do
      result_my = 0
      block_my = Proc.new {|x| result_my += x}
      array_numbers.my_each(&block_my)

      result = 0
      block = Proc.new {|x| result += x}
      array_numbers.each(&block)

      expect(result_my).to eq(result)
    end

    it "returns an enumerable if block wasn't given" do
       expect(array_numbers.my_each).to be_an(Enumerator)
    end
  end
end