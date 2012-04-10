module ApplicationHelper
      
  def link_to_add_fields(name, kind)  
    link_to_function(name, "add_fields(this, \"#{kind}\", \"#{escape_javascript(row(kind))}\", \"\")")
  end
    
  def row(kind)
    render "shared/#{kind}_row"
  end
end
