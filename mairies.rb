require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'google_drive'
require 'json'
require 'csv'


#Ce fichier récupère les emails des mairies, et les stocke dans un Google Drive

def get_the_email_of_a_townhal_from_its_webpage(url)

page = Nokogiri::HTML(open(url))

page.css("table.table:nth-child(1) > tbody:nth-child(3) > tr:nth-child(4) > td:nth-child(2)").text

end




def get_all_the_urls_of_val_doise_townhalls


    page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))

    links = page.css('.Style20 a')

    array_of_hashes = Array.new

    j = 0

    links.each do |i|
      page_url = i['href']
      page_url[0] = ""
      url = "http://annuaire-des-mairies.com" + page_url
      nom_ville = i.text

      url_hash = Hash.new
      url_hash[:name] = nom_ville
      url_hash[:email] = get_the_email_of_a_townhal_from_its_webpage(url)
      array_of_hashes[j] = url_hash

      j +=1

    end

return array_of_hashes

end




def drive

list = get_all_the_urls_of_val_doise_townhalls

session = GoogleDrive::Session.from_config("config.json")

ws = session.spreadsheet_by_key("18t9vrvd1oxsje3o2farAidH8h7KIWqZosqizRY9LbJo").worksheets[0]


ws[1, 1] = "Ville"
ws[1, 2] = "Email"

nb_emails = get_all_the_urls_of_val_doise_townhalls.length
(2..nb_emails+1).each do |row|
    puts row
    ws[row, 1] = list[row-2][:name]
    puts ws[row, 1]
    ws[row, 2] = list[row-2][:email]
    puts ws[row, 2]

end

ws.save
ws.reload

end




def json

list = get_all_the_urls_of_val_doise_townhalls

File.open("temp.json", "w") do |f|
  f.write(list.to_json)
end

end




def csv

list = get_all_the_urls_of_val_doise_townhalls

CSV.open("test.csv", "wb") do |line|

list.each do |hash|
line << hash.values
    end

  end

end




drive
