# Acts as a wrapper class for superclass WeightingRelation
class WebgrouperWeightingRelation < WeightingRelation
	attr_accessor :factor	
	def initialize(drg_code)
		super()
		@factor = 10000
		drg = DRG.where(:code => drg_code).first
		self.setDrg(drg_code)
		self.setCostWeight(drg.cost_weight*@factor)
		self.setAvgDuration(drg.avg_duration*@factor)
		self.setFirstDayDiscount(drg.first_day_discount)
		self.setFirstDaySurcharge(drg.first_day_surcharge)
		self.setSurchargePerDay(drg.surcharge_per_day*@factor)
		self.setDiscountPerDay(drg.discount_per_day*@factor)
		self.setTransferFlatrate(drg.transfer_flatrate*@factor)
		self.setUseTransferFlatrate(drg.transfer_flag)
	end
end
