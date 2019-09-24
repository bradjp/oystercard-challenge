require 'oystercard'

describe Oystercard do
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:journey){ {entry_station: entry_station, exit_station: exit_station} }

  it 'checks money on card' do
    expect(subject.balance).to eq 0
  end

  describe '#add_money' do
    it 'adds amount to card' do
      subject.top_up(10)
      expect(subject.balance).to eq 10
    end
  end

    it 'limits the balance to 90' do
      max_balance = Oystercard::MAX_BALANCE
      subject.top_up(max_balance)
      expect(subject.top_up(1)).to eq "Card limit: £#{Oystercard::MAX_BALANCE}"
    end

    it 'stores an entry station' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect(subject.entry_station).to eq entry_station
    end

    it 'creates an empty journey history' do
      expect(subject.journeys).to be_empty
    end

    it 'stores a journey' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journeys).to include journey
  end
  

  describe '#in_journey?' do
    it 'creates a in_journey instance variable' do
      expect(subject).not_to be_in_journey
    end
  end

  describe '#touch_in' do
    it 'sets in journey to true' do
      subject.top_up(40)
      subject.touch_in(entry_station)
      expect(subject).to be_in_journey
    end
  end

  describe '#touch_out' do
    it 'sets in_journey to false' do
      subject.top_up(40)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject).not_to be_in_journey
    end
    it 'deducts minimum fare from balance when touching out' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect { subject.touch_out(exit_station) }.to change{ subject.balance} .by -Oystercard::MIN_BALANCE
    end

    it 'forgets a entry station upon checking out' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.entry_station).to eq nil
    end

    it 'stores an exit station to instance variable on touching out' do
      subject.top_up(40)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.exit_station).to eq exit_station
    end
  end

    it 'stores a completed journey in history' do
      subject.top_up(10)
      subject.touch_in('Kings Cross')
      subject.touch_out('Aldgate East')
      journey = {:entry_station => 'Aldgate East', :exit_station => 'Aldgate East'}
      expect(journey).to include({:entry_station => 'Aldgate East', :exit_station => 'Aldgate East'})
    end
  

  describe 'insufficient balance to travel' do
    it 'throws error if insufficient balance' do
      expect{subject.touch_in(entry_station)}.to raise_error "Balance below minimum of #{Oystercard::MIN_BALANCE}"
    end
  end
end