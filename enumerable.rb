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

  def my_map(my_proc = false)
    item = []
    (self.length).times do |x|
      if my_proc
        result = my_proc.call(self[x])
      else
        result = yield(self[x])
      end
      if(result)
        item.push(true)
      else
        item.push(false)
      end
    end
    return item
  end

  def my_inject
    sum = self[0]
    (self.length - 1).times do |x|
      sum = yield(sum, self[x + 1])
    end
    return sum
  end

  def multiply_els
    self.my_inject { |sum, n| sum * n }
  end

end
