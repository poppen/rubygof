require_relative 'factory'

describe 'BusFactory' do
  before do
    @factory = BusFactory.new
  end
  describe '#create_car' do
    it { expect(@factory.create_car).to be_instance_of(Bus) }
    it { expect(@factory.create_car.to_s).to match(/bus/i) }
  end
end

describe 'TruckFactory' do
  before do
    @factory = TruckFactory.new
  end
  describe '#create_car' do
    it { expect(@factory.create_car).to be_instance_of(Truck) }
    it { expect(@factory.create_car.to_s).to match(/truck/i) }
  end
end
