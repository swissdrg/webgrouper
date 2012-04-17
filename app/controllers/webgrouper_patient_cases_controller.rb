class WebgrouperPatientCasesController < ApplicationController
  
  autocomplete :ICD, :IcName, :full => true, 
                              :display_value => :autocomplete_result, 
                              :extra_data => [:IcCode]
  
  def index
    @webgrouper_patient_case = WebgrouperPatientCase.new
  end
  
  def create_query
    @webgrouper_patient_case = WebgrouperPatientCase.new(params[:webgrouper_patient_case])
    if @webgrouper_patient_case.valid?
      group(@webgrouper_patient_case)
    else
      flash.now[:error] = @webgrouper_patient_case.errors.full_messages
      render 'index'
    end  
  end
  
  def group(patient_case) 
		@result = GROUPER.group(patient_case)
		@weighting_relation = WeightingRelation.new
		all_drg = DRG.where(:DrFKSyID => 9)
		drg = all_drg.find_by_DrCode(@result.getDrg)
    		
		@weighting_relation.setDrg(@result.getDrg)
		
		@factor = 10000
		
		@weighting_relation.setCostWeight(drg.cost_weight*@factor)
		@weighting_relation.setAvgDuration(drg.avg_duration*@factor)
		@weighting_relation.setFirstDayDiscount(drg.first_day_discount)
		@weighting_relation.setFirstDaySurcharge(drg.first_day_surcharge)
		@weighting_relation.setSurchargePerDay(drg.surcharge_per_day*@factor)
		@weighting_relation.setDiscountPerDay(drg.discount_per_day*@factor)
		@weighting_relation.setTransferFlatrate(drg.transfer_flatrate*@factor)
		@weighting_relation.setUseTransferFlatrate(drg.transfer)
		
		@base_cost_weight = drg.cost_weight
		@cost_weight = GROUPER.calculateEffectiveCostWeight(patient_case, @weighting_relation)
    render 'index'
  end
  
end
