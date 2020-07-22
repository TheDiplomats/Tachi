#!/usr/bin/env ruby
#
# Source: http://c2.com/cgi/wiki?HexDumpInManyProgrammingLanguages

def hexdump(filename, start = 0, finish = nil, width = 16)
	ascii = ''
	counter = 0
	print('%06x ' % start)
	File.open(filename).each_byte do |c|
		if counter >= start
			print('%02x ' % c)
			ascii << (c.between?(32, 126) ? c : ?.)
			if ascii.length >= width
		puts(ascii)
		ascii = ''
		print '%06x		' % (counter + 1)
			end
		end
		throw :done if finish && finish <= counter
		counter += 1
	end rescue :done
	puts '		' * (width - ascii.length) + ascii
end

if $0 == __FILE__
	if ARGV.empty?
		hexdump $0
	else
		filename = ARGV.shift
		hexdump filename, *(ARGV.map {|arg| arg.to_i})
	end
end
