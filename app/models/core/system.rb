class System 
  include Mongoid::Document

  field :system_id, type: Integer
  field :description, type: String, localize: true
  field :chop_version, type: String
  field :icd_version, type: String
  field :drg_version, type: String
  field :manual_url, type: String
  field :public, type: Boolean
  

  scope :public, lambda { where(:public => true) }

  #TODO: use scope instead of helper method
  def self.all_public
    self.public.all
  end

  def self.exists?(id)
    self.where(:system_id => id).exists?
  end

  index({"system_id" => 1}, unique: true)
end
