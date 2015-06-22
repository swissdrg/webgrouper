TarpsySystem.delete_all

java_import org.swissdrg.grouper.tarpsy.ITARPSYGrouperKernel::PerCasePaymentType


PerCasePaymentType.values.each_with_index do |lst, idx|
  lst_number = lst.to_s.scan(/\d+/).first
  TarpsySystem.create!({
                           system_id: idx + 1,
                           description: "Tarpsy 0.2 Fallpauschale #{lst_number}%",
                           icd_version: 'ICD10-GM-2012',
                           per_case_payment_type: lst.to_s,
                           public: true
                       })
end