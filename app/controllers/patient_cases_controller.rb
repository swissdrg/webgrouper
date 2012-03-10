class PatientCasesController < ApplicationController
  
  def index
    @webgrouper_patient_case = WebgrouperPatientCase.new
  end
  
  def create
    @webgrouper_patient_case = WebgrouperPatientCase.new(params[:webgrouper_patient_case])
    if @webgrouper_patient_case.valid?
      group(@webgrouper_patient_case)
    else
      flash.now[:error] = @webgrouper_patient_case.errors.full_messages
      render 'index'
    end  
  end
  
  def group(webgrouper_patient_case)
    patient_case = webgrouper_patient_case.wrapper_patient_case
    kernel = org.swissdrg.grouper.kernel.GrouperKernel.create("spec.bin")
    @result = kernel.group(patient_case)
    @webgrouper_patient_case = webgrouper_patient_case
    render 'index'
  end
  
end
