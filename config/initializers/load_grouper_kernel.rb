require 'java'
require 'app/helpers/webgrouper_patient_cases_helper'
include WebgrouperPatientCasesHelper

# On mac: debugging only with mock-grouper
if java.lang.System.getProperty('os.name').downcase.include?('mac')
  require 'lib/javawrapper/swissdrg-grouper-1.0.0-mock.jar'
else
  require 'lib/javawrapper/swissdrg-grouper-1.1.0.jar'
  require 'lib/javawrapper/jna.jar'
end

import org.swissdrg.grouper.PatientCase
import org.swissdrg.grouper.GrouperResult
import org.swissdrg.grouper.WeightingRelation
import org.swissdrg.grouper.EffectiveCostWeight

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
  file_extension = '.so.1.1.0'
end

# The real grouper:
spec_path = spec_path(11)
grouper_path = File.join(Rails.root, 'lib', lib_prequel + 'GrouperKernel' + arch_lib + file_extension)
GROUPER = org.swissdrg.grouper.kernel.GrouperKernel.create(grouper_path, spec_path)


