#
# The GoF Command pattern
# written by Matthieu Tanguay-Carel
#
# The Command instance is initialized with its receiver.
# Commands can be grouped by registering children to a macro command.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

class Command
    attr_accessor :receiver
    def initialize receiver
        @receiver = receiver
        @commands = []
    end

    def register_command *command
        @commands.push *command
    end

    def execute
        @commands.each {|cmd| cmd.save }
        @commands.each {|cmd| cmd._execute }
        save
        _execute
    end

    def undo
        @commands.each {|cmd| cmd.undo }
    end

    #implement the following methods in the subclasses
    protected
    def save
    end

    def _execute
    end
end

class TextCommand < Command
    def save
        @last_state ||= Marshal.load(Marshal.dump(@receiver.text)) 
        super
    end
    def undo
        @receiver.text = @last_state
        @last_state = nil
        super
    end
end

class UppercaseCommand < TextCommand
    def _execute 
        @receiver.text.upcase!
        super
    end
end

class IndentCommand < TextCommand
    def _execute
        @receiver.text = "\t" + @receiver.text
        super
    end
end

module Invoker
    attr_accessor :command
    def click
        @command.execute
    end

    def undo
        @command.undo
    end
end

class Document
    attr_accessor :text
    def initialize text
        @text = text
    end
end

if __FILE__ == $0
    text = "This is a test"
    doc = Document.new text
    upcase_cmd = UppercaseCommand.new doc
    button = Object.new.extend(Invoker)
    button.command = upcase_cmd

    puts "before anything"
    puts doc.text
    button.click
    puts "after click"
    puts doc.text
    button.undo
    puts "after undo"
    puts doc.text

    puts "\nNow a macro command"
    allCmds = Command.new doc
    indent_cmd = IndentCommand.new doc
    allCmds.register_command upcase_cmd, indent_cmd

    big_button = Object.new.extend(Invoker)
    big_button.command = allCmds
    puts "before anything"
    puts doc.text
    big_button.click
    puts "after click"
    puts doc.text
    big_button.undo
    puts "after undo"
    puts doc.text
end
