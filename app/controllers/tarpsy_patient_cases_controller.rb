class TarpsyPatientCasesController < ApplicationController

  def index
    redirect_to action: :new
  end

  def tos
    @link = new_tarpsy_patient_case_path
    render 'static_pages/tos'
  end

  def generate_random
    @tarpsy_patient_case = TarpsyPatientCase.new
    # Any icd that starts with F is valid.
    possible_pdxs = @tarpsy_patient_case.system.icds.where(code: /^F/)
    @tarpsy_patient_case.pdx = possible_pdxs.skip(rand(possible_pdxs.count)).first.code
    @tarpsy_patient_case.entry_date = 1.year.ago.to_date
    @tarpsy_patient_case.exit_date = 1.year.ago.to_date + rand(5..100).days
    # First assessment has to be within 3 days of entry date.
    assessment_date = @tarpsy_patient_case.entry_date + rand(3).days
    # Generate assessments until exit, at maximum 14 days apart of each other.
    while @tarpsy_patient_case.exit_date > assessment_date
      a = Assessment.new(date: assessment_date)
      a.assessment_items.each do |i|
        # TODO: Make sure at least two items should be > 2
        # (probabilistically, we're good, since the chance of it happening is pretty low:
        # (2/5)^12 + (2/5)^11 + (2/5)^10 = 0.00016357785)
        i.value = rand(5)
      end
      @tarpsy_patient_case.assessments << a
      assessment_date += rand(10..14).days
    end
    if @tarpsy_patient_case.save
      group(@tarpsy_patient_case)
    end
    render 'form'
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
      @result = @pc.getTarpsyGrouperResult()
      @los_chart = TarpsyDataTable.new(@result).make_chart
      Rails.logger.debug("Grouped patient case in #{Time.now - start}")
    rescue Exception => e
      if Rails.env == 'development'
        raise e
      else
        flash[:error] = e.message
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace.join("\n"))
      end
    end
  end

end
