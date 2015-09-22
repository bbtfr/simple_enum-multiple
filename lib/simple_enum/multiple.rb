require 'simple_enum/multiple/accessors'
require 'simple_enum/multiple/collection_proxy'
require 'simple_enum/multiple/extension'
require 'simple_enum/multiple/version'

SimpleEnum.register_generator :multiple, SimpleEnum::Multiple::Extension
SimpleEnum.register_accessor :multiple, SimpleEnum::Multiple::Accessors::MultipleAccessor
SimpleEnum.register_accessor :join_table, SimpleEnum::Multiple::Accessors::JoinTableAccessor
SimpleEnum.register_accessor :bitwise, SimpleEnum::Multiple::Accessors::BitwiseAccessor
