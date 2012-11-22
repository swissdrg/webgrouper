# Acts as a wrapper class for superclass WeightingRelation
# Has some special logic for System V1.0 and birthhouse DRGs
class WebgrouperWeightingRelation < WeightingRelation
	attr_accessor :factor	
	def initialize(drg_code, house, system_id)
		super()
		@factor = 10000
		if (house == "2")
		  drg = Drg.find_by_birthhouse_code(system_id, drg_code)
		else
		  drg = Drg.find_by_code(system_id, drg_code)
		end
		
		# a non birthhouse DRG in a birthhouse => cost-weight 0
		# take all other information from normal DRG
		if (house == "2" and drg.nil?) 
  		drg = Drg.find_by_code(system_id, drg_code)
    else
      self.setCostWeight(drg.cost_weight*@factor)
      self.setSurchargePerDay(drg.surcharge_per_day*@factor)
      self.setDiscountPerDay(drg.discount_per_day*@factor)
      self.setTransferFlatrate(drg.transfer_flatrate*@factor)
      self.setUseTransferFlatrate(drg.transfer_flag)
    end
    # These values needs to be set in all cases
    self.setDrg(drg.code)
    self.setAvgDuration(drg.avg_duration*@factor)
    self.setFirstDayDiscount(drg.first_day_discount)
    self.setFirstDaySurcharge(drg.first_day_surcharge)
	end
end
