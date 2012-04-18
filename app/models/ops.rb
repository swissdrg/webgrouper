class OPS < ActiveRecord::Base

  default_scope lambda{where(:OpFKSyID => System.current_system.SyID)}

  def self.table_name
    "ops"
  end

end
