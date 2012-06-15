require 'everywhere/util'

module ActiveRecord
  class PredicateBuilder
    if ActiveRecord::VERSION::STRING > '3.1'
      class << self
        include Everywhere::Util

        # >= 3.2.4, >= 3.1.5
        if ActiveRecord::PredicateBuilder.method(:build_from_hash).arity == -4
          def build_from_hash_with_not_and_like_and_not_like(engine, attributes, default_table, allow_table_name = true)
            attributes_with_not_and_like_and_not_like = attributes.map do |column, value|
              # {key: {not: value}}
              if value.is_a?(Hash) && (value.keys.size == 1) && value.keys.first.in?([:not, :like, :not_like])
                ["#{column}__#{value.keys.first}__", value.values.first]
              else
                [column, value]
              end
            end
            build_from_hash_without_not_and_like_and_not_like(engine, attributes_with_not_and_like_and_not_like, default_table, allow_table_name).map do |rel|
              if rel.left.name.to_s.ends_with?('__not__')
                rel.left.name = rel.left.name.to_s.sub(/__not__$/, '').to_sym
                negate rel
              elsif rel.left.name.to_s.ends_with?('__like__')
                rel.left.name = rel.left.name.to_s.sub(/__like__$/, '').to_sym
                Arel::Nodes::Matches.new rel.left, rel.right
              elsif rel.left.name.to_s.ends_with?('__not_like__')
                rel.left.name = rel.left.name.to_s.sub(/__not_like__$/, '').to_sym
                Arel::Nodes::DoesNotMatch.new rel.left, rel.right
              else
                rel
              end
            end
          end
        # < 3.2.4, < 3.1.5, >= 4.0?
        else
          def build_from_hash_with_not_and_like_and_not_like(engine, attributes, default_table)
            attributes_with_not_and_like_and_not_like = attributes.map do |column, value|
              # {key: {not: value}}
              if value.is_a?(Hash) && (value.keys.size == 1) && value.keys.first.in?([:not, :like, :not_like])
                ["#{column}__#{value.keys.first}__", value.values.first]
              else
                [column, value]
              end
            end
            build_from_hash_without_not_and_like_and_not_like(engine, attributes_with_not_and_like_and_not_like, default_table).map do |rel|
              if rel.left.name.to_s.ends_with?('__not__')
                rel.left.name = rel.left.name.to_s.sub(/__not__$/, '').to_sym
                negate rel
              elsif rel.left.name.to_s.ends_with?('__like__')
                rel.left.name = rel.left.name.to_s.sub(/__like__$/, '').to_sym
                Arel::Nodes::Matches.new rel.left, rel.right
              elsif rel.left.name.to_s.ends_with?('__not_like__')
                rel.left.name = rel.left.name.to_s.sub(/__not_like__$/, '').to_sym
                Arel::Nodes::DoesNotMatch.new rel.left, rel.right
              else
                rel
              end
            end
          end
        end
        alias_method_chain :build_from_hash, :not_and_like_and_not_like
      end
    else
      include Everywhere::Util

      # >= 3.0.13
      if ActiveRecord::PredicateBuilder.method(:build_from_hash).arity == -3
        def build_from_hash_with_not_and_like_and_not_like(attributes, default_table, allow_table_name = true)
          attributes_with_not_and_like_and_not_like = attributes.map do |column, value|
            # {key: {not: value}}
            if value.is_a?(Hash) && (value.keys.size == 1) && ((value.keys.first == :not) || (value.keys.first == :like) || (value.keys.first == :not_like))
              ["#{column}__#{value.keys.first}__", value.values.first]
            else
              [column, value]
            end
          end
          build_from_hash_without_not_and_like_and_not_like(attributes_with_not_and_like_and_not_like, default_table, allow_table_name).map do |rel|
            if rel.left.name.to_s.ends_with?('__not__')
              rel.left.name = rel.left.name.to_s.sub(/__not__$/, '').to_sym
              negate rel
            elsif rel.left.name.to_s.ends_with?('__like__')
              rel.left.name = rel.left.name.to_s.sub(/__like__$/, '').to_sym
              Arel::Nodes::Matches.new rel.left, rel.right
            elsif rel.left.name.to_s.ends_with?('__not_like__')
              rel.left.name = rel.left.name.to_s.sub(/__not_like__$/, '').to_sym
              Arel::Nodes::DoesNotMatch.new rel.left, rel.right
            else
              rel
            end
          end
        end
      # < 3.0.13
      else
        def build_from_hash_with_not_and_like_and_not_like(attributes, default_table)
          attributes_with_not_and_like_and_not_like = attributes.map do |column, value|
            # {key: {not: value}}
            if value.is_a?(Hash) && (value.keys.size == 1) && ((value.keys.first == :not) || (value.keys.first == :like) || (value.keys.first == :not_like))
              ["#{column}__#{value.keys.first}__", value.values.first]
            else
              [column, value]
            end
          end
          build_from_hash_without_not_and_like_and_not_like(attributes_with_not_and_like_and_not_like, default_table).map do |rel|
            if rel.left.name.to_s.ends_with?('__not__')
              rel.left.name = rel.left.name.to_s.sub(/__not__$/, '').to_sym
              negate rel
            elsif rel.left.name.to_s.ends_with?('__like__')
              rel.left.name = rel.left.name.to_s.sub(/__like__$/, '').to_sym
              Arel::Nodes::Matches.new rel.left, rel.right
            elsif rel.left.name.to_s.ends_with?('__not_like__')
              rel.left.name = rel.left.name.to_s.sub(/__not_like__$/, '').to_sym
              Arel::Nodes::DoesNotMatch.new rel.left, rel.right
            else
              rel
            end
          end
        end
      end
      alias_method_chain :build_from_hash, :not_and_like_and_not_like
    end
  end
end
