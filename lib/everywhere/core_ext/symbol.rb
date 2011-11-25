class Symbol
  def not
    {:not => self}
  end

  def like
    {:like => self}
  end
end
