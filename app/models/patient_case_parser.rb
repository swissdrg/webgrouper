require 'json'
require 'nokogiri'

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
    parser = org.swissdrg.grouper.pcparsers.BatchgrouperPatientCaseParser.new
    if string.blank?
      pcs << parser.parse(pc_string)
    else
      string.each_line do |pc_string|
        pcs << parser.parse(pc_string)
      end
    end
    pcs
  end

  def parse_xml_sax string
    pc_doc = PatientCaseDocument.new
    parser = Nokogiri::XML::SAX::Parser.new(pc_doc)
    parser.parse(string)
    pc_doc.cases
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
      pc.pdx = org.swissdrg.grouper.Diagnosis.new(pch["pdx"])

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
      @diagnoses = Array.new
      @procedures = Array.new
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
        if :pdx= == @current_method
          @pc.send @current_method, org.swissdrg.grouper.Diagnosis.new(string)
        elsif :diagnosis= == @current_method
          @diagnoses << string unless string.blank?
        elsif :procedure= == @current_method
          @procedures << string.gsub('.', '') unless string.blank?
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