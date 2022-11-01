class Player
  attr_reader :cards, :score, :name, :bank

  def initialize(name)
    @name = name
    validate!

    @bank = Bank.new(100)
    @cards = []
    @score = 0
    @score_full = 0
    @aces = 0
  end

  class NameValidationError < RuntimeError
  end

  def take_card(card)
    cards << card
    @aces += 1 if card.rank == :A
    update_score(card)
  end

  def show_cards(side = :face)
    cards.map(&side)
  end

  def fold
    cards.clear
    @score_full = 0
    @aces = 0
  end

  def make_bet(amount = 10)
    bank.get(amount)
  end

  def take_money(amount)
    bank.put(amount)
  end

  private

  NAME_FORMAT = /^([a-z]|[а-я][0-9]){3,15}$/i
  def validate!
    raise NameValidationError if name !~ NAME_FORMAT
  end

  def update_score(card)
    @score_full += SCORE_DICT[card.rank] || card.rank
    @score = @score_full
    @aces.times do
      @score -= 10 if @score > 21
    end
  end

  SCORE_DICT = {
    J: 10,
    Q: 10,
    K: 10,
    A: 11
  }.freeze
end
