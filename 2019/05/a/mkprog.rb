class Program
  attr_reader :program
  def initialize(program_text)
    @program = program_text.split(",").map(&:to_i)
  end
end

file = File.open('/Users/scrozier/projects/advent/5/a/input.txt')
program_text = file.readline.chomp
program = Program.new(program_text).program

program.each_with_index do |value, index|
  puts "(#{index.to_s.rjust(3, ' ')}) #{value}"
end
