class WebgrouperPatientCasesController < ApplicationController

  def autocomplete_code(model)
    term = params[:term]
    version = params[:version]
    # Find 10 matching codes, either by matching text, code or code_short
    codes = model.where(version: version)
                .any_of({text: /#{term}/i}, {code: /^#{term}/i}, {code_short: /^#{term}/i})
                .order_by(:code.asc)
                .limit(10)
    render :json => codes.map { |code| {:label => "#{code.code} #{code.text}", :code => code.code, text: code.text} }
  end

  def autocomplete_icd_code
    autocomplete_code(Icd)
  end

  def autocomplete_chop_code
    autocomplete_code(Chop)
  end

  def index
    redirect_to action: :new
  end

  def tos
    @link = new_webgrouper_patient_case_path
    render 'static_pages/tos'
  end
  
  def new
    @webgrouper_patient_case = WebgrouperPatientCase.new
    render 'form'
  end

  def parse
    if params[:webgrouper_patient_case_parsing].present?
      @webgrouper_patient_case_parsing = WebgrouperPatientCaseParsing.new(params[:webgrouper_patient_case_parsing])
      if @webgrouper_patient_case_parsing.valid?
        @webgrouper_patient_case = @webgrouper_patient_case_parsing.to_patient_case
        if @webgrouper_patient_case.valid?
          group(@webgrouper_patient_case)
        end
        render 'form'
      end
    else
      @webgrouper_patient_case_parsing = WebgrouperPatientCaseParsing.new
    end
  end

  def create
    @webgrouper_patient_case = WebgrouperPatientCase.create(webgrouper_patient_case_params)
    if @webgrouper_patient_case.errors.empty?
      group(@webgrouper_patient_case)
    end
    render 'form'
  end

  # For testing new systems, exclusive users are given this url. This activates the beta for the current session,
  # then sends the user to the grouper interface
  def activate_beta
    session[:beta] = true
    flash[:popup] = { body: I18n.t('flash.beta.body'), title: I18n.t('flash.beta.title') }
    redirect_to :action => 'index'
  end

  private

  def webgrouper_patient_case_params
    params[:webgrouper_patient_case].permit(:system_id, :house, :entry_date, :exit_date, :leave_days,
                                            :adm, :sep, :los, :sex, :birth_date, :age, :adm_weight,
                                            :hmv, :pdx, :age_mode, :age_mode_decoy,
                                            diagnoses: [], procedures: [:c, :l, :d])
  end

  def group(patient_case)
    begin
      start = Time.now
      @factor = 10000
      @supplement_procedures = patient_case.get_supplements
      @pc = patient_case.to_java
      grouper, catalogue = patient_case.system.grouper_and_catalogue
      grouper.groupByReference(@pc)
      @result = @pc.getGrouperResult()
      @webgrouper_patient_case.drg_code = @result.drg
      @weighting_relation = catalogue.get(@result.drg)
      @weighting_relation.extend(WeightingRelation)

      @cost_weight = grouper.calculateEffectiveCostWeight(@pc, @weighting_relation)

      @los_chart = LosDataTable.new(@pc.los, @cost_weight, @weighting_relation, @factor).make_chart
      Rails.logger.debug("Grouped patient case in #{Time.now - start}")
    rescue Exception => e
      flash[:error] = e.message
      if Rails.env == 'development'
        raise e
      end
    end
  end

end
