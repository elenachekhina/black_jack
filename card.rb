class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = FACE_DICT[rank] || rank + 2
    @suit = SUIT_DICT[suit]
  end

  def face
    "#{@rank}#{@suit}"
  end

  def back
    '*'
  end

  SUIT_DICT = {
    0 => "\u2665",
    1 => "\u2666",
    2 => "\u2663",
    3 => "\u2660"
  }.freeze
  FACE_DICT = {
    12 => :A,
    11 => :K,
    10 => :Q,
    9 => :J
  }.freeze
end
