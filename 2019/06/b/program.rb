class Planet
  attr_reader :name
  attr_accessor :orbited
  def initialize(name)
    @name = name
    @orbited = nil
  end

  def path_to_com
    return [] if @name == 'COM'
    return @orbited.path_to_com << self.name
  end

  def num_steps_to_planet(planet)
    return 0 if self == planet
    1 + @orbited.num_steps_to_planet(planet)
  end

  def ==(other)
    @name == other.name
  end
end

file = File.open('../a/input.txt')
planet_list = {}
orbits = file.readlines.map do |ostr|
  orbited_s = ostr[0..2]
  orbiter_s = ostr[4..6]
  orbited = orbiter = nil

  if planet_list[orbiter_s]
    orbiter = planet_list[orbiter_s]
  else
    orbiter = Planet.new(orbiter_s)
    planet_list[orbiter_s] = orbiter
  end

  if planet_list[orbited_s]
    orbited = planet_list[orbited_s]
  else
    orbited = Planet.new(orbited_s)
    planet_list[orbited_s] = orbited
  end

  orbiter.orbited = orbited
end

you_to_com = planet_list['YOU'].path_to_com
san_to_com = planet_list['SAN'].path_to_com

# find where the paths diverge
planet_index = 0
while you_to_com[planet_index] == san_to_com[planet_index]
  planet_index += 1
end
closest_common_planet = planet_list[you_to_com[planet_index - 1]]

num_steps_for_you = planet_list['YOU'].num_steps_to_planet(closest_common_planet)
num_steps_for_san = planet_list['SAN'].num_steps_to_planet(closest_common_planet)

answer = num_steps_for_you + num_steps_for_san - 2
puts answer
exit