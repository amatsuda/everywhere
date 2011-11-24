require 'everywhere/util'

module ActiveRecord
  class PredicateBuilder
    if ActiveRecord::VERSION::STRING > '3.1'
      class << self
        include Everywhere::Util

        def build_from_hash_with_not(engine, attributes, default_table)
          attributes_with_not = attributes.map do |column, value|
            # {key: {not: value}}
            if value.is_a?(Hash) && (value.keys.size == 1) && (value.keys.first == :not)
              ["#{column}__not__", value.values.first]
            else
              [column, value]
            end
          end
          build_from_hash_without_not(engine, attributes_with_not, default_table).map do |rel|
            if rel.left.name.to_s.ends_with? '__not__'
              rel.left.name = rel.left.name.to_s.sub(/__not__$/, '').to_sym
              negate rel
            else
              rel
            end
          end
        end
        alias_method_chain :build_from_hash, :not
      end
    else
      include Everywhere::Util

      def build_from_hash_with_not(attributes, default_table)
        attributes_with_not = attributes.map do |column, value|
          # {key: {not: value}}
          if value.is_a?(Hash) && (value.keys.size == 1) && (value.keys.first == :not)
            ["#{column}__not__", value.values.first]
          else
            [column, value]
          end
        end
        build_from_hash_without_not(attributes_with_not, default_table).map do |rel|
          if rel.left.name.to_s.ends_with? '__not__'
            rel.left.name = rel.left.name.to_s.sub(/__not__$/, '').to_sym
            negate rel
          else
            rel
          end
        end
      end
      alias_method_chain :build_from_hash, :not
    end
  end
end
