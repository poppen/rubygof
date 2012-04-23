#
# The GoF Composite pattern
# written by Matthieu Tanguay-Carel
#
# The Component module contains the common behavior between the leaf 
# and composite. The component being a module, two classes are free to
# share the same interface without being in the same object hierarchy.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

module Component #file system entity
    attr_accessor :name
    attr_accessor :owner

    def initialize name
        @name = name
    end

    def children
        @children ||= []
    end

    def rename new_name
        @name = new_name
    end

    def to_s
        @name
    end

    def add_child *new_children
        new_children.each {|child| 
            children.push child
            puts "adding #{self} as owner of #{child}"
            child.owner = self
        }
    end
 
    def remove_child child
        children.delete child
    end
end

class MyFile
    include Component
    attr_accessor :file_type

    def initialize name, type
        @file_type = type
        super name #we need to call super whatever happens
                   #see ruby cookbook's recipe 9.8
    end
end

class MyDir
    include Component
    attr_accessor :icon

    def is_dir; true; end

    def initialize name, icon
        @icon = icon
        super name
    end
end

if __FILE__ == $0
    #setup
    root  = MyDir.new 'root', :ginger
    puts "created directory root with icon in the form of a #{root.icon}"
    music = MyDir.new 'music', :clef
    jewel = MyDir.new 'jewel', :guitar
    notes = MyFile.new 'notes', :text
    puts "created file notes whose file type is #{notes.file_type}"
    movie = MyFile.new 'ratatouille', :mpeg
    todos = MyFile.new 'todos', :text
    song  = MyFile.new 'iloveyou', :mp3

    root.add_child notes, movie, todos
    root.add_child music
    music.add_child song
    music.add_child jewel
    
    #use case 1
    puts 'prefixing all components as if they were the same type'
    def recursive_prefix prefix, component
        component.rename(prefix + component.name)
        component.children.each {|child|
            recursive_prefix prefix, child
        }
    end
    recursive_prefix 'prefixed_', root

    #use case 2
    puts "extracting all directories"
    def all_directories root
        root.children.inject([]){|acc,component|
            if component.respond_to? :is_dir
                acc << component 
                acc.push *all_directories(component)
            end
            acc
        }
    end
    all_directories(root).each {|d| puts d}

    #use case 3
    puts "going up the hierarchy"
    def get_master component
        component = component.owner while !component.owner.nil?
        component
    end
    puts get_master(song)
    puts get_master(jewel)
end

