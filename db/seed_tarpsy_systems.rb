TarpsySystem.delete_all

java_import org.swissdrg.grouper.tarpsy.ITARPSYGrouperKernel::LumpSumType


LumpSumType.values.each_with_index do |lst, idx|
  TarpsySystem.create!({
    system_id: idx + 1,
    description: 'Testsystem lump sum type ' + lst.to_s,
    icd_version: 'ICD10-GM-2014',
    lump_sum_type: lst.to_s,
    public: true
  })
end