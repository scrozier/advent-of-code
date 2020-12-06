NUM_STEPS = 1000000
X = 0
Y = 1
Z = 2

class Moon
	attr_accessor :pos, :vel

	def initialize(x, y, z)
		@pos = [x, y, z]
		@vel = [0, 0, 0]
	end

	# potential energy = sum of absolute values of x, y, z position coordinates
	def potential_energy
		@pos[0].abs + @pos[1].abs + @pos[2].abs
	end

	# kinetic energy = sum of absolute values of x, y, z velocity coordinates
	def kinetic_energy
		@vel[0].abs + @vel[1].abs + @vel[2].abs
	end

  def ==(other)
    @pos == other.pos && @vel == other.vel
  end

	def to_s
		"MOON: pos=#{@pos} vel=#{@vel}"
	end
end

file = File.open('/Users/scrozier/projects/advent/12/a/input.txt')
moons = []
moons_initial_state = []
file.readlines.map do |input|
  coords = input.chomp.split(',').map { |coord| coord.to_i }
  moon = Moon.new(coords[0], coords[1], coords[2])
  mooni = Moon.new(coords[0], coords[1], coords[2])
  moons << moon
  moons_initial_state << mooni
end

history = []
1.upto NUM_STEPS do |step|
  history << moons[3].vel[Z]
	# apply gravity for each pair of moons
	moons.combination(2).each do |moon_pair|
		# puts "\n#{moon_pair.first} / #{moon_pair.last}"
		[X, Y, Z].each do |axis|
			# puts "#{axis} axis"
			if moon_pair.first.pos[axis] > moon_pair.last.pos[axis]
				moon_pair.first.vel[axis] -= 1
				moon_pair.last.vel[axis] += 1
			elsif moon_pair.first.pos[axis] < moon_pair.last.pos[axis]
				moon_pair.first.vel[axis] += 1
				moon_pair.last.vel[axis] -= 1
			end
		# puts "#{moon_pair.first} / #{moon_pair.last}"
		end
	end
	# apply velocity
	moons.each_with_index do |moon, index|
		[X, Y, Z].each do |axis|
			moon.pos[axis] = moon.pos[axis] + moon.vel[axis]
		end
	end
  # puts "#{history.slice(0, 4)} / #{history.slice(step - 4, 4)}"
  if moons[0].pos[Z] == moons_initial_state[0].pos[Z] &&
     moons[0].vel[Z] == moons_initial_state[0].vel[Z] &&
     moons[1].pos[Z] == moons_initial_state[1].pos[Z] &&
     moons[1].vel[Z] == moons_initial_state[1].vel[Z] &&
     moons[2].pos[Z] == moons_initial_state[2].pos[Z] &&
     moons[2].vel[Z] == moons_initial_state[2].vel[Z] &&
     moons[3].pos[Z] == moons_initial_state[3].pos[Z] &&
     moons[3].vel[Z] == moons_initial_state[3].vel[Z]
     puts "X cycle at #{step}"
   end
  # puts "cyclic at #{step - 6}" if history.slice(0, 6) == history.slice(step - 6, 6)
  # puts "equal? #{history.slice(0, 4) == history.slice(step - 4, 4)}"
end
exit
