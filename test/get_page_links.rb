#get_page_links.rb
require 'rubygems'
require 'nokogiri'   
require 'open-uri'

page_url = "http://www.unimelb.edu.au"
page = Nokogiri::HTML(open(page_url))   
links = page.css('a')
internal_links = 0

links.each { |row| 
	link_url = row['href']
	if link_url.include?("unimelb")
   		clean_str = row.text.gsub(/\s+/, " ").strip
   		if clean_str.empty?
   			image_links = row.css('img')
   			if !image_links.empty?
   				# is image link
   				#puts "--- is an image ---"
   				puts row.css('img')[0]['alt']
   				puts link_url
   			else
   				#puts "--- not an image ---"
   				#puts row
   				#puts link_url
   			end
   		else
   			# is text link
   			puts "#{clean_str}"
   			puts link_url
   		end
   		internal_links += 1
	else
		# is an external link
	end
} 

puts "Total links: #{links.length}"
puts "UoM links: #{internal_links}"
