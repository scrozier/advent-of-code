NUM_ROWS = 41
NUM_COLS = 41

WALL = '#'
TRAVERSABLE = ' '
S = 'S'
T = 'T'

class Node
  attr_reader :x, :y, :descriptor, :distance_from_droid, :considered

  def initialize(x, y, descriptor)
    @x = x
    @y = y
    @descriptor = descriptor
    @distance_from_droid = 9999999999
    @considered = false
  end

  def has_distance?
    @distance_from_droid ? true : false
  end

  def is_t?(maze)
    [@x, @y] == [maze.t_loc.first, maze.t_loc.last]
  end

  def set_distance_from_droid(dist)
    @distance_from_droid = dist
  end

  def mark_considered
    @considered = true
  end

  def inspect
    "(#{@x}, #{y}), considered: #{@considered}, distance: #{@distance_from_droid}"
  end
end

class Maze
  attr_reader :s_loc, :t_loc
  def initialize(lines)
    @s_loc = [nil, nil]
    @t_loc = [nil, nil]
    @grid = {}
    for y in 0..(lines.length - 1)
      line = lines[y]
      for x in 0..(line.length - 1)
        @s_loc = [x, y] if line[x] == S
        @t_loc = [x, y] if line[x] == T
        descriptor = ([S, T].include?(line[x]) ? TRAVERSABLE : line[x])
        @grid[[x, y]] = Node.new(x, y, descriptor)
      end
    end
  end

  def node_at(x, y)
    @grid[[x, y]]
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

  def to_s(under_consideration)
    output = ""
    0.upto NUM_ROWS - 1 do |y|
      0.upto NUM_COLS - 1 do |x|
        if under_consideration &&
            [x, y] == [under_consideration.x, under_consideration.y]
          output += "\e[1;31mO\e[0m"
        else
          output += @grid[[x, y]].descriptor
        end
      end
      output += "\n"
    end
    return output.gsub('#', '.')
  end
end
################################################################################
file = File.open('/Users/scrozier/projects/advent/15/a/maze.txt')
maze = Maze.new(file.readlines.map(&:chomp))

puts maze.to_s(nil)
puts "S is at #{maze.s_loc.inspect}"
puts "T is at #{maze.t_loc.inspect}"

to_consider = []
# start with the S node
s_node = maze.node_at(maze.s_loc.first, maze.s_loc.last)
s_node.set_distance_from_droid(0)
to_consider.push s_node
until to_consider.empty?
  under_consideration = to_consider.pop
  puts maze.to_s(under_consideration)
  sleep 0.01
  next if under_consideration.considered
  neighbors = maze.get_neighbors(under_consideration)
  # all my neighbors can have a distance of one more than me, if they don't
  # already have a distance; see which is smaller
  for neighbor in neighbors
    neighbor.set_distance_from_droid([
      neighbor.distance_from_droid, under_consideration.distance_from_droid + 1
    ].min)
  end
  if under_consideration.is_t?(maze)
    puts "The answer is #{under_consideration.distance_from_droid}"
    exit
  end
  for neighbor in neighbors
    to_consider.push(neighbor) unless neighbor.considered
  end
  under_consideration.mark_considered
  # gets
end

exit