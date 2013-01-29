person = "manish"

def person.add_surname
  "#{self} kangia"
end

# class << person
#   def add_surname
#     "#{self} kangia"
#   end
# end

puts person.add_surname

new_person = "ashish"
puts new_person.add_surname