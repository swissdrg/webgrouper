require 'shellwords'
class TarpsyBatchgrouperQuery
  include Mongoid::Document
  include Mongoid::Timestamps

  field :output_file_path, type: String

  mount_uploader :mb_input, TarpsyBatchgrouperInputUploader
  mount_uploader :honos_input, TarpsyBatchgrouperInputUploader

  belongs_to :system, class_name: 'TarpsySystem', primary_key: :system_id

  validates_presence_of :mb_input, :honos_input, :system_id

  after_initialize :set_defaults
  before_destroy :delete_output

  def group
    # Remove non-number characters, e. g. p0 -> 0.
    update_attribute(:output_file_path, mb_input.file.path + '.out')
    pcp_percentage = system.per_case_payment_type.gsub /[^\d]/, ''
    cmd = "java -jar lib/tarpsy-grouper.jar"
    cmd << " --percasepayment-percentage #{pcp_percentage}"
    cmd << " --output-file #{Shellwords.escape(self.output_file_path)}"
    cmd << " #{Shellwords.escape(system.workspace)}"
    cmd << " #{Shellwords.escape(self.mb_input.file.path)}"
    cmd << " #{Shellwords.escape(self.honos_input.file.path)}"
    `#{cmd} 2>&1`
  end

  def output_file
    File.new(output_file_path)
  end

  private

  def set_defaults
    self.system_id ||= TarpsySystem::DEFAULT_SYSTEM_ID
  end

  def delete_output
    FileUtils.rm self.output_file_path, force: true
  end
end