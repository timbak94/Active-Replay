class AttrAccessorObject

  def self.my_attr_accessor(*names)
    
    
    
    names.each do |ivar|
      method_name = ivar.to_s
      setter = method_name + "="
    
    
      define_method(method_name) do 
    
        self.instance_variable_get("@#{method_name}")
      end 
    
      define_method("#{setter}") do |arg|
        self.instance_variable_set("@#{method_name}", arg)
      end 
    
    end 
    
  
     
  end 
end
