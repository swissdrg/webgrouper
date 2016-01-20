class System 
  include Mongoid::Document

  field :system_id, type: Integer
  field :description, type: String, localize: true
  field :chop_version, type: String
  field :icd_version, type: String
  field :drg_version, type: String
  field :manual_url, type: String
  field :public, type: Boolean

  has_many :chops, primary_key: :chop_version, foreign_key: :version
  has_many :icds, primary_key: :icd_version, foreign_key: :version
  has_many :drgs, primary_key: :drg_version, foreign_key: :version
  has_many :mdcs, primary_key: :drg_version, foreign_key: :version
  has_many :supplements, primary_key: :drg_version, foreign_key: :version

  scope :all_public, lambda { where(:public => true) }

  DEFAULT_SYSTEM_ID = 17

  def self.exists?(id)
    self.where(:system_id => id).exists?
  end

  java_import org.swissdrg.grouper.batchgrouper.Catalogue
  java_import org.swissdrg.grouper.xml.XMLWorkspaceReader

  def grouper_and_catalogue
    g = Rails.cache.fetch("#{system_id}_grouper", expires_in: 2.days) do
      XMLWorkspaceReader.new.loadGrouper(workspace)
    end
    c = Rails.cache.fetch("#{system_id}_catalogue", expires_in: 2.days) do
      Catalogue.createFrom(catalogue)
    end
    return g, c
  end

  def workspace
    w = File.join(folder, 'workspace')
    raise 'Could not find workspace in ' + w unless File.exist? w
    w
  end

  def catalogue
    c = File.join(folder, 'catalogue-acute.csv')
    raise 'Could not find catalogue in ' + c unless File.exist? c
    c
  end

  def birthhouse_catalogue
    c = File.join(folder, 'catalogue-birthhouses.csv')
    raise 'Could not find catalogue in ' + c unless File.exist? c
    c
  end

  def folder
    File.join(spec_folder, system_id.to_s)
  end

  private

  def spec_folder
    production_spec_folder = File.join('/','home', 'tim', 'grouperspecs')
    development_spec_folder = File.join(Rails.root, 'lib', 'grouperspecs')
    if File.directory?(production_spec_folder)
      production_spec_folder
    else
      development_spec_folder
    end
  end

  index({system_id: 1}, unique: true)
  index({public: 1 })
end
