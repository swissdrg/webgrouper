class Chop
  include Mongoid::Document
  
  field :code_short, type: String
  field :code, type: String
  field :text, type: String, localize: true
  field :version, type: String
	
	scope :in_system, lambda { |system_id| where(:version => System.where(:system_id => system_id ).first.chop_version) }
  
  def self.short_code_of(value)
    value.gsub(/\./, "").strip.upcase
  end
  
  # Returns the value as pretty code if it is available in the db.
  # Throws a Runtime Error if the given value is not valid.
  def self.pretty_code_of(system_id, value)
    db_entry = get_code(system_id, value)
    raise "'#{value}' is not a valid icd code" if db_entry.nil?
    db_entry.code
  end
  
  def autocomplete_result
    "#{self.code} #{self.text}"
  end
  
  def self.get_description_for(system_id, search_code)
    get_code(system_id, search_code).text
  end
  
  # Returns true if the code exists in the database.
  # you can either give the code of the code_short.
  def self.exists?(system_id, search_code)
    !get_code(system_id, search_code).nil?
  end

  # Returns the entry of a certain code in a certain system and caches it into
  # the rails cache for faster querrying. 
  def self.get_code system_id, search_code
    Rails.cache.fetch(system_id.to_s + ':' + search_code) do
      in_system(system_id).where(code_short: self.short_code_of(search_code)).first
    end
  end
  
  #index for faster searching:
  index "code_short" => 1, "version" => 1
end
