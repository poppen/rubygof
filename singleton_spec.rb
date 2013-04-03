require_relative "singleton"

describe MySingleton do
  before do
    @singleton = MySingleton.instance
  end

  describe '#new' do
    it do
      expect{MySingleton.new}.to raise_error(NoMethodError)
    end
  end

  describe '#instance' do
    it { expect(@singleton).to be(MySingleton.instance) }
  end

  describe '#up' do
    it { expect(@singleton.count).to eq(0) }

    it do
      singleton = MySingleton.instance
      singleton.up
      expect(@singleton.count).to eq(1)
    end
  end
end
