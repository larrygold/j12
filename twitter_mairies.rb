require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'google_drive'
require 'json'
require 'csv'

#Ce programme créer une nouvelle colonne

def get_twitter_handle
  session = GoogleDrive::Session.from_config("config.json")
  ws = session.spreadsheet_by_key("1Z_MDkn11Lym6HJpoGzmLp1aeGJmso2V0dpOkFkAHBuc").worksheets[0]

  (2..ws.num_rows).each do |row|
  townhall = ws[row,1]
  townhall.gsub! ' ', '%20'
  url_origin= "https://twitter.com/search?f=users&vertical=default&q="
  url = url_origin + townhall
  page = Nokogiri::HTML(open(url))
  twitter_link = page.css('div > div > div.ProfileCard-userFields > span > a > span > b')
  twitter_link_modified = twitter_link.map{|element| element.text}
  ws[row,4] = twitter_link_modified[0]
  puts ws[row,4]

  retry_attempts = 0
  begin
  ws.save
  rescue StandardError => e
  retry_attempts +=1
      if retry_attempts < 10
        retry
      else puts "Erreure fatale"
      end
  end

   end
end

get_twitter_handle
