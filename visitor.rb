#
# The GoF Visitor pattern
# written by Matthieu Tanguay-Carel
#
# Depends on Rubytree (gem install rubytree).
# The Node module contains the whole logic. A visitor can only implement
# the callbacks it is interested in.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

require 'rubygems'
require 'tree'

module Node
    def accept visitor
        if self.kind_of? StringNode
            visitor.visit_string self if visitor.respond_to? :visit_string
        elsif self.kind_of? IntegerNode
            visitor.visit_int self if visitor.respond_to? :visit_int
        end
    end
end

class StringNode
    include Node
    attr_accessor :string
    def initialize val
        @string = val
    end
end

class IntegerNode
    include Node
    attr_accessor :int
    def initialize val
        @int = val
    end
end

class PrintingVisitor
    def visit_string node
        puts node.string
    end
    def visit_int node
        puts node.int
    end
end

class RevertingVisitor
    def visit_string node
        puts node.string.reverse!
    end
end

if __FILE__ == $0
    myTreeRoot = Tree::TreeNode.new("ROOT", StringNode.new("this is the root node"))
    myTreeRoot << Tree::TreeNode.new("child1", StringNode.new("madam im adam")) \
        << Tree::TreeNode.new("grandchild1", IntegerNode.new(3)) \
        << Tree::TreeNode.new("grandchild2", IntegerNode.new(2))
    myTreeRoot << Tree::TreeNode.new("child2", StringNode.new("race car")) \
        << Tree::TreeNode.new("grandchild3", StringNode.new("damn, i agassi " + \
            "miss again. mad"))

    puts "PRINTING visitor..."
    @pvisitor = PrintingVisitor.new
    myTreeRoot.each { |node| node.content.accept @pvisitor }

    puts "\nREVERTING visitor..."
    @rvisitor = RevertingVisitor.new
    myTreeRoot.each { |node| node.content.accept @rvisitor }
end

