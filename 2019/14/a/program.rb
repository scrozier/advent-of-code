class Ingredient
  attr_accessor :qty, :chem

  def initialize(qty, chem)
    @qty = qty
    @chem = chem
  end

  def to_s
    "#{@qty} #{@chem}"
  end
end

class Station
  attr_accessor :inputs, :output

  def initialize(process_string)
    # parse the string
    inputs_s, output_s = process_string.split(" => ")
    # "3 A, 4 B" and "1 AB"
    inputs = inputs_s.split(", ")
    # "3 A", "4 B"
    @inputs = []
    for input in inputs
      qty, chem = input.split(" ")
      @inputs << Ingredient.new(qty.to_i, chem)
    end
    qty, chem = output_s.split(" ")
    @output = Ingredient.new(qty.to_i, chem)
  end

  def to_s
    "#{@inputs.join(", ")} => #{@output}"
  end
end

class Factory
  def initialize
    @stations = []
    @inventory = {}
    @indent = 0
  end

  def init_stations(stations)
    @stations = stations
    for station in @stations
      @inventory[station.output.chem] = 0
      for input in station.inputs
        @inventory[input.chem] = 0
      end
    end
  end

  def station_that_makes(chem)
    stations = @stations.select { |station| station.output.chem == chem }
    throw "Help!" if stations.length > 1
    return stations.first
  end

  # when you make something, you use up ingredients and you increase the
  # product
  def make(qty, chem)
    # if it's ORE requested, we don't make it, just magically get it
    if chem == 'ORE'
      # @inventory['ORE'] -= qty
      return
    else
      station = station_that_makes(chem)
      qty_from_inventory = [[@inventory[chem], qty].min, 0].max
      num_to_make = qty - qty_from_inventory
      return if num_to_make == 0
      ore_needed = 0
      num_batches = (num_to_make.to_f / station.output.qty).ceil
      for ingredient in station.inputs
        @indent += 2
        make(num_batches * ingredient.qty, ingredient.chem)
        @inventory[ingredient.chem] -= num_batches * ingredient.qty
        @indent -= 2
      end
      qty_made = num_batches * station.output.qty
      @inventory[chem] += qty_made
      return
   end
  end

  def how_much_ore
    @inventory['ORE']
  end
end

#################################################################################

file = File.open('/Users/scrozier/projects/advent/14/a/input.txt')
factory = Factory.new
stations = []
for process_string in file.readlines
  stations << Station.new(process_string)
end
factory.init_stations(stations)
factory.make(1, 'FUEL')
puts factory.how_much_ore

exit
