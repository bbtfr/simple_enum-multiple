require 'simple_enum/multiple/accessors/multiple_accessor'
require 'simple_enum/multiple/coders/bitwise'

module SimpleEnum
  module Multiple
    module Accessors
      class BitwiseAccessor < MultipleAccessor
        def init(klass)
          source = self.source

          klass.class_eval do
            serialize source, SimpleEnum::Multiple::Coders::Bitwise
          end
        end

        def scope(collection, value)
          column = Arel::Nodes::Group.new(collection.arel_table[source]).to_sql
          collection.where("#{column} >> ? & 1 = 1", value)
        end
      end
    end
  end
end
