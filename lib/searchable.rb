require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_params = params.keys.map{ |el| el.to_s + " = ?" }.join(" AND ")
    vals = params.values
    res = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_params}
    SQL
    results = []
    res.each do |el|
      results << self.new(el)
    end
    results
  end
end

class SQLObject
  extend Searchable
end
