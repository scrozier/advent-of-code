class Asteroid
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def angle_from_other(other)
    Math.atan2(y - other.y, x - other.x)
  end

  def distance_from_other(other)
    Math.sqrt((y - other.y)**2 + (x - other.x)**2)
  end

  def to_s
    "(#{@x}, #{@y})"
  end
end

class MonitoringLocation
  # location is the monitoring asteroid, asteroids is an array of all
  # asteroids on the map
  def initialize(location, asteroids)
    @location = location
    @array_of_other_asteroid_angles = []
    for asteroid in asteroids
      next if asteroid == location
      @array_of_other_asteroid_angles << asteroid.angle_from_other(location)
    end
  end

  def vaporize
  end

  def number_detected
    # get array of angles to all asteroids (other than location)
    # take unique to eliminate those in a line, return the count
    @array_of_other_asteroid_angles.uniq.count
  end
end

class AstMap
  attr_reader :lines, :asteroids

  def initialize(lines)
    @lines = lines
    @asteroids = []
    for y in 0..(@lines.count - 1)
      for x in 0..(@lines[y].length - 1)
        @asteroids << Asteroid.new(x, y) if @lines[y][x] == '#'
      end
    end

    def best_monitoring_location
      highest_number = 0
      for asteroid in @asteroids
        try_location = MonitoringLocation.new(asteroid, @asteroids)
        highest_number = try_location.number_detected if try_location.number_detected > highest_number
      end
      return highest_number
    end
  end
end

file = File.open('/Users/scrozier/projects/advent/10/a/input.txt')
map = AstMap.new(file.readlines)
puts map.best_monitoring_location

exit
