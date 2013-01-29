file_name = "Persons.csv"
f = File.new( file_name )

class_name = file_name.split('.')[0]
Object.const_set(class_name, Class.new)
d = eval( class_name )

attributes = f.gets.chomp.split(',')

attributes.each { |attribute| d.class_eval("attr_accessor :#{attribute}") }

new_class_objects = []

while line = f.gets
  details = line.chomp.split(',')
  new_obj = d.new
  details.each_index { |i| new_obj.instance_variable_set("@#{attributes[i]}", details[i]) }
  new_class_objects << new_obj
end

new_class_objects.each { |obj| puts obj.inspect }