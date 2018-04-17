require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'google_drive'
require 'json'
require 'csv'
require 'twitter'

#Ce programme follow les mairies sur Twitter

def follow_users
  session = GoogleDrive::Session.from_config("config.json")
  ws = session.spreadsheet_by_key("1Z_MDkn11Lym6HJpoGzmLp1aeGJmso2V0dpOkFkAHBuc").worksheets[0]

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "S4Slbwgfu2GDIQqKcWinjHroA"
  config.consumer_secret     = "4kBE46p43Zx1A2vp5xHVp3IIglN7SvwdUu5VaynojP177Rhh7y"
  config.access_token        = "986181539435286528-DGoX5tnMz1dJgZ26YQn9rJ3w2Mdloif"
  config.access_token_secret = "0pcNdFCVpdTz3hOGE8fRbYVujBEWJobOPRiPb8iL8GEIV"

                                  end
(2..ws.num_rows).each do |row|
client.follow(ws[row,4])
end
end

follow_users
