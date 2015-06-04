class TarpsyPatientCasesController < ApplicationController

  def tos
    @link = new_tarpsy_patient_case_path
    render 'static_pages/tos'
  end
  
  def new
    @tarpsy_patient_case = TarpsyPatientCase.new
    render 'form'
  end

  def create
    # render index if called without arguments
    unless params[:tarpsy_patient_case].present?
      redirect_to webgrouper_patient_cases_path and return
    end

    @tarpsy_patient_case = TarpsyPatientCase.create(tarpsy_patient_case_params)
    if @tarpsy_patient_case.errors.empty?
      group(@tarpsy_patient_case)
    end
    render 'form'
  end

  private

  def tarpsy_patient_case_params
    params[:tarpsy_patient_case].permit(:system_id, :entry_date, :exit_date, :leave_days,
                                        :los, :pdx, assessments: [:date] + 12.times.map(&:to_s))
  end

  def group(patient_case)
    begin
      start = Time.now
      Rails.logger.debug("Grouped patient case in #{Time.now - start}")
    rescue Exception => e
      flash[:error] = e.message
      if Rails.env == 'development'
        raise e
      end
    end
  end

end
