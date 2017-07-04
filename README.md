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
Once the Player model was connected to the players tabe, it would be able to call Player#name and Player#name=(new_name).



UnifORM was built as a simple solution for object-relational mapping. The prime directive for this mapping has been to minimize the amount of code needed to build a real-world domain model. This is made possible by relying on a number of conventions that make it easy for Active Record to infer complex relations and structures from a minimal amount of explicit direction.



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
