file = File.open('/Users/scrozier/projects/advent/2/a/input.txt')
program_text = file.readline.chomp
puts program_text
program = program_text.split(",").map(&:to_i)
puts program.inspect

opcode_position = 0
while true
  opcode = program[opcode_position]
  if opcode == 99
    puts program.inspect
    exit
  end

  input_a = program[program[opcode_position + 1]]
  input_b = program[program[opcode_position + 2]]
  output_position = program[opcode_position + 3]
  case opcode
  when 1
    program[output_position] = input_a + input_b
  when 2
    program[output_position] = input_a * input_b
  else
    puts "Whoa! Mayday!"
    exit
  end

  opcode_position += 4
end
puts program.inspect

exit
