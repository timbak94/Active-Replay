require_relative '03_associatable'

module Associatable

  def has_one_through(name, through_name, source_name)
    through_options = self.assoc_options[through_name]
    define_method(name) do
      source_options = through_options.class_name.constantize.assoc_options[source_name]
      source_table = source_name.to_s.capitalize.constantize.table_name
      through_table = through_name.to_s.capitalize.constantize.table_name
      res = DBConnection.execute(<<-SQL, self.send(through_options.foreign_key))
        SELECT
          #{source_table + '.*'}
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{through_table}.#{source_options.foreign_key} = #{source_table}.#{source_options.primary_key}
        WHERE
          #{through_table}.#{source_options.primary_key} = ?
      SQL
      source_name.to_s.capitalize.constantize.parse_all(res).first
    end
  end

  def has_many_through(name, through_name, source_name)
    through_options = self.assoc_options[through_name]
    define_method(name) do
      source_options = through_options.class_name.constantize.assoc_options[source_name]
      source_table = source_name.to_s.singularize.capitalize.constantize.table_name
      through_table = through_name.to_s.singularize.capitalize.constantize.table_name
      res = DBConnection.execute(<<-SQL, self.send(through_options.primary_key))
        SELECT
          #{source_table + '.*'}
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{through_table}.#{source_options.primary_key} = #{source_table}.#{source_options.foreign_key}
        WHERE
          #{through_table}.#{through_options.foreign_key} = ?
      SQL
      source_name.to_s.singularize.capitalize.constantize.parse_all(res)
    end
  end
end
