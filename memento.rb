#
# The GoF Memento pattern
# written by Matthieu Tanguay-Carel
#
# The Originator can save and load itself.
# The Caretaker (the main function in this case) never has to touch
# the memento objects.
#
# This implementation is a bit naive: 
#   - saves should be kept in files
#   - Marshal will not always work (singleton methods, bindings, etc..)
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

module Originator
    def saves
        @saves ||= {}
    end

    def save key
        puts "saving key #{key}"
        saves[key] = Marshal.dump self
    end

    def restore key
        puts "restoring key #{key}"
        include_state Marshal.load(saves[key])
    end

    def include_state other
        other.instance_variables.each {|var|
            instance_variable_set(var, other.instance_variable_get(var)) \
                if var != "@saves"
        }
    end
end

class Example
    include Originator
    attr_accessor :name, :color

    def initialize name, color
        @name = name
        @color = color
    end
end

if __FILE__ == $0
    ex = Example.new "Matt", "blue"
    puts "my name is #{ex.name}"
    ex.save :now
    ex.name = "John"
    puts "my name is #{ex.name}"
    ex.save :later

    ex.restore :now
    puts "my name is #{ex.name}"
    ex.restore :later
    puts "my name is #{ex.name}"
end

