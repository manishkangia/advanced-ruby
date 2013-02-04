module MyObjectStore
  
  Object_array = []
    
  module MyClassMethods
    
    def attr_accessor(*args)
      args.each { |arg| super( arg ) }
      create_methods(args)
    end

    def create_methods(args)
      args.each do |arg|
        instance_eval %{ 
          def find_by_#{arg}(search_for)
            Object_array.select { |obj| obj.#{arg} == search_for }
          end
        }
      end
    end
    
    def count
      Object_array.length
    end
  end

  def self.included(cls)
    cls.extend MyClassMethods
  end
  
  def save
    if validate then Object_array << self 
    else puts "Invalid Entry for #{self.inspect}"
    end
  end

end

class Play
  
  include MyObjectStore

  attr_accessor :age, :fname, :email

  def validate
    @age && @age > 15 && @fname && @email
  end

end

p1 = Play.new
# p1.age = 14
p1.fname = "Manish"
p1.email = "manish.kangia@vinsol.com"
p1.save

p2 = Play.new
p2.age = 18
p2.fname = "Manish"
p2.email = "ashish.sharma@vinsol.com"
p2.save

puts "Currently there are #{Play.count} object(s)"

puts "Enter the name to find objects with that as their attribute age value"
result = Play.find_by_age(gets.chomp.to_i)

if result.empty? then puts "no match"
else puts result
end