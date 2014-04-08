require 'mechanize'
require 'scraperwiki'

# XML feed of the applications submitted in the last 14 days
base_url = "http://eservices2.warringah.nsw.gov.au/ePlanning/Public/XC.Track"
url = base_url + "/SearchApplication.aspx?o=xml&d=last14days"

agent = Mechanize.new
page = Nokogiri::XML(agent.get(url).body)

page.search("Application").each do |app|
  record = {
    "council_reference" => app.at('ReferenceNumber').inner_text,
    "date_received" => Date.parse(app.at('LodgementDate').inner_text).to_s,
  }
  record["info_url"] =  base_url + "/SearchApplication.aspx?id=" + record["council_reference"]
  record["comment_url"] = base_url + "/Submission.aspx?id=" + record['council_reference']
  # Only use the first address
  if app.at('Address')
    record["address"] = app.at('Address Line1').inner_text + ", " + app.at('Address Line2').inner_text
  end
  # Some DAs have good descriptions whilst others just have
  # "<insert here>" so we search for "<insert" and if it's there we
  # use another more basic description
  if app.at('ApplicationDetails').nil? || app.at('ApplicationDetails').inner_text.downcase.index(/(<|\()insert/)
    record["description"] = app.at('NatureOfApplication').inner_text
  else
    record["description"] = app.at('ApplicationDetails').inner_text
  end
  #p record
  if (ScraperWiki.select("* from data where `council_reference`='#{record['council_reference']}'").empty? rescue true)
  ScraperWiki.save_sqlite(['council_reference'], record)
  else
  puts "Skipping already saved record " + record['council_reference']
  end
end
