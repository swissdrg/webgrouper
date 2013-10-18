class WebapiController < ApplicationController

  def index
    render 'webapi/index'
  end

  def group
    # TODO: log request
    #log params

    system_id = params[:system] ||= 9
    unless System.exists?(system_id)
      system_id = 9
    end

    response = []
    begin
      pcs = PatientCaseParser.new(params).result
      pcs.each do |pc|
        GROUPER.load(spec_path(system_id))
        result = GROUPER.group(pc)
        # Housing is always set to 0 -> no birthhouse stuff possible!
        wr =  WebgrouperWeightingRelation.new(result.drg, 0, system_id)
        effective_cost_weight = GROUPER.calculateEffectiveCostWeight(pc, wr)
        response << WebapiResponse.new(result, pc, effective_cost_weight, system_id).result
      end
    rescue Exception => e
      raise e if Rails.env == 'development' #dont catch in development mode
      response = {:Error => e.message}
    end

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
