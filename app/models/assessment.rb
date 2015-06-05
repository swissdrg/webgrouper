class Assessment
  include Mongoid::Document

  embedded_in :tarpsy_patient_case
  embeds_many :assessment_items
  accepts_nested_attributes_for :assessment_items

  field :date, type: Date
  field :items, type: Array

  validates :assessment_items, presence: true, length: { is: 12 }
  validates :date, presence: true

  after_initialize :build_assessments

  def build_assessments
    c = assessment_items.size
    (12 - c).times { assessment_items.build }
  end

  java_import org.swissdrg.grouper.tarpsy.HoNOSAssessment
  def to_java
    ha = HoNOSAssessment.new
    ha.date = date.strftime(TarpsyPatientCase::GROUPER_DATE_FORMAT)
    assessment_items.each_with_index {|item, idx| ha.setItem(idx, item.value)}
    ha
  end
end