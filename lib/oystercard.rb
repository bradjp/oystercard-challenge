class Oystercard
  attr_reader :balance, :journeys, :exit_station, :entry_station 

  MAX_BALANCE = 90
  MIN_BALANCE = 1

  def initialize
    @balance = 0
    @entry_station = nil
    @journeys = []
  end

  def in_journey?
    true unless @entry_station == nil
   # true if @journeys.has_value(:unfinished)
  end

  def top_up(amount)
    @balance + amount > MAX_BALANCE ? "Card limit: £#{Oystercard::MAX_BALANCE}" : @balance += amount
  end

  def touch_in(station)
    raise "Balance below minimum of #{MIN_BALANCE}" unless @balance >= MIN_BALANCE
    @entry_station = station
   # @journeys << { entry_station: station, exit_station: :unfinished }
  end

  def touch_out(station)
    @exit_station = station

   # @journeys[-1][:exit_station] = station

   @journeys << { entry_station: entry_station, exit_station: exit_station }


    @entry_station = nil

    deduct(MIN_BALANCE)
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end
