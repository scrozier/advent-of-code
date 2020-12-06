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

i = []
i[0] = "A,C,A,C,A,B,C,B,A,B\n"
i[1] = "L,6,R,12,L,6\n"
i[2] = "L,10,L,10,L,4,L,6\n"
i[3] = "R,12,L,10,L,4,L,6\n"
i[4] = "n\n"

next_input = 0
next_char = 0
provide_input = lambda do
  to_return = i[next_input][next_char, 1]
  if i[next_input][next_char, 1] == "\n"
    next_input += 1
    next_char = 0
  else
    next_char += 1
  end
  return to_return.ord
end

# 35 #
# 46 .
# 10 new line
# 94 ^
# 60 <
# 62 >
# 88 X
# 118 v
answer = nil
receive_output = lambda do |output|
  answer = output
end

halt = lambda do
  puts "The answer is #{answer}"
  exit
end

file = File.open('/Users/scrozier/projects/advent/17/b/input.txt')
program_text = file.readline.chomp
ascii = Intcode.new(program_text, provide_input, receive_output, halt)

ascii.run
exit

# L,6,R,12,L,6,R,12,L,10,L,4,L,6,L,6,R,12,L,6,R,12,L,10,L,4,L,6,L,6,R,12,L,6,L,10,L,10,L,4,L,6,R,12,L,10,L,4,L,6,L,10,L,10,L,4,L,6,L,6,R,12,L,6,L,10,L,10,L,4,L,6
# L6R12L6R12L10L4L6L6R12L6R12L10L4L6L6R12L6L10L10L4L6R12L10L4L6L10L10L4L6L6R12L6L10L10L4L6
