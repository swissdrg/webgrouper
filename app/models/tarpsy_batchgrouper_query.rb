require 'shellwords'
class TarpsyBatchgrouperQuery
  include Mongoid::Document
  include Mongoid::Timestamps

  field :output_file_path, type: String
  # Archived entries have their input/output files deleted.
  field :archived, type: Boolean, default: false

  # Request specific attributes
  field :ip, type: String
  field :line_count, type: Integer # TODO: log size

  mount_uploader :mb_input, TarpsyBatchgrouperInputUploader
  mount_uploader :honos_input, TarpsyBatchgrouperInputUploader

  belongs_to :system, class_name: 'TarpsySystem', primary_key: :system_id

  validates_presence_of :mb_input, :honos_input, unless: :archived
  validates_presence_of :system_id, :ip

  after_initialize :set_defaults
  before_destroy :delete_output

  def group
    update_attribute(:output_file_path, mb_input.file.path + '.out')
    # Remove non-number characters, e. g. p0 -> 0.
    pcp_percentage = system.per_case_payment_type.gsub /[^\d]/, ''
    cmd = "java -jar lib/tarpsy-grouper.jar"
    cmd << " --percasepayment-percentage #{pcp_percentage}"
    cmd << " --output-file #{Shellwords.escape(self.output_file_path)}"
    cmd << " #{Shellwords.escape(system.workspace)}"
    cmd << " #{Shellwords.escape(self.mb_input.file.path)}"
    cmd << " #{Shellwords.escape(self.honos_input.file.path)}"
    `#{cmd} 2>&1`
  end

  def archive!
    delete_output
    remove_mb_input!
    remove_honos_input!
    self.archived = true
    save!
  end

  private

  def set_defaults
    self.system_id ||= TarpsySystem::DEFAULT_SYSTEM_ID
  end

  def delete_output
    if output_file_path and File.exists?(output_file_path)
      FileUtils.rm self.output_file_path
    end
  end
end