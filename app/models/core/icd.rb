class ICD
  include Mongoid::Document
	self.collection_name = "icd"
  
  field :code_short, type: String
  field :code, type: String
  field :description, type: String, localize: true
  field :icd_version, type: String
  
  default_scope lambda{where(:icd_version => System.current_system.icd_version)}
		
  def self.short_code_of(value)
    value.gsub(/\./, "").strip
  end
  
  # Returns the value as pretty code if it is available in the db.
  # Throws a Runtime Error if the given value is not valid.
  def self.pretty_code_of(value)
    db_entry = where(code_short: short_code_of(value)).first
    raise "'#{value}' is not a valid icd code" if db_entry.nil?
    db_entry.code
  end
  
  def autocomplete_result
    "#{self.code} #{self.description}"
  end
  
  def self.get_description_for(search_code)
    where(code_short: self.short_code_of(search_code)).first.description
  end
  
  # Returns true if the code exists in the database.
  # you can either give the code of the code_short.
  def self.exists?(search_code)
    !where(code_short: self.short_code_of(search_code)).first.nil?
  end

  index "description.de"
  index "description.fr"
  index "description.it"
end
