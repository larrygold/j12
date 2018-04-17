require 'gmail'
require 'mail'
require 'pry'
require "google_drive"

# methode pour envoyer les l'emails a partir d'un spreadsheet
def go_through_all_the_lines
# creation du fichier config.json et lien vers le spreadsheet et le fichier emails.rb
  session = GoogleDrive::Session.from_config("config.json")

#ajout du spreadsheet
  ws = session.spreadsheet_by_key("1Z_MDkn11Lym6HJpoGzmLp1aeGJmso2V0dpOkFkAHBuc").worksheets[0]

#boucle pour implementer les emails et les villes
    (2..ws.num_rows).each do |row|

      emails = ws[row,2]
      city = ws[row,1]

# identifiants de la boite d'envoi
      gmail = Gmail.connect("johndoethp@gmail.com", "thehackingproject") do |gmail|

# methode qui permet d'envoyer l'email en format HTML
          email = gmail.compose do
            to "#{emails}"
            subject "Formation informatique gratuite - #{city}"

            html_part do
              content_type 'text/html; charset=UTF-8'
              body "<p>Bonjour,</p>
              <p>Je m'appelle John, je suis élève à The Hacking Project, une formation à la programmation informatique gratuite, sans locaux, sans sélection, sans restriction géographique. La pédagogie de notre école est basée sur du peer-learning, où nous travaillons par petits groupes sur des projets concrets et responsabilisants. </p>
                <p>Pour en savoir plus sur notre formation, n'hésitez pas à contacter Charles Dacquay, co-fondateur de The Hacking Project, qui pourra répondre à toutes vos questions : <b>06.95.46.60.80</b>  </p>
                <br>
                <p>John Doe</p>"
            end
          end
          gmail.deliver(email)
        end
    end
end
go_through_all_the_lines
