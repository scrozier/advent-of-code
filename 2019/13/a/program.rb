# DEBUG = true
DEBUG = false

NUM_COLS = 40
NUM_ROWS = 40

EMPTY = 0
WALL = 1
BLOCK = 2
PADDLE = 3
BALL = 4

require '/Users/scrozier/projects/advent/intcode'

###############################################################################

require 'io/console'

class Display
  def initialize
    @grid = Hash.new(EMPTY)
  end

  def draw(x, y, tile)
    @grid[[x, y]] = tile
  end

  def to_s
    output = ""
    0.upto NUM_ROWS - 1 do |y|
      0.upto NUM_COLS - 1 do |x|
        output += [' ', "H", "I", "-", "o"][@grid[[x, y]]]
      end
      output += "\n"
    end
    return output
  end
end

file = File.open('/Users/scrozier/projects/advent/13/a/input.txt')
program_text = file.readline.chomp

@provide_input = lambda do
  return @input
end  

@receive_output = lambda do |rec|
  @next_output_index = (@next_output_index + 1) % 3
  @output[@next_output_index] = rec
  if @next_output_index == 2
    x, y, tile = @output
    @display.draw(x, y, tile)
    puts @display
  end
end

@halt = lambda do
  puts @display
  exit
end

cabinet = Intcode.new(program_text, @provide_input, @receive_output, @halt)

@display = Display.new
@output = [nil, nil, nil]
@next_output_index = -1

block_count = 0
while true
  cabinet.run
end
