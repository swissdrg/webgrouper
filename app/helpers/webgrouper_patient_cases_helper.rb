module WebgrouperPatientCasesHelper
  def link_to_add_fields(name, kind)  
    link_to(image_tag(name), '#', onclick: "add_fields(\"#{kind}\", \"#{escape_javascript(render "shared/#{kind}_row")}\", \"\")", :id => "add_#{kind}")
  end
  
  def link_to_remove_fields(name, kind)
    link_to(image_tag(name), '#', onclick: "remove_fields(\"#{kind}\")", :id => "remove_#{kind}")
  end
  
  def add_button(kind)
    render "shared/add_button", :kind => kind
  end
  
  def remove_button(kind)
    render "shared/remove_button", :kind => kind
  end
  
  # valid types are: drgs, mdcs, adrgs, tables, icd_codes, chop_codes, functions
  # (given as strings)
  def link_to_online_definition_manual(code, type, system_id)
    manual_url = System.where(:system_id => system_id).first.manual_url
    if manual_url.blank?
      code
    else
      link_to code, manual_url + type.to_s + "/name?code=" + code + "&locale=" + I18n.locale.to_s, :title => t('to_online_definition_manual')
    end
  end

  def current_case_url
    parse_url + '?' + {:pc => {:string => @webgrouper_patient_case.to_s}}.to_query
  end
end
