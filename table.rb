class Table
  def initialize(user, dealer, bank, width = 10)
    @width = width
    @user = user
    @dealer = dealer
    @bank = bank
  end

  def show(show_dealer = false)
    draw_player(dealer, show = show_dealer)
    draw_line
    draw_cards(dealer, show_dealer ? :face : :back)
    draw_bank
    draw_cards(user, :face)
    draw_line
    draw_player(user)
  end

  private

  attr_accessor :width, :user, :dealer, :bank

  def draw_line
    print '+'
    width.times { print '-' }
    puts '+'
  end

  def draw_cards(player, side)
    player_cards = player.show_cards(side).join(' ')
    num = width - player_cards.length
    left = num / 2
    right = num - left
    puts '|' + ' ' * left + player_cards + ' ' * right + '|'
  end

  def draw_bank
    bank_amount = bank.money.to_s
    num = width - bank_amount.length
    left = num / 2
    right = num - left
    puts '|' + ' ' * left + bank_amount + ' ' * right + '|'
  end

  def draw_player(player, show = true)
    puts "#{player.name} Points: #{show ? player.score : '*'} Money: #{player.bank.money}"
  end
end
