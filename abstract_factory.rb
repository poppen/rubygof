#
# The GoF Abstract Factory pattern
# written by Matthieu Tanguay-Carel
#
# Factories behave in effect like singletons.
# Extra functionality can be tested for with "Object#respond_to? :extra"
# if needed (See GTKFactory).
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

module MyAbstractFactory
  def create_button
    raise NotImplementedError, "You should implement this method"
  end
end

class Win95Factory
  include MyAbstractFactory
  def create_button
    puts "I'm Win95"
    "win95button"
  end
end

class MotifFactory
  include MyAbstractFactory
  def create_button
    puts "I'm Motif"
    "motifbutton"
  end
end

class GTKFactory
  include MyAbstractFactory
  def create_button
    puts "I'm GTK"
    "gtkbutton"
  end

  def extra
    puts "I'm enhanced"
  end
end

class LookAndFeelManager

  @@types2classes = {
    :motif => [MotifFactory,nil],
    :gtk   => [GTKFactory,nil],
    :win95 => [Win95Factory,nil]
  }

  def self.create type
    if !@@types2classes.include? type
      raise NotImplementedError, "I know nothing about type: #{type}"
    end
    factory_and_instance = @@types2classes[type]

    if factory_and_instance[1].nil?
      puts 'instantiating new factory'
      factory_and_instance[1] = factory_and_instance[0].new #mutex this
    else
      puts 'returning already instantiated factory'
      factory_and_instance[1]
    end
  end
end

if __FILE__ == $0
  factory = LookAndFeelManager.create [:gtk, :motif, :win95].sample
  puts factory.create_button
  factory.extra if factory.respond_to? :extra
end

