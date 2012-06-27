class System 
  include Mongoid::Document

  field :system_id, type: Integer
  field :description, type: String, localize: true
  field :chop_version, type: String
  field :icd_version, type: String
  field :drg_version, type: String
    
  cache = ActiveSupport::Cache::MemoryStore.new
  
  def self.current_system
    current_system = Rails.cache.read(:current_system) 
    current_system ||= System.where(system_id: DEFAULT_SYSTEM).first
  end
  
  def self.current_system=(id)
    Rails.cache.write(:current_system, System.where(system_id: id).first)
  end
 
end
