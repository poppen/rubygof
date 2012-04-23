#
# The GoF Adapter pattern
# written by Matthieu Tanguay-Carel
#
# The Adapter offers exactly the same interface as the adaptee, but it can
# override any method or add new ones.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

class Adaptee
    def talk
        puts "I'm Adaptee"
    end
    def whine
        puts "Stop bullying me!"
    end
end

class Adapter
    def initialize
        @adaptee = Adaptee.new
    end

    def talk #override
        puts "Let me introduce you to Adaptee!"
        @adaptee.talk
        puts "That was my adaptee"
    end

    def do_other_stuff
        puts "I'm versatile"
    end

    def method_missing method
        if @adaptee.respond_to? method
            @adaptee.send method
        else
            raise NotImplementedError, "This method is not " + \
                "available on this interface"
        end
    end
end

if __FILE__ == $0
    adapter = Adapter.new
    adapter.talk
    adapter.whine
    adapter.do_other_stuff
end
