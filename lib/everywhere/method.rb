require 'everywhere/util'

module ActiveRecord
  class Base
    class << self
      delegate :where_not, :where_like, :to => :scoped
    end
  end

  module QueryMethods
    include Everywhere::Util

    def where_not(opts, *rest)
      return self if opts.blank?

      relation = clone
      relation.where_values += build_where(opts, rest).map {|r| negate r}
      relation
    end

    def where_like(opts, *rest)
      return self if opts.blank?

      relation = clone
      relation.where_values += build_where(opts, rest).map {|r| Arel::Nodes::Matches.new r.left, r.right}
      relation
    end
  end
end
