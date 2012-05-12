module ApplicationHelper
      
  def link_to_add_fields(name, kind)  
    link_to_function(image_tag(name), "add_fields(\"#{kind}\", \"#{escape_javascript(row(kind))}\", \"\")", :id => "add_#{kind}")
  end
  
  def link_to_remove_fields(name, kind)
    link_to_function(image_tag(name), "remove_fields(\"#{kind}\")")
  end
    
  def row(kind)
    render "shared/#{kind}_row"
  end
  
  def add_button(kind)
    render "shared/add_button", :kind => kind
  end
  
  def remove_button(kind)
    render "shared/remove_button", :kind => kind
  end
end
