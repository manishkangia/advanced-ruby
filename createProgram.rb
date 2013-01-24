class Test
end

puts "Put in the name of the program"
program_name = gets.chomp

puts "Put in the single line code"
program_code = gets.chomp

program_string = "def #{program_name}() #{program_code} end"
Test.class_eval( program_string )
t = Test.new()
t.method( program_name.to_s ).call