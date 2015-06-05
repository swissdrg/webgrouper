class TarpsyPatientCase
  include Mongoid::Document
  include Mongoid::Timestamps

  TARPSY_DEFAULT_SYSTEM = 1

  field :entry_date, type: Date
  field :exit_date, type: Date
  field :leave_days, type: Integer, default: 0
  field :los, type: Integer, default: 10
  field :pdx, type: String
  embeds_many :assessments
  belongs_to :system, class_name: 'TarpsySystem', primary_key: :system_id

  accepts_nested_attributes_for :assessments
  after_initialize :set_defaults

  validates_presence_of :pdx, :entry_date

  java_import org.swissdrg.grouper.tarpsy.TARPSYPatientCase
  java_import org.swissdrg.grouper.Diagnosis

  GROUPER_DATE_FORMAT = "%Y%m%d"

  attr_accessor :pc_java

  def to_java
    pc_java = TARPSYPatientCase.new
    pc_java.entry_date = entry_date.strftime(GROUPER_DATE_FORMAT) unless entry_date.blank?
    pc_java.exit_date = exit_date.strftime(GROUPER_DATE_FORMAT) unless exit_date.blank?
    pc_java.pdx = Diagnosis.new(pdx)

    # Turn each assessment hash into an assessment object and add it to pc.
    assessments.each do |a|
      pc_java.add_assessment(a.to_java)
    end
    pc_java
  end

  # TODO: Create url format and allow parsing it.
  def to_url_string
    pc_java.to_s
  end

  private

  def set_defaults
    self.system_id ||= TARPSY_DEFAULT_SYSTEM
    self.assessments.reject! { |a| a.date.blank? and a.assessment_items.all? &:blank? }
  end

end
