class System < ActiveRecord::Base
  def self.table_name
    "system"
  end

  def self.current_system=(system)
    @current_system = system
  end
  
  def self.current_system
    @current_system ||= System.find_by_SyID(9)
  end
  
  def self.current_system_id
    @current_system
  end
end
