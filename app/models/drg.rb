class DRG < ActiveRecord::Base

  default_scope lambda{where(:DrFKSyID => System.current_system)}
  
  def self.table_name
    "drg"
  end

end
