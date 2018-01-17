require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'

class AssocOptions
  attr_accessor :foreign_key, :class_name, :primary_key

  def model_class
    self.table_name.singularize.capitalize.constantize
  end

  def table_name
    self.class_name.downcase + "s"
  end
end

class BelongsToOptions < AssocOptions

  def initialize(name, options = {})
    default = {
      class_name: name.to_s.capitalize,
      primary_key: :id,
      foreign_key: (name.to_s + "_id").to_sym
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
    default = {
      class_name: name.dup.to_s.singularize.capitalize,
      primary_key: :id,
      foreign_key: (self_class_name.to_s.downcase + "_id").to_sym
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

  def belongs_to(name, options = {})
    op = BelongsToOptions.new(name, options)
    self.assoc_options[name] = op
    define_method(name.to_s) do
      name.to_s.capitalize.constantize.where(
        id: self.send(op.foreign_key)
      )[0]
    end
  end

  def has_many(name, options = {})
    op = HasManyOptions.new(name.to_s, self.name, options)
    self.assoc_options[name] = op
    new_name = name.to_s.dup.reverse.delete("s").reverse
    define_method(name.to_s) do
      new_name.capitalize.constantize.where(
        op.foreign_key => self.send(op.primary_key)
      )
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
















#
