require 'json'
require 'xmlsimple'

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
      pcs = parse_patientcase params
      pcs.each do |pc|
        GROUPER.load(spec_path(system_id))
        result = GROUPER.group(pc)
        wr =  WebgrouperWeightingRelation.new(result.drg, 0, system_id)    # lets hope this method is overloaded?
        effective_cost_weight = GROUPER.calculateEffectiveCostWeight(pc, wr)
        response << {:PatientCase => convert_patientcase(pc),
                     :GrouperResult => convert_result(result, pc), :SystemId => system_id,
                     :EffectiveCostWeight => convert_ecw(effective_cost_weight) }
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


  def convert_patientcase pc
    pch = Hash.new
    pch[:id] = pc.id
    pch[:entryDate] = pc.entryDate
    pch[:exitDate] = pc.exitDate
    pch[:birthDate] = pc.birthDate
    pch[:leaveDays] = pc.leaveDays
    pch[:ageYears] = pc.ageYears
    pch[:ageDays] = pc.ageDays
    pch[:admWeight] = pc.admWeight
    pch[:sex] = pc.sex
    pch[:adm] = pc.adm
    pch[:sep] = pc.sep
    pch[:los] = pc.los
    pch[:hmv] = pc.hmv
    pch[:pdx] = pc.pdx

    # TODO: possibly refactor to blank checks?
    pch[:diagnoses] = pc.diagnoses.select {|e| e != nil}# && !"".eql?(e)}
    pch[:procedures] = pc.procedures.select {|e| e != nil}# && !"".eql?(e)}

    return pch
  end

  def convert_result(result, pc)
    rh = Hash.new
    rh[:drg] = result.drg
    rh[:mdc] = result.mdc
    rh[:pccl] = result.pccl
    rh[:gst] = result.gst.to_s
    rh[:ageFlag] = convert_flag(result.ageFlag)
    rh[:weightFlag] = convert_weight_flag(result.admWeightFlag)
    rh[:sexFlag] = convert_flag(result.sexFlag)
    rh[:admFlag] = convert_flag(result.admFlag)
    rh[:sepFlag] = convert_flag(result.sepFlag)
    rh[:losFlag] = convert_flag(result.losFlag)
    rh[:sdfFlag] = convert_flag(result.sdfFlag)
    rh[:hmvFlag] = convert_flag(result.hmvFlag)
    rh[:pdxFlag] = result.pdxFlag.to_s
    rh[:pdxDiagnosisFlag] = convert_diagnosis_flag(result.pdxDiagnosisFlag)
    i = -1
    rh[:diagnosesFlags] = result.diagnosesFlags.select{|d|i = i + 1; d!= nil && pc.diagnoses[i] != nil}.
        map{|d| convert_diagnosis_flag(d)}
    i = -1
    rh[:proceduresFlags] = result.proceduresFlags.select{|d|i = i + 1; d!= nil && pc.procedures[i] != nil}.
        map{|d| convert_procedure_flag(d)}

    return rh
  end

  def convert_flag flag
    fh = Hash.new
    fh[:valid] = flag.valid
    fh[:used] = flag.used
    return fh
  end

  def convert_weight_flag flag
    fh = Hash.new
    fh[:valid] = flag.valid.to_s
    fh[:used] = flag.used.to_s
    return fh
  end

  def convert_procedure_flag flag
    fh = convert_weight_flag flag
    fh[:por] = flag.por.to_s
    return fh
  end

  def convert_diagnosis_flag flag
    fh = Hash.new
    fh[:valid] = flag.valid.to_s
    fh[:used] = flag.used
    fh[:ccl] = flag.ccl
    return fh
  end

  def parse_patientcase params
    pc_string = params[:pc] == nil ? "" : params[:pc]
    format = params[:input_format] ||= nil

    pcs = []
    case format
      when "swissdrg" then pcs = parse_swissdrg(pc_string)
      when "xml" then pcs = parse_xml(pc_string)
      when "json" then pcs = parse_json(pc_string)
      else raise Exception.new("No format given as argument! Please include either swissdrg, xml or json as input_format.")
    end
    return pcs
  end

  def parse_swissdrg string
    pcs = []
    if(string == "")
      pcs << org.swissdrg.grouper.PatientCase.new
    else
      string.each_line do |pc_string|
        pcs << org.swissdrg.grouper.PatientCase.parse(pc_string)
      end
    end
    return pcs
  end

  def parse_xml string
    pcs = []
    parser = XmlSimple.new
    pchs = parser.parse_string string
    throw :NoPatientCaseNode => "Couldn't find any nodes called \"PatientCase\"" if pchs["PatientCase"] == nil
    throw :TooManyArguments => "The number Patient Cases that can be grouped at once is limited to #{ARRAY_LIMIT}" if pchs["PatientCase"].size > ARRAY_LIMIT
    pchs["PatientCase"].each do |pch|
      pc = org.swissdrg.grouper.PatientCase.new

      pc.id = pch["id"][0] if pch["id"] != nil
      pc.entryDate = pch["entryDate"][0] if pch["entryDate"] != nil
      pc.exitDate = pch["exitDate"][0] if pch["exitDate"] != nil
      pc.birthDate = pch["birthDate"][0] if pch["birthDate"] != nil
      pc.leaveDays = pch["leaveDays"][0]["content"].to_i if pch["leaveDays"] != nil
      pc.ageYears = pch["ageYears"][0]["content"].to_i if pch["ageYears"] != nil
      pc.ageDays = pch["ageDays"][0]["content"].to_i if pch["ageDays"] != nil
      pc.admWeight = pch["admWeight"][0]["content"].to_i if pch["admWeight"] != nil
      pc.sex = pch["sex"][0] if pch["sex"] != nil
      pc.adm = pch["adm"][0] if pch["adm"] != nil
      pc.sep = pch["sep"][0] if pch["sep"] != nil
      pc.los = pch["los"][0]["content"].to_i if pch["los"] != nil
      pc.hmv = pch["hmv"][0]["content"].to_i if pch["hmv"] != nil
      pc.pdx = pch["pdx"][0] if pch["pdx"] != nil

      if(pch["diagnoses"] != nil)
        diagnoses = pch["diagnoses"][0]["diagnosis"].map {|d| d.to_s}
        @diagMax = diagnoses.size
        (diagnoses.size..98).each {|i| diagnoses << nil}
        pc.diagnoses = diagnoses
      end
      if(pch["procedures"] != nil)
        procedures = pch["procedures"][0]["procedure"].map { |p| p.to_s.gsub(".", "") }
        (procedures.size..99).each {|i| procedures << nil}
        pc.procedures = procedures
      end
      pcs << pc
    end
    return pcs
  end

  def parse_json string
    pcs = []
    pchs = JSON.parse string
    throw :TooManyArguments => "The number Patient Cases that can be grouped at once is limited to #{ARRAY_LIMIT}" if pchs.size > ARRAY_LIMIT
    pchs.each do |pch|
      pc = org.swissdrg.grouper.PatientCase.new
      pc.id = pch["id"]
      pc.entryDate = pch["entryDate"]
      pc.exitDate = pch["exitDate"]
      pc.birthDate = pch["birthDate"]
      pc.leaveDays = pch["leaveDays"]
      pc.ageYears = pch["ageYears"]
      pc.ageDays = pch["ageDays"]
      pc.admWeight = pch["admWeight"]
      pc.sex = pch["sex"]
      pc.adm = pch["adm"]
      pc.sep = pch["sep"]
      pc.los = pch["los"]
      pc.hmv = pch["hmv"]
      pc.pdx = pch["pdx"]

      diagnoses = pch["diagnoses"]
      (diagnoses.size..98).each {|i| diagnoses << nil}
      pc.diagnoses = diagnoses
      procedures = pch["procedures"].map { |p| p.gsub(".", "") }
      (procedures.size..99).each {|i| procedures << nil}
      pc.procedures = procedures
      pcs << pc
    end
    return pcs
  end

  def convert_ecw ecw
    ecwh = Hash.new
    ecwh["effectiveCostWeight"] = ecw.effectiveCostWeight
    ecwh["caseFlag"] = ecw.caseFlag.to_s
    ecwh
  end

  def log params
    input_format = params[:input_format] ||= nil

    log = Log.new({:message => input_format, :user_ip => request.remote_ip, :user_agent => request.env['HTTP_USER_AGENT']})
    log.save
  end
end
