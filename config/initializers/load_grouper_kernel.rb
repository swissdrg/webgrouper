include Java 
require 'app/helpers/application_helper'
include ApplicationHelper

DEFAULT_SYSTEM = 22

# On mac: debugging only with mock-grouper
if java.lang.System.getProperty('os.name').downcase.include?('mac')
  require 'lib/javawrapper/swissdrg-grouper-1.0.0-mock.jar'
else
  require 'lib/javawrapper/swissdrg-grouper-2.0.0.jar'
  require 'lib/javawrapper/jna.jar'
end

java_import Java::org.swissdrg.grouper.PatientCase
java_import Java::org.swissdrg.grouper.GrouperResult
java_import Java::org.swissdrg.grouper.WeightingRelation
java_import Java::org.swissdrg.grouper.EffectiveCostWeight

grouper_path = File.join(spec_folder, 'libGrouperKernel64.so.4.0.0')
Rails.logger.info("Loading grouper kernel from: #{grouper_path}")

unless File.exist?(grouper_path)
  raise 'Grouper does not exist in ' + grouper_path
end

GROUPER = org.swissdrg.grouper.kernel.GrouperKernel.create(grouper_path)
