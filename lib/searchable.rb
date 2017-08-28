require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    keys = params.keys.map { |key| "#{key} = ?" }.join(' AND ')
    vals = params.values
    result = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{keys}
    SQL
    result.map { |hash| self.new(hash) }
  end
end
