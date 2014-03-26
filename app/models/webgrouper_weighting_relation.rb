# Acts as a wrapper class for superclass WeightingRelation
# Has some special logic for System V1.0 and birthhouse DRGs
class WebgrouperWeightingRelation < WeightingRelation
	attr_accessor :factor, :drg
	def initialize(drg_code, house, system_id)
		super()
		@factor = 10000
    set_cost_weight_data = true
		if (house == "2")
		  @drg = Drg.find_by_birthhouse_code(system_id, drg_code)
      if @drg.nil?
        @drg = Drg.find_by_code(system_id, drg_code)
        set_cost_weight_data = false
      end
		else
		  @drg = Drg.find_by_code(system_id, drg_code)
		end

    # raise exception if no DRG could be found
    raise NoDrgException, "Could not find DRG for #{drg_code} in system \"#{System.find_by(:system_id => system_id).description}\"" if drg.nil?

    # a non birthhouse DRG in a birthhouse => cost-weight 0
		# take all other information from normal DRG
		if set_cost_weight_data
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
    self.setFirstDayDiscount(drg.first_day_discount)
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
