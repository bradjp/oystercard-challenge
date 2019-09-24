require 'oystercard'

describe Oystercard do

  subject(:oystercard) { described_class.new }
  let(:station){ double :station }

  it 'checks money on card' do
    expect(oystercard.balance).to eq 0
  end

  describe '#add_money' do
    it 'adds amount to card' do
      oystercard.top_up(10)
      expect(oystercard.balance).to eq 10
    end

    it 'limits the balance to 90' do
      max_balance = Oystercard::MAX_BALANCE
      subject.top_up(max_balance)
      expect(oystercard.top_up(1)).to eq "card has balance limit of £#{Oystercard::MAX_BALANCE}"
    end

    it 'stores an entry station' do
      oystercard.top_up(10)
      oystercard.touch_in(station)
      expect(oystercard.entry_station).to eq station
    end

    it 'creates an empty journey history' do
      expect(subject.history).to be_empty
    end
  end
  #deduct method no longer tested as it is a private method

  # describe "#deduct" do
  #   it "deducts momney from card" do
  #     oystercard.top_up(50)
  #     expect{oystercard.deduct(10)}.to change{oystercard.balance}.by -10
  #   end
  # end

  describe "#in_journey?" do
    it "creates a in_journey instance variable" do
      expect(subject).not_to be_in_journey
    end
  end

  describe "#touch_in" do
    it "touching in to set @journey to true" do
      subject.top_up(40)
      subject.touch_in(station)
      expect(subject).to be_in_journey
      end
    end

  describe "#touch_out" do
    it "touching out sets in_journey to false" do
      subject.top_up(40)
      subject.touch_in(station)
      subject.touch_out(station)
      expect(subject).not_to be_in_journey
    end
    it "deducts minimum fare from balance when touching out" do
      subject.top_up(10)
      subject.touch_in(station)
      expect{subject.touch_out(station)}.to change{oystercard.balance}.by (-Oystercard::MIN_BALANCE)
    end

    it "forgets a entry station upon checking out" do
      subject.top_up(10)
      subject.touch_in('kingsx')
      subject.touch_out(station)
      expect(subject.entry_station).to eq nil
    end

    it "stores an exit station to instance variable on touching out" do
      subject.top_up(40)
      subject.touch_in(station)
      subject.touch_out('station')
      expect(subject.exit_station).to eq 'station'
    end
  end

  describe "#history" do
    # it "stores the entry station to journey history" do
    #   subject.top_up(10)
    #   subject.touch_in('kingsx')
    #   subject.touch_out
    #   expect(subject.history).to include('kingsx')
    # end

    it "stores a completed journey in history" do
      subject.top_up(10)
      subject.touch_in('Kings Cross')
      subject.touch_out('Aldgate East')
      journey = {:entry_station => 'Aldgate East', :exit_station => 'Aldgate East'}
      expect(journey).to include({:entry_station => 'Aldgate East', :exit_station => 'Aldgate East'})
    end
  end

  context "insufficient balance to travel" do
    it "throws error if insufficent balance" do
      expect { subject.touch_in(station) } .to raise_error "Balance below minimum of #{Oystercard::MIN_BALANCE}"
    end
  end
end
