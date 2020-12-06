require '/Users/scrozier/projects/advent/intcode'

@provide_input = lambda do
  return 5
end

@receive_output = lambda do |output|
  puts output
end

file = File.open('/Users/scrozier/projects/advent/05/a/input.txt')
program_text = file.readline.chomp
program = Intcode.new(program_text, @provide_input, @receive_output)
program.run
exit
