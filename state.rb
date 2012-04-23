#
# The GoF State pattern
#
#   Here is Maurice Codik's implementation.
#   I only added an "if __FILE__ == $0", tweaked the layout, and fixed
#   a typo.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Copyright (C) 2006 Maurice Codik - maurice.codik@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# Each call to state defines a new subclass of Connection that is stored
# in a hash.  Then, a call to transition_to instantiates one of these
# subclasses and sets it to the be the active state.  Method calls to
# Connection are delegated to the active state object via method_missing.

module StatePattern
  class UnknownStateException < Exception
  end
  
  def StatePattern.included(mod)
    mod.extend StatePattern::ClassMethods
  end
  
  module ClassMethods
    attr_reader :state_classes
    def state(state_name, &block)
      @state_classes ||= {}
      
      new_klass = Class.new(self, &block)
      new_klass.class_eval do
        alias_method :__old_init, :initialize
        def initialize(context, *args, &block)
          @context = context
          __old_init(*args, &block)
        end
      end
      
      @state_classes[state_name] = new_klass
    end
  end
  
  attr_accessor :current_state, :current_state_obj
  
  def transition_to(state_name, *args, &block)
    new_context = @context || self
    
    klass = new_context.class.state_classes[state_name]
    if klass
      new_context.current_state = state_name
      new_context.current_state_obj = klass.new(new_context, *args, &block)
    else
      raise UnknownStateException, "tried to transition to " + \
        "unknown state, #{state_name}"      
    end
  end
  
  def method_missing(method, *args, &block)
    unless @current_state_obj
      transition_to :initial
    end
    if @current_state_obj
      @current_state_obj.send(method, *args, &block)
    else
      super
    end
  end
  
end

class Connection
  include StatePattern
  state :initial do # you always need a state named initial
    def connect
      puts "connected"
      # move to state :connected. all other args to transition_to 
      # are passed to the new state's constructor
      transition_to :connected, "hello from initial state" 
    end
    def disconnect
      puts "not connected yet"
    end
  end
  state :connected do
    def initialize(msg)
      puts "initialize got msg: #{msg}"
    end
    def connect
      puts "already connected"
    end
    def disconnect
      puts "disconnecting"
      transition_to :initial
    end
  end
  def reset
    puts "resetting outside a state"
    # you can also change the state from outside of the state objects
    transition_to :initial
  end
end

if __FILE__ == $0
    c = Connection.new
    c.disconnect # not connected yet
    c.connect    # connected
                 # initialize got msg: hello from initial state
    c.connect    # already connected
    c.disconnect # disconnecting
    c.connect    # connected
                 # initialize got msg: hello from initial state
    c.reset      # reseting outside a state
    c.disconnect # not connected yet
end

