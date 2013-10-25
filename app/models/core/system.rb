class System 
  include Mongoid::Document

  field :system_id, type: Integer
  field :description, type: String, localize: true
  field :chop_version, type: String
  field :icd_version, type: String
  field :drg_version, type: String
  field :manual_url, type: String
  field :public, type: Boolean

  # TODO: validate chop/drg/icd if it is an available valid version
  validates :chop_version, :presence => true
  validates :drg_version, :presence => true
  validates :icd_version, :presence => true
  validates :description, :presence => true
  validates :system_id, :presence => true

  before_validation(on: :create) do
    self.system_id = System.last.system_id + 1
  end

  index "system_id" => 1

  def self.all_public
    self.where(:public => true)
  end

  def self.exists?(id)
    self.where(:system_id => id).exists?
  end

end
