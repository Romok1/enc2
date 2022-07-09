class BaseSerializer
  attr_reader :data

  def self.serialize(data)
    new(data).serialize
  end

  def initialize(data)
    @data = data
  end

  def serialize
    raise NotImplementedError
  end
end
