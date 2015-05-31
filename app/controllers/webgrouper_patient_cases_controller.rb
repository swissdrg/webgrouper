class WebgrouperPatientCasesController < ApplicationController
  
  autocomplete :Icd, [:code, :code_short, :text], :full => true,
                              :display_value => :autocomplete_result,
                              :extra_data => [:text]
  autocomplete :Chop, [:code, :code_short, :text], :full => true,
                              :display_value => :autocomplete_result,
                              :extra_data => [:text]
  def tos
    @link = webgrouper_patient_cases_path
    render 'static_pages/tos'
  end
  
  def index
    @webgrouper_patient_case = WebgrouperPatientCase.new()
  end

  def parse
    if params[:pc].present?
      @webgrouper_patient_case = WebgrouperPatientCase.parse(params[:pc][:string])
      if @webgrouper_patient_case.valid?
        group(@webgrouper_patient_case)
      else
        flash.now[:error] = @webgrouper_patient_case.errors.full_messages
      end
      render 'index'
    end
  end

  def create_query
    # render index if called without arguments
    unless params[:webgrouper_patient_case].present?
      redirect_to webgrouper_patient_cases_path and return
    end

    @webgrouper_patient_case = WebgrouperPatientCase.create(params[:webgrouper_patient_case].permit!)
    if @webgrouper_patient_case.errors.empty?
      group(@webgrouper_patient_case)
    end
    render 'index'
  end
  
  # Reduces autocomplete results to the system specified in the form
  def get_autocomplete_items(parameters)
    items = super(parameters)
    items.send(:in_system, params[:system_id])
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
      @supplement_procedures, @total_supplement_amount = patient_case.get_supplements
      @pc = patient_case.to_java
      grouper, catalogue = patient_case.system.grouper_and_catalogue
      grouper.groupByReference(@pc)
      @result = @pc.getGrouperResult()
      @webgrouper_patient_case.drg = @result.drg
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
