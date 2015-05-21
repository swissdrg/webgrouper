require 'java'

DEFAULT_SYSTEM = 12

require 'lib/grouper.jar'

def spec_folder
  production_spec_folder = File.join('/','home', 'tim', 'grouperspecs')
  development_spec_folder = File.join(Rails.root,'lib', 'grouperspecs')
  if File.directory?(production_spec_folder)
    production_spec_folder
  else
    development_spec_folder
  end
end

java_import org.swissdrg.grouper.batchgrouper.Catalogue
java_import org.swissdrg.grouper.xml.XMLWorkspaceReader

GROUPERS = System.all.each_with_object({}) do |system, hash|
  next if Rails.env == 'development' and system.system_id != DEFAULT_SYSTEM
  hash[system.system_id] = XMLWorkspaceReader.new.readWorkspace(system.workspace)
  Rails.logger.debug("Read workspace for #{system.description}")
end

CATALOGUES = System.all.each_with_object({}) do |system, hash|
  next if Rails.env == 'development' and system.system_id != DEFAULT_SYSTEM
  hash[system.system_id] = Catalogue.createFrom(system.catalogue)
  Rails.logger.debug("Read catalogue for #{system.description}")
end