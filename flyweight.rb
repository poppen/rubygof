#
# The GoF Flyweight pattern
# written by Matthieu Tanguay-Carel
#
# The Glyph instances are the flyweights.
# Each glyph knows how to draw itself, given the context.
# You can supply a block to Glyp#draw to draw something else than
# the glyph itself.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

class Glyph
    attr_accessor :char
    def initialize char
        puts "initializing with #{char}"
        @char = char
    end

    def draw context #hash expecting :color and :size and :x and :y as keys
        inner_html = block_given?? yield(@char) : @char
        "<span style='color:#{context[:color]}; font-size:#{context[:size]};\
        position:absolute; top: #{context[:y]}px; " + \
        " left: #{context[:x]}px'>#{inner_html}</span>"
    end
end

class FlyweightFactory
    def initialize
        @flyweights = {}
    end

    def get charsym
        return @flyweights[charsym] if @flyweights.include? charsym
        @flyweights[charsym] = Glyph.new charsym
    end
end

if __FILE__ == $0
    #a few tests
    factory = FlyweightFactory.new
    a = factory.get :a
    a2 = factory.get :a
    puts "Flyweights are the same object: #{a.eql?(a2)}"
    b = factory.get :b
    b2 = factory.get :b
    puts "Flyweights are the same object: #{b.eql?(b2)}"

    #draw a rectangle containing letters in random contexts
    File.open('test.html','w') {|file|
        file.write "<div style='width:800px; height:600px; " + \
            "border:1px #ccc solid; background-color:#efefff;'"
        colors = ['red', 'blue', 'grey']
        sizes = ['24pt', '8pt', '14pt']
        context = {}
        syms = [:a, :b, :b, :b, :c, :d, :e, :e, :f, :d, :e, :e, :f]
        syms.each {|s|
            index = rand 3
            index2 = rand 3
            x = rand 800
            y = rand 600
            context[:color] = colors[index]
            context[:size] = sizes[index2]
            context[:x] = x
            context[:y] = y
            file.write factory.get(s).draw(context) {|char|
                "#{char}?!"
            }
        }
    }
end
