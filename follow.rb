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
  config.consumer_key        = ""
  config.consumer_secret     = ""
  config.access_token        = ""
  config.access_token_secret = ""

                                  end
(2..ws.num_rows).each do |row|
client.follow(ws[row,4])
end
end

follow_users
