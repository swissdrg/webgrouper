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
    if @webgrouper_patient_case.valid?
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
end
