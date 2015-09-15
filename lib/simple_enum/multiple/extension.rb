module SimpleEnum
  module Multiple
    module Extension
      def generate_enum_multiple_extension_for enum, accessor
        accessor.init(self) if accessor.respond_to? :init
      end
    end
  end
end

SimpleEnum.register_generator :multiple, SimpleEnum::Multiple::Extension
