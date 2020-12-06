NUM_ROWS = 41
NUM_COLS = 41

WALL = '#'
TRAVERSABLE = ' '
OXYGENATED = 'O'

class Maze
  def initialize(lines)
    @grid = {}
    for y in 0..(lines.length - 1)
      line = lines[y]
      for x in 0..(line.length - 1)
        @grid[[x, y]] = line[x]
      end
    end
  end

  # positions you could move from the given node
  def get_neighbors(node)
    possible = []
    possible << @grid[[node.x, node.y - 1]] if @grid[[node.x, node.y - 1]].descriptor == TRAVERSABLE
    possible << @grid[[node.x, node.y + 1]] if @grid[[node.x, node.y + 1]].descriptor == TRAVERSABLE
    possible << @grid[[node.x - 1, node.y]] if @grid[[node.x - 1, node.y]].descriptor == TRAVERSABLE
    possible << @grid[[node.x + 1, node.y]] if @grid[[node.x + 1, node.y]].descriptor == TRAVERSABLE
    return possible
  end

  def oxygenate
    new_grid = {}
    0.upto NUM_ROWS - 1 do |y|
      0.upto NUM_COLS - 1 do |x|
        new_grid[[x, y]] = @grid[[x, y]]
        new_grid[[x, y]] = OXYGENATED if @grid[[x, y]] != WALL && (
          @grid[[x, y - 1]] == OXYGENATED ||
          @grid[[x, y + 1]] == OXYGENATED ||
          @grid[[x - 1, y]] == OXYGENATED ||
          @grid[[x + 1, y]] == OXYGENATED
          )
      end
    end
    @grid = new_grid
  end    

  def all_oxygenated?
    1.upto NUM_ROWS - 2 do |y|
      1.upto NUM_COLS - 2 do |x|
        return false if @grid[[x, y]] == TRAVERSABLE && !(
          # 4 neighbors are walls
          @grid[[x, y - 1]] == WALL &&
          @grid[[x, y + 1]] == WALL &&
          @grid[[x - 1, y]] == WALL &&
          @grid[[x + 1, y]] == WALL
          )
      end
    end
    return true
  end    

  def to_s
    output = ""
    0.upto NUM_ROWS - 1 do |y|
      0.upto NUM_COLS - 1 do |x|
        if @grid[[x, y]] == OXYGENATED
          output += "\e[1;31mO\e[0m"
        else
          output += @grid[[x, y]]
        end
      end
      output += "\n"
    end
    return output
  end
end
################################################################################
file = File.open('/Users/scrozier/projects/advent/15/b/maze.txt')
maze = Maze.new(file.readlines.map(&:chomp))

puts maze.to_s
num_minutes = 0
until maze.all_oxygenated?
  num_minutes += 1
  maze.oxygenate
  puts maze
  # sleep 0.2
end

puts "The answer is #{num_minutes}"

exit