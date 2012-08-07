class Batchgrouper
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include_class 'java.lang.IllegalArgumentException'
  
  attr_accessor :file, :system_id, :single_group, :house
  
  def initialize(attributes = {})
    self.system_id = DEFAULT_SYSTEM
    
    attributes.each do |name, value|
      value = value.to_i if send(name).is_a? Fixnum
      send("#{name}=", value) 
    end
    GROUPER.load(spec_path(self.system_id))
  end
  
  def persisted?
    false
  end
  
  def group
    f = Tempfile.open('groupings', File.join(Rails.root, 'tmp') )
    file.read.each_line do |line, nr|
      begin
        f.print group_line(line)
      rescue IllegalArgumentException 
        f.println "ERROR (#{nr}): #{line}"
      end
      f.print "\n"
    end
    f.flush
    return f
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