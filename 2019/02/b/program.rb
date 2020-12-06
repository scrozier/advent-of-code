def run_program_with(program, noun, verb)
  program[1] = noun
  program[2] = verb

  opcode_position = 0
  while true
    opcode = program[opcode_position]
    if opcode == 99
      return program[0]
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
      return -1
    end

    opcode_position += 4
  end
end

file = File.open('/Users/scrozier/projects/advent/2/a/input.txt')
program_text = file.readline.chomp
program = program_text.split(",").map(&:to_i)

for noun in 0..99
  for verb in 0..99
    puts "noun: #{noun}, verb: #{verb}..."
    output = run_program_with(program.clone, noun, verb)
    puts "...program[0]: #{output}"
    if output == 19690720
      puts "...answer: #{noun * 100 + verb}"
      exit
    end
  end
end
exit

