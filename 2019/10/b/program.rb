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
    Math.atan2(@y - other.y, @x - other.x)
  end

  def normalized_angle_from_other(other)
    degrees = (angle_from_other(other) * 180.0 / Math::PI) + 90
    degrees += 360.0 if degrees < 0.0
    return degrees
  end

  def distance_from_other(other)
    Math.sqrt((@y - other.y)**2 + (@x - other.x)**2)
  end

  def info(monitoring_location)
    {
      x: @x,
      y: @y,
      angle: normalized_angle_from_other(monitoring_location.location),
      distance: distance_from_other(monitoring_location.location)
    }
  end

  def to_s
    "asteroid at (#{@x}, #{@y})"
  end
end

class MonitoringLocation
  attr_reader :location, :other_asteroids, :asteroid_info
  # location is the monitoring asteroid, asteroids is an array of all
  # asteroids on the map
  def initialize(location, asteroids)
    @location = location
    @x = @location.x
    @y = @location.y
    @other_asteroids = asteroids
    @other_asteroids.delete(@location)
    @asteroid_info = []
    for asteroid in @other_asteroids
      @asteroid_info << asteroid.info(self)
    end
  end

  def asteroid_target_list
    target_list = @asteroid_info
    target_list.sort! do |a1, a2|
      case
      when a1[:angle] != a2[:angle]
        a1[:angle] <=> a2[:angle]
      else
        a1[:distance] <=> a2[:distance]
      end
    end
    vaporized_asteroid_list = []
    until target_list.length == 0
      puts "target list"
      puts target_list
      last_angle = -1.0
      untouched = []
      target_list.each_with_index do |target, index|
        unless target[:angle] == last_angle
          vaporized_asteroid_list << target
          last_angle = target[:angle]
        else
          untouched << target
        end
      end
      target_list = untouched
    end
    return vaporized_asteroid_list
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
  end
end

file = File.open('/Users/scrozier/projects/advent/10/a/input.txt')
map = AstMap.new(file.readlines)

monitoring_asteroid = Asteroid.new(37, 25)
monitoring_location = MonitoringLocation.new(monitoring_asteroid, map.asteroids)
# puts monitoring_location.other_asteroids
# puts monitoring_location.asteroid_info
list = monitoring_location.asteroid_target_list
puts "Final list"
list.each_with_index do |a, i|
  puts "#{i + 1}: #{a}"
end

exit
