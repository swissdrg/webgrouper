require 'java'
# On mac: debugging only with mock-grouper
if java.lang.System.getProperty('os.name').downcase.include?('mac')
  require 'lib/javawrapper/swissdrg-grouper-1.0.0-mock.jar'
else
  require 'lib/javawrapper/swissdrg-grouper-1.0.0.jar'
  require 'lib/javawrapper/jna.jar'
end

# Spec.bin is the binary file containing the decision tree
import org.swissdrg.grouper.PatientCase
import org.swissdrg.grouper.GrouperResult
import org.swissdrg.grouper.WeightingRelation
import org.swissdrg.grouper.EffectiveCostWeight

#For mock-grouper:
#GROUPER = org.swissdrg.grouper.kernel.GrouperKernel.create("spec.bin")

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
  file_extension = '.so.1.0.0'
end
# The real grouper:
grouper_path = File.join('lib', lib_prequel + 'GrouperKernel' + arch_lib + file_extension)
spec_path = File.join('lib', 'specs', 'Spec10billing' + arch_bin + 'bit.bin')
GROUPER = org.swissdrg.grouper.kernel.GrouperKernel.create(grouper_path, spec_path)

# for source code and a description of all classes involved
# Use Import -> Existing Project within Eclipse

# Example call:
# p = PatientCase.new
# p.age_years = 30
# p.sex = 'W'
# p.los = 10
# GROUPER.group(p)
