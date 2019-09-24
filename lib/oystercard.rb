class Oystercard
  attr_reader :balance, :entry_station, :history, :exit_station

  MAX_BALANCE = 90
  MIN_BALANCE = 1

  def initialize
    @balance = 0
    @entry_station = nil
    @history = {}
  end

  def in_journey?
    true unless @entry_station == nil
    #!!entry_station
  end

  def top_up(amount)
    @balance + amount > MAX_BALANCE ? "card has balance limit of £#{MAX_BALANCE}" : @balance += amount
  end

  def touch_in(station)
    raise "Balance below minimum of #{MIN_BALANCE}" unless @balance >= MIN_BALANCE
    # @in_journey = true
    @entry_station = station
    # @history[:entry_station] = station 

  end

  def touch_out(station)
    # @in_journey = false
    @entry_station = nil
    @exit_station = station

    deduct(MIN_BALANCE)

  end

  private

  def deduct(amount)
    @balance -= amount
  end

end
