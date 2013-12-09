require 'csv'

CSV.foreach('db/systems.csv', :headers => true, :converters => :all, :col_sep => ';') do |row|
  s = System.find_or_create_by(:system_id => row[0])
  s.description_translations = {'de' => row[1], 'fr' => row[2], 'it' => row[3]}
  s.chop_version = row[4]
  s.icd_version = row[5]
  s.drg_version = row[6]
  s.manual_url = row[7]
  if row[8].downcase == 'true'
    s.public = true
  else
    s.public = false
  end
  s.save
end
puts "Now #{System.count} systems available!"
