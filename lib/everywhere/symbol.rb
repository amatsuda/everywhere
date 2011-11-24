require 'everywhere/util'

module ActiveRecord
  module QueryMethods
    include Everywhere::Util

    def build_where_with_not(opts, other = [])
      if opts == :not
        build_where_without_not(*other).map {|r| negate r}
      else
        build_where_without_not(opts, other)
      end
    end
    alias_method_chain :build_where, :not
  end
end
