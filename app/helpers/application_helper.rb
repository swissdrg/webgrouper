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
end
