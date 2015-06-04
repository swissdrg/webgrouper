module ApplicationHelper
  def batchgroupings_temp_folder
    File.join("/tmp", "batchgroupings")
  end

  def shown_systems
    if session[:beta]
      shown_systems = System.all
    else
      shown_systems = System.all_public
    end
    shown_systems.order_by(:id.desc)
  end

  def link_to_language_change(label, locale)
    url = url_for(:locale => locale)
    if @webgrouper_patient_case || @tarpsy_patient_case
      link_to label, '#', class: 'button', onclick: "submitFormTo('#{url}');"
    else
      link_to label, url, class: 'button'
    end
  end
end
