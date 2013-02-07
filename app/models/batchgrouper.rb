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
  
  #Saves the second line of the given file for logging purposes.
  #It is required, that it contains only ASCII characters!
  def preprocess_file
    encoding_options = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Use a blank for those replacements
      :universal_newline => true       # Always break lines with \n
    }
    file_content = file.read
    if file_content.include?("|")
      raise ArgumentError, I18n.t("batchgrouper.detected_bfs")
    end
    lines_of_file = file_content.split("\n")
    self.line_count = lines_of_file.size
    # assuming the first line is a header line, save the second line of the querry.
    if self.line_count > 1
      self.second_line = lines_of_file[1].encode Encoding.find('ASCII'), encoding_options
    else 
      self.second_line = lines_of_file[0].encode Encoding.find('ASCII'), encoding_options
    end
  end
  
  def persisted?
    false
  end
  
  def group
    file.rewind
    batchgrouper_exec = File.join(spec_folder, 'batchgrouper')
    # Use a temp directory: 
    main_folder = batchgroupings_temp_folder
    Dir.mkdir(main_folder) unless File.directory?(main_folder)
    work_path = Dir.mktmpdir(File.join(main_folder, "Temp"))

    uploaded_file = File.join(work_path, "data.in")
    File.open(uploaded_file, "w") do |f| 
      f.write(file.read)
      f.chmod(0666) # this should not be necessary, since rails also spawns the batchgrouper executable
    end
    output_file = File.join(work_path, "data.out")
    additional_argument = "-bh " if house == '2'
    cmd = "#{batchgrouper_exec} #{additional_argument}'#{spec_path(self.system_id)}' '#{catalogue_path(self.system_id, self.house)}' '#{uploaded_file}' '#{output_file}'"
    proc_status = `#{cmd}`
    puts "#{cmd}, terminated with: #{proc_status}"
    renamed_file = File.join(work_path, file.original_filename + ".out")
    File.rename(output_file, renamed_file)
    renamed_file
  end
  
  def group_line(line)
    line = line.strip
    return nil if line.blank? # allows blank lines
    pc = PatientCase.parse(line)
    pc.set_birth_house("2" == house)
    grouper_result = GROUPER.group(pc)
    weighting_relation = WebgrouperWeightingRelation.new(grouper_result.drg, house, system_id)
    ecw = GROUPER.calculateEffectiveCostWeight(pc, weighting_relation)
    return [pc.id, grouper_result.drg, grouper_result.mdc, 
                  flag_to_int(grouper_result.age_flag),
                  flag_to_int(grouper_result.sex_flag), 
                  "0" + grouper_result.gst.ordinal.to_s, 
                  grouper_result.pccl,
                  ecw.effective_cost_weight, 
                  "0" + ecw.case_flag.ordinal.to_s].join(";")
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