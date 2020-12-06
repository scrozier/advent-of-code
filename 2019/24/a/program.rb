BUG = '#'
EMPTY_SPACE = '.'

class Eris
  attr_reader :map

  def initialize(lines)
    @map = Hash.new(EMPTY_SPACE)
    @lines = lines
    for y in 0..4
      for x in 0..4
        @map[[x, y]] = @lines[y][x]
      end
    end
  end

  def evolve
    new_map = {}
    for y in 0..4
      for x in 0..4
        case @map[[x, y]]
        when BUG
          new_map[[x, y]] = (adjacent_bugs(x, y) == 1 ? BUG : EMPTY_SPACE)
        when EMPTY_SPACE
          num_adjacent = adjacent_bugs(x, y)
          new_occupant = ([1, 2].include?(num_adjacent) ? BUG : EMPTY_SPACE)
          new_map[[x, y]] = new_occupant
        else
          raise "Oops"
        end
      end
    end
    @map = new_map
  end

  def biodiversity_rating
    rating = 0
    value = 1
    for y in 0..4
      for x in 0..4
        rating += value if @map[[x, y]] == BUG
        value *= 2
      end
    end
    return rating
  end

  def adjacent_bugs(x, y)
    num_bugs = 0
    num_bugs += 1 if @map[[x, y - 1]] == BUG
    num_bugs += 1 if @map[[x, y + 1]] == BUG
    num_bugs += 1 if @map[[x - 1, y]] == BUG
    num_bugs += 1 if @map[[x + 1, y]] == BUG
    return num_bugs
  end

  def to_s
    output = ""
    for y in 0..4
      output << "\n"
      for x in 0..4
        output << @map[[x, y]]
      end
    end
    return output + "\n\n"
  end
end

file = File.open('/Users/scrozier/projects/advent/24/a/input.txt')
map = Eris.new(file.readlines.map(&:chomp))

maps = [map]

while true do
  map.evolve
  if maps.find { |m| m == map.map }
    puts "The answer is #{map.biodiversity_rating}"
    exit
  end
  maps << map.map
end

exit
