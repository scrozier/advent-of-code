NUM_PHASES = 100 #100
OFFSET_LENGTH = 7
SIGNAL_REPEAT_FACTOR = 10000

file = File.open('/Users/scrozier/projects/advent/16/a/input.txt')
input = file.readline.chomp

single = input.chars.map(&:to_i)
offset = input[0, OFFSET_LENGTH].to_i
full = (single * SIGNAL_REPEAT_FACTOR)
tail = full[offset, full.length]

NUM_PHASES.times do
  (tail.size - 2).downto(0) do |i|
    tail[i] = (tail[i] + tail[i + 1]) % 10
  end
end

puts "Answer: #{tail.first(8).join}"

exit
