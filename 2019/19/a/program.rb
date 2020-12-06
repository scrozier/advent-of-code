require '/Users/scrozier/projects/advent/intcode'

NUM_ROWS = 50
NUM_COLS = 50

class BeamMap
  def initialize
    @map = Hash.new(0)
  end

  def set_status(x, y, status)
    throw "nil for x" unless x
    throw "nil for y" unless y
    throw "bad coords: #{x}, #{y}" if x >= NUM_COLS || y >= NUM_ROWS
    @map[[x, y]] = status
  end

  def num_affected_points
    @map.count {|e| e.last == 1}
  end

  def to_s
    output = ""
    0.upto NUM_ROWS - 1 do |x|
      0.upto NUM_COLS - 1 do |y|
        output += ['.', '#'][@map[[x, y]]]
      end
      output += "\n"
    end
    return output
  end
end

###############################################################################

map = BeamMap.new

location = nil
map_location = nil
provide_input = lambda do
  value = location.shift
  puts "AA providing input of #{value}"
  return value
end

receive_output = lambda do |output|
  puts "AA received output of #{output}"
  map.set_status(map_location.first, map_location.last, output)
end

halt = lambda do
  puts map.to_s
end

file = File.open('/Users/scrozier/projects/advent/19/a/input.txt')
program_text = file.readline.chomp
drone_computer = Intcode.new(program_text, provide_input, receive_output, halt)

for x in 0..(NUM_COLS - 1)
  for y in 0..(NUM_ROWS - 1)
    location = [x, y]
    map_location = location.dup
    puts "location: #{location.inspect}"
    next_is_x = true
    drone_computer = Intcode.new(program_text, provide_input, receive_output, halt)
    drone_computer.run
  end
end

puts "affected points: #{map.num_affected_points}"
exit
