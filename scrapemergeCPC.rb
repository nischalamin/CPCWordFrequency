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
numberhits = 0
body = ""
pagestotal = 0
numofrows = 0
numofrowsindex = 0
patnoarray = Array.new
# Use stdargs as way to specify which CPC class will be inputted - first put in class (i.e. H04B7) then second arg to be the group (i.e. 0413) do not add slashes
# H04B10 70 is a good test class to use - it only returns 143 patents
cpcclass = ARGV[0]
cpcgroup = ARGV[1]
cpcpage = Mechanize.new
#This query returns a certain number of hits paginated into 50 at a time. So, we will need to call this X hits / 50 times to get all the patents issued
queryparam = "&Query=CPC%2F" + cpcclass + "%2F" + cpcgroup
RSparam = "&RS=CPC%2F" + cpcclass + "%2F" + cpcgroup
searchjumpparam = "&Srch1=" + cpcclass + "%2F" + cpcgroup + ".CPC.&StartAt=Jump+To&StartNum="
query = "http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.htm&r=0&p=1&f=S&l=50" + queryparam + "&d=PTXT"

page = cpcpage.get(query)
# now scrape out the total number returned - this will be the text value of the third STRONG tag found:
numberhits = page.parser.xpath("//strong")[2].text.strip.to_i
pagestotal = (numberhits / 50).ceil
# puts "Number of results: " + numberhits.to_s
jumptoquery = "http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.htm&r=0&f=S&l=50&d=PTXT" + RSparam + queryparam + "&TD=" + numberhits.to_s + searchjumpparam
# Now get the paginated tables of results. The results begin on the second TABLE tag down

pagetags = page.parser.xpath("//table")[1]
# we want to iterate through the table listing of patents for this page
patentlisting = pagetags.xpath(".//tr")
j = 1

until numofrowsindex > (numberhits - 1)
  j = 1
  if numofrowsindex != 0
   page = cpcpage.get(jumptoquery+(numofrowsindex+1).to_s)
   pagetags = page.parser.xpath("//table")[1]
   patentlisting = pagetags.xpath(".//tr")
  end
  until (j > 50) || (numofrowsindex > (numberhits - 1))
    # Scrape one page at a time, get just the patent number, then the gsub is a regex to remove the commas
    patnoarray[numofrowsindex] = patentlisting[j].xpath(".//td/a")[0].text.gsub(/[\s,]/ ,"")
    #puts "patent no: " + patnoarray[numofrowsindex]
    j = j + 1
    numofrowsindex = numofrowsindex + 1
  end
end

# The patnoarray will contain a full list of all the patents under that CPC classification now.
#puts "Number of Pat No array members: " + patnoarray.count.to_s + " Which should equal the count scraped from the page: " + numberhits.to_s
# Export list (CR separated) into a text file:
File.open("patentnums.txt", "w") do |file|
  patnoarray.each { |patno| 
   file.puts patno
  }
end