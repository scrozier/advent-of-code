class Program
  def initialize(program_text)
    @program_int_array = program_text.split(",").map(&:to_i)
  end

  def execute_instruction_at(pos)
    puts "execute at #{pos}"
    instruction_string = @program_int_array[pos].to_s.rjust(5, '0')
    opcode = instruction_string[-2..-1].to_i
    if [1, 2, 5, 6, 7, 8].include?(opcode)
      p1mode = instruction_string[2]
      p2mode = instruction_string[1]
      p1 = (p1mode == '0' ? @program_int_array[@program_int_array[pos + 1]] : @program_int_array[pos + 1])
      p2 = (p2mode == '0' ? @program_int_array[@program_int_array[pos + 2]] : @program_int_array[pos + 2])
    end
    if [1, 2, 7, 8].include?(opcode)
      write_addr = @program_int_array[pos + 3]
    end
    if opcode == 3
      write_addr = @program_int_array[pos + 1]
    end
    if opcode == 4
      p1 = @program_int_array[@program_int_array[pos + 1]]
    end

    case opcode
    when 1
      @program_int_array[write_addr] = p1 + p2
    when 2
      @program_int_array[write_addr] = p1 * p2
    when 3
      @program_int_array[write_addr] = (@next_input == 'phase' ? @phase : @initial)
      @next_input = 'initial'
    when 4
      @output = p1
    when 5, 6
    when 7
      @program_int_array[write_addr] = (p1 < p2 ? 1 : 0)
    when 8
      @program_int_array[write_addr] = (p1 == p2 ? 1 : 0)
    when 99
      return true, @output
    else
      puts "Blowing up in execute!"
    end
    return false, next_pos(pos, opcode, p1, p2)
  end

  def to_s
    @program_int_array.join("\n")
  end

  def run(initial, phase) # if phase is nil, continue rather than reset
    @next_input = 'phase'
    @initial = initial
    @phase = phase if phase
    next_pos = 0 if phase
    while true
      done, next_pos = execute_instruction_at(next_pos)
      return @output if done
    end
  end

  def next_pos(pos, opcode, p1, p2)
    case opcode
    when 1, 2, 7, 8
      return pos + 4
    when 3, 4
      return pos + 2
    when 5
      return p1 != 0 ? p2 : pos + 3
    when 6
      return p1 == 0 ? p2 : pos + 3
    else
      puts "Blowing up in Program#next_pos"
    end
  end
end

file = File.open('/Users/scrozier/projects/advent/7/a/input.txt')
program_text = file.readline.chomp
program = Program.new(program_text)

max_thrust = [0, nil] # [thrust, array_of_inputs]
[0, 1, 2, 3, 4].permutation do |combo| # combo is an array of the 5 numbers
  thrust = program.run(program.run(program.run(program.run(program.run(0, combo[0]), combo[1]), combo[2]), combo[3]), combo[4])
  max_thrust = [thrust, combo] if thrust > max_thrust.first
end
puts "Answer: #{max_thrust.inspect}"
exit
