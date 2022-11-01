class Deck
  def initialize
    @cards = (0..51).to_a
  end

  def give_card
    num = rand(cards.length)
    card = cards[num]
    cards.delete_at(num)
    Card.new(card % 13, card / 13)
  end
  alias take_card give_card

  private

  attr_accessor :cards
end
