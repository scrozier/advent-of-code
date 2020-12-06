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

  def locations_occupied
    location_array = []
    current_location = Location.new(0,0) # central port
    for instruction in @drawing_instructions do
      incremental_locations =
        Location.calculate_occupied_locations(current_location, instruction)
      location_array += incremental_locations
      current_location = location_array.last
    end
    return location_array
  end
end

file = File.open('/Users/scrozier/projects/advent/3/a/input.txt')
line1 = Line.new(file.readline.chomp)
line2 = Line.new(file.readline.chomp)

# draw the first line, creating an array of locations occupied

line1_locations = line1.locations_occupied

# move along the second line by segment, identifying locations that also exist
# in the first line

intersections = []
current_location = Location.new(0,0) # central port
for instruction in line2.drawing_instructions do
  incremental_locations =
    Location.calculate_occupied_locations(current_location, instruction)
  for location in incremental_locations do
    intersections << location if line1_locations.include? location
  end
  current_location = incremental_locations.last
end

puts "intersections at #{intersections.inspect}"

# take the smallest of those distances as the answer

closest = intersections.min_by { |i| i.distance_from_central_port }
answer = closest.distance_from_central_port
puts "closest is #{closest}, answer is #{answer}"
