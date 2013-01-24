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
    if(params[:pc])
      @webgrouper_patient_case = WebgrouperPatientCase.parse(params[:pc][:string])
      if @webgrouper_patient_case.valid?
        group(@webgrouper_patient_case)
      else
        flash.now[:error] = @webgrouper_patient_case.errors.full_messages
        render 'index'
      end
    end
  end
  
  def create_query
    @webgrouper_patient_case = WebgrouperPatientCase.new(params[:webgrouper_patient_case])
    @webgrouper_patient_case.manual_submission = !params[:commit].nil?
    @webgrouper_patient_case.id = Query.create(params[:webgrouper_patient_case].merge({:valid => @webgrouper_patient_case.valid?, :time => Time.now})).id.to_s
    if @webgrouper_patient_case.valid?
      group(@webgrouper_patient_case)
    else
      flash.now[:error] = @webgrouper_patient_case.errors.full_messages
      render 'index'
    end
  end
  
  def group(patient_case)
		get_supplements(patient_case)
		GROUPER.load(spec_path(patient_case.system_id))
		@result = GROUPER.group(patient_case)
		@weighting_relation = WebgrouperWeightingRelation.new(@result.drg, patient_case.house, patient_case.system_id)
		@factor = @weighting_relation.factor
		@cost_weight = GROUPER.calculateEffectiveCostWeight(patient_case, @weighting_relation)		
		@los_chart = LosDataTable.new(patient_case.los, @cost_weight,
		                              @weighting_relation, @factor).make_chart
    render 'index'
  end
  
  # Reduces autocomplete results to the system specified in the form
  def get_autocomplete_items(parameters)
    items = super(parameters)
    items.send(:in_system, params[:system_id])
  end

  private
  
	# creates the a hash which contains, if there are any, procedures relevant for zusatzentgelte
	# the hash contains the appropriate fee, description, amount of the fee, and the number of apperiances
	# of the same procedure which entered the user as values and as key a procedure code.
	# futhermore this method calculates also the total supplement amount (summed up). 
  def get_supplements(patient_case)
    @supplement_procedures = {}
    @total_supplement_amount = 0
    patient_case.procedures.each do |p|
			# cleanup: we just want the procedure code (no seitigkeit or date)
      p = p.match(/(\S*)\:(\w*)\:(\w*)/)[1]
			
			# if there is an a row in supplementops which has a column equals the given procedure value
			# prepare hash for a new value
      sup = Supplement.in_system(patient_case.system_id).where(:chop_code => p).first
      unless sup.nil?
        supplement = SupplementDescription.in_system(patient_case.system_id).where(:code => sup.supplement_code).first
        code = supplement.code
        amount = supplement.amount
	     	description = supplement.text
        @total_supplement_amount += amount
				
				# count how many times the same proc appeared with same fee.
				default_proc_count = 1
				if @supplement_procedures[p].nil?
					data = {:fee => code, :description => description, :amount => amount, :proc_count => default_proc_count}	
			  	@supplement_procedures[p] = data			
				else
					new_proc_count = @supplement_procedures[p][:proc_count] + 1
					@supplement_procedures[p][:proc_count] = new_proc_count
				end				
        
      end
    end
  end
end
