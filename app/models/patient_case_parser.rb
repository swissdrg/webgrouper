require 'json'
require 'nokogiri'
ARRAY_LIMIT = 1000

class PatientCaseParser
  def initialize params
    pc_string = params[:pc] == nil ? "" : params[:pc]
    format = params[:input_format]

    case format
      when "swissdrg" then @pcs = parse_swissdrg(pc_string)
      when "xml" then @pcs = parse_xml(pc_string)
      when "json" then @pcs = parse_json(pc_string)
      else raise Exception.new("No format given as argument! Please include either swissdrg, xml or json as input_format.")
    end
  end

  def result
    @pcs
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

  def parse_swissdrg string
    pcs = []
    if string.blank?
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
    pchs = Nokogiri::XML(string).xpath("//PatientCase")
    throw :NoPatientCaseNode => "Couldn't find any nodes called \"PatientCase\"" if pchs.size < 1
    throw :TooManyArguments => "The number Patient Cases that can be grouped at once is limited to #{ARRAY_LIMIT}" if pchs.size > ARRAY_LIMIT
    pchs.each do |pch|
      pc = org.swissdrg.grouper.PatientCase.new

      pc.id =  pch.xpath('.//id').text
      pc.entryDate = pch.xpath('.//entryDate').text
      pc.exitDate = pch.xpath('.//exitDate').text
      pc.birthDate = pch.xpath('.//birthDate').text
      pc.leaveDays = pch.xpath('.//leaveDays').text.to_i
      pc.ageYears = pch.xpath('.//ageYears').text.to_i
      pc.ageDays = pch.xpath('.//ageDays').text.to_i
      pc.admWeight = pch.xpath('.//admWeight').text.to_i
      pc.sex = pch.xpath('.//sex').text
      pc.adm = pch.xpath('.//adm').text
      pc.sep = pch.xpath('.//sep').text
      pc.los = pch.xpath('.//los').text.to_i
      pc.hmv = pch.xpath('.//hmv').text.to_i
      pc.pdx = pch.xpath('.//pdx').text

      unless pch.xpath('.//diagnoses').empty?
        diagnoses = pch.xpath('.//diagnoses//diagnosis').map { |d| d.text }
        @diagMax = diagnoses.size
        (diagnoses.size..98).each {|_| diagnoses << nil}   # pad with nil
        pc.diagnoses = diagnoses
      end
      unless pch.xpath('.//procedures').empty?
        procedures = pch.xpath('.//procedures//procedure').map { |d| d.text.gsub('.', '') }
        (procedures.size..99).each {|_| procedures << nil}   # pad with nil
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

end