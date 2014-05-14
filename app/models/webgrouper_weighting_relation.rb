# Acts as a wrapper class for superclass WeightingRelation
# Has some special logic for System V1.0 and birthhouse DRGs
class WebgrouperWeightingRelation < WeightingRelation
	attr_accessor :factor, :has_first_day_discount, :has_first_day_surcharge
	def initialize(drg_code, house, system_id)
		super()
		self.factor = 10000
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
      self.setCostWeight(prepare_for_grouper(drg.cost_weight))
      self.setSurchargePerDay(prepare_for_grouper(drg.surcharge_per_day))
      self.setDiscountPerDay(prepare_for_grouper(drg.discount_per_day))
      self.setTransferFlatrate(prepare_for_grouper(drg.transfer_flatrate))
      
      #This doesn't make sense bc it needs to be set to the inverse of what makes sense.
      self.setUseTransferFlatrate(drg.transfer_flag)
    end
    # These values needs to be set in all cases
    self.setDrg(drg.code)
    self.setAvgDuration(prepare_for_grouper(drg.avg_duration, 1))
    # by assigning it to java floats, nil gets mapped to zero. We need to preserve information, if it was nil
    self.has_first_day_discount = drg.first_day_discount != nil
    self.setFirstDayDiscount(drg.first_day_discount)
    self.has_first_day_surcharge = drg.first_day_surcharge != nil
    self.setFirstDaySurcharge(drg.first_day_surcharge)
	end
	
	def prepare_for_grouper(number, ndigits=0)
    if number
	    (number*@factor).round(ndigits)
    else
      0
    end
	end
end
