# -*- encoding: utf-8 -*-
# vim: set filetype=ruby expandtab tabstop=4 shiftwidth=4 autoindent smartindent:

class BaseModel
  def display
    raise "display: Not implemented"
  end

  def grow
    raise "grow: Not implemented"
  end
end

class Node < BaseModel
  @@children = %w[Node Leaf]

  def initialize(name)
    @name = name
    @children = []
  end

  def grow(numbers, name="")
    numbers.times do |i|
      if name.empty?
        name = i.to_s
      else
        name = "#{name}_#{i}"
      end
      klass = Object.const_get(@@children.sample)
      object = klass.new("#{klass}#{name}")
      object.grow(numbers-1, name)
      @children.push object
    end
  end

  def display(indent=0)
    puts ' ' * 4 * indent + @name
    @children.each do |child|
      child.display(indent+1)
    end
  end
end

class Leaf < BaseModel
  def initialize(name)
    @name = name
  end

  def display(indent=0)
    puts ' ' * 4 * indent + @name
  end

  def grow(numbers, name)
  end
end

if $0 == __FILE__
  root = Node.new("Root")
  root.grow(Random.rand(10))
  root.display
end
