#!/usr/bin/env ruby

require_relative 'adapter2'

describe Manager do
  before do
    @manager = Manager.new
  end

  it { expect{@manager.payment_hour}.to raise_error(NoMethodError) }
  it { expect{@manager.work_hours}.to raise_error(NoMethodError) }

  describe '#salaly' do
    it 'returns 250' do
      expect(@manager.salaly).to eq(250)
    end
  end
end

describe ManagerAdapter do
  before do
    manager = Manager.new
    @adapter = ManagerAdapter.new(manager)
  end

  describe '#payment_hour' do
    it 'returns 250' do
      expect(@adapter.payment_hour).to eq(250)
    end
  end

  describe '#work_hours' do
    it 'returns 1' do
      expect(@adapter.work_hours).to eq(1)
    end
  end
end

describe SalaryCalculation do
  before do
    @calc = SalaryCalculation.new
  end

  describe '#get_saraly' do
    it 'returns 160' do
      expect( @calc.get_saraly(Employee.new) ).to eq(160)
    end

    it 'returns 250' do
      manager = ManagerAdapter.new( Manager.new )
      expect( @calc.get_saraly(manager) ).to eq(250)
    end
  end
end
