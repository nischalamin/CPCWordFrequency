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
# Use stdargs as way to specify which CPC class will be inputted - first put in class (i.e. H04B7) then second arg to be the group (i.e. 0413) do not add slashes
cpcclass = ARGV[0]
cpcgroup = ARGV[1]
cpcpage = Mechanize.new
#This query returns a certain number of hits paginated into 50 at a time. So, we will need to call this X hits / 50 times to get all the patents issued
query = "http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.htm&r=0&p=1&f=S&l=50&Query=CPC%2F" + cpcclass + "%2F" + cpcgroup + "&d=PTXT"

page = cpcpage.get(query)
# now scrape out the total number returned - this will be the text value of the third STRONG tag found:
numberhits = page.parser.xpath("//strong")[2].text.strip.to_i
pagestotal = (numberhits / 50).ceil
puts "Number of results: " + numberhits.to_s

# Now get the paginated tables of results. The results begin on the second TABLE tag down

pagetags = page.parser.xpath("//table")[1]
# we want to iterate through the table listing of patents for this page
patentlisting = pagetags.xpath("//tr")
patentpage = patentlisting[2]
#pagetags.each_with_index do |row, i|
  # Get the patent text link to follow - they start at TD/A/HREF number 6 - then you alter the query variable r (r for return) up to 50, for the 50ith return for that page, then go to the next page by changing the variable
  # p = 2 and so on. The page variable must increment after every 50, but the r variable keeps counting up until you hit the total number of returns
  patentnoURL =  patentpage.xpath("//td/a/@href")[6].text
  # Get just the static portions of this URL
  prefixURL = "http://patft.uspto.gov"
  uptoRURL = patentnoURL.split("&r=")[0] # 0 gives up everything up to the &r= part
  afterpURL = patentnoURL.split("&p=")[1] # 1 gives us everything after &p part. We know whats between since r and p variables are right next to each other
# Now we go through all of the hits, extract the text, and concatentate into a big file.
returnno = 1
pageno = 1
until returnno > numberhits
  # follow the link via a new Mechanize page
  patenttextURL = prefixURL + uptoRURL + "&r=" + returnno.to_s + "&p=" + pageno.to_s + afterpURL[1..-1]
### TO DO STILL IN THIS CODE
# Call the page in the patenttextURL
  #patenttext = cpcpage.get(patenttextURL)
# Scrape text of patent and output to an aggregate file - maybe best to do this with Ruby string library since theres no real structure on the returned HTML
  #body = patenttext.parser.xpath("//body").text
  #body = body.split("DETAILED DESCRIPTION")[1]
# Spit our the detailed description text to a text file that's aggregating all the patent text so far

# Increment page and result variables accordingly
  if(returnno % 50 == 0) # will be zero for multiples of 50 - this signals when we need to increment the page var
    pageno = pageno + 1
  end
  returnno = returnno + 1
end
