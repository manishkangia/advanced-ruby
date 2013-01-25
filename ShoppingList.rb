class ShoppingList
  attr_accessor :list
  def initialize
    @list = Hash.new(0)
  end
  def items( &block )
    self.instance_eval( &block )
  end
  def add(name, qty)
    @list[name] += qty
  end
  def display
    @list.each_pair { |name, qty| puts "Name : #{name}".ljust(20) + "Quantity : #{qty}".ljust(10) }
  end
end

s1 = ShoppingList.new
s1.items do
  add("Toothpaste", 2)
  add("Toothpaste",3)
  add("Computer",1)
end
s1.display