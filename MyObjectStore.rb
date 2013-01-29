module MyObjectStore
	
	Object_array = []
	
	module MyClassMethods
		def create_methods *args
			args.flatten!.each_index { |i| args[i] = args[i].to_s.delete('@') }
			args.each do |arg|
		    instance_eval %{ 
		    	def find_by_#{arg}(search_for)
		        temp = []
		        Object_array.each { |obj| temp<< obj if obj.#{arg} == search_for }
		        temp 
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
		begin
		  if validate then Object_array << self 
		  else puts "Invalid Entry for #{self.inspect}"
		  end
		rescue
			puts "No Validation done for #{self.inspect}"
			Object_array << self
		end
		self.class.create_methods( self.instance_variables ) if Object_array.length == 1
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
p1.age = 14
p1.fname = "Manish"
p1.email = "manish.kangia@vinsol.com"
p1.save

p2 = Play.new
p2.age = 18
p2.fname = "Manish"
p2.email = "ashish.sharma@vinsol.com"
p2.save

puts "Currently there are #{Play.count} objects"

puts "Enter the name to find objects with that as their attribute name value"
puts Play.find_by_fname(gets.chomp.capitalize)