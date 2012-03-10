class PatientCasesController < ApplicationController
  
  def index
    @webgrouper_patient_case = WebgrouperPatientCase.new
  end
  
  def create
    attributes = params[:webgrouper_patient_case]
    @webgrouper_patient_case = WebgrouperPatientCase.new(attributes)
    if @webgrouper_patient_case.valid?
      group(attributes)
    else
      @webgrouper_patient_case = WebgrouperPatientCase.new
      flash.now[:error] = "Die Validierung ist fehlgeschlagen."
      render 'index'
    end  
  end
  
  def group(attributes)
    patient_case = WebgrouperPatientCase.wrapper_patient_case_for(attributes)
    kernel = org.swissdrg.grouper.kernel.GrouperKernel.create("spec.bin")
    @result = kernel.group(patient_case)
    render 'index'
  end
  
end
