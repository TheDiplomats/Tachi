#!usr/bin/env ruby
# Developed by King Sabri | Extended by Surfs Up

require 'readline'

#Prevent Ctrl+C for exiting
trap('INT', 'SIG_IGN')

#List of commands
CMDS = ['help', 'tachi', 'ls', 'pwd', 'exit'].sort

completion =
	proc do |str|
		case
		when Readline.line_buffer =~ /help.*/i
	puts "Available commands:\n" + "\n" + "#{CMDS.join("\n")}"
		when Readline.line_buffer =~ /rubyfu.*/i
	puts "Tachi, weaponized ruby for the discriminating operative."
		when Readline.line_buffer =~ /ls.*/i
	puts `ls`
		when Readline.line_buffer =~ /exit.*/i
	puts "Exiting..."
	exit 0
		else
	CMDS.grep(/^#{Regexp.escape(str)}/i) unless str.nil?
		end
	end

#Interface settings
Readline.completion_proc = completion		#Set completion process
Readline.completion_append_character = ' '	#Add space after completion

while line = Readline.readline('-> ', true)	#Start console with arrow and set add_hist = true
	puts completion.call
	break if line =~ /^quit.*/i or line =~ /^exit.*/i
end
