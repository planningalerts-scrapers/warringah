require 'scraperwiki'
require File.dirname(__FILE__) + '/lib_icon_rest_xml/scraper'

# XML feed of the applications submitted in the last 14 days
scrape_icon_rest_xml("https://eservices1.warringah.nsw.gov.au/ePlanning/live/Public/XC.Track/SearchApplication.aspx", "d=thismonth&k=LodgementDate&t=DevApp&o=xml")
