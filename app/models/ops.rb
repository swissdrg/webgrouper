class OPS < ActiveRecord::Base

  default_scope lambda{where(:OpFKSyID => 9)}

  def self.table_name
    "ops"
  end

end
