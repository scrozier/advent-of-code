require '/Users/scrozier/projects/advent/intcode'

@provide_input = lambda do
  return gets.chomp.to_i
end

@receive_output = lambda do |output|
  @output = output
end

@halt = lambda { return }

# test all the addressing modes
# this also tests add and output and halt
program_text = '00001,0,1,2,00004,2,99'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
program.run
puts "01: #{@output == 1 ? 'PASS' : 'FAIL'}"

program_text = '01101,4,19,2,00004,2,99'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
program.run
puts "02: #{@output == 23 ? 'PASS' : 'FAIL'}"

program_text = '00109,9,02101,11,0,10,00004,10,99,22'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
program.run
puts "03: #{@output == 33 ? 'PASS' : 'FAIL'}"

# multiply
program_text = '00002,0,1,2,00004,2,99'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
program.run
puts "04: #{@output == 0 ? 'PASS' : 'FAIL'}"

# input
program_text = '00003,5,4,5,99,0'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
puts "Enter 124"
program.run
puts "05: #{@output == 124 ? 'PASS' : 'FAIL'}"

# jump-if-true
program_text = '3,9,8,9,10,9,4,9,99,-1,8'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
puts "Enter 8"
program.run
puts "06: #{@output == 1 ? 'PASS' : 'FAIL'}"

program_text = '3,9,7,9,10,9,4,9,99,-1,8'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
puts "Enter 7"
program.run
puts "07: #{@output == 1 ? 'PASS' : 'FAIL'}"

program_text = '3,3,1108,-1,8,3,4,3,99'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
puts "Enter 8"
program.run
puts "08: #{@output == 1 ? 'PASS' : 'FAIL'}"

program_text = '3,3,1107,-1,8,3,4,3,99'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
puts "Enter 7"
program.run
puts "09: #{@output == 1 ? 'PASS' : 'FAIL'}"

program_text = '3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
puts "Enter 0"
program.run
puts "10: #{@output == 0 ? 'PASS' : 'FAIL'}"

program_text = '3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
puts "Enter 5"
program.run
puts "11: #{@output == 1 ? 'PASS' : 'FAIL'}"

program_text = '3,3,1105,-1,9,1101,0,0,12,4,12,99,1'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
puts "Enter 0"
program.run
puts "12: #{@output == 0 ? 'PASS' : 'FAIL'}"

program_text = '3,3,1105,-1,9,1101,0,0,12,4,12,99,1'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
puts "Enter 5"
program.run
puts "13: #{@output == 1 ? 'PASS' : 'FAIL'}"

program_text = '3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
puts "Enter 5"
program.run
puts "14: #{@output == 999 ? 'PASS' : 'FAIL'}"

program_text = '3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
puts "Enter 8"
program.run
puts "15: #{@output == 1000 ? 'PASS' : 'FAIL'}"

program_text = '3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
puts "Enter 10"
program.run
puts "16: #{@output == 1001 ? 'PASS' : 'FAIL'}"

@t17_result = []
@t17_output = lambda do |output|
  @t17_result << output
end

program_text = '109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99'
program = Intcode.new(program_text, @provide_input, @t17_output, @halt)
program.run
puts "17: #{@t17_result == [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99] ? 'PASS' : 'FAIL'}"

program_text = '1102,34915192,34915192,7,4,7,99,0'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
program.run
puts "18: #{@output.to_s.length == 16 ? 'PASS' : 'FAIL'}"

program_text = '104,1125899906842624,99'
program = Intcode.new(program_text, @provide_input, @receive_output, @halt)
program.run
puts "19: #{@output == 1125899906842624 ? 'PASS' : 'FAIL'}"

exit




