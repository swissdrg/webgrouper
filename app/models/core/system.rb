class System 
  include Mongoid::Document

  field :system_id, type: Integer
  field :description, type: String, localize: true
  field :chop_version, type: String
  field :icd_version, type: String
  field :drg_version, type: String
  field :manual_url, type: String
  field :public, type: Boolean
  
  index "system_id" => 1

  def self.all_public
    self.where(:public => true)
  end

  def self.exists?(id)
    self.where(:system_id => id).exists?
  end

end
