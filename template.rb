#
# The GoF Template pattern
# written by Matthieu Tanguay-Carel
#
# The module Template implements the boilerplate of the algorithm.
# Some hooks are optional and some mandatory.
#
# Of course you could also just yield to a block if your template is simple.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

module Template
    #mandatory_methods = ["tagname", "content"]
    #optional_methods = ["font_size", "background_color"]
    def generate
        str = "<#{tagname}" 
        styles = ''
        styles += "font-size:#{font_size};" if respond_to? :font_size
        styles += "background-color:#{background_color};" \
            if respond_to? :background_color
        str += " style='#{styles}'" if !styles.empty?
        str += ">#{content}</#{tagname}>"
    end
end

class Body
    def tagname
        "body"
    end
    def content
        "hello"
    end
    def font_size
        "18pt"
    end
    include Template
end

if __FILE__ == $0
    b = Body.new
    puts b.generate
end

