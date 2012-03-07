class WebgouperPatientCasesController < ApplicationController
  def new
    @patient_case = WebgrouperPatientCase.new
  end

  def create
    @patient_case = WebgrouperPatientCase.new(params[:webgrouper_patient_case])
    if @patient_case.valid?
    else
      render 'new'
    end
  end

end
