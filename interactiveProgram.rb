evaluate_code = ""
until (next_line = gets).chomp =~ /^[q]$/i
  if next_line.length == 1
    puts eval(evaluate_code)
    evaluate_code = ""
  else
    begin
      eval(evaluate_code + next_line)
      evaluate_code += next_line
    rescue Exception => e
      puts e.message
    end
  end
end