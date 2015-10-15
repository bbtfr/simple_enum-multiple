module SimpleEnum
  module Multiple
    class CollectionProxy
      include Enumerable

      attr_reader :origin, :accessor

      def initialize(origin, accessor)
        @origin, @accessor = origin, accessor
      end

      def push(*keys)
        keys = accessor.filter_keys(keys)
        origin.push(*accessor.fetch_values(keys)).uniq!
        self
      end
      alias_method :<<, :push

      def delete(key)
        origin.delete(accessor.enum.value(key)) && key
      end

      def proxy
        accessor.fetch_keys(origin)
      end

      alias_method :to_a, :proxy
      delegate :inspect, :to_s, :==, :each, :join, to: :proxy

    end
  end
end
