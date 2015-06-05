class AssessmentItem
  VALID_VALUES = [0, 1, 2, 3, 4, 9]
  include Mongoid::Document

  embedded_in :assessment

  field :value, type: Integer

  validates_presence_of :value
  # Only apply this validation if value is not nil (so only one error will show up).
  validates :value, inclusion: { in: VALID_VALUES }, unless: -> { value.blank? }

  def blank?
    value.blank?
  end
end