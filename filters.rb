module MyModule
  module FilterModule
    @@before_methods, @@after_methods, @@methods_for_before, @@methods_for_after = [],[],[],[]
    METHODS_HASH = {}

    def before_filter(*method_names)
      @@methods_for_before, @@before_methods = categorize_methods(method_names)
    end
    
    def after_filter(*method_names)
      @@methods_for_after, @@after_methods = categorize_methods(method_names)
    end

    def categorize_methods(method_names)
      on_methods = self.public_instance_methods(false)
      on_methods.each { |v| METHODS_HASH[v] = self.instance_method(v) }
      apply_methods = []
      method_names.each do |method|
        if method.class == Hash
          on_methods = method.values_at(:only).flatten if method.has_key?(:only) 
          on_methods -= method.values_at(:except).flatten if method.has_key?(:except)
        else 
          apply_methods << method
        end
      end
      return on_methods, apply_methods
    end

    def apply_filter 
      @@methods_for_before -= ( @@after_methods )
      @@methods_for_after -= ( @@before_methods )
      @@methods_for_before.each do |method|
        original_method = instance_method(method)
        define_method(method) do
          (@@before_methods - [method]).each { |meth| METHODS_HASH[meth].bind(self).call }
          original_method.bind(self).call
        end
      end

      @@methods_for_after.each do |method|
        original_method = instance_method(method)
        define_method(method) do
          original_method.bind(self).call
          (@@after_methods - [method]).each { |meth| METHODS_HASH[meth].bind(self).call }
        end
      end

    end

    def new
      apply_filter
      super
    end  
  end

  def self.included(cls)
    cls.extend FilterModule
  end

end

class Filter
  include MyModule
#   def say_hi
#     puts "hey! i was called for the beginning!!"
#   end
  
#   def say_bye
#     puts  "hey!! i was called when method exited"
#   end
  
#   def say_hellow
#     puts "Hellow!!i need check for both begin and start"
#   end
  
#   def say_miaow
#     puts "Miaow!! i need only beginning check"
#   end
  
#   before_filter :say_hi, :only => [:say_miaow, :say_hellow]
#   after_filter :say_bye, :except => [:say_miaow]
#   apply_filter

# end

# f = Filter.new
# f.say_hellow
# puts 
# f.say_miaow
  def greet
    puts "in greet"
  end
  def foo
    puts "in foo"
  end
  def hello
    puts "in hello"
  end
  def bar
    puts "in bar"
  end
  def see
    puts "in see" 
  end
  def me
    puts "in me"
  end
  def see_me
    puts "in see_me"
  end
  before_filter :greet,:foo,:except=>[:me]
  after_filter :bar,:hello,:only=>[:see_me]
end

f = Filter.new
f.greet
puts 
f.see_me

