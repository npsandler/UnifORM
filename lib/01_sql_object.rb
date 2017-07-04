require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    return @columns if @columns
    cols = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}

    SQL
    @columns = cols.first.map { |col| col.to_sym }
  end

  def self.finalize!
    self.columns.each do |column|

      define_method("#{column}") do
        attributes[column]
      end


      define_method("#{column}=") do |arg|
        attributes[column] = arg
      end

   end
  end

  def self.table_name=(table_name)
    @table_name = "#{table_name}"
  end

  def self.table_name
    if @table_name
      @table_name
    else
      @table_name = self.name.tableize
    end
  end

  def self.all
    objects = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      SQL
    self.parse_all(objects)
  end

  def self.parse_all(results)
     results.map { |hash| self.new(hash)}
  end

  def self.find(id)
    found = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL

    return nil if found.empty?

    object = self.new(found.first)
  end

  def initialize(params = {})
    params.each do |k, v|
      if self.class.columns.include?(k.to_sym)
        self.send("#{k}=", v)
      else
        raise "unknown attribute '#{k}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |column| self.send("#{column}") }
  end

  def insert
    n = self.class.columns.count
    col_names = self.class.columns.join(', ')
    q_marks = Array.new(n) { '?' }.join(', ')
    DBConnection.execute(<<-SQL, *self.attribute_values)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{q_marks})
    SQL

    DBConnection.last_insert_row_id


    self.id = DBConnection.last_insert_row_id
  end



  def update
    updates = self.class.columns.map { |column| "#{column} = ?" }.join(', ')
    DBConnection.execute(<<-SQL, *self.attribute_values)
    UPDATE
      #{self.class.table_name}
    SET
      #{updates}
    WHERE
      id = #{self.id}
    SQL
  end

  def save
    if self.class.find(id)
      update
    else
      insert
    end
  end
end
