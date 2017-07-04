Uniform - Object-relational mapping in Rails
==================

UnifORM is a project which connects classes to relational database tables to establish a straightforward persistence layer for applications. The library provides a base class which allows users to map between subclasses and existing tables in the database. These classes can also be connected to other models via associations.

Objects mapped to tables will automatically gain access to certain accessors.

```ruby
CREATE TABLE players (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  team_id INTEGER,

  FOREIGN KEY(team_id) REFERENCES team(id)
);
```
Once the Player class was connected to the players tabe, it would be able to call `Player#name` and `Player#name=(new_name)`.

Once relationships have been set up on the Class level, Users can call associations on instances including `has_many`, `belongs_to`, and `has_one_through`

```ruby
def belongs_to(name, options = {})
  self.assoc_options[name] = BelongsToOptions.new(name, options)

    define_method(name) do
      options = self.class.assoc_options[name]
      key_val = self.send(options.foreign_key)
   options
    .model_class
    .where(options.primary_key => key_val)
    .first
end
```
They can also query the database using Ruby with intuitive library methods like `.find` and `.where`

```ruby
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
```


UnifORM was built as a simple solution for object-relational mapping. The main goal for the project is to minimize the amount of code needed to build a real-world domain model.
