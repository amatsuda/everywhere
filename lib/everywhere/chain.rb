require 'everywhere/util'

module ActiveRecord
  module ChainRelation
    module NotBuilder
      include Everywhere::Util

      def build_where(opts, other = [])
        super.map {|r| negate r}
      end
    end

    module LikeBuilder
      def build_where(opts, other = [])
        super.map {|r| Arel::Nodes::Matches.new r.left, r.right}
      end
    end

    module NotLikeBuilder
      def build_where(opts, other = [])
        super.map {|r| Arel::Nodes::DoesNotMatch.new r.left, r.right}
      end
    end

    def not(opts, *rest)
      extend(NotBuilder).where(opts, *rest).dup
    end

    def like(opts, *rest)
      extend(LikeBuilder).where(opts, *rest).dup
    end

    def not_like(opts, *rest)
      extend(NotLikeBuilder).where(opts, *rest).dup
    end
  end

  module QueryMethods
    if ActiveRecord::VERSION::STRING > '4'
      def where_with_not_and_like_and_not_like(opts = nil, *rest)
        if opts.nil?
          spawn.extend(ChainRelation)
        else
          where_without_not_and_like_and_not_like(opts, *rest)
        end
      end
    else
      def where_with_not_and_like_and_not_like(opts = nil, *rest)
        if opts.nil?
          clone.extend(ChainRelation)
        else
          where_without_not_and_like_and_not_like(opts, *rest)
        end
      end
    end
    alias_method_chain :where, :not_and_like_and_not_like
  end
end
