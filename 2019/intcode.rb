# DEBUG = true
DEBUG = false

class Intcode
  def initialize(program_text, input_function, output_function, halt_function)
    # @program_int_array = program_text.split(",").map(&:to_i)
    @temp = program_text.split(",").map(&:to_i)
    @program_int_array = Array.new(@temp.length * 10) { |i| @temp[i] || 0}
    @input_function = input_function
    @output_function = output_function
    @halt_function = halt_function
    @relative_base = 0
    @pos = 0
  end

  def execute_instruction_at(pos)
    puts "execute at #{@pos}" if DEBUG
    throw "@pos is nil" unless @pos
    instruction_string = @program_int_array[@pos].to_s.rjust(5, '0')
    opcode = instruction_string[-2..-1].to_i
    puts "executing instruction_string #{instruction_string}" if DEBUG

    p1mode = instruction_string[2]
    p2mode = instruction_string[1]
    p3mode = instruction_string[0]
    case opcode
    when 1
      p1 = parameter_at(@pos + 1, p1mode)
      p2 = parameter_at(@pos + 2, p2mode)
      write_addr = address_at(@pos + 3, p3mode)
      @program_int_array[write_addr] = p1 + p2
      puts "ADD #{p1} + #{p2}, store at #{write_addr}" if DEBUG
      return @pos + 4
    when 2
      p1 = parameter_at(@pos + 1, p1mode)
      p2 = parameter_at(@pos + 2, p2mode)
      write_addr = address_at(@pos + 3, p3mode)
      @program_int_array[write_addr] = p1 * p2
      puts "MUL #{p1} * #{p2}, store at #{write_addr}" if DEBUG
      return @pos + 4
    when 3
      puts "INP relative_base is #{@relative_base}" if DEBUG
      write_addr = address_at(@pos + 1, p1mode)
      input = @input_function.call
      @program_int_array[write_addr] = input
      puts "INP wrote #{input} to #{write_addr}" if DEBUG
      return @pos + 2
    when 4
      p1 = parameter_at(@pos + 1, p1mode)
      @output_function.call(p1)
      return @pos + 2
    when 5
      p1 = parameter_at(@pos + 1, p1mode)
      p2 = parameter_at(@pos + 2, p2mode)
      puts "JMP if #{p1} to #{p2}" if DEBUG
      return p1 != 0 ? p2 : @pos + 3
    when 6
      p1 = parameter_at(@pos + 1, p1mode)
      p2 = parameter_at(@pos + 2, p2mode)
      puts "JMP unless #{p1} to #{p2}" if DEBUG
      return p1 == 0 ? p2 : @pos + 3
    when 7
      p1 = parameter_at(@pos + 1, p1mode)
      p2 = parameter_at(@pos + 2, p2mode)
      write_addr = address_at(@pos + 3, p3mode)
      @program_int_array[write_addr] = (p1 < p2 ? 1 : 0)
      puts "WRITE 1 to #{write_addr} if #{p1} < #{p2}" if DEBUG
      return @pos + 4
    when 8
      p1 = parameter_at(@pos + 1, p1mode)
      p2 = parameter_at(@pos + 2, p2mode)
      write_addr = address_at(@pos + 3, p3mode)
      @program_int_array[write_addr] = (p1 == p2 ? 1 : 0)
      puts "WRITE 1 to #{write_addr} if #{p1} == #{p2}" if DEBUG
      return @pos + 4
    when 9
      p1 = parameter_at(@pos + 1, p1mode)
      @relative_base += p1
      puts "CHG relative_base by adding #{p1} (now #{@relative_base})" if DEBUG
      return @pos + 2
    when 99
      puts "HALTING" if DEBUG
      @halt_function.call
      return -1
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

  def run(reset=false)
    @pos = 0 if reset
    while true
      @pos = execute_instruction_at(@pos)
      puts "@pos = #{@pos}" if DEBUG
      throw "@pos is nil in run" unless @pos
      return if @pos == -1
    end
  end
end
