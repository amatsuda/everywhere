require 'everywhere/util'

module ActiveRecord
  class PredicateBuilder
    if ActiveRecord::VERSION::STRING > '3.1'
      class << self
        include Everywhere::Util

        def build_from_hash_with_not(engine, attributes, default_table)
          attributes_with_not = {}
          attributes.each do |column, value|
            # {not: {key: value}}
            if column.in?([:not, :like])
              value.each do |k, v|
                attributes_with_not["#{k}__#{column}__"] = v
              end
            else
              attributes_with_not[column] = value
            end
          end
          build_from_hash_without_not(engine, attributes_with_not, default_table).map do |rel|
            if rel.left.name.to_s.ends_with? '__not__'
              rel.left.name = rel.left.name.to_s.sub(/__not__$/, '').to_sym
              negate rel
            elsif rel.left.name.to_s.ends_with? '__like__'
              rel.left.name = rel.left.name.to_s.sub(/__like__$/, '').to_sym
              Arel::Nodes::Matches.new rel.left, rel.right
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
        attributes_with_not = {}
        attributes.each do |column, value|
          # {not: {key: value}}
          if (column == :not) || (column == :like)
            value.each do |k, v|
              attributes_with_not["#{k}__#{column}__"] = v
            end
          else
            attributes_with_not[column] = value
          end
        end
        build_from_hash_without_not(attributes_with_not, default_table).map do |rel|
          if rel.left.name.to_s.ends_with? '__not__'
            rel.left.name = rel.left.name.to_s.sub(/__not__$/, '').to_sym
            negate rel
          elsif rel.left.name.to_s.ends_with? '__like__'
            rel.left.name = rel.left.name.to_s.sub(/__like__$/, '').to_sym
            Arel::Nodes::Matches.new rel.left, rel.right
          else
            rel
          end
        end
      end
      alias_method_chain :build_from_hash, :not
    end
  end
end
