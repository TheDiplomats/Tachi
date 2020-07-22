#!/usr/bin/ruby
# KING SABRI extended Surfs Up

require 'packetfu'

#Get interface information
ifconfig = PacketFu::Utils.ifconfig("wlan0")
ifconfig[:iface]
ifconfig[:ip_saddr]
ifconfig[:eth_saddr]

#Get MAC address of remote host
PacketFu::utils.arp("192.168.0.21", :iface => "wlan0")

#Read Pcap file
PacketFu::PcapFile.read_packets("file.pcap")

def pkts
  #$config = PacketFu::Config.new(PacketFu::Utils.whoami?(:iface=> "wlan0")).config     # set interface
  $config = PacketFu::Config.new(:iface=> "wlan0").config   # use this line instead of above if you face `whoami?': uninitialized constant PacketFu::Capture (NameError)

  #
  #--> Build TCP/IP
  #
  #- Build Ethernet header:---------------------------------------
  pkt = PacketFu::TCPPacket.new(:config => $config , :flavor => "Linux")    # IP header
  #     pkt.eth_src = "00:11:22:33:44:55"        # Ether header: Source MAC ; you can use: pkt.eth_header.eth_src
  #     pkt.eth_dst = "FF:FF:FF:FF:FF:FF"        # Ether header: Destination MAC ; you can use: pkt.eth_header.eth_dst
  pkt.eth_proto                                  # Ether header: Protocol ; you can use: pkt.eth_header.eth_proto
  #- Build IP header:---------------------------------------------
  pkt.ip_v     = 4                     # IP header: IPv4 ; you can use: pkt.ip_header.ip_v
  pkt.ip_hl    = 5                     # IP header: IP header length ; you can use: pkt.ip_header.ip_hl
  pkt.ip_tos   = 0                     # IP header: Type of service ; you can use: pkt.ip_header.ip_tos
  pkt.ip_len   = 20                    # IP header: Total Length ; you can use: pkt.ip_header.ip_len
  pkt.ip_id                            # IP header: Identification ; you can use: pkt.ip_header.ip_id
  pkt.ip_frag  = 0                     # IP header: Don't Fragment ; you can use: pkt.ip_header.ip_frag
  pkt.ip_ttl   = 115                   # IP header: TTL(64) is the default ; you can use: pkt.ip_header.ip_ttl
  pkt.ip_proto = 6                     # IP header: Protocol = tcp (6) ; you can use: pkt.ip_header.ip_proto
  pkt.ip_sum                           # IP header: Header Checksum ; you can use: pkt.ip_header.ip_sum
  pkt.ip_saddr = "2.2.2.2"             # IP header: Source IP. use $config[:ip_saddr] if you want your real IP ; you can use: pkt.ip_header.ip_saddr
  pkt.ip_daddr = "10.20.50.45"         # IP header: Destination IP ; you can use: pkt.ip_header.ip_daddr
  #- TCP header:-------------------------------------------------
  pkt.payload        = "Hacked!"       # TCP header: packet header(body)
  pkt.tcp_flags.ack  = 0               # TCP header: Acknowledgment
  pkt.tcp_flags.fin  = 0               # TCP header: Finish
  pkt.tcp_flags.psh  = 0               # TCP header: Push
  pkt.tcp_flags.rst  = 0               # TCP header: Reset
  pkt.tcp_flags.syn  = 1               # TCP header: Synchronize sequence numbers
  pkt.tcp_flags.urg  = 0               # TCP header: Urgent pointer
  pkt.tcp_ecn        = 0               # TCP header: ECHO
  pkt.tcp_win        = 8192            # TCP header: Window
  pkt.tcp_hlen       = 5               # TCP header: header length
  pkt.tcp_src        = 5555            # TCP header: Source Port (random is the default )
  pkt.tcp_dst        = 4444            # TCP header: Destination Port (make it random/range for general scanning)
  pkt.recalc                           # Recalculate/re-build whole pkt (should be at the end)
  #--> End of Build TCP/IP

  pkt_to_a = [pkt.to_s]
  return pkt_to_a
end


def scan
  pkt_array = pkts.sort_by{rand}
  puts "-" * " [-] Send Syn flag".length + "\n"  + " [-] Send Syn flag " + "\n"

  inj = PacketFu::Inject.new(:iface => $config[:iface] , :config => $config, :promisc => false)
  inj.array_to_wire(:array => pkt_array)        # Send/Inject the packet through connection

  puts " [-] Done" + "\n" + "-" * " [-] Send Syn flag".length
end

#TcpDump
capture = PacketFu::Capture.new(:iface => "wlan0", :promisc => true, :start => true)
capture.show_live

#Intusion Detection System
cap = PacketFu::Capture.new(:iface => "wlan0", :start => true, :filter => "ip")
loop do
	capture.stream.each do |pkt|
		packet = PacketFu::Packet.parse(pkt)
		puts("#{Time.now}: " + "Source IP: #{packet.ip_saddr}" + "--->" + "Destination IP: #{packet.ip_daddr}" if packet.payload =~ /hacked/i)
	end
end

#echo "Hacked" | nc -nv 192.168.0.15 4444
