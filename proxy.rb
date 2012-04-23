#
# The GoF Proxy pattern
# written by Matthieu Tanguay-Carel
#
# The Image class is the proxy. It should override the operations
# the clients need before costly processing has to take place.
# The attr_proxy method allows the Proxy module to automatically
# remove the overridden methods once the real subject is created.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

module Proxy
    def self.included cls
        puts "creating the attr_proxy method"
        cls.instance_eval {
            def proxy_methods
                @proxy_methods ||= []
            end
            def attr_proxy name
                proxy_methods << name
            end
        }
    end

    #call this to set the proxy object
    def proxy real_cls, constructor_args
        @real_cls = real_cls
        @constructor_args = constructor_args
    end
    
    def real_subject
        @real_subject or nil
    end

    def method_missing method, *args
        if real_subject.nil?
            @real_subject = @real_cls.new *@constructor_args
            puts "instantiating real subject"
            self.class.proxy_methods.each {|proxy_meth| 
                puts "removing #{proxy_meth} from proxy"
                self.class.instance_eval {
                    remove_method proxy_meth 
                }
            }
        end
        if real_subject.respond_to? method
            real_subject.send method, *args
        else
            raise NotImplementedError, "This method (#{method}) is " + \
                "not available on this interface"
        end
    end
end

class Image
    include Proxy
    attr_accessor :mtime
    attr_proxy :mtime
    attr_proxy :mtime=
    attr_proxy :to_s

    def to_s
        "proxy_image"
    end
end

if __FILE__ == $0
    #create the proxy
    img = Image.new
    img.proxy(File, ["img.jpg", 'w'])
    img.mtime = "a few hours ago"
    puts "proxy methods:"
    img.class.proxy_methods.each {|m| puts m}
    puts ''

    #use the proxy
    puts "image's last modified time is #{img.mtime}"
    puts "image's string representation: #{img}"
    puts ''

    #force creation of the real subject
    img.write "im stuck in an image !\n"
    puts "image's last modified time is #{img.mtime}"
    puts "image's string representation: #{img}"
    puts "file written to!"
end
