module WebgrouperPatientCasesHelper
  # valid types are: drgs, mdcs, adrgs, tables, icd_codes, chop_codes, functions
  # (given as strings)
  def link_to_online_definition_manual(code, type, system)
    manual_url = system.manual_url
    if manual_url.blank?
      code
    else
      link_to code, manual_url + type.to_s + "/name?code=" + code + "&locale=" + I18n.locale.to_s, :title => t('to_online_definition_manual')
    end
  end

  def current_case_url
    parse_url(:pc => {:string => @webgrouper_patient_case.to_s})
  end

  java_import org.swissdrg.grouper.GrouperResult

  def normal_group?
    @result.gst == GrouperResult::GSTFlag::NORMAL_GROUP
  end
end
