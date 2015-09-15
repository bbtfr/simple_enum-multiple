require 'simple_enum/multiple/accessors/multiple_accessor'
require 'simple_enum/multiple/accessors/join_table_accessor'
require 'simple_enum/multiple/accessors/bitwise_accessor'

module SimpleEnum
  module Multiple
    module Accessors
      SimpleEnum::Accessors::ACCESSORS.merge!({
        multiple: MultipleAccessor,
        join_table: JoinTableAccessor,
        bitwise: BitwiseAccessor
      })

    end
  end
end
