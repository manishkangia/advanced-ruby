module MyModule
  
  module ClassMethods
    
    def chained_aliasing( func_name, extend_with )
      ends_with = (/[?=!]$/).match( func_name ) 
      existing_func_name = :"#{func_name}_with_#{extend_with}#{ends_with}"
      
      if self.public_instance_methods.include?(existing_func_name) then scope = :public
      elsif self.protected_instance_methods.include?(existing_func_name) then scope = :protected
      else scope = :private
      end
      
      class_eval %{
        #{scope}
        def #{func_name}
          #{func_name}_with_#{extend_with}#{ends_with}
        end
        def #{func_name}_without_#{extend_with}#{ends_with} 
          puts "hello"
        end
      }
    end
  end

  def self.included(cls)
    cls.extend ClassMethods
  end

end

class Hello
  
  include MyModule
  
  protected
  
  def greet_with_logger
    puts '--logging start'
    greet_without_logger
    puts "--logging end"
  end

  chained_aliasing :greet, :logger
end

say = Hello.new
say.send :greet
say.send :greet_with_logger
say.send :greet_without_logger

puts "\nmethods scope reserved\nProtected methods are:"
puts say.class.protected_instance_methods