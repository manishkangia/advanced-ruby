class Klass
  attr_accessor :var
  
  def initialize( str )
    @var = str
  end
  
  def exclude?( c )
    !@var.include?( c )
  end

  def alt_case
    temp_string = ""
    (0..@var.length-1).each { |i| temp_string[i] = i.odd? ? @var[i].upcase : @var[i].downcase  }
    temp_string
  end
end
puts "create a new object by typing in Klass.new( some_string )"
code = gets.chomp
new_obj = eval( code )

puts "Nice! Now you can call two functions on it namely, alt_case and exclude?( some_char ) by just typing in the function name"
code2 = gets.chomp 
puts new_obj.instance_eval( code2 )
puts "Thank you!\nBye"