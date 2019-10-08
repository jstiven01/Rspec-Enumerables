module Enumerable
  def my_each
    (self.length).times do |x|
      yield(self[x])
    end
  end

  def my_each_with_index
    (self.length).times do |x|
      yield(x, self[x])
    end
  end

  def my_select
    item = []
    (self.length).times do |x|
      if(yield(self[x], y = nil))
        item.push(self[x])
      end
    end
    return item
  end

  def my_all
    (self.length).times do |x|
      return false unless yield(self[x])
    end
    true
  end

  def my_any
    (self.length).times do |x|
      return true if yield(self[x])
    end
    false
  end

  def my_none
    (self.length).times do |x|
      return false if yield(self[x])
    end
    true
  end

  def my_count
    item = 0
    (self.length).times do |x|
      if(yield(self[x], y = nil))
        item += 1
      end
    end
    return item
  end

  def my_map
    item = []
    (self.length).times do |x|
      if(yield(self[x], y = nil))
        item.push(true)
      else
        item.push(false)
      end
    end
    return item
  end

  def my_inject
    n = self[0]
    (self.length - 1).times do |x|
      n = yield(self[x + 1], n)
    end
    return n
  end

end

test = [5,3,7,4, 8, 9]

test = [1,1,1,1]

puts test.my_inject { |x, n|
  n + x
}
