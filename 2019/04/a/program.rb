class Password
  def initialize(integer)
    @integer = integer
    @digit_array = @integer.to_s.scan(/./).map {|ds| ds.to_i}
  end

  def has_digit_pair
    @digit_array[0] == @digit_array[1] ||
    @digit_array[1] == @digit_array[2] ||
    @digit_array[2] == @digit_array[3] ||
    @digit_array[3] == @digit_array[4] ||
    @digit_array[4] == @digit_array[5]
  end

  def is_monotonically_increasing
    @digit_array[1] >= @digit_array[0] &&
    @digit_array[2] >= @digit_array[1] &&
    @digit_array[3] >= @digit_array[2] &&
    @digit_array[4] >= @digit_array[3] &&
    @digit_array[5] >= @digit_array[4]
  end
end

answer = 0
246515.upto 739105 do |i|
  pw = Password.new(i)
  answer += 1 if (pw.has_digit_pair && pw.is_monotonically_increasing)
end

puts "answer: " + answer.to_s
