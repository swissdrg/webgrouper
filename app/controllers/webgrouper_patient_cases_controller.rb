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
		weighting_relation.setDrg(@result.getDrg)
<<<<<<< HEAD
		avg_duration = DRG.find_by_DrCode(@result.getDrg).avg_duration
		weighting_relation.setAvgDuration(avg_duration)
		@cost_weight = GROUPER.calculateEffectiveCostWeight(patient_case, weighting_relation)
		puts "** Outout cost weight **" + (@cost_weight.getEffectiveCostWeight).to_s
=======
		drg = DRG.find_by_DrCode(@result.getDrg)
		weighting_relation.setAvgDuration(drg.avg_duration)
		@costWeight = GROUPER.calculateEffectiveCostWeight(patient_case, weighting_relation)
>>>>>>> b4d2da98582dc6af64be57f30eeb81fedf30587f
    render 'index'
  end
  
end
