# Acts as a wrapper class for superclass WeightingRelation
class WebgrouperWeightingRelation < WeightingRelation
	attr_accessor :factor	
	def initialize(drg_code, house)
		super()
		@factor = 10000
		self.setDrg(drg_code)
		drg = DRG.where(:DrCode => drg_code, :house => house).first
		if drg.nil?
			drg = DRG.where(:DrCode => drg_code, :house => 1).first 
		else
			self.setCostWeight(drg.cost_weight*@factor)
			self.setAvgDuration(drg.avg_duration*@factor)
			self.setFirstDayDiscount(drg.first_day_discount)
			self.setFirstDaySurcharge(drg.first_day_surcharge)
			self.setSurchargePerDay(drg.surcharge_per_day*@factor)
			self.setDiscountPerDay(drg.discount_per_day*@factor)
			self.setTransferFlatrate(drg.transfer_flatrate*@factor)
			self.setUseTransferFlatrate(drg.transfer == 1)
		end
		self
	end
end
