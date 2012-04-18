module WebgrouperPatientCasesHelper
  
  # Is this still in use somewhere?
  def procedure_values(patient_case, field_counter)
    compressed_procedure = patient_case.procedures[field_counter]
    procedures = compressed_procedure.split("$") unless compressed_procedure.nil?
    procedures
  end
  
  def current_system=(system)
    @current_system = system
  end
  
  def current_system
    @current_sytem ||= System.find_by_SyID(9)
  end
  
end
