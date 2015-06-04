class TarpsySystem
  include Mongoid::Document

  field :system_id, type: Integer
  field :description, type: String, localize: true
  field :icd_version, type: String

  has_many :icds, primary_key: :icd_version, foreign_key: :version

  index({system_id: 1}, unique: true)
  index({public: 1 })
end
