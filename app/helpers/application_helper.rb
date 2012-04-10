module ApplicationHelper
      
  def link_to_add_fields(name, kind)  
    link_to_function(name, "add_fields(\"#{kind}\", \"#{escape_javascript(row(kind))}\", \"\")")
  end
  
  def link_to_remove_fields(name, kind)
    link_to_function(name, "remove_fields(\"#{kind}\")")
  end
    
  def row(kind)
    render "shared/#{kind}_row"
  end
end
