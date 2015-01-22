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
      begin
        group(@webgrouper_patient_case)
      rescue Exception => e
        flash[:error] = e.message
      end
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
    flash[:info] = "Activated beta for this session. After closing the browser, the beta won't be active anymore!"
    redirect_to :action => 'index'
  end

  private

  def group(patient_case)
    @supplement_procedures, @total_supplement_amount = get_supplements(patient_case)
    GROUPER.load(spec_path(patient_case.system_id))
    @result = GROUPER.group(patient_case)

    @weighting_relation = WebgrouperWeightingRelation.new(@result.drg, patient_case.house, patient_case.system_id)
    @factor = @weighting_relation.factor
    @cost_weight = GROUPER.calculateEffectiveCostWeight(patient_case, @weighting_relation)
    @los_chart = LosDataTable.new(patient_case.los, @cost_weight,
                                  @weighting_relation, @factor).make_chart
  end

  # Creates a hash which contains, if there are any, procedures relevant for zusatzentgelte
	# the hash contains the appropriate fee, description, amount of the fee, and the number of appearances
	# of the same procedure which entered the user as values and as key a procedure code.
	# furthermore this method calculates also the total supplement amount (summed up).
  def get_supplements(patient_case)
    supplement_procedures = {}
    total_supplement_amount = 0
    patient_case.procedures.each do |p|
			# cleanup: we just want the procedure code (no seitigkeit or date)
      p = p.match(/(\S*)\:(\w*)\:(\w*)/)[1]
			# if there is an a row in supplementops which has a column equals the given procedure value
			# prepare hash for a new value
      sup = Supplement.in_system(patient_case.system_id).where(:chop_atc_code => p).first
      unless sup.nil?
        code = sup.supplement_code
        amount = sup.amount
	     	description = sup.text
        total_supplement_amount += amount
				
				# count how many times the same proc appeared with same fee.
				default_proc_count = 1
				if supplement_procedures[p].nil?
					data = {
              :fee => code,
              :description => description,
              :amount => amount,
              :proc_count => default_proc_count,
              :age_max => sup.age_max
          }
			  	supplement_procedures[p] = data
				else
					supplement_procedures[p][:proc_count] += 1
				end				
        
      end
    end
    return supplement_procedures, total_supplement_amount
  end
end
