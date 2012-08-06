class Batchgrouper
  attr_accessor :file, :system_id, :house
  
  def initialize(attributes = {})
    self.system_id = DEFAULT_SYSTEM
  end
  
  def persisted?
    false
  end
end