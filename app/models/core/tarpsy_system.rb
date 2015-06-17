# Represents a tarpsy system.
# Expects a folder with the specifications of the system in the folder in `lib/tarpsy/#{system_id}/workspace`.
class TarpsySystem
  include Mongoid::Document

  field :system_id, type: Integer
  field :description, type: String, localize: true
  field :icd_version, type: String
  field :per_case_payment_type, type: String
  field :public, type: Boolean

  has_many :icds, primary_key: :icd_version, foreign_key: :version

  index({system_id: 1}, unique: true)
  index({public: 1 })

  java_import org.swissdrg.grouper.tarpsy.kernel.TARPSYPrototypeParser
  java_import org.swissdrg.grouper.tarpsy.ITARPSYGrouperKernel::PerCasePaymentType

  def grouper
    Rails.cache.fetch("#{system_id}_tarpsy_grouper", expires_in: 2.days) do
      lst = PerCasePaymentType.valueOf(self.per_case_payment_type)
      TARPSYPrototypeParser.new.parse(workspace, lst)
    end
  end

  def workspace
    w = File.join(folder, 'workspace', '')
    raise 'Could not find workspace in ' + w unless File.exist? w
    w
  end

  def folder
    Rails.root.join('lib', 'tarpsy', system_id.to_s)
  end

end
