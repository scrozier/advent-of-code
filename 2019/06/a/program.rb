class Planet
  attr_reader :name
  attr_accessor :orbited
  def initialize(name)
    @name = name
    @orbited = nil
  end

  def depth
    return 0 if @name == 'COM'
    1 + @orbited.depth
  end
end

file = File.open('input.txt')
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

answer = planet_list.inject(0) do |accum, (k, planet)|
  accum += planet.depth
end
puts answer
exit