class WebgrouperPatientCasesController < ApplicationController
  
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

		weighting_relation = WeightingRelation.new		
		drg = DRG.find_by_DrCode(@result.getDrg)
    
    puts "DORIS: #{drg}"
    puts drg.cost_weight
    puts drg.avg_duration
    
    puts @result.getDrg
    
		weighting_relation.setDrg(@result.getDrg)
		
		puts "BLA: #{weighting_relation.getDrg}"
		weighting_relation.setCostWeight(drg.cost_weight)
		weighting_relation.setAvgDuration(drg.avg_duration)
		weighting_relation.setFirstDayDiscount(drg.first_day_discount)
		weighting_relation.setFirstDaySurcharge(drg.first_day_surcharge)
		weighting_relation.setSurchargePerDay(drg.surcharge_per_day)
		weighting_relation.setDiscountPerDay(drg.discount_per_day)
		weighting_relation.setTransferFlatrate(drg.transfer_flatrate)
		weighting_relation.setUseTransferFlatrate(drg.transfer)
		
		@cost_weight = GROUPER.calculateEffectiveCostWeight(patient_case, weighting_relation)
		puts "** Outout PENIS #{@cost_weight.getEffectiveCostWeight}"
		puts weighting_relation.getDrg.nil?
    render 'index'
  end
  
end
