#
# The GoF Decorator pattern
# written by Matthieu Tanguay-Carel
#
# This pattern is made trivial by Ruby's meta methods.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

module Bordered
    attr_accessor :color
    attr_accessor :width
end

module Scrollable
    def position
        @position ||= 0
    end
    def scroll offset
        @position = position + offset
    end
end

class Widget
    attr_accessor :content
    def initialize content
        @content = content
    end
end

if __FILE__ == $0
    widget = Widget.new "flagada jones"
    widget.extend(Bordered)
    widget.color = :blue

    widget.extend(Scrollable)
    widget.scroll 3

    puts widget.kind_of?(Scrollable)
    puts widget.kind_of?(Bordered)
end
