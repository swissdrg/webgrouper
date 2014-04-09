require 'db/seed_helpers'
include SeedHelpers
bar = make_progress_bar('drgs')
Drg.delete_all
conn.exec("SELECT * FROM classifications.drgs").each do |row|
  # rename some attributes
  row['avg_duration'] = row.delete 'average_stay_duration'
  row['transfer_flatrate'] = row.delete 'transfer_discount'
  row['exception_from_reuptake_flag'] = row.delete 'exception_from_reuptake'
  save_code(Drg, row)
  bar.increment
end
puts "Created #{Drg.count} drg entries!"