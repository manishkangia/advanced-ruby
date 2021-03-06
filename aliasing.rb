module AliasModule
  def chained_aliasing( func_name, extend_with )
    ends_with = (/[?=!]$/).match( func_name ) 
    
    if self.public_instance_methods.include?(func_name) then scope = :public
    elsif self.protected_instance_methods.include?(func_name) then scope = :protected
    else scope = :private
    end
    
    func_name_without_end = func_name.to_s.delete(ends_with.to_s).to_sym if ends_with
    
    puts "scope of function is : #{scope}"
    class_eval %{
      #{scope}
      alias_method :original_method, :#{func_name}
      
      def #{func_name_without_end}_with_#{extend_with}#{ends_with}
        puts '--logging start'
        original_method
        puts "--logging end"
        puts
      end
      
      alias_method :#{func_name}, :#{func_name_without_end}_with_#{extend_with}#{ends_with}

      def #{func_name_without_end}_without_#{extend_with}#{ends_with} 
        original_method
      end
    }
  end
end

class Hello
  
  extend AliasModule
  
  protected
  
  def greet!
    puts "hello boy!"
  end

  chained_aliasing :greet!, :logger
end

say = Hello.new
say.send :greet!
say.send :greet_with_logger!
say.send :greet_without_logger!