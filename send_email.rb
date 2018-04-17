require 'gmail'
require 'mail'
require 'pry'

gmail = Gmail.connect("johndoethp@gmail.com", "thehackingproject") do |gmail|

puts gmail.inbox.count

email = gmail.compose do
  to "geraldy.leondas@gmail.com"
  subject "Having fun in Paris!"
  body "Spent the day on the road..."
  end

gmail.deliver(email)
end
