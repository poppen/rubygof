#
# The GoF Builder pattern
# written by Matthieu Tanguay-Carel
#
# The Director class declares the creation process.
# The Builder classes are the concrete builders.
# The builders are free to implement a method or not, and can be
# customised at will by the client.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

class Director
    def initialize
        @process = [:create_header, :create_body, :create_footer]
    end
    def build builder
        @process.inject("") {|acc, method|
            acc += builder.send method if builder.respond_to? method
            acc
        }
    end
end

class HTMLBuilder
    def initialize title
        @title = title
    end

    def create_header
        "<html><title>#{@title}</title>"
    end

    def create_body
        "<body>fig leave</body>"
    end

    def create_footer
        "</html>"
    end
end

class XMLBuilder
    def create_header
        "<?xml version='1.0' charset='utf-8'?>"
    end

    def create_body
        "<root>welcome</root>"
    end
end

if __FILE__ == $0
    director = Director.new
    html_builder = HTMLBuilder.new 'xml sucks'
    puts director.build(html_builder)

    xml_builder = XMLBuilder.new
    puts director.build(xml_builder)
end
