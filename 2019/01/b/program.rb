def fuel_calc(mass)
  return 0 if (mass / 3) - 2 <= 0
  initial_fuel_required = (mass / 3) - 2
  return initial_fuel_required + fuel_calc(initial_fuel_required)
end

file = File.open('/Users/scrozier/projects/advent/1/a/input.txt')
fuel = file.readlines.map { |mstr|
  mstr.chomp.to_i
}
puts fuel.inject(0) { |sum, module_fuel| sum + fuel_calc(module_fuel) }
exit
