# frozen_string_literal: true

module Enumerable
  def my_each
    length.times do |x|
      yield(self[x])
    end
  end

  def my_each_with_index
    length.times do |x|
      yield(x, self[x])
    end
  end

  def my_select
    item = []
    length.times do |x|
      item.push(self[x]) if yield(self[x])
    end
    item
  end

  def my_all
    value = true
    length.times do |x|
      value = false unless yield(self[x])
    end
    value
  end

  def my_any
    value = false
    length.times do |x|
      value = true if yield(self[x])
    end
    value
  end

  def my_none
    length.times do |x|
      return false if yield(self[x])
    end
    true
  end

  def my_count
    item = 0
    length.times do |x|
      item += 1 if yield(self[x])
    end
    item
  end

  def my_map(my_proc = false)
    item = []
    length.times do |x|
      result =  if my_proc
                  my_proc.call(self[x])
                else
                  yield(self[x])
                end
      item.push(result)
    end
    item
  end

  def my_inject
    sum = self[0]
    (length - 1).times do |x|
      sum = yield(sum, self[x + 1])
    end
    sum
  end

  def multiply_els
    my_inject { |sum, n| sum * n }
  end
end