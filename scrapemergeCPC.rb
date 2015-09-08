#!/usr/bin/env ruby
require 'net/http'
require 'net/https'
require 'rubygems'
require 'json'
require 'date'
require 'csv'
require 'mechanize'
require 'uri'

pictureURL = ""
pid = ""
piddetailURL = ""
fulltextpara = ""
organization = ''
summary = ""
category = ""
cpcclass = ""
cpcgroup = ""
query=""
numberhits = ""
# Use stdargs as way to specify which CPC class will be inputted - first put in class (i.e. H04B7) then second arg to be the group (i.e. 0413) do not add slashes
cpcclass = ARGV[0]
cpcgroup = ARGV[1]
cpcpage = Mechanize.new
#This query returns 1157 hits paginated into 50 at a time. So, we will need to call this X hits / 50 times to get all the patents issued
query = "http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.htm&r=0&p=1&f=S&l=50&Query=CPC%2F" + cpcclass + "%2F" + cpcgroup + "&d=PTXT"

#http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=/netahtml/PTO/search-adv.htm&r=0&f=S&l=50&d=PTXT&OS=CPC/H04B7/0413&RS=CPC/H04B7/0413&Query=CPC/H04B7/0413&TD=1157&Srch1=H04B7/0413.CPC.&NextList2=Next+50+Hits

page = cpcpage.get(query)
# now scrape out the total number returned - this will be the text value of the third STRONG tag found:
numberhits = page.parser.xpath("//strong")[2].text.strip
puts "Number of results: " + numberhits

# Now get the paginated tables of results. The results begin on the second TABLE tag down

pagetags = page.parser.xpath("//table")[1]
# we want to iterate through the table listing of patents for this page
patentlisting = pagetags.xpath("//tr")
=begin
pagetags.each_with_index do |row, i|
  # Get the patent text link to follow
  patentnoURL = row.xpath("//td/a/@href")[i].text.strip
  # follow the link via a new Mechanize page
  patenttext = cpcpage.get (patentnoURL)
  # Scrape text of patent and output to an aggregate file - maybe best to do this with Ruby string library since theres no real structure on the returned HTML
  #fulltextpara = patenttext.parser.xpath("//div[@class='full-text paragraph']/p")[i].text.strip
=end
