module Enumerable
  def my_each
    (self.length).times do |x|
      yield(self[x], y = nil)
    end
  end
end

test = [5,2,7,4]

test.my_each { |x|
  puts x * 10
}
