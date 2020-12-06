DEBUG = false

INST_RESULT_DO_NEXT = 'next'
INST_RESULT_PROVIDE_OUTPUT_TO_NEXT_AMPLIFIER = 'output'
INST_RESULT_HALT = 'halt'

RUN_RESULT_HALT = 'halt'
RUN_RESULT_CONTINUE = 'continue'

DONE = true
NOT_DONE = false

class Machine
  def initialize(program_text, name, phase)
    @program_int_array = program_text.split(",").map(&:to_i)
    @name = name
    @phase = phase
    @output = 0
    @next_pos = 0
    @next_input = 'phase'
    @input = nil
  end

  def execute_instruction_at(pos)
    puts "execute at #{pos}" if DEBUG
    instruction_string = @program_int_array[pos].to_s.rjust(5, '0')
    opcode = instruction_string[-2..-1].to_i
    puts "executing instruction_string #{instruction_string}" if DEBUG

    p1mode = instruction_string[2]
    p2mode = instruction_string[1]
    p3mode = instruction_string[0]
    case opcode
    when 1
      p1 = parameter_at(pos + 1, p1mode)
      p2 = parameter_at(pos + 2, p2mode)
      write_addr = address_at(pos + 3, p3mode)
      @program_int_array[write_addr] = p1 + p2
      puts "ADD #{p1} + #{p2}, store at #{write_addr}" if DEBUG
      @next_pos = pos + 4
      return INST_RESULT_DO_NEXT
    when 2
      p1 = parameter_at(pos + 1, p1mode)
      p2 = parameter_at(pos + 2, p2mode)
      write_addr = address_at(pos + 3, p3mode)
      @program_int_array[write_addr] = p1 * p2
      puts "MUL #{p1} * #{p2}, store at #{write_addr}" if DEBUG
      @next_pos = pos + 4
      return INST_RESULT_DO_NEXT
    when 3
      puts "INP relative_base is #{@relative_base}" if DEBUG
      write_addr = address_at(pos + 1, p1mode)
      value_to_write = @next_input == 'phase' ? @phase : @input
      @program_int_array[write_addr] = value_to_write
      @next_input = 'input'
      puts "INP wrote #{value_to_write} to #{write_addr}" if DEBUG
      @next_pos = pos + 2
      return INST_RESULT_DO_NEXT
    when 4
      p1 = parameter_at(pos + 1, p1mode)
      @output = p1
      @next_pos = pos + 2
      puts "OUTPUT: #{@output}"
      return INST_RESULT_PROVIDE_OUTPUT_TO_NEXT_AMPLIFIER
    when 5
      p1 = parameter_at(pos + 1, p1mode)
      p2 = parameter_at(pos + 2, p2mode)
      puts "JMP if #{p1} to #{p2}" if DEBUG
      @next_pos = p1 != 0 ? p2 : pos + 3
      return INST_RESULT_DO_NEXT
    when 6
      p1 = parameter_at(pos + 1, p1mode)
      p2 = parameter_at(pos + 2, p2mode)
      puts "JMP unless #{p1} to #{p2}" if DEBUG
      @next_pos = p1 == 0 ? p2 : pos + 3
      return INST_RESULT_DO_NEXT
    when 7
      p1 = parameter_at(pos + 1, p1mode)
      p2 = parameter_at(pos + 2, p2mode)
      write_addr = address_at(pos + 3, p3mode)
      @program_int_array[write_addr] = p1 < p2 ? 1 : 0
      puts "WRITE 1 to #{write_addr} if #{p1} < #{p2}" if DEBUG
      @next_pos = pos + 4
      return INST_RESULT_DO_NEXT
    when 8
      p1 = parameter_at(pos + 1, p1mode)
      p2 = parameter_at(pos + 2, p2mode)
      write_addr = address_at(pos + 3, p3mode)
      @program_int_array[write_addr] = p1 == p2 ? 1 : 0
      puts "WRITE 1 to #{write_addr} if #{p1} == #{p2}" if DEBUG
      @next_pos = pos + 4
      return INST_RESULT_DO_NEXT
    when 9
      p1 = parameter_at(pos + 1, p1mode)
      @relative_base += p1
      puts "CHG relative_base by adding #{p1} (now #{@relative_base})" if DEBUG
      @next_pos = pos + 2
      return INST_RESULT_DO_NEXT
    when 99
      return INST_RESULT_HALT
    else
      puts "Blowing up in main execution line with opcode #{opcode}"
    end
  end

  def parameter_at(pos, mode)
    puts "parameter_at(#{pos}, #{mode})" if DEBUG
    parameter = case mode
    when '0'
      @program_int_array[@program_int_array[pos]]
    when '1'
      @program_int_array[pos]
    when '2'
      @program_int_array[@program_int_array[pos] + @relative_base]
    end
    puts "parameter is #{parameter}" if DEBUG
    return parameter
  end

  def address_at(pos, mode)
    puts "address_at(#{pos}, #{mode})" if DEBUG
    parameter = case mode
    when '0'
      @program_int_array[pos]
    when '2'
      @program_int_array[pos] + @relative_base
    end
    puts "address is #{parameter}" if DEBUG
    return parameter
  end

  def to_s
    @program_int_array.join("\n")
  end

  def run(input)
    puts "I am #{@name}, ready to execute with input #{input}" if DEBUG
    @input = input
    while true
      next_action = execute_instruction_at(@next_pos)
      return @output if next_action == INST_RESULT_PROVIDE_OUTPUT_TO_NEXT_AMPLIFIER
      return -1 if next_action == INST_RESULT_HALT
    end
  end
end

class MachinePool
  def initialize(array_of_machines)
    raise "Wrong number of machines" if array_of_machines.length != 5
    @machine_array = array_of_machines
    @next_machine = 0
  end

  def next_machine
    machine = @machine_array[@next_machine]
    @next_machine += 1
    @next_machine = 0 if @next_machine == 5
    return machine
  end
end

####################

file = File.open('/Users/scrozier/projects/advent/07/a/input.txt')
program_text = file.readline.chomp

max_thrust = [0, nil] # [thrust, array_of_inputs]

[5, 6, 7, 8, 9].permutation do |combo| # combo is an array of these 5 numbers
  # spin up five machines
  puts "Trying #{combo.inspect}..."
  machineA = Machine.new(program_text, "A", combo[0])
  machineB = Machine.new(program_text, "B", combo[1])
  machineC = Machine.new(program_text, "C", combo[2])
  machineD = Machine.new(program_text, "D", combo[3])
  machineE = Machine.new(program_text, "E", combo[4])

  machine_pool = MachinePool.new([machineA, machineB, machineC, machineD, machineE])

  new_signal = 0
  while true
    machine = machine_pool.next_machine
    new_signal = machine.run(new_signal)
    break if new_signal == -1
    max_thrust = [new_signal, combo] if new_signal > max_thrust.first
  end
end
puts "Answer: #{max_thrust.inspect}"
exit
