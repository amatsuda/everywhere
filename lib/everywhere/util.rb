module Everywhere
  module Util
    private
    def negate(rel)
      case rel.class.name
      when 'Arel::Nodes::Equality'
        Arel::Nodes::NotEqual.new rel.left, rel.right
      when 'Arel::Nodes::In'
        Arel::Nodes::NotIn.new rel.left, rel.right
      else
        rel.not
      end
    end
  end
end
