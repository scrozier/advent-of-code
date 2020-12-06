require '/Users/scrozier/projects/advent/intcode'

NUM_ROWS = 50
NUM_COLS = 50

###############################################################################

@location = nil
@output = nil

@provide_input = lambda do
  value = @location.shift
  return value
end

@receive_output = lambda do |rec|
  @output = rec
end

@halt = lambda do
  return
end

file = File.open('/Users/scrozier/projects/advent/19/a/input.txt')
@program_text = file.readline.chomp

def run_detector(x, y)
  @location = [x, y]
  drone_computer = Intcode.new(@program_text, @provide_input, @receive_output, @halt)
  drone_computer.run
  return @output
end

# pick a row, get the output (.'s and #'s)
for y in 400..10000
# find the last # in that row, last_hash
  got_hash = false
  x = 99
  found_edge = false
  while !found_edge
    x += 1
    beam_here = run_detector(x, y)
    if got_hash && beam_here == 0 # found the edge of the beam
      found_edge = true
      last_hash = x - 1
      opposite_corner = run_detector(last_hash - 99, y + 99)
      if opposite_corner == 1
        puts "Answer: (#{last_hash - 99}, #{y})"
        exit
      end
    end
    got_hash = true if beam_here == 1 && !got_hash
  end
end



# is there a # at last_hash - 100?
# if not, next y
# if so
#   get output at (last_hash, y + 100)
#   is it a hash?
#   if not, next y
#.  if so, the answer is last_hash - 100, y


# y = 5
# got_hash = true
# x = 17
# found_edge = true
# beam_here = 0
# last_hash = 16

#           1         2
# 012345678901234567890
# .......##########....



# exit
