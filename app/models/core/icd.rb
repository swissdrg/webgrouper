class ICD
  include Mongoid::Document
	self.collection_name = "icd"
  
  field :code_short, type: String
  field :code, type: String
  field :description, type: String, localize: true
  field :icd_version, type: String
  
  scope :in_system, lambda { |system_id| where(:icd_version => System.where(:system_id => system_id ).first.icd_version) }
		
  def self.short_code_of(value)
    value.gsub(/\./, "").strip.upcase
  end
  
  # Returns the value as pretty code if it is available in the db.
  # Throws a Runtime Error if the given value is not valid.
  def self.pretty_code_of(system_id, value)
    db_entry = in_system(system_id).where(code_short: short_code_of(value)).first
    raise "'#{value}' is not a valid icd code" if db_entry.nil?
    db_entry.code
  end
  
  def autocomplete_result
    "#{self.code} #{self.description}"
  end
  
  def self.get_description_for(system_id, search_code)
    in_system(system_id).where(code_short: self.short_code_of(search_code)).first.description
  end
  
  # Returns true if the code exists in the database.
  # you can either give the code of the code_short.
  def self.exists?(system_id, search_code)
    !in_system(system_id).where(code_short: self.short_code_of(search_code)).first.nil?
  end

  index "description.de"
  index "description.fr"
  index "description.it"
end
