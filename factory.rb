class CarFactory
  def initialze
    @car
  end

  def set_car
    raise "should be override"
  end

  def create_car
    set_car
    @car
  end
end

class BusFactory < CarFactory
  def set_car
    @car = Bus.new
  end
end

class TruckFactory < CarFactory
  def set_car
    @car = Truck.new
  end
end

class Car
end

class Bus < Car
  def to_s
    "This is a bus."
  end
end

class Truck < Car
  def to_s
    "This is a truck."
  end
end
