class WebgrouperPatientCasesController < ApplicationController
  
  def new
    @webgrouper_patient_case = WebgrouperPatientCase.new
  end
  
  def create
    @webgrouper_patient_case = WebgrouperPatientCase.new(params[:webgrouper_patient_case])
    if @webgrouper_patient_case.valid?
      group(@webgrouper_patient_case)
    else
      flash.now[:error] = @webgrouper_patient_case.errors.full_messages
      render 'new'
    end  
  end
  
  def group(patient_case)
    kernel = org.swissdrg.grouper.kernel.GrouperKernel.create("spec.bin")
    @result = kernel.group(patient_case)
    render 'new'
  end
  
end
