
class Batchgrouper
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
  
  # Saves the second line of the given file for logging purposes.
  # It is required, that it contains only ASCII characters!
  def preprocess_file
    encoding_options = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Use a blank for those replacements
      :universal_newline => true       # Always break lines with \n
    }
    first_two_lines = file.tempfile.readline
    first_two_lines += file.tempfile.readline unless file.tempfile.eof?

    if first_two_lines.include?("|")
      raise ArgumentError, I18n.t("batchgrouper.detected_bfs")
    end

    file.tempfile.rewind
    self.line_count = File.foreach(file.tempfile).inject(0) {|c, line| c+1}
    # assuming the first line is a header line, save first and second line of the querry.
    # TODO: refactor name of second_line
    self.second_line =  first_two_lines.encode Encoding.find('ASCII'), encoding_options
  end
  
  def persisted?
    false
  end
  
  def group
    file.tempfile.rewind
    batchgrouper_exec = File.join(spec_folder, 'batchgrouper')
    # Use a temp directory: 
    main_folder = batchgroupings_temp_folder
    Dir.mkdir(main_folder) unless File.directory?(main_folder)
    work_path = Dir.mktmpdir(File.join(main_folder, "Temp"))

    uploaded_file = File.join(work_path, "data.in")
    File.open(uploaded_file, "w") do |f|
      File.copy_stream(file.tempfile, f)
    end
    file.tempfile.close(true)
    output_file = File.join(work_path, "data.out")
    additional_argument = "-bh " if house == '2'
    cmd = "#{batchgrouper_exec} #{additional_argument}'#{spec_path(self.system_id)}' '#{catalogue_path(self.system_id, self.house)}' '#{uploaded_file}' '#{output_file}'"
    proc_status = `#{cmd}`
    puts "#{cmd}, terminated with: #{proc_status}"
    renamed_file = File.join(work_path, file.original_filename + ".out")
    File.rename(output_file, renamed_file)
    renamed_file
  end

  # This saves the line in a file, wraps it as uploaded file, then does a normal group
  # TODO: clean up temp file?
  def group_line(line)
    line.strip!
    f = Tempfile.new("single_group")
    f.write(line)
    # wrap around UploadFile class for easier handling
    self.file = ActionDispatch::Http::UploadedFile.new( tempfile: f, filename: 'single_group.in')

    output = group()
    File.open(output, 'r') do |f|
      f.readline()
    end
  end
  
  private
  
  def flag_to_int(flag)
    if flag.valid
      if !flag.used
        return 0
      else
        return 1
      end
    else
      if !flag.used
        return 2
      else
        return 3
      end
    end
  end
end