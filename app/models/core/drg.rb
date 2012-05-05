class DRG < ActiveRecord::Base
	has_many :names, :class_name => "DRGName", :foreign_key => "DnFkDrID" 
  default_scope lambda{where(:DrFKSyID => System.current_system.SyID)}
  
  def self.table_name
    "drg"
  end

end
