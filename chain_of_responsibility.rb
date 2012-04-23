#
# The GoF Chain of Responsibility pattern
# written by Matthieu Tanguay-Carel
#
# Each handler needs to be added to a chain and needs to be given
# an operation.
# The handler's operation is a block that should return false if the request
# should be sent forward.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

class Array
    def element_after item
        inject(false){|acc, elem|
            return elem if acc
            elem == item ? true : false
        }
        nil
    end
end

class Chain
    def initialize
        @chain = []
    end

    def add_handler *handlers
        handlers.reverse.each {|h|
            @chain << h
            h.chain = self
        }
    end

    def forward caller, request
        next_soul = @chain.element_after caller
        raise Exception.new("End of chain: caller has no forward " + \
            "neighbor available in this chain") if next_soul.nil?
        next_soul.handle request
    end
end

module Handler
    attr_accessor :chain
    def handle request
        raise Exception.new("Handler without a chain") if @chain.nil?
        raise Exception.new("Handler without an operation") if @operation.nil?
        chain.forward self, request if !@operation.call request
    end

    def operation &block
        @operation = block
    end
end

def protect
    begin
        yield
    rescue Exception
        puts $!
    end
end

if __FILE__ == $0
    @chain = Chain.new

    #create some handlers and add them to chain
    default_handler = Object.new
    default_handler.extend Handler
    default_handler.operation {|request|
        puts "Default handler: the chain of responsibility could not handle" + \
            " the request: #{request}"
    }
    
    coward = Object.new
    coward.extend Handler
    coward.operation {|request|
        puts "I'm not getting my hands dirty. Let's forward."
        false
    }

    hard_worker = Object.new
    hard_worker.extend Handler
    hard_worker.operation {|request|
        if request.respond_to? :include? and request.include? "work"
            puts "Request handled!"
            true
        else
            puts "Could not handle request... forwarding."
            false
        end
    }
    
    @chain.add_handler default_handler, hard_worker, coward

    #tests
    protect {
        puts "\nSending first test request"
        coward.handle "test"
    }
    protect { 
        puts "\nSending work request"
        coward.handle "work"
    }
    puts "\nMaking it fail"
    foreigner = Object.new
    foreigner.extend Handler
    protect { foreigner.handle "me" }
    foreigner.operation {|request| puts "Guten Tag"}
    protect { @chain.forward foreigner, "hehe" }
end

