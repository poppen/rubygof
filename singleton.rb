class MySingleton
  @@obj = nil

  class << self
    def instance
      return @@obj if @@obj
      @@obj = new
    end
  end

  def count
    @count
  end

  def initialize
    @count = 0
  end

  def up
    @count += 1
  end

  private_class_method :new
end
