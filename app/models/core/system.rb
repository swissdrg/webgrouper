class System < Mongoid::Document
  store_in collection: "systems"

  field :system_id, type: Integer
  field :description, type: String, localize: true
  field :chop_version, type: String
  field :icd_version, type: String
  field :drg_version, type: String
  
  
  default_scope lambda{where(:system_id => current_system())}

  
  def self.current_system
    @current_system ||= System.find_by_SyID(DEFAULT_SYSTEM)
  end
  
end
