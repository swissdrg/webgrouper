class System < ActiveRecord::Base
  def self.table_name
    "system"
  end

  def self.current_system=(system)
    @current_system = system
  end
  
  def self.current_system
    @current_system ||= 9
  end
end
