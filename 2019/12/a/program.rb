NUM_STEPS = 1000
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

	def to_s
		"MOON: pos=#{@pos} vel=#{@vel}"
	end
end

file = File.open('/Users/scrozier/projects/advent/12/a/input.txt')
moons = []
file.readlines.map do |input|
  coords = input.chomp.split(',').map { |coord| coord.to_i }
  moons << Moon.new(coords[0], coords[1], coords[2])
end

# puts "After step 0"
# puts moons
1.upto NUM_STEPS do |step|
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
	for moon in moons
		[X, Y, Z].each do |axis|
			moon.pos[axis] = moon.pos[axis] + moon.vel[axis]
		end
	end
	# puts "\nAfter step #{step}"
	# puts moons
end

# calculate total energy
total_energy = 0
for moon in moons
	# potential energy * kinetic energy
	total_energy += (moon.potential_energy * moon.kinetic_energy)
end
puts "Answer: #{total_energy}"

exit
