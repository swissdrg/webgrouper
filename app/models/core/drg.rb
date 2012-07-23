class Drg
  include Mongoid::Document
  
  field :code_short, type: String
  field :code, type: String
  field :text, type: String, localize: true
  field :cost_weight, type: Float
  field :avg_duration, type: Float
  field :first_day_discount, type: Integer
  field :discount_per_day, type: Float
  field :first_day_surcharge, type: Integer
  field :surcharge_per_day, type: Float
  field :transfer_flatrate, type: Float
  field :transfer_flag, type: Boolean
  field :exception_from_reuptake, type: Boolean
  field :version, type: String
  
  scope :in_system, lambda { |system_id| where(:version => System.where(:system_id => system_id ).first.drg_version) }

	def self.reuptake_exception_for?(system_id, search_code)
		in_system(system_id).where(code: search_code).first.exception_from_reuptake
	end
	
	def self.get_description_for(system_id, search_code)
    in_system(system_id).where(code: search_code).first.text
  end
  
  def self.reuptake_exception?(system_id, search_code)
    in_system(system_id).where(code: search_code).first.exception_from_reuptake_flag
  end
  
  def self.find_by_code(system_id, search_code)
    in_system(system_id).where(code: search_code).first
  end
  
  index :code => 1, :version => 1
end
