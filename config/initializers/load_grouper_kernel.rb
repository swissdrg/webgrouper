include Java 
require 'app/helpers/application_helper'
include ApplicationHelper

# On mac: debugging only with mock-grouper
if java.lang.System.getProperty('os.name').downcase.include?('mac')
  require 'lib/javawrapper/swissdrg-grouper-1.0.0-mock.jar'
else
  require 'lib/javawrapper/swissdrg-grouper-2.0.0.jar'
  require 'lib/javawrapper/jna.jar'
end

include_class Java::org.swissdrg.grouper.PatientCase
include_class Java::org.swissdrg.grouper.GrouperResult
include_class Java::org.swissdrg.grouper.WeightingRelation
include_class Java::org.swissdrg.grouper.EffectiveCostWeight

# Load libraries according to system:
# This is a bit complicated due to obscure naming convention.
if java.lang.System.getProperty('os.arch').include?('64')
  arch_bin = '64'
  arch_lib = '64bit'
else 
  arch_bin = '32'
  arch_lib = ''
end

if java.lang.System.getProperty('os.name').downcase.include?('windows')
  lib_prequel = ''
  file_extension = '.dll'
else 
  lib_prequel = 'lib'
  file_extension = '.so.2.0.2'
end

DEFAULT_SYSTEM = 9

# The real grouper:
spec_path = spec_path(DEFAULT_SYSTEM)
grouper_path = File.join(Rails.root, 'lib', lib_prequel + 'GrouperKernel' + arch_lib + file_extension)
GROUPER = org.swissdrg.grouper.kernel.GrouperKernel.create(grouper_path, spec_path)


