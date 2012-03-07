class PatientCasesController < ApplicationController
  
  def new
    @webgrouper_patient_case = WebgrouperPatientCase.new
  end
  
  def create
    @webgrouper_patient_case = WebgrouperPatientCase.new(params[:webgrouper_patient_case])
    if @webgrouper_patient_case.valid?
      group(@webgrouper_patient_case)
    else
      render 'new'
    end  
  end
  
  def group(webgrouper_patient_case)
    patient_case = webgrouper_patient_case.wrapper_patient_case
    kernel = GroupKernel.create("spec.bin")
    @result = kernel.group(patient_case)
    
  end
  
end
