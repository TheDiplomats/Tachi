#!usr/bin/env ruby
# Developed by Surfs Up

#TODO Create a custom join to get the first 4 from array then join and remove first 4 items in array or create copy

class Network_String

def initailize() super initailize() end
@@regex = Hash[
'mac' => /(?:[0-9A-F][0-9A-F][:\-]){5}[0-9A-F][0-9A-F]/i,
'ipv4' => /(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/,
'ipv6' => /^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$/
]

def find_network_string(string)
	results = Array.new
    if get_network_string('ipv4', string)
      results.append(string.scan(@@regex['ipv4']).join('.'))
      return results
    elsif get_network_string('ipv6', string)
      results.append(string.scan(@@regex['ipv6']).join('.'))
      return results
    elsif get_network_string('mac', string)
      results.append(string.scan(@@regex['mac']).join(':'))
      return results
    else
	  results.append(string)
      return results
    end
end

def get_network_string(selection, search_string)
  case selection
  when 'mac'
    return !search_string.scan(@@regex['mac']).nil?
  when 'ipv4'
    return !search_string.scan(@@regex['ipv4']).nil?
  when 'ipv6'
    return !search_string.scan(@@regex['ipv6']).nil?
  else
	return false
  end
end

end

#ip = 'ads fs:ad fa:fs:fe: Wind10.0.4.5ows 11192.168.0.15dsfsad fas fa1 20.555.1.700 f2'
#mac = 'ads fs:ad fa:fs:fe: Wind00-0C-29-38-1D-61ows 1100:50:7F:E6:96:20dsfsad fas fa1 3c:77:e6:68:66:e9 f2'
#foo = 'bar'

ip = "bar 100.10.100.10 foo"
check = Network_String.new()
print check.find_network_string(ip)
#print check.find_network_string(mac)
#print check.find_network_string(foo)
