require 'everywhere/util'

module ActiveRecord
  class PredicateBuilder
    if ActiveRecord::VERSION::STRING > '3.1'
      class << self
        include Everywhere::Util

        # >= 3.2.4, >= 3.1.5
        if ActiveRecord::PredicateBuilder.method(:build_from_hash).arity == -4
          def build_from_hash_with_not_and_like_and_not_like(engine, attributes, default_table, allow_table_name = true)
            attributes_with_not_and_like_and_not_like = {}
            attributes.each do |column, value|
              # {not: {key: value}}
              if column.in?([:not, :like, :not_like])
                value.each do |k, v|
                  attributes_with_not_and_like_and_not_like["#{k}__#{column}__"] = v
                end
              else
                attributes_with_not_and_like_and_not_like[column] = value
              end
            end
            build_from_hash_without_not_and_like_and_not_like(engine, attributes_with_not_and_like_and_not_like, default_table, allow_table_name).map do |rel|
              if rel.left.name.to_s.ends_with? '__not__'
                rel.left.name = rel.left.name.to_s.sub(/__not__$/, '').to_sym
                negate rel
              elsif rel.left.name.to_s.ends_with? '__like__'
                rel.left.name = rel.left.name.to_s.sub(/__like__$/, '').to_sym
                Arel::Nodes::Matches.new rel.left, rel.right
              elsif rel.left.name.to_s.ends_with? '__not_like__'
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
            attributes_with_not_and_like_and_not_like = {}
            attributes.each do |column, value|
              # {not: {key: value}}
              if column.in?([:not, :like, :not_like])
                value.each do |k, v|
                  attributes_with_not_and_like_and_not_like["#{k}__#{column}__"] = v
                end
              else
                attributes_with_not_and_like_and_not_like[column] = value
              end
            end
            build_from_hash_without_not_and_like_and_not_like(engine, attributes_with_not_and_like_and_not_like, default_table).map do |rel|
              if rel.left.name.to_s.ends_with? '__not__'
                rel.left.name = rel.left.name.to_s.sub(/__not__$/, '').to_sym
                negate rel
              elsif rel.left.name.to_s.ends_with? '__like__'
                rel.left.name = rel.left.name.to_s.sub(/__like__$/, '').to_sym
                Arel::Nodes::Matches.new rel.left, rel.right
              elsif rel.left.name.to_s.ends_with? '__not_like__'
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
    # 3.0
    else
      include Everywhere::Util

      # >= 3.0.13
      if ActiveRecord::PredicateBuilder.method(:build_from_hash).arity == -3
        def build_from_hash_with_not_and_like_and_not_like(attributes, default_table, allow_table_name = true)
          attributes_with_not_and_like_and_not_like = {}
          attributes.each do |column, value|
            # {not: {key: value}}
            if (column == :not) || (column == :like) || (column == :not_like)
              value.each do |k, v|
                attributes_with_not_and_like_and_not_like["#{k}__#{column}__"] = v
              end
            else
              attributes_with_not_and_like_and_not_like[column] = value
            end
          end
          build_from_hash_without_not_and_like_and_not_like(attributes_with_not_and_like_and_not_like, default_table, allow_table_name).map do |rel|
            if rel.left.name.to_s.ends_with? '__not__'
              rel.left.name = rel.left.name.to_s.sub(/__not__$/, '').to_sym
              negate rel
            elsif rel.left.name.to_s.ends_with? '__like__'
              rel.left.name = rel.left.name.to_s.sub(/__like__$/, '').to_sym
              Arel::Nodes::Matches.new rel.left, rel.right
            elsif rel.left.name.to_s.ends_with? '__not_like__'
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
          attributes_with_not_and_like_and_not_like = {}
          attributes.each do |column, value|
            # {not: {key: value}}
            if (column == :not) || (column == :like) || (column == :not_like)
              value.each do |k, v|
                attributes_with_not_and_like_and_not_like["#{k}__#{column}__"] = v
              end
            else
              attributes_with_not_and_like_and_not_like[column] = value
            end
          end
          build_from_hash_without_not_and_like_and_not_like(attributes_with_not_and_like_and_not_like, default_table).map do |rel|
            if rel.left.name.to_s.ends_with? '__not__'
              rel.left.name = rel.left.name.to_s.sub(/__not__$/, '').to_sym
              negate rel
            elsif rel.left.name.to_s.ends_with? '__like__'
              rel.left.name = rel.left.name.to_s.sub(/__like__$/, '').to_sym
              Arel::Nodes::Matches.new rel.left, rel.right
            elsif rel.left.name.to_s.ends_with? '__not_like__'
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
