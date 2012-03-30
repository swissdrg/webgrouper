module PatientCasesHelper
  
  def procedure_values(field_counter)
    puts "THERESE!"
    compressed_procedure = procedures[field_counter]
    procedures = compressed_procedure.split("$")
    puts "#{procedures}"
    procedures
  end
end
