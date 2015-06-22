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

  # If there is a form on the current page, we must submit it to make sure no content in the form is lost
  # instead of doing a simple get on the current page.
  def link_to_language_change(label, locale)
    if @webgrouper_patient_case || @tarpsy_patient_case
      url = url_for(:locale => locale, action: 'create')
      link_to label, '#', class: 'button', onclick: "submitFormTo('#{url}');"
    else
      link_to label, url_for(:locale => locale), class: 'button'
    end
  end
end
