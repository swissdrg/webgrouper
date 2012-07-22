class ICD
  include Mongoid::Document
  
  field :code_short, type: String
  field :code, type: String
  field :text, type: String, localize: true
  field :version, type: String
  
  scope :in_system, lambda { |system_id| where(:version => System.where(:system_id => system_id ).first.icd_version) }
		
  def self.short_code_of(value)
    value.gsub(/\./, "").strip.upcase
  end
  
  # Returns the value as pretty code if it is available in the db.
  # If the code is blank, the db is not querried and an empty string is returned.
  # Throws a Runtime Error if the given value is not valid.
  def self.pretty_code_of(system_id, value)
    return "" if value.blank?
    db_entry = in_system(system_id).where(code_short: short_code_of(value)).first
    raise "'#{value}' is not a valid icd code" if db_entry.nil?
    db_entry.code
  end
  
  def autocomplete_result
    "#{self.code} #{self.text}"
  end
  
  def self.get_description_for(system_id, search_code)
    in_system(system_id).where(code_short: self.short_code_of(search_code)).first.text
  end
  
  # Returns true if the code exists in the database.
  # you can either give the code of the code_short.
  def self.exists?(system_id, search_code)
    !in_system(system_id).where(code_short: self.short_code_of(search_code)).first.nil?
  end

  index "code" => 1
end
