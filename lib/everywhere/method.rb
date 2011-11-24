require 'everywhere/util'

module ActiveRecord
  class Base
    class << self
      delegate :where_not, :to => :scoped
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
  end
end
