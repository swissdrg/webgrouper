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

  scope :public, lambda { where(:public => true) }

  #TODO: use scope instead of helper method
  def self.all_public
    self.public.all
  end

  def self.exists?(id)
    self.where(:system_id => id).exists?
  end

  java_import org.swissdrg.grouper.batchgrouper.Catalogue
  java_import org.swissdrg.grouper.xml.XMLWorkspaceReader

  def grouper_and_catalogue
    g = Rails.cache.fetch("#{system_id}_grouper", expires_in: 2.days) do
      XMLWorkspaceReader.new.readWorkspace(workspace)
    end
    c = Rails.cache.fetch("#{system_id}_catalogue", expires_in: 2.days) do
      Catalogue.createFrom(catalogue)
    end
    return g, c
  end

  def workspace
    File.join(folder, 'workspace')
  end

  def catalogue
    File.join(folder, 'catalogue-acute.csv')
  end

  def birthhouse_catalogue
    File.join(folder, 'catalogue-birthhouses.csv')
  end

  def folder
    File.join(spec_folder, system_id.to_s)
  end

  private

  def spec_folder
    production_spec_folder = File.join('/','home', 'tim', 'grouperspecs')
    development_spec_folder = File.join(Rails.root,'lib', 'grouperspecs')
    if File.directory?(production_spec_folder)
      production_spec_folder
    else
      development_spec_folder
    end
  end

  index({"system_id" => 1}, unique: true)
end
