class DRG < Mongoid::Document
  store_in collection: "drg"
  
  field :code_short, type: String
  field :code, type: String
  field :description, type: String, localize: true
  field :cost_weight, type: Float
  field :avg_duration, type: Float
  field :first_day_discount, type: Integer
  field :discount_per_day, type: Float
  field :first_day_surcharge, type: Integer
  field :surcharge_per_day, type: Float
  field :transfer_flatrate, type: Float
  field :transfer_flag, type: Boolean
  field :exception_from_reuptake_flag, type: Boolean
  field :drg_version, type: String
  
  default_scope lambda{where(:drg_version => System.drg_version)}

	def self.reuptake_exception_for?(search_code)
		DRG.find_by(code: search_code).exception_from_reuptake_flag
	end

  #index for faster searching:
  index "description.de"
  index "description.fr"
  index "description.it"
end
