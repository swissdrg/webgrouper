class TarpsyPatientCase
  include Mongoid::Document
  include Mongoid::Timestamps

  TARPSY_DEFAULT_SYSTEM = 1

  field :entry_date, type: Date
  field :exit_date, type: Date
  field :leave_days, type: Integer, default: 0
  field :los, type: Integer, default: 10

  field :pdx, type: String

  field :assessments, type: Array, default: []

  belongs_to :system, class_name: 'TarpsySystem', primary_key: :system_id

  after_initialize :set_defaults


  private

  def set_defaults
    self.system_id ||= TARPSY_DEFAULT_SYSTEM
    self.assessments.reject! { |a| a.values.all? &:blank? }
  end

end
