WIDTH = 25
HEIGHT = 6

# WIDTH = 2
# HEIGHT = 2

BLOCK = "\u2588".encode('utf-8')

BLACK = '0'
WHITE = '1'
TRANSPARENT = '2'

class Pixel
  def initialize(array_of_layers)
    @array_of_layers = array_of_layers
  end

  def visualize
    # drill down until we find a black or white
    for layer in @array_of_layers
      if layer != TRANSPARENT
        return " " if layer == BLACK
        return BLOCK if layer == WHITE
        throw "Bad news in visualize"
      end
    end
  end
end

class Row
  def initialize(row_string)
    @row_string = row_string
  end

  def char_at(pos)
    @row_string[pos]
  end
end

class Layer
  def initialize(layer_string)
    @layer_string = layer_string
    regexp = Regexp.new(".{#{WIDTH}}")
    @rows = layer_string.scan(regexp).map {|rs| Row.new(rs)}
  end

  def count_char(char)
    @layer_string.count(char)
  end

  def row(rownum)
    @layer_string[rownum * WIDTH, WIDTH]
  end

  def char_at(row, column)
    @rows[row].char_at(column)
  end

  def to_s
    @layer_string
  end
end

class Image
  attr_reader :layers

  def initialize(image_string)
    @image_string = image_string
    characters_in_layer = WIDTH * HEIGHT
    regexp = Regexp.new(".{#{characters_in_layer}}")
    @layers = image_string.scan(regexp).map {|ls| Layer.new(ls)}
  end

  def layer_with_fewest(char)
    counts = @layers.map { |layer| layer.count_char(char) }
    @layers[counts.each_with_index.min.last]
  end

  def visualize_string
    str = ""
    for row in 0..(HEIGHT - 1)
      str << "\n"
      for column in 0..(WIDTH - 1)
        str << Pixel.new(pixel_array_for(row, column)).visualize
      end
    end
    str
  end

  def pixel_array_for(row, column)
    pixel_array = []
    for layer in @layers
      pixel_array << layer.char_at(row, column)
    end
    pixel_array
  end

  def to_s
    @image_string
  end
end

file = File.open('/Users/scrozier/projects/advent/8/a/input.txt')
image_text = file.readline.chomp
image = Image.new(image_text)
puts image.visualize_string
exit
