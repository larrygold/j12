require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'google_drive'
require 'json'
require 'csv'
require 'dotenv'


#Ce fichier récupère les emails des mairies, et les stocke dans un Google Drive

def get_the_email_of_a_townhal_from_its_webpage(url)

page = Nokogiri::HTML(open(url))

page.css("table.table:nth-child(1) > tbody:nth-child(3) > tr:nth-child(4) > td:nth-child(2)").text

end



#On récupère les emails de toutes les mairies d'un département à partir d'une page dont l'adresse est url_department, un paramètre de cette méthode

def get_all_the_urls_of_all_townhalls(url_department)


    page = Nokogiri::HTML(open(url_department))

    links = page.css('a.lientxt')
    puts links
    array_of_hashes = Array.new

    j = 0

    links.each do |i|
      page_url = i['href']
      department = page_url[2] + page_url[3]
      puts department
      page_url[0] = ""
      url = "http://annuaire-des-mairies.com" + page_url
      nom_ville = i.text

      puts url

      url_hash = Hash.new
      url_hash[:name] = nom_ville
      url_hash[:department] = department

      begin
        url_hash[:email] = get_the_email_of_a_townhal_from_its_webpage(url)
      rescue OpenURI::HTTPError => e
        url_hash[:email] = "unknown"
      end

      array_of_hashes[j] = url_hash

      j +=1

    end

return array_of_hashes

end



#On fait appel à la méthode get_all_the_urls_of_all_townhalls, avec la liste des URL des pages des départements, puis on enregistre la ville/email/département dans un Google Drive. Pensez bien à nous demander le fichier config.json sur Slack, car il n'est pas publié sur Github par sécurité.

def drive

url_all_departments = ["http://www.annuaire-des-mairies.com/vendee.html", "http://www.annuaire-des-mairies.com/bas-rhin.html", "http://www.annuaire-des-mairies.com/bas-rhin-2.html", "http://www.annuaire-des-mairies.com/cotes-d-armor.html", "http://www.annuaire-des-mairies.com/cotes-d-armor-2.html"]

session = GoogleDrive::Session.from_config("config.json")


ws = session.spreadsheet_by_key("1Z_MDkn11Lym6HJpoGzmLp1aeGJmso2V0dpOkFkAHBuc").worksheets[0]

ws[1, 1] = "Ville"
ws[1, 2] = "Email"
ws[1, 3] = "Département"

row_nb = 2

url_all_departments.each do |url_of_a_department|

list = get_all_the_urls_of_all_townhalls(url_of_a_department)


nb_emails = list.length

arr_index = 0

(row_nb..row_nb+nb_emails-1).each do |row|
    puts row
    ws[row, 1] = list[arr_index][:name]
    puts ws[row, 1]
    ws[row, 2] = list[arr_index][:email]
    puts ws[row, 2]
    ws[row, 3] = list[arr_index][:department]
    puts ws[row, 2]
    arr_index += 1
    end

retry_attempts = 0
begin
ws.save
rescue StandardError => e
  retry_attempts += 1
  puts "Error: retrying #{retry_attempts} time(s) to load the code"
  if retry_attempts < 10
    retry
  else puts "We retried 10 times, it didn't work out. Life sucks!"
  end
end

row_nb += nb_emails

end



end




drive
