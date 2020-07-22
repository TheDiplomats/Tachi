#!/usr/bin/ruby

require 'net/dns'

resolver = Net::DNS::Resolver.start('google.com').answer
mx = Net::DNS::Resolver.start("google.com", Net::DNS::MX).answer
any = Net::DNS::Resolver.start("google.com", Net::DNS::ANY).answer

#Reverse DNS Lookup
rsv = Net::DNS::Resolver.new
query = rsv.query("69.171.239.12", Net::DNS::PTR)

#Use nameserver
res = Net::DNS::Resolver.new(:namesever => "8.8.8.8")

#Update object
rvr = Net::DNS::Resolver.new
rvr.nameservers = ["8.8.4.4", "8.8.8.8"]
