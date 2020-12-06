input = 'L6R12L6R12L10L4L6L6R12L6R12L10L4L6L6R12L6L10L10L4L6R12L10L4L6L10L10L4L6L6R12L6L10L10L4L6'

for a_start in 0..(input.length - 20)
	for a_length in 1..20
    a = input[a_start, a_length]
    # puts "a: #{a}"
    after_a = input.dup
    after_a.gsub!(a, 'A')
    # puts "left: #{after_a}"
    for b_start in 0..(after_a.length - 20)
      for b_length in 1..20
        b = input[b_start, b_length]
        # puts "b: #{b}"
        after_b = after_a.dup
        after_b.gsub!(b, 'B')
        # puts "left: #{after_b}"
        for c_start in 0..(after_b.length - 20)
          for c_length in 1..20
            c = input[c_start, c_length]
            # puts "c: #{c}"
            after_c = after_b.dup
            after_c.gsub!(c, 'C')
            # puts "left: #{after_c}"
            if after_c.chars.uniq.sort == ['A', 'B', 'C']
              puts "We have a winner: #{[a, b, c].inspect}"
              puts "Master: #{after_c}"
              exit
            end
          end
        end
      end
    end
  end
end
exit
