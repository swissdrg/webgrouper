TarpsySystem.delete_all

java_import org.swissdrg.grouper.tarpsy.ITARPSYGrouperKernel::PerCasePaymentType


PerCasePaymentType.values.each_with_index do |lst, idx|
  TarpsySystem.create!({
                           system_id: idx + 1,
                           description: 'Testsystem per case payment type ' + lst.to_s,
                           icd_version: 'ICD10-GM-2012',
                           per_case_payment_type: lst.to_s,
                           public: true
                       })
end