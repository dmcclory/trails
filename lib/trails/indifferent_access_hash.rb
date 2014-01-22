class IndifferentAccessHash < Hash

  def [](key)
    super(key) || super(key.to_s)
  end
end
