class Flash
  def initialize(req)
    @cookie = 
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, value)
    @cookie[key] = value
  end

  def store_flash
  end

  def now
  end

end
