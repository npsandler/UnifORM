Uniform - Object-relational mapping in Rails


UnifORM is a project which connects classes to relational database tables to establish a straightforward persistence layer for applications. The library provides a base class which allows users to map between subclasses and existing tables in the database. These classes can also be connected to other models via associations.









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
