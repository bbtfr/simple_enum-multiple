# SimpleEnum::Multiple

[![Travis](https://img.shields.io/travis/bbtfr/simple_enum-multiple.svg)](https://travis-ci.org/bbtfr/simple_enum-multiple) 
[![Gem](https://img.shields.io/gem/v/simple_enum-multiple.svg)](https://rubygems.org/gems/simple_enum-multiple)

SimpleEnum::Multiple is extension of SimpleEnum, which brings multi-select enum support to SimpleEnum.

## ActiveRecord Quick start

Add this to a model:
```ruby
class User < ActiveRecord::Base
  as_enum :favorites, [:iphone, :ipad, :macbook], accessor: :join_table
end
```

Then create the required `users_favorites` table using migrations:
```ruby
class AddFavoritesColumnToUser < ActiveRecord::Migration
  def change
    create_join_table :users, :favorites
  end
end
```

It will store multi-enums data in a join table, if you don't want a join table, you may use `bitwise` accessor:

```ruby
# Migration
add_column :Users, :favorite_cds, :integer

# Model
as_enum :favorites, [:iphone, :ipad, :macbook], accessor: :bitwise
```

It will store multi-enums data in a integer column, and if you don't want SimpleEnum::Multiple manage how you store your data, you can use `multiple` accessor:

```ruby
# Model
# serialize :favorite_cds 
# serialize :favorite_cds, YourOwnCoder 
as_enum :favorites, [:iphone, :ipad, :macbook], accessor: :multiple
```

This accessor will not handle how the data saved in the database, so you have to use something like `serialize :favorite_cds`, or implement your own [Coder](https://github.com/rails/rails/blob/master/activerecord/lib/active_record/coders/json.rb).


## Working with multi-select enums
```ruby
class User < ActiveRecord::Base
  as_enum :favorites, [:iphone, :ipad, :macbook], accessor: :join_table
end

jane = User.new
jane.favorites = [:iphone, :ipad]
jane.iphone?      # => true
jane.ipad?        # => true
jane.macbook?     # => false
jane.favorites    # => [:iphone, ipad]
jane.favorite_cds # => [0, 1]

joe = User.new
joe.iphone!       # => [:iphone]
joe.favorites     # => [:iphone]
joe.favorite_cds  # => [0]

User.favorites                            # => #<SimpleEnum::Enum:0x0....>
User.favorites[:iphone]                   # => [0]
User.favorites.values_at(:iphone, :ipad)  # => [0, 1]
User.iphones                              # => #<ActiveRecord::Relation:0x0.... [jane, joe]>

# You can also do this since `favorites` returns a 
# #<SimpleEnum::Multiple::CollectionProxy> rather than a #<Array>:
joe = User.new
joe.iphone!       # => [:iphone]
joe.favorites.push :ipad
joe.favorites     # => [:iphone, ipad]
joe.favorite_cds  # => [0, 1]

```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

