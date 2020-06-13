# frozen_string_literal: true

# My each method for Ruby, you can use it by simply calling it .my_each
module Enumerable
  def my_each
    new_array = [] unless block_given?
    i = 0
    a = Array self
    while i < a.size
      yield(a[i]) if block_given?
      new_array << a[i] unless block_given?
      i += 1
    end
    return Enumerator.new(new_array) unless block_given?

    self
  end

  def my_each_with_index
    new_array = [] unless block_given?
    i = 0
    a = Array self
    while i < size
      yield(a[i], i) if block_given?
      new_array << a[i] unless block_given?
      i += 1
    end
    return Enumerator.new(new_array) unless block_given?

    self
  end

  def my_select
    return my_each unless block_given?

    new_array = []
    my_each { |n| new_array.push(n) if yield(n) }
    new_array
  end

  def my_all?(*args)
    result = true
    if block_given?
      my_each do |i|
        result = false unless yield(i)
      end
    elsif !args[0].nil?
      my_each do |i|
        result = false unless args[0] === i
      end
    elsif empty? && args[0].nil?
      result = true
    else
      my_each do |i|
        result = false unless i
      end
    end
    result
  end

  def my_any?(*args)
    result = false
    if block_given?
      my_each do |i|
        result = true if yield(i)
      end
    elsif !args[0].nil?
      my_each do |i|
        result = true if args[0] === i
      end
    elsif empty? && args[0].nil?
      result = false
    else
      my_each do |i|
        result = true if i
      end
    end
    result
  end

  def my_none?(args = nil)
    result = if block_given?
               !my_any? { |i| yield i }
             else
               !my_any?(args)
             end
    result
  end

  def my_count(item = false)
    count = 0

    if !block_given?
      return size unless item

      my_each { |n| count += 1 if n == item }
    elsif block_given? && !item
      my_each { |n| count += 1 if yield(n) }
    elsif block_given? && item
      my_each { |n| count += 1 if n == item }
    end
    count
  end

  def my_map(args_proc = nil)
    return to_enum :my_map unless block_given? || args_proc.class == Proc
    new_arr = []
    new_object = to_a
    if !args_proc.nil?
      new_object.my_each do |i|
        new_arr.push(proc.call(i))
      end
    else
      new_object.my_each do |i|
        new_arr.push(yield(i))
      end
    end
    new_arr
  end

  def my_inject(args1 = nil, args2 = nil)
    new_object = to_a
    sum = new_object[0]
    t = 1
    if !args1.nil? && args2.class == Symbol
      sum = args1
      new_object.my_each { |i| sum = sum.send(args2, i) }
    elsif args1.nil? && args2.nil?
      loop do
        sum = yield(sum, new_object[t]) if block_given?
        t += 1
        break if t == new_object.length
      end
    elsif args1.class == Symbol
      loop do
        sum = sum.send(args1, new_object[t])
        t += 1
        break if t == new_object.length
      end

    elsif !args1.nil? && args2.nil?
      sum = args1
      new_object.my_each { |i| sum = yield(sum, i) } if block_given?
    end
    sum
  end
end

def multiply_els(array)
  array.my_inject { |product, n| product * n }
end
