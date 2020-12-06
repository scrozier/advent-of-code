# represent locations as arrays, [x, y]

class Location
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def move(direction)
    x = @x
    y = @y
    x += 1 if direction == 'R'
    x -= 1 if direction == 'L'
    y += 1 if direction == 'U'
    y -= 1 if direction == 'D'
    Location.new(x, y)
  end

  def distance_from_central_port
    x.abs + y.abs
  end

  def to_s
    "(#{@x}, #{@y})"
  end

  def inspect
    "(#{@x}, #{@y})"
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def self.calculate_occupied_locations(current_location, instruction)
    occupied_locations = []
    # e.g. R 5
    instruction.distance.times do
      occupied_locations << current_location.move(instruction.direction)
      current_location = occupied_locations.last
    end
    return occupied_locations
  end
end

class DrawingInstruction
  attr_reader :direction, :distance

  def initialize(direction_and_distance)
    @direction = direction_and_distance[0]
    @distance = direction_and_distance[1, 99].to_i
  end
end

class Line
  attr_reader :drawing_instructions

  # path is the input string read from the file
  def initialize(path)
    @drawing_instructions = path.split(",").map { |dds| DrawingInstruction.new(dds)}
  end

  def calculate_locations_occupied
    @location_array = []
    current_location = Location.new(0,0) # central port
    for instruction in @drawing_instructions do
      incremental_locations =
        Location.calculate_occupied_locations(current_location, instruction)
      @location_array += incremental_locations
      current_location = @location_array.last
    end
  end

  def steps_from_central_port(location)
    steps = 0
    for step in @location_array do
      steps += 1
      return steps if step == location
    end
  end

end

###############################################################################

file = File.open('/Users/scrozier/projects/advent/3/a/input.txt')
line1 = Line.new(file.readline.chomp)
line2 = Line.new(file.readline.chomp)
file.close

line1.calculate_locations_occupied
line2.calculate_locations_occupied

intersections = [
  Location.new(-1004, -148),
  Location.new(-1106, -252),
  Location.new(-1403, -252),
  Location.new(-1423, -252),
  Location.new(-1767, -252),
  Location.new(-1913, -274),
  Location.new(-1913, -351),
  Location.new(-1913, -505),
  Location.new(-1913, -670),
  Location.new(-1139, -1069),
  Location.new(-1526, -1078),
  Location.new(-2380, -1521),
  Location.new(-2316, -988),
  Location.new(-367, -693),
  Location.new(-367, -605),
  Location.new(1003, -28),
  Location.new(662, -28),
  Location.new(446, 0),
  Location.new(662, 350)
]

distances = []
intersections.each_with_index do |intersection, index|
  distances[index] =
    line1.steps_from_central_port(intersection) +
    line2.steps_from_central_port(intersection)
end

# find the shortest distance

answer = distances.min

puts "answer is #{answer}"
