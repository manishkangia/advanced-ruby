evaluate_code = ""
until ( next_line = gets ).chomp =~ /^[q]$/i
  if( next_line.length == 1 )
    begin
      puts eval( evaluate_code )
      rescue Exception => e
        puts e.message
    end
    evaluate_code = ""
  else
    evaluate_code += next_line
  end
end