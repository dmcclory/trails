class IndifferentAccessHash < Hash

  def self.build_from_hash(env)
    ia_hash = new
    env.each do |key, value|
      ia_hash[key] = value
    end
    ia_hash
  end

  def [](key)
    super(key) || super(key.to_s)
  end
end
