require '/Users/scrozier/projects/advent/intcode2'

class Computer
  attr_reader :initialized, :software, :address, :input_queue

  def initialize(software, address)
    @software = software
    @address = address
    @input_queue = []
    @initialized = false
    @output = {dest: nil, x: nil, y: nil}
    @last_packet = [nil, nil]
  end

  def check_and_process_idle(computers)
    c2c = computers.select { |c| c && c.address <= 49 }
    return @last_packet if c2c.all? { |c| c.input_queue.empty? }
    return false
  end

  def set_last(packet)
    @last_packet = packet
  end

  def initialize_it
    @initialized = true
  end

  def stage_output(val)
    case
    when @output[:dest].nil?
      @output[:dest] = val
      return false
    when @output[:x].nil?
      @output[:x] = val
      return false
    when @output[:y].nil?
      @output[:y] = val
      return @output
    else
      puts "Oops in stage_output"
    end
  end

  def clear_staged_output
    @output = {dest: nil, x: nil, y: nil}
  end

  def queue_input(val)
    @input_queue.push val
  end

  def next_input
    return -1 if @input_queue.empty?
    @input_queue.shift
  end
end

###############################################################################

@computers = []
@threads = []
@last_to_255 = [nil, nil]
@ys_to_0 = []

provide_input = lambda do |addr|
  # if not initialized, send its network address
  unless @computers[addr].initialized
    puts "Initializing #{addr}"
    @computers[addr].initialize_it
    return addr
  end
  input_val = @computers[addr].next_input
  puts "providing input of #{input_val} to [#{addr}]" if input_val != -1
  return input_val
end

receive_output = lambda do |addr, output|
  puts "Received output of #{output} from [#{addr}]"
  output_ready = @computers[addr].stage_output(output)
  if output_ready
    puts "...destined for #{output_ready[:dest]}"
    until @computers[output_ready[:dest]] && @computers[output_ready[:dest]].initialized
      sleep 2
    end
    @computers[output_ready[:dest]].queue_input(output_ready[:x])
    @computers[output_ready[:dest]].queue_input(output_ready[:y])
    @computers[addr].clear_staged_output
    @computers[output_ready[:dest]].set_last [output_ready[:x], output_ready[:y]]
    if output_ready[:dest] == 255
      puts "Doing the 255..."
      last_packet = @computers[255].check_and_process_idle(@computers)
      puts "last_packet: #{last_packet.inspect}"
      if last_packet
        @computers[0].queue_input(last_packet.first)
        @computers[0].queue_input(last_packet.last)
        this_y = last_packet.last
        # has this y value been delivered before?
        puts "@ys_to_0: #{@ys_to_0.inspect}"
        if @ys_to_0.find { |e| e == this_y }
          puts "The answer is #{this_y}"
          raise "The end"
        end
        @ys_to_0 << this_y
      end
    end
  end
end

halt = lambda do |addr|
  @threads[addr].exit
end

file = File.open('/Users/scrozier/projects/advent/23/a/input.txt')
program_text = file.readline.chomp

Thread.abort_on_exception = true

# create 50 computers and their threads
for address in 0..49
  @computers[address] = Computer.new(Intcode2.new(program_text, address, provide_input, receive_output, halt), address)
  puts "Created #{@computers[address].address}"
  @threads[address] = Thread.new(address) { |a| @computers[a].software.run }
end
@computers[255] = Computer.new(Intcode2.new(program_text, address, provide_input, receive_output, halt), 255)
puts "Created #{@computers[255].address}"
@threads[255] = Thread.new(255) { |a| @computers[a].software.run }
@computers[255].initialize_it

@threads.each { |t| t.join }

exit
