require 'json'
require 'nokogiri'
require 'xmlsimple'

ARRAY_LIMIT = 1000

class PatientCaseParser
  def initialize params
    pc_string = params[:pc] == nil ? "" : params[:pc]
    format = params[:input_format]
    case format
      when "swissdrg" then
        @pcs = parse_swissdrg(pc_string)
      when "xml" then
        @pcs = parse_xml_sax(pc_string)
      when "json" then
        @pcs = parse_json(pc_string)
      else
        raise Exception.new("No format given as argument! Please include either swissdrg, xml or json as input_format.")
    end
  end

  def result
    @pcs
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

  # dead code, not in use
  def parse_xml string
    pcs = []
    pchs = Nokogiri::XML(string).xpath("//PatientCase")
    throw :NoPatientCaseNode => "Couldn't find any nodes called \"PatientCase\"" if pchs.size < 1
    throw :TooManyArguments => "The number Patient Cases that can be grouped at once is limited to #{ARRAY_LIMIT}" if pchs.size > ARRAY_LIMIT
    pchs.each do |pch|
      pc = org.swissdrg.grouper.PatientCase.new

      pc.id = pch.xpath('id').text
      pc.entryDate = pch.xpath('entryDate').text
      pc.exitDate = pch.xpath('exitDate').text
      pc.birthDate = pch.xpath('birthDate').text
      pc.leaveDays = pch.xpath('leaveDays').text.to_i
      pc.ageYears = pch.xpath('ageYears').text.to_i
      pc.ageDays = pch.xpath('ageDays').text.to_i
      pc.admWeight = pch.xpath('admWeight').text.to_i
      pc.sex = pch.xpath('sex').text
      pc.adm = pch.xpath('adm').text
      pc.sep = pch.xpath('sep').text
      pc.los = pch.xpath('los').text.to_i
      pc.hmv = pch.xpath('hmv').text.to_i
      pc.pdx = pch.xpath('pdx').text

      unless pch.xpath('diagnoses').empty?
        diagnoses = pch.xpath('diagnoses').xpath('diagnosis').map { |d| d.text }
        @diagMax = diagnoses.size
        (diagnoses.size..98).each { |_| diagnoses << nil } # pad with nil
        pc.diagnoses = diagnoses
      end
      unless pch.xpath('procedures').empty?
        procedures = pch.xpath('procedures').xpath('procedure').map { |d| d.text.gsub('.', '') }
        (procedures.size..99).each { |_| procedures << nil } # pad with nil
        pc.procedures = procedures
      end
      pcs << pc
    end
    pcs
  end

  def parse_xml_sax string
    pc_doc = PatientCaseDocument.new
    parser = Nokogiri::XML::SAX::Parser.new(pc_doc)
    parser.parse(string)
    pc_doc.cases
  end

  #dead code, not in use
  def parse_xml_xmlsimple string
    puts 'using old parser!'
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

      unless pch["diagnoses"].nil?
        diagnoses = pch["diagnoses"][0]["diagnosis"].map { |d| d.to_s }
        @diagMax = diagnoses.size
        (diagnoses.size..98).each { |i| diagnoses << nil }
        pc.diagnoses = diagnoses
      end
      unless pch["procedures"].nil?
        procedures = pch["procedures"][0]["procedure"].map { |p| p.to_s.gsub(".", "") }
        (procedures.size..99).each { |i| procedures << nil }
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
      (diagnoses.size..98).each { |i| diagnoses << nil }
      pc.diagnoses = diagnoses
      procedures = pch["procedures"].map { |p| p.gsub(".", "") }
      (procedures.size..99).each { |i| procedures << nil }
      pc.procedures = procedures
      pcs << pc
    end
    return pcs
  end

end

class PatientCaseDocument < Nokogiri::XML::SAX::Document
  def cases
    @cases
  end

  def initialize
    @cases = []
    @pc = nil
  end

  def end_document
    Rails.logger.debug "Found #{@cases.size} cases in xml"
  end

  def start_element(name, attributes =[])
    if name == 'PatientCase'
      @pc = org.swissdrg.grouper.PatientCase.new
      @diagnoses = Array.new(99)
      @procedures = Array.new(100)
      @diagnoses_count = 0
      @procedures_count = 0
    else
      @is_integer = %w(leaveDays ageYears ageDays admWeight los hmv).include?(name)
      @current_method = "#{name}=".to_sym
    end
  end

  def end_element(name, attributes=[])
    if name == 'PatientCase'
      @pc.diagnoses = @diagnoses
      @pc.procedures = @procedures
      @cases << @pc
      @pc = nil
    end
  end

  def characters string
    if not @pc.nil? and not string.blank?
      string.strip!
      begin
        if :diagnosis= == @current_method
          @diagnoses[@diagnoses_count] = string
          @diagnoses_count += 1
        elsif :procedure= == @current_method
          @procedures[@procedures_count] = string.gsub('.', '')
          @procedures_count += 1
        elsif @is_integer
          @pc.send @current_method, string.to_i
        else
          @pc.send @current_method, string
        end
      rescue NoMethodError => e
        Rails.logger.debug "Ignored the node with title: #{@current_method}, entry: #{string}"
        raise e if Rails.environment == 'development'
      end
    end
  end
end