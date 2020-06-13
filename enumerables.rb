# frozen_string_literal: true

# My each method for Ruby, you can use it by simply calling it .my_each
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    i = -1
    arr = to_a
    arr.length.times do
      i += 1
      yield(arr[i])
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = -1
    arr = to_a
    arr.length.times do
      i += 1
      yield(arr[i], i)
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    new_array = []
    my_each do |value|
      new_array << value if yield(value) == true
    end
    new_array
  end

  def my_all?(pattern = nil)
    my_each do |value|
      if block_given?
        return false unless yield(value)
      elsif pattern.nil?
        return false unless value
      else
        return false unless pattern === value
      end
    end
    true
  end

  def my_any?(pattern = nil, &block)
    my_each do |value|
      if block_given?
        return true unless block.call(value) == false
      elsif pattern.nil?
        return true unless value == false || value.nil?
      else
        return true unless (pattern === value) == false
      end
    end
    false
  end

  def my_none?(pattern = nil, &block)
    !my_any?(pattern, &block)
  end

  def my_count(num = nil, &block)
    result = 0
    my_each do |value|
      if (block_given? == false) && (value == num)
        result += 1
      elsif block_given? && (block.call(value) == true)
        result += 1
      elsif num.nil? && (block_given? == false)
        result += 1
      end
    end
    result
  end

  def my_map(val = nil)
    return to_enum(:my_map) unless block_given?

    new_array = []
    my_each do |value|
      new_array << if val
                     val.call(value)
                   else
                     yield(value)
                   end
    end
    new_array
  end

  def my_inject(memo = nil, sym = nil)
    total = 0
    if block_given?
      my_each do |value|
        memo = memo.nil? ? value : yield(memo, value)
      end
    elsif sym && memo
      my_each do |value|
        memo = memo.nil? ? value : memo.send(sym, value)
      end
    else
      my_each do |value|
        total = total.send(memo, value)
      end
      return total
    end
    memo
  end
end

def multiply_els(array)
  array.my_inject { |product, n| product * n }
end
puts(5..10).inject { |sum, n| sum + n }
