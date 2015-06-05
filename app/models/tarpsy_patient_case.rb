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
  accepts_nested_attributes_for :assessments

  belongs_to :system, class_name: 'TarpsySystem', primary_key: :system_id

  after_initialize :set_defaults


  java_import org.swissdrg.grouper.tarpsy.TARPSYPatientCase
  java_import org.swissdrg.grouper.tarpsy.HoNOSAssessment
  java_import org.swissdrg.grouper.Diagnosis

  def to_java
    pc = TARPSYPatientCase.new
    pc.entry_date = entry_date
    pc.exit_date = exit_date
    pc.pdx = Diagnosis.new(pdx)

    # Turn each assessment hash into an assessment object and add it to pc.
    assessments.each do |a|
      ha = HoNOSAssessment.new
      ha.date = a['date']
      12.times { |i| ha.item(i, a[i.to_s]) }
      pc.add_assessment(ha)
    end
  end

  private

  def set_defaults
    self.system_id ||= TARPSY_DEFAULT_SYSTEM
    self.assessments.reject! { |a| a.date.blank? and a.assessment_items.all? &:blank? }
  end

end
