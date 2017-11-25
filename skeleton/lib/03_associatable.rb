require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    
  end

  def table_name

  end
end

class BelongsToOptions < AssocOptions
  
  def initialize(name, options = {})
    default = {
      :class_name => name.to_s.capitalize, 
      :primary_key => :id,
      :foreign_key => (name.to_s + "_id").to_sym
     }
    unless options.empty?
      default.merge!(options)
    end 
    @foreign_key = default[:foreign_key]
    @class_name = default[:class_name]
    @primary_key = default[:primary_key]
  end
end

class HasManyOptions < AssocOptions
  
  def initialize(name, self_class_name, options = {})
    class_maker = name.dup.reverse.delete("s").reverse
    default = {
      :class_name => class_maker.to_s.capitalize, 
      :primary_key => :id,
      :foreign_key => (self_class_name.to_s.downcase + "_id").to_sym
     }
    unless options.empty?
      default.merge!(options)
    end 
    @foreign_key = default[:foreign_key]
    @class_name = default[:class_name]
    @primary_key = default[:primary_key]
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    op = BelongsToOptions.new(name, options)
  
    define_method(name.to_s) do 
      name.to_s.capitalize.constantize.where(id: self.send(op.foreign_key) ).first

    end 
  end
# self.send(babadeboop.foreign_key)
  def has_many(name, options = {})
    op = HasManyOptions.new(name.to_s, self.class.name, options = {})
    new_name = name.to_s.dup.reverse.delete("s").reverse
    define_method(name.to_s) do 
      new_name.capitalize.constantize.where(op.primary_key => self.send(op.primary_key) )
    end 
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
end












