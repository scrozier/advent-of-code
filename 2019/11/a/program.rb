BLACK = 0
WHITE = 1
UNPAINTED = -1

require '/Users/scrozier/projects/advent/intcode'

class Hull
  def initialize
    @num_rows = 0
    @num_columns = 0
    @panels = Hash.new(UNPAINTED)
    @min_x_painted = 0
    @max_x_painted = 0
    @min_y_painted = 0
    @max_y_painted = 0
  end

  def paint_panel(x, y, color)
    # puts "PAINTING (#{x}, #{y}) #{['BLACK', 'WHITE'][color]}"
    @panels[[x, y]] = color
    @min_x_painted = x if x < @min_x_painted
    @max_x_painted = x if x > @max_x_painted
    @min_y_painted = y if y < @min_y_painted
    @max_y_painted = y if y > @max_y_painted
  end

  def panel_color_at(x, y)
    color = @panels[[x, y]]
    color == UNPAINTED ? BLACK : color
  end

  def num_painted_panels
    count = 0
    for x in @min_x_painted..@max_x_painted
      for y in @min_y_painted..@max_y_painted
        count += 1 if @panels[[x, y]] != UNPAINTED
      end
    end
    return count
  end

  def to_s
    output = ""
    for x in @min_x_painted..@max_x_painted
      output << "\n"
      for y in @min_y_painted..@max_y_painted
        color_int = @panels[[x, y]]
        output << [".", " ", "#"][color_int + 1]
      end
    end
    return output + "\n\n"
  end
end

###############################################################################

INITIAL_LOCATION = [0, 0]
INITIAL_FACING = 'up'

@hull = Hull.new

@location = INITIAL_LOCATION
@facing = INITIAL_FACING
@current_panel_color = WHITE
@facing = 'up'

def paint_panel(color)
  @hull.paint_panel(@location.first, @location.last, color)
end

def turn_and_move(direction)
  case @facing
  when 'up'
    if direction == 0
      @facing = 'left'
      @location = [@location.first - 1, @location.last]
    else
      @facing = 'right'
      @location = [@location.first + 1, @location.last]
    end
  when 'right'
    if direction == 0
      @facing = 'up'
      @location = [@location.first, @location.last - 1]
    else
      @facing = 'down'
      @location = [@location.first, @location.last + 1]
    end
  when 'down'
    if direction == 0
      @facing = 'right'
      @location = [@location.first + 1, @location.last]
    else
      @facing = 'left'
      @location = [@location.first - 1, @location.last]
    end
  when 'left'
    if direction == 0
      @facing = 'down'
      @location = [@location.first, @location.last + 1]
    else
      @facing = 'up'
      @location = [@location.first, @location.last - 1]
    end
  else
    puts "Blowing up in direction"
  end
  # puts "Now at #{@location.inspect}, facing #{@facing}"
end

@provide_input = lambda do
  return @current_panel_color
end

@next_output = 'color'
@color = nil
@turn_direction = nil
@receive_output = lambda do |output|
  case @next_output
  when 'color'
    @color = output
    @next_output = 'turn_direction'
  when 'turn_direction'
    # puts "Got output of (#{@color}, #{output})"
    @next_output = 'color'
    paint_panel(@color)
    turn_and_move(output)
    @current_panel_color = @hull.panel_color_at(@location.first, @location.last)
    # puts @hull
  else
    throw 'Mayday!'
  end
end

@halt = lambda do
  puts @hull
  puts "Panels painted: #{@hull.num_painted_panels}"
  exit
end  

file = File.open('/Users/scrozier/projects/advent/11/a/input.txt')
program_text = file.readline.chomp
robot = Intcode.new(program_text, @provide_input, @receive_output, @halt)

@current_panel_color = WHITE
robot.run

exit
