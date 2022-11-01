class Bank
  attr_reader :money

  def initialize(money = 0)
    @money = money
  end

  def get(amount)
    @money -= amount
    amount
  end
  alias give get
  def put(amount)
    @money += amount
    amount
  end
  alias take put

  def get_all
    get(money)
  end
end
