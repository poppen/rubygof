# -*- encoding: utf-8 -*-
# vim: set filetype=ruby expandtab tabstop=4 shiftwidth=4 autoindent smartindent:

class Display
  def draw(data)
    puts data
  end
end

class Draw
  def initialize(display)
    @bridge = display
  end

  def draw(data)
    @bridge.draw(data)
  end
end

class MultiDraw < Draw
  def draw(data, int=5)
    int.times.each do |i|
      super("#{i+1}. data")
    end
  end
end

if __FILE__ == $0
  puts "Draw with Display:"
  obj = Draw.new(Display.new)
  obj.draw("foo")

  puts

  puts "MultiDraw with Display:"
  obj = MultiDraw.new(Display.new)
  obj.draw("foo")
end
