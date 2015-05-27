require 'java'
require 'lib/grouper.jar'
require 'singleton'

class SystemProvider
  include Singleton

  java_import org.swissdrg.grouper.batchgrouper.Catalogue
  java_import org.swissdrg.grouper.xml.XMLWorkspaceReader

  def initialize
    # Hash of the form { 4 => grouper object }
    groupers = System.all.each_with_object({}) do |system, hash|
#      next if Rails.env == 'development' and system.system_id != DEFAULT_SYSTEM
      hash[system.system_id] = XMLWorkspaceReader.new.readWorkspace(system.workspace)
      Rails.logger.debug("Read workspace for #{system.description}")
    end

    catalogues = System.all.each_with_object({}) do |system, hash|
#      next if Rails.env == 'development' and system.system_id != DEFAULT_SYSTEM
      hash[system.system_id] = Catalogue.createFrom(system.catalogue)
      Rails.logger.debug("Read catalogue for #{system.description}")
    end
    @singleton = [groupers, catalogues]
  end

  def groupers
    @singleton[0]
  end

  def catalogues
    @singleton[1]
  end

end