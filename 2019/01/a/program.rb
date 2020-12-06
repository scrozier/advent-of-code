file = File.open('input.txt')
fuel = file.readlines.map { |mstr|
  (mstr.chomp.to_i / 3) - 2
}
puts fuel.inject(0) { |sum, module_fuel| sum + module_fuel }
exit
