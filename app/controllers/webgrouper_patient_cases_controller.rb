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
		weight_relation = WeightRelation.new
		weight_relation.setDrg(result.getDrg)
		avg_duration = DRG.find_by_DrCode(result.getDrg).avg_duration
		weight_relation.setAvgDuration(avg_duration)
		@costWeight = GROUPER.calculateEffectiveCostWeight(patient_case, weight_relation)
    render 'index'
  end
  
end
