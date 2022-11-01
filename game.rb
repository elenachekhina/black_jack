class Game
  def initialize
    @user_input = ''
    @user = create_user
    @dealer = Player.new('Dealer')
    @game_bank = Bank.new(0)
    @table = Table.new(user, dealer, game_bank, 10)
  end

  def game
    loop do
      play
      break if user.bank.money.zero? || dealer.bank.money.zero?

      puts 'Would you like to play one more?'
      show_dict(YES_NO_DICT)
      read_user_input(:option)
      break if user_input != 1
    end
    make_conclusion
  end

  class StopIterationError < RuntimeError
  end

  private

  attr_accessor :deck, :user, :dealer, :table, :game_bank, :user_input

  YES_NO_DICT = {
    1 => 'Yes',
    2 => 'No'
  }.freeze

  def read_user_input(type = :string)
    self.user_input = gets.chomp.strip
    self.user_input = user_input.to_i if type == :option
  end

  def make_conclusion
    winner = if user.bank.money > dealer.bank.money
               user
             elsif dealer.bank.money > user.bank.money
               dealer
             end
    output = if winner.nil?
               'Draw'
             else
               "Winner is #{winner.name}"
             end
    puts output
  end

  def play
    @deck = Deck.new
    give_card(user, 2)
    game_bank.put(user.make_bet)
    give_card(dealer, 2)
    game_bank.put(dealer.bank.get(10))
    table.show
    loop do
      show_dict(user_option.select { |_key, value| value[:condition] }.transform_values { |value| value[:name] })
      read_user_input(:option)
      send user_option[user_input][:func]
      dealer_move
    rescue StopIterationError
      open_cards
      break
    rescue NoMethodError
      retry
    end
    user.fold
    dealer.fold
  end

  def dealer_move
    give_card(dealer, 1) if dealer.score < 17 && dealer.cards.length < 3
    table.show
    check_cards
  end

  def give_card(player, num)
    num.times do
      player.take_card(deck.give_card)
    end
  end

  def create_user
    puts 'Enter your name:'
    name = gets.chomp.downcase.capitalize
    Player.new(name)
  rescue Player::NameValidationError
    retry
  end

  def show_dict(dict)
    puts dict.map { |key, option| "#{key} - #{option}" }
  end

  def take_card
    give_card(user, 1)
    table.show
    check_cards
  end

  def check_cards
    raise StopIterationError if user.cards.length == 3 && dealer.cards.length == 3
  end

  def open_cards
    winner = if (user.score > dealer.score || dealer.score > 21) && user.score <= 21
               user
             elsif (dealer.score > user.score || user.score > 21) && dealer.score <= 21
               dealer
             end
    bank = game_bank.get_all
    if !winner.nil?
      winner.take_money(bank)
    else
      user.take_money(bank / 2)
      dealer.take_money(bank / 2)
    end
    table.show(true)
  end

  def skip; end

  def stop_iteration
    raise StopIterationError
  end

  def user_option
    {
      1 => { name: 'Skip', func: :skip, condition: true },
      2 => { name: 'Open cards', func: :stop_iteration, condition: true },
      3 => { name: 'Take card', func: :take_card, condition: user.cards.length < 3 }
    }
  end
end
