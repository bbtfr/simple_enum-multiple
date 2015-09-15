# SimpleEnum::Multiple

SimpleEnum::Multiple is extension of SimpleEnum, which brings multi-select enum support to SimpleEnum.

## ActiveRecord Quick start

Add this to a model:
```ruby
as_enum :tags, [:iphone, :ipad, :macbook], accessor: :join_table
```

Then create the required posts_tags table using migrations:
```ruby
class AddTagsColumnToPost < ActiveRecord::Migration
  def change
    create_join_table :posts, :tags
  end
end
```

It will store multi-enums data in a join table, if you don't want a join table, you may use `bitwise` accessor:

```ruby
# Migration
add_column :posts, :tag_cds, :integer

# Model
as_enum :tags, [:iphone, :ipad, :macbook], accessor: :bitwise
```

It will store multi-enums data in a integer column, and if you don't want SimpleEnum::Multiple manage how you store your data, you can use `multiple` accessor:

```ruby
# Model
# serialize :tag_cds 
# serialize :tag_cds, YourOwnCoder 
as_enum :tags, [:iphone, :ipad, :macbook], accessor: :multiple
```

This accessor will not handle how the data saved in the database, so you have to use something like `serialize :tag_cds`, or implement your own [Coder](https://github.com/rails/rails/blob/master/activerecord/lib/active_record/coders/json.rb).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

