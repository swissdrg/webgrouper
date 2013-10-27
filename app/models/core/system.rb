class System 
  include Mongoid::Document

  field :system_id, type: Integer
  field :description, type: String, localize: true
  field :chop_version, type: String
  field :icd_version, type: String
  field :drg_version, type: String
  field :manual_url, type: String
  field :public, type: Boolean

  # TODO: validate chop/drg/icd if it is an available valid version
  validates :chop_version, :presence => true
  validates :drg_version, :presence => true
  validates :icd_version, :presence => true
  validates :description, :presence => true
  validates :system_id, :presence => true

  before_validation(on: :create) do
    self.system_id = System.last.system_id + 1
  end

  before_destroy :delete_specfile

  index "system_id" => 1

  def self.all_public
    self.where(:public => true)
  end

  def self.exists?(id)
    self.where(:system_id => id).exists?
  end

  # uses the grouperc project to automatically compile a 64 bit spec.
  # For linux compatability, the SPEC.ini file has to be changed to use linux style folder references.
  # This method uses the linux tools sed and unzip.
  #@param spec_zip, a zip file, consisting of a whole spec folder
  def compile_64bit_spec(spec_zip)
    path = File.join(spec_folder, self.system_id.to_s)
    zip_file = File.join(path, 'spec_files.zip')
    FileUtils.mkdir_p(path)
    File.open(zip_file, 'wb') { |f| f.write(spec_zip.read) }

    # unzips into spec folder
    `unzip #{zip_file} -d #{path}`
    FileUtils.mv(File.join(path, 'Spec.bin'), File.join(path, 'Spec32bit.bin'))
    spec_ini = File.join(path, 'SPEC.ini')

    # replace file separator to linux style slash
    sed_arg = "'s/\\\\/\\//g'"   # without ugly escapes: 's/\\/\//g'
    `sed -i #{sed_arg} #{spec_ini}`

    # Syntax external call:
    # grouperc {specs-ini} {output folder}
    cmd_status = `lib/grouperc/gcc_port/Linux_x86/grouperc #{spec_ini} #{path}`
    raise Exception("Spec compilation failed with #{cmd_status}") unless cmd_status.include?('Done! 0')
    FileUtils.mv(File.join(path, 'Spec.bin'), File.join(path, 'Spec64bit.bin'))
    # TODO: clean up remainders of zip file
  end

  def delete_specfile
    begin
      path = File.join(spec_folder, self.system_id.to_s)
      puts path
      FileUtils.rm_r(path)
    rescue Errno::ENOENT => e
      Rails.logger.debug "Could not delete specfile in #{path}: #{e.message}"
    end
  end
end
