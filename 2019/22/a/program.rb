class Shuffler
  def self.deal_into_new_stack(deck)
    deck.reverse
  end

  def self.cut(deck, num)
    num_to_cut = (num > 0 ? num : deck.length + num)
    to_end = deck[0, num_to_cut]
    deck - to_end + to_end
  end

  def self.deal_with_increment(deck, num)
    new_deck = Array.new(deck.length)
    next_pos = 0
    for card in deck
      new_deck[next_pos] = card
      next_pos = (next_pos + num) % deck.length
    end
    return new_deck
  end
end

DEAL_INTO_NEW_STACK_REGEX = Regexp.new('deal into new stack')
CUT_REGEX = Regexp.new('cut (-?\d+)')
DEAL_WITH_INCREMENT_REGEX = Regexp.new('deal with increment (-?\d+)')

deck = (0..10006).to_a

file = File.open('/Users/scrozier/projects/advent/22/a/input.txt')
file.readlines.map do |shuffle_line|
  shuffle = shuffle_line.chomp
  deck = case shuffle
  when DEAL_INTO_NEW_STACK_REGEX
    Shuffler.deal_into_new_stack(deck)
  when CUT_REGEX
    Shuffler.cut(deck, $1.to_i)
  when DEAL_WITH_INCREMENT_REGEX
    Shuffler.deal_with_increment(deck, $1.to_i)
  else
    throw "Oh no!"
  end
end

puts "The answer is #{deck.index(2019)}"
