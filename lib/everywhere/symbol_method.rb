require 'everywhere/hash_value'
require 'everywhere/core_ext/symbol'

class << ActiveRecord::Base
  def expand_hash_conditions_for_aggregates_with_everywhere(attrs)
    if attrs.keys.index{|k| k.is_a?(Hash) }
      attrs = attrs.map{|k, v|
        if k.is_a?(Hash)
          (m, k) = k.first.to_a
          [k, {m => v}]
        else
          [k, v]
        end
      }
      attrs = Hash[attrs]
    end
    expand_hash_conditions_for_aggregates_without_everywhere(attrs)
  end
  alias_method_chain :expand_hash_conditions_for_aggregates, :everywhere


end
