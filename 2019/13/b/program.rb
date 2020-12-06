require 'io/console'

# DEBUG = true
DEBUG = false

NUM_COLS = 40
NUM_ROWS = 26

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

  def ball_x
    0.upto NUM_ROWS - 1 do |y|
      0.upto NUM_COLS - 1 do |x|
        return x if @grid[[x, y]] == BALL
      end
    end
    throw "Fell through ball_y"
  end

  def paddle_x
    0.upto NUM_ROWS - 1 do |y|
      0.upto NUM_COLS - 1 do |x|
        return x if @grid[[x, y]] == PADDLE
      end
    end
    throw "Fell through paddle_y"
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

################################################################################

file = File.open('/Users/scrozier/projects/advent/13/b/input.txt')
program_text = file.readline.chomp

JOYSTICK_VALUES = {44 => -1, 32 => 0, 46 => 1}
@score = 0

@provide_input = lambda do
  return (@display.ball_x <=> @display.paddle_x)
end  

@receive_output = lambda do |rec|
  @next_output_index = (@next_output_index + 1) % 3
  @output[@next_output_index] = rec
  if @next_output_index == 2
    x, y, tile = @output
    if x == -1 && y == 0
      @score = tile
    else
      @display.draw(x, y, tile)
    end
    puts @display
    puts "\nScore: #{@score}\n\n"
  end
end

@halt = lambda do
  puts "Halting..."
  puts @display
  exit
end

@display = Display.new
@output = [nil, nil, nil]
@next_output_index = -1

@cabinet = Intcode.new(program_text, @provide_input, @receive_output, @halt)
while true
  @cabinet.run
end

###############################################################################

# JOYSTICK_VALUES = {68 => -1, 66 => 0, 67 => 1}
# joystick = 0
# score = 0
# while true
#   display.run
#   input = STDIN.getch
#   exit if input.ord == 3
#   @joystick = JOYSTICK_VALUES[input]
# end

# exit
