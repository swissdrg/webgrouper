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

    @webgrouper_patient_case = WebgrouperPatientCase.new(params[:webgrouper_patient_case])
    @webgrouper_patient_case.manual_submission = !params[:commit].nil?
    query_attributes = params[:webgrouper_patient_case].merge({:valid_case => @webgrouper_patient_case.valid?, :time => Time.now}).permit!
    @webgrouper_patient_case.id = Query.create(query_attributes).id.to_s
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
    # Uncommment this once beta is allowed to be public again
    session[:beta] = true
    flash[:popup] = { body: I18n.t('flash.beta.body'), title: I18n.t('flash.beta.title') }
    redirect_to :action => 'index'
  end

  private

  def group(patient_case)
    begin
      @supplement_procedures, @total_supplement_amount = get_supplements(patient_case)
      GROUPER.load(spec_path(patient_case.system_id))
      @result = GROUPER.group(patient_case)

      @weighting_relation = WebgrouperWeightingRelation.new(@result.drg, patient_case.house, patient_case.system_id)
      @factor = @weighting_relation.factor
      @cost_weight = GROUPER.calculateEffectiveCostWeight(patient_case, @weighting_relation)
      @los_chart = LosDataTable.new(patient_case.los, @cost_weight,
                                    @weighting_relation, @factor).make_chart
    rescue Exception => e
      flash[:error] = e.message
    end
  end

  # Creates a hash which contains, if there are any, procedures relevant for zusatzentgelte
	# the hash contains the appropriate fee, description, amount of the fee, and the number of appearances
	# of the same procedure which entered the user as values and as key a procedure code.
	# furthermore this method calculates also the total supplement amount (summed up).
  def get_supplements(patient_case)
    # TODO: Removed computation of supplements, needs reimplementation after supplements grouper is finished.
    return Hash.new, 0
  end
end
