class Batchgrouper
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :file, :system_id, :single_group, :house, :first_line, :line_count
  
  def initialize(attributes = {})
    self.system_id = DEFAULT_SYSTEM
    self.line_count = 0
    
    attributes.each do |name, value|
      value = value.to_i if send(name).is_a? Fixnum
      send("#{name}=", value) 
    end
  end
  
  def preprocess_file
    lines_of_file = file.read.split("\n")
    self.first_line = lines_of_file[0]
    self.line_count = lines_of_file.size
  end
  
  def persisted?
    false
  end
  
  def group
    file.rewind
    batchgrouper_exec = File.join(spec_folder, 'batchgrouper')
    # Use a temp directory: 
    work_path = Dir.mktmpdir(File.join("/tmp", "batchgroupings", "Temp"))
    uploaded_file = File.join(work_path, file.original_filename)
    File.open(uploaded_file, "w") do |f| 
      f.write(file.read)
      f.chmod(0666) # this should not be necessary, since rails also spawns the batchgrouper executable
    end
    output_file = File.join(work_path, file.original_filename + ".out")
    additional_argument = "-bh " if house == '2'
    cmd = "#{batchgrouper_exec} #{additional_argument}'#{spec_path(self.system_id)}' '#{catalogue_path(self.system_id, self.house)}' '#{uploaded_file}' '#{output_file}'"
    proc_status = `#{cmd}`
    puts "#{cmd}, terminated with: #{proc_status}"
    output_file
  end
  
  def group_line(line)
    line = line.strip
    return nil if line.blank? # allows blank lines
    pc = PatientCase.parse(line)
    pc.set_birth_house(2 == house)
    grouper_result = GROUPER.group(pc)
    weighting_relation = WebgrouperWeightingRelation.new(Drg.find_by_code(system_id, grouper_result.drg))
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