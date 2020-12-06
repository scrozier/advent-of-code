require '/Users/scrozier/projects/advent/intcode'

NUM_ROWS = 44
NUM_COLS = 49

class Scaffold
  def initialize
    @map = Hash.new(" ")
  end

  def draw(char, row, col)
    @map[[row, col]] = char
  end

  # returns an array of [row, col] coordinates
  def intersections
    results = []
    0.upto NUM_ROWS - 1 do |row|
      next if row == 0 || row == NUM_ROWS - 1
      0.upto NUM_COLS - 1 do |col|
        next if col == 0 || col == NUM_COLS - 1
        results << [row, col] if
          @map[[row, col]] == '#' &&
          @map[[row - 1, col]] == '#' &&
          @map[[row + 1, col]] == '#' &&
          @map[[row, col - 1]] == '#' &&
          @map[[row, col + 1]] == '#'
      end
    end
    return results
  end

  def to_s
    output = ""
    0.upto NUM_ROWS - 1 do |row|
      0.upto NUM_COLS - 1 do |col|
        output += @map[[row, col]]
      end
      output += "\n"
    end
    return output
  end
end

###############################################################################

scaffold = Scaffold.new

num_rows = 0
num_cols = 0

current_row = 0
current_col = 0

provide_input = lambda do
  throw "Input?!?"
  # return @current_panel_color
end

# 35 #
# 46 .
# 10 new line
# 94 ^
# 60 <
# 62 >
# 88 X
# 118 v
receive_output = lambda do |output|
  puts "Received #{output}"
  case output
  when 10 # new line
    current_row += 1
    current_col = 0
  when 35, 46, 94, 60, 62, 88, 118
    scaffold.draw({
      35 => '#',
      46 => '.',
      60 => '<',
      62 => '>',
      88 => 'X',
      94 => '^',
      118 => 'v'
    }[output], current_row, current_col)
    current_col += 1
  else
    throw "Mayday! Don't know how to handle #{output}"
  end
  puts scaffold.to_s
end

file = File.open('/Users/scrozier/projects/advent/17/a/input.txt')
program_text = file.readline.chomp
ascii = Intcode.new(program_text, provide_input, receive_output)

ascii.run
intersections = scaffold.intersections
for intersection in intersections
  scaffold.draw('O', intersection.first, intersection.last)
end
puts scaffold.to_s

alignment_parameters = intersections.map { |i| i.first * i.last }
puts alignment_parameters.inspect

ap_sum = alignment_parameters.reduce(&:+)
puts "The answer is #{ap_sum}"

exit
