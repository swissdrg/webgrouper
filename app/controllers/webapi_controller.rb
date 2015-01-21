class WebapiController < ApplicationController

  def index
    render 'webapi/index'
  end

  def group
    system_id = params[:system] ||= 9
    unless System.exists?(system_id)
      system_id = 9
    end

    # TODO: How correctly read out format?
    log_entry = WebapiQuery.create!(ip: request.remote_ip, system_id: system_id,
                                    input_format: params[:input_format], output_format: request.format,
                                    start_time: Time.now, user_agent: request.env['HTTP_USER_AGENT'])
    response = []
    begin
      pcs = PatientCaseParser.new(params).result
      log_entry.update_attributes!(nr_cases: pcs.size, finished_parsing_time: Time.now)
      pcs.each do |pc|
        GROUPER.load(spec_path(system_id))
        result = GROUPER.group(pc)
        # Housing is always set to 0 -> no birthhouse stuff possible!
        wr =  WebgrouperWeightingRelation.new(result.drg, 0, system_id)
        effective_cost_weight = GROUPER.calculateEffectiveCostWeight(pc, wr)
        response << WebapiResponse.new(result, pc, effective_cost_weight, system_id).result
      end
    rescue Exception => e
      log_entry.update_attributes!(error: e.message)
      raise e if Rails.env == 'development' #dont catch in development mode
      response = {:Error => e.message}
    end
    log_entry.update_attributes!(end_time: Time.now)
    respond_to do |format|
      format.xml {render :xml => response}
      format.json {render :json => response}
    end
  end

  def systems
    systems_hash = System.all_public.to_a.map {|s| { :name => s["description"]["de"], :id => s["system_id"] } }
    respond_to do |format|
      format.xml {render :xml => systems_hash}
      format.json {render :json => systems_hash}
    end
  end

  def log params
    input_format = params[:input_format] ||= nil

    log = Log.new({:message => input_format, :user_ip => request.remote_ip, :user_agent => request.env['HTTP_USER_AGENT']})
    log.save
  end
end
