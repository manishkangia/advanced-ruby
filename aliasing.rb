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
        alias_method :original_method, :#{func_name}
        
        def #{func_name}_with_#{extend_with}#{ends_with}
          puts '--logging start'
          original_method
          puts "--logging end"
          puts
        end
        
        alias_method :#{func_name}, :#{func_name}_with_#{extend_with}#{ends_with}

        def #{func_name}_without_#{extend_with}#{ends_with} 
          original_method
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
  
  def greet
    puts "hello boy!"
  end

  chained_aliasing :greet, :logger
end

say = Hello.new
say.send :greet
say.send :greet_with_logger
say.send :greet_without_logger