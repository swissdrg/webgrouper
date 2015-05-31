require 'shellwords'

class Batchgrouper
  include ApplicationHelper
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :file, :system_id, :single_group, :house, :second_line, :line_count

  def initialize(attributes = {})
    self.system_id = DEFAULT_SYSTEM
    self.line_count = 0

    attributes.each do |name, value|
      value = value.to_i if send(name).is_a? Fixnum
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  # Saves the second line of the given file for logging purposes.
  # It is required, that it contains only ASCII characters!
  def preprocess_file
    file.tempfile.rewind
    encoding_options = {
        :invalid => :replace, # Replace invalid byte sequences
        :undef => :replace, # Replace anything not defined in ASCII
        :replace => '', # Use a blank for those replacements
        :universal_newline => true # Always break lines with \n
    }
    first_two_lines = file.tempfile.readline
    first_two_lines += file.tempfile.readline unless file.tempfile.eof?

    if first_two_lines.include?("|")
      raise ArgumentError, I18n.t("batchgrouper.detected_bfs")
    end

    file.tempfile.rewind
    self.line_count = File.foreach(file.tempfile).inject(0) { |c, line| c+1 }
    # assuming the first line is a header line, save first and second line of the querry.
    # TODO: refactor name of second_line
    self.second_line = first_two_lines.encode Encoding.find('ASCII'), encoding_options
  end

  def group
    file.tempfile.rewind

    # Use a temp directory:
    main_folder = batchgroupings_temp_folder
    Dir.mkdir(main_folder) unless File.directory?(main_folder)
    work_path = Dir.mktmpdir(File.join(main_folder, "Temp"))

    uploaded_file = File.join(work_path, "data.in")
    File.open(uploaded_file, "w") do |f|
      File.copy_stream(file.tempfile, f)
    end
    file.tempfile.close(true)
    output_file = File.join(work_path, file.original_filename + ".out")
    args = {'input-format' => 'batch',
            'output-format' => 'batch',
            'output-file' => output_file,
    }

    # Depending house variable, use catalogue for birthhouses or hospitals
    s = System.find_by(system_id: system_id)
    if house == "1"
      args.merge!('drg-catalogue' => s.catalogue)
    else
      args.merge!('birthouse' => nil, 'drg-catalogue' => s.birthhouse_catalogue)
    end

    # Insert quotes where necessary.
    args_string = args.map {|k, v| "--#{k} #{v.nil? ? '' : Shellwords.escape(v)}"}.join(' ')
    # Start grouper
    grouper_command = "java -jar #{Rails.root.join('lib', 'grouper.jar')} #{args_string} #{Shellwords.escape(s.workspace)} #{Shellwords.escape(uploaded_file)}"
    Rails.logger.info(grouper_command)
    grouper_output = `#{grouper_command}`
    Rails.logger.info(grouper_output)
    output_file
  end

  # This saves the line in a file, wraps it as uploaded file, then does a normal group.
  # Tempfiles are cleaned up every through a torquebox job.
  def group_line(line)
    line.strip!
    f = Tempfile.new("single_group")
    f.write(line)
    # wrap around UploadFile class for easier handling
    self.file = ActionDispatch::Http::UploadedFile.new(tempfile: f, filename: 'single_group.in')
    self.preprocess_file
    output = self.group
    File.open(output, 'r') do |f|
      f.readline()
    end
  end
end