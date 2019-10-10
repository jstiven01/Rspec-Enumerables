# frozen_string_literal: true

module Enumerable # rubocop:disable Metrics/ModuleLength
  def my_each
    return to_enum unless block_given?

    length.times do |x|
      yield(self[x])
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    length.times do |x|
      yield(x, self[x])
    end
    self
  end

  def my_select
    return to_enum unless block_given?

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

  def validata(var)
    if var.instance_of? Regexp
      return 'regex'
    elsif var.respond_to?(:is_a?) && (var.is_a?(String) || var.is_a?(Integer))
      return 'i_o_s'
    elsif var.respond_to?(:is_a?)
      return 'type'
    end

  end

  def test_var(var, field)
    case validata(field)
      when 'regex'
        return false if var.match(field)
      when 'i_o_s'
        return false if field == var
      when 'type'
        return false if var.is_a? field
    end

    true
  end

  def my_none(field = nil)
    return true if !block_given? && field.nil?

    length.times do |x|
      return false if !field.nil? && !test_var(self[x], field)
      return false if field.nil? && block_given? && yield(self[x])
    end
    true
  end

  def my_count(field = nil)
    return length if !block_given? && !field

    item = 0
    length.times do |x|
      if field
        item += 1 if field == self[x]
      elsif yield(self[x])
        item += 1
      end
    end
    item
  end

  def my_map(my_proc = false)
    return to_enum unless block_given?

    item = []
    length.times do |x|
      result = my_proc ? my_proc.call(self[x]) : yield(self[x])
      item.push(result)
    end
    item
  end

  def my_inject(field = nil)
    arr = to_a
    if field&.respond_to?(:is_a?) && field&.is_a?(Integer)
      sum = field
      d_m = 0
    else
      sum = arr[0]
      d_m = 1
    end

    o = nil

    if field&.respond_to?(:is_a?) && field&.is_a?(Symbol)
      o = field.to_s
      o.sub! ':', ''
    end

    (arr.length - d_m).times do |x|
      sum = o ? sum.method(o).call(arr[x + d_m]) : sum = yield(sum, arr[x + d_m])
    end
    sum
  end

  def multiply_els
    my_inject { |sum, n| sum * n }
  end
end

#my_none

false_array = [nil, false, nil, false]

puts false_array.none?
puts false_array.my_none

array = [7, 8, 1, 4, 5, 0, 8, 4, 7, 6, 7, 8, 4, 8, 8, 6, 8, 0, 1, 7, 0, 2, 6, 6, 3, 1, 6, 6, 8, 5, 0, 2, 3, 7, 8, 7, 1, 5, 4, 4, 5, 1, 3, 5, 8, 7, 3, 3, 0, 0, 4, 1, 6, 2, 0, 4, 2, 1, 8, 3, 3, 6, 0, 8, 4, 4, 1, 6, 4, 6, 5, 3, 6, 6, 8, 6, 8, 7, 0, 6, 6, 2, 8, 8, 2, 1, 8, 5, 0, 5, 0, 3, 6, 4, 5, 8, 3, 3, 2, 1]
puts array.none?(String)
puts array.my_none(String)

words = %w[dog door rod blade]
puts words.none?(/z/)
puts words.my_none(/z/)

words[0] = 5
puts words.none?(5)
puts words.my_none(5)
