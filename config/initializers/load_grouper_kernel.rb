require 'java'
require 'lib/swissdrg-grouper-1.0.0.jar'
require 'lib/jna.jar'

# Spec.bin is the binary file containing the decision tree
import org.swissdrg.grouper.PatientCase
import org.swissdrg.grouper.GrouperResult
import org.swissdrg.grouper.WeightingRelation
import org.swissdrg.grouper.EffectiveCostWeight

#For mock-grouper:
#GROUPER = org.swissdrg.grouper.kernel.GrouperKernel.create("spec.bin")

# TODO: Load other stuff depending on operating system

# The real grouper:
grouper_path = File.join(Rails.root, 'lib', 'libGrouperKernel64bit.so')
spec_path = File.join(Rails.root, 'lib', 'Spec10billing64bit.bin')
GROUPER = org.swissdrg.grouper.kernel.GrouperKernel.create(grouper_path, spec_path)
# for source code and a description of all classes involved
# Use Import -> Existing Project within Eclipse

# Example call:
# p = PatientCase.new
# p.age_years = 30
# p.sex = 'W'
# p.los = 10
# GROUPER.group(p)
