#!usr/bin/env ruby
#King Sabri | extended Surfs Up
## This can be made modular and separated does not address AV bypass ##

#Hide

file1, file2 = ARGV
sec_file = File.read file1  #This should be pdf file - file.pdf
nor_file = File.read file2	#This should be image file - image.png
sep = '*-----------------------*'
one_file = [nor_file, sep, sec_file]

#Write sec_file, sep, nor_file into steg.png
File.open("steg.png", "wb") do |stg|
	one_file.each do |f|
		stg.puts f
	end
end

#Recover

#Read steg.png to be like "one_file" array
recov_file = File.Read('steg.png').force_encoding("BINARY").split(sep).last
#Write sec_file to new.pdf
File.open('new.pdf', 'wb') {|file| file.print recov_file}s
