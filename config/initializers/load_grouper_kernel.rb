require 'java'
require 'lib/swissdrg-grouper-1.0.0-mock.jar'

# Spec.bin is the binary file containing the decision tree
import org.swissdrg.grouper.PatientCase
import org.swissdrg.grouper.GrouperResult
import org.swissdrg.grouper.WeightingRelation
import org.swissdrg.grouper.EffectiveCostWeight

GROUPER = org.swissdrg.grouper.kernel.GrouperKernel.create("spec.bin")

# Check the swissdrg-grouper-1.0.0-mock.jar
# for source code and a description of all classes involved
# Use Import -> Existing Project within Eclipse

# Example call:
# p = PatientCase.new
# p.age_years = 30
# p.sex = 'W'
# p.los = 10
# GROUPER.group(p)
