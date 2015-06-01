class WebgrouperPatientCasesController < ApplicationController

  def autocomplete_code(type)
    term = params[:term]
    system_id = params[:system_id]
    # Find 10 matching codes, either by matching text, code or code_short
    codes = System.find_by(system_id: system_id)
                .send(type)
                .any_of({text: /#{term}/i}, {code: /^#{term}/i}, {code_short: /^#{term}/i})
                .order_by(:code.asc)
                .limit(10)
    render :json => codes.map { |code| {:label => "#{code.code} #{code.text}", :code => code.code, text: code.text} }
  end

  def autocomplete_icd_code
    autocomplete_code('icds')
  end

  def autocomplete_chop_code
    autocomplete_code('chops')
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
    if params[:pc].present?
      @webgrouper_patient_case = WebgrouperPatientCase.parse(params[:pc][:string])
      if @webgrouper_patient_case.save
        group(@webgrouper_patient_case)
      end
      render 'form'
    end
  end

  def create
    # render index if called without arguments
    unless params[:webgrouper_patient_case].present?
      redirect_to webgrouper_patient_cases_path and return
    end

    @webgrouper_patient_case = WebgrouperPatientCase.create(params[:webgrouper_patient_case].permit!)
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
