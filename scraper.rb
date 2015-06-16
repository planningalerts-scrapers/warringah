require 'scraperwiki'
require File.dirname(__FILE__) + '/lib_icon_rest_xml/scraper'

# XML feed of the applications submitted in the last 14 days
scrape_icon_rest_xml("http://eservices2.warringah.nsw.gov.au/ePlanning/Public/XC.Track/SearchApplication.aspx", "o=xml&d=last14days&t=DevApp")

