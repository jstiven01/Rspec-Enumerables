# frozen_string_literal: true

module Enumerable # rubocop:disable Metrics/ClassLength
  def my_each
    return self.to_enum if !block_given?
    length.times do |x|
      yield(self[x])
    end
  end

  def my_each_with_index
    return self.to_enum unless block_given?
    length.times do |x|
      yield(x, self[x])
    end
    self
  end

  def my_select
    return self.to_enum unless block_given?

    item = []
    length.times do |x|
      item.push(self[x]) if yield(self[x])
    end
    item
  end

  def my_all(field = nil)
    return true if !block_given? && field.nil?

    value = true
    length.times do |x|
      if !field.nil?
        if field.instance_of? Regexp
          value = false unless self[x].match(field)
        elsif field.respond_to?(:is_a?) && (field.is_a?(String) || field.is_a?(Integer))
          value = false if field != self[x]
        elsif field.respond_to?(:is_a?) && !(self[x].is_a? field)
          value = false
        end
      elsif block_given?
        value = false unless yield(self[x])
      end
    end
    value
  end

  def my_any(field = nil)
    return true if !block_given? && field.nil?

    value = false
    length.times do |x|
      if !field.nil?
        if field.instance_of? Regexp
          value = true if self[x].match(field)
        elsif field.respond_to?(:is_a?) && (field.is_a?(String) || field.is_a?(Integer))
          value = true if field == self[x]
        elsif field.respond_to?(:is_a?) && (self[x].is_a? field)
          value = true
        end
      elsif block_given?
        value = true if yield(self[x])
      end
    end
    value
  end

  def my_none(field = nil)
    return true if !block_given? && field.nil?

    length.times do |x|
      if !field.nil?
        if field.instance_of? Regexp
          return false if self[x].match(field)
        elsif field.respond_to?(:is_a?) && (field.is_a?(String) || field.is_a?(Integer))
          return false if field == self[x]
        elsif field.respond_to?(:is_a?) && (self[x].is_a? field)
          return false
        end
      elsif block_given?
        return false if yield(self[x])
      end
    end
    true
  end

  def my_count(field = nil)
    return length if (!block_given? && !field)
    item = 0
    length.times do |x|
      if field
        item += 1 if field == self[x]
      else
        item += 1 if yield(self[x])
      end
    end
    item
  end

  def my_map(my_proc = false)
    return self.to_enum if !block_given?
    item = []
    length.times do |x|
      result = my_proc ? my_proc.call(self[x]) : yield(self[x])
      item.push(result)
    end
    item
  end

  def my_inject(field = nil)
    arr = self.to_a
    if field && field.respond_to?(:is_a?) && field.is_a?(Integer)
      sum = field
      d_m = 0
    else
      sum = arr[0]
      d_m = 1
    end

    o = nil

    if field && field.respond_to?(:is_a?) && field.is_a?(Symbol)
      o = field.to_s
      o.sub! ":", ""
    end

    (arr.length - d_m).times do |x|
      if o
        sum = sum.method(o).(arr[x+ d_m])
      else
        sum = yield(sum, arr[x + d_m])
      end
    end
    sum
  end

  def multiply_els
    my_inject { |sum, n| sum * n }
  end
end
