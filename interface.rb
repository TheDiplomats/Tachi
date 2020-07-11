#!usr/bin/env ruby
# Developed by King Sabri | Extended by Surfs Up

require 'readline'

# Prevent Ctrl+C for exiting
trap('INT', 'SIG_IGN')

# List of commands
CMDS = %w[help tachi ls pwd exit].sort

# TODO: handle ls in powershell on windows

class String
  def colorize(text, color_code)
    "#{color_code}#{text}\e[0m"
end

  def red
    colorize(self, "\e[1m\e[31m")
end

  def green
    colorize(self, "\e[1m\e[32m")
end

  def dark_green
    colorize(self, "\e[32m")
end

  def yellow
    colorize(self, "\e[1m\e[33m")
end

  def blue
    colorize(self, "\e[1m\e[34m")
end

  def dark_blue
    colorize(self, "\e[34m")
end

  def purple
    colorize(self, "\e[35m")
end

  def dark_purple
    colorize(self, "\e[1;35m")
end

  def cyan
    colorize(self, "\e[1;36m")
end

  def dark_cyan
    colorize(self, "\e[36m")
end

  def pure
    colorize(self, "\e[0m\e[28m")
end

  def bold
    colorize(self, "\e[1m")
end

  # For moving cursor in terminal
  def mv_up(n = 1)
    cursor(self, "\033[#{n}A")
  end

  def mv_down(n = 1)
    cursor(self, "\033[#{n}B")
  end

  def mv_fw(n = 1)
    cursor(self, "\033[#{n}C")
  end

  def mv_bw(n = 1)
    cursor(self, "\033[#{n}D")
  end

  def cls_upline
    cursor(self, "\e[K")
  end

  def cls
    # cursor(self, "\033[2J")
    cursor(self, "\e[H\e[2J")
  end

  def save_position
    cursor(self, "\033[s")
  end

  def restore_position
    cursor(self, "\033[u")
  end

  def cursor(text, position)
    "\r#{position}#{text}"
  end
 end

completion =
  proc do |str|
    if Readline.line_buffer =~ /help.*/i
      puts "Available commands:\n".green + "\n" + CMDS.join("\n").to_s.green
    elsif Readline.line_buffer =~ /tachi.*/i
      puts 'Tachi, weaponized ruby for the discriminating operative.'.red
    elsif Readline.line_buffer =~ /ls.*/i
      puts `ls`
    elsif Readline.line_buffer =~ /pwd.*/i
      puts `pwd`
    elsif Readline.line_buffer =~ /exit.*/i
      puts 'Exiting...'.cyan
      exit 0
    else
      CMDS.grep(/^#{Regexp.escape(str)}/i) unless str.nil?
     end
  end

# Interface settings
Readline.completion_proc = completion	# Set completion process
Readline.completion_append_character = ' '	# Add space after completion

while line = Readline.readline('-> '.red, true)	# Start console with arrow and set add_hist = true
  puts completion.call
  break if line =~ /^quit.*/i || line =~ /^exit.*/i
end
