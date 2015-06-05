class TarpsyPatientCasesController < ApplicationController

  def tos
    @link = new_tarpsy_patient_case_path
    render 'static_pages/tos'
  end
  
  def new
    @tarpsy_patient_case = TarpsyPatientCase.new
    @tarpsy_patient_case.assessments.build
    render 'form'
  end

  def create
    @tarpsy_patient_case = TarpsyPatientCase.create(tarpsy_patient_case_params)
    if @tarpsy_patient_case.errors.empty?
      group(@tarpsy_patient_case)
    end
    @tarpsy_patient_case.assessments.build
    render 'form'
  end

  private

  def tarpsy_patient_case_params
    params[:tarpsy_patient_case].permit(:system_id, :entry_date, :exit_date, :leave_days,
                                        :los, :pdx, assessments_attributes: [:date,
                                                                             assessment_items_attributes: [:value]])
  end

  def group(patient_case)
    begin
      start = Time.now
      @pc = patient_case.to_java
      grouper = patient_case.system.grouper
      grouper.group(@pc)
      @result = @pc.getGrouperResult()
      Rails.logger.debug("Grouped patient case in #{Time.now - start}")
    rescue Exception => e
      flash[:error] = e.message
      if Rails.env == 'development'
        raise e
      end
    end
  end

end
