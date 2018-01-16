require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    return @columns if @columns
    all = DBConnection.execute2("SELECT * FROM #{self.table_name}")
    @columns = all.first.map {|el| el.to_sym}
  end

  def self.finalize!
    self.columns.each do |column_name|
      define_method("#{column_name}=") do |arg|
        self.attributes[column_name] = arg
      end
      define_method("#{column_name}") do
        self.attributes[column_name]
      end
    end
  end

  def self.table_name=(table_name)
    @t_name = table_name
  end

  def self.table_name
    @t_name ||= self.name.tableize
  end

  def self.all
    res = DBConnection.execute(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    SQL
    self.parse_all(res)
  end

  def self.parse_all(results)
    results.map { |el| self.new(el) }
  end

  def self.find(id)
    res = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = ?
      LIMIT
        1
    SQL
    if res.empty?
      return nil
    end
    self.new(res.first)
  end

  def initialize(params = {})
    params.each_key do |key|
      unless self.class.columns.include?(key.to_sym)
        raise Exception.new("unknown attribute '#{key}'")
      else
        self.send("#{key}=", params[key])
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.attributes.values
  end

  def insert
    col_names = self.class.columns.dup
    question_marks = []
    (self.class.columns.length - 1).times do
      question_marks << '?'
    end
    col_names.delete(:id)
    col_names = col_names.join(",")
    question_marks = "(#{question_marks.join(',')})"
    DBConnection.execute(<<-SQL, self.attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        #{question_marks}
    SQL
    self.id = self.class.all.last.id
  end

  def update
    setter = self.class.columns.map { |el| "#{el} = ?" }.join(",")
    DBConnection.execute(<<-SQL, self.attribute_values)
      UPDATE
        #{self.class.table_name}
      SET
        #{setter}
      WHERE
        id = #{self.id}
    SQL
  end

  def save
    if self.id.nil?
      self.insert
    else
      self.update
    end
  end

end
