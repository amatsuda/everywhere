require 'everywhere/util'

module ActiveRecord
  module QueryMethods
    include Everywhere::Util

    def build_where_with_not_and_like_and_not_like(opts, other = [])
      case opts
      when :not
        build_where_without_not_and_like_and_not_like(*other).map {|r| negate r}
      when :like
        build_where_without_not_and_like_and_not_like(*other).map {|r| Arel::Nodes::Matches.new r.left, r.right}
      when :not_like
        build_where_without_not_and_like_and_not_like(*other).map {|r| Arel::Nodes::DoesNotMatch.new r.left, r.right}
      else
        build_where_without_not_and_like_and_not_like(opts, other)
      end
    end
    alias_method_chain :build_where, :not_and_like_and_not_like
  end
end
