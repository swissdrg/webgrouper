# For logging queries to the batchgrouper
class BatchgrouperQuery
  include Mongoid::Document
  include Mongoid::Timestamps

  field :output_file_path, type: String
  field :house, type: Integer

  field :ip, type: String
  field :client, type: String
  field :first_line, type: String
  field :line_count, type: Integer
  field :archived, type: Boolean, default: false

  validates_presence_of :input, unless: :archived
  validates_presence_of :house, :ip, :system_id
  validates_inclusion_of :house, in: [1, 2]
  validates_with BatchgrouperInputValidator, field_name: :input

  belongs_to :system, primary_key: :system_id

  mount_uploader :input, BatchgrouperInputUploader

  after_initialize :set_defaults
  before_destroy :delete_output

  index created_at: 1

  def group
    # TODO: Log first_line, line_count
    update_attribute(:output_file_path, input.file.path + '.out')
    args = {'input-format' => 'batch',
            'output-format' => 'batch',
            'output-file' => output_file_path,
    }
    # Depending house variable, use catalogue for birthhouses or hospitals
    if house == 1
      args.merge!('drg-catalogue' => self.system.catalogue)
    else
      args.merge!('birthouse' => nil, 'drg-catalogue' => self.system.birthhouse_catalogue)
    end

    # Insert quotes where necessary.
    args_string = args.map {|k, v| "--#{k} #{v.nil? ? '' : Shellwords.escape(v)}"}.join(' ')
    trailing_args_string = "#{Shellwords.escape(self.system.workspace)} #{Shellwords.escape(self.input.file.path)}"
    # Start grouper
    grouper_command = "java -jar #{Rails.root.join('lib', 'grouper.jar')} #{args_string} #{trailing_args_string}"
    Rails.logger.debug(grouper_command)
    grouper_output = `#{grouper_command}`
    Rails.logger.info(grouper_output)
    grouper_output
  end

  def group_line(line)
    # TODO
  end

  def archive!
    delete_output
    remove_input!
    self.archived = true
    save!
  end


  private

  def set_defaults
    self.system_id ||= System::DEFAULT_SYSTEM_ID
  end

  def delete_output
    if output_file_path and File.exists?(output_file_path)
      FileUtils.rm self.output_file_path
    end
  end
end