class System 
  include Mongoid::Document
  store_in collection: "systems"

  field :system_id, type: Integer
  field :description, type: String, localize: true
  field :chop_version, type: String
  field :icd_version, type: String
  field :drg_version, type: String
    
  def self.current_system
    @current_system ||= System.find(system_id: DEFAULT_SYSTEM)
  end
  
  def self.current_system=(system)
    @current_system = system
  end
 
end
