class WebgrouperPatientCasesController < ApplicationController
  
  autocomplete :ICD, [:IcCode, :IcShort, :IcName], :full => true, 
                              :display_value => :autocomplete_result,
                              :extra_data => [:IcName]
  
  autocomplete :OPS, [:OpCode, :OpShort, :OpName], :full => true, 
                              :display_value => :autocomplete_result,
                              :extra_data => [:OpName]
                              
  def index
    @webgrouper_patient_case = WebgrouperPatientCase.new
  end
  
  def create_query
		System.current_system = System.find_by_SyID(params[:system][:SyID])
    @webgrouper_patient_case = WebgrouperPatientCase.new(params[:webgrouper_patient_case])
    @webgrouper_patient_case.manual_submission = params[:commit]
    if @webgrouper_patient_case.valid?
      group(@webgrouper_patient_case)
    else
      flash.now[:error] = @webgrouper_patient_case.errors.full_messages
      render 'index'
    end  
  end
  
  def group(patient_case)
		current_system_id = System.current_system.SyID
		get_supplements(patient_case)
		GROUPER.load(spec_path(current_system_id))
		@result = GROUPER.group(patient_case)
		@weighting_relation = WebgrouperWeightingRelation.new(@result.getDrg, patient_case.house)
		@factor = @weighting_relation.factor
		@cost_weight = GROUPER.calculateEffectiveCostWeight(patient_case, @weighting_relation)		
		@los_chart = LosDataTable.new(patient_case.los, @cost_weight,
		                              @weighting_relation, @factor).make_chart
    render 'index'
  end
  
  def help
  end
  
  def tos
  end
  
  private
  
  def get_supplements(patient_case)
    @supplement_procedures = {}
    @total_supplement_amount = 0
    patient_case.procedures.each do |p|
      p = p.match(/(\S*)\:(\w*)\:(\w*)/)[1]
      sup_op = SupplementOps.where(:ops => p).first
      unless sup_op.nil?
        fee = sup_op.fee
        supplement = Supplement.where(:fee => fee).first
        amount = supplement.amount
	     	description = supplement.description
        @total_supplement_amount += amount
				
				# count how many times the same proc appeared with same fee.
				default_proc_count = 1
				if @supplement_procedures[p].nil?
					data = {:fee => fee, :description => description, :amount => amount, :proc_count => default_proc_count}	
			  	@supplement_procedures[p] = data			
				else
					new_proc_count = @supplement_procedures[p][:proc_count] + 1
					@supplement_procedures[p][:proc_count] = new_proc_count
				end				
        
      end
			puts "AAAAA number " + @supplement_procedures.values.to_s + "\n"
    end
  end
  
  
end
