require 'pg'
config = YAML.load_file('db/pg_config.yml')
conn = PG.connect(host: 'drg-dev', port: 5432, dbname: 'swiss_drg',
                  user: config['user'], password: config['password'])

# maps 'true' and 't' to true, everything else to false
def to_boolean(str)
  str.downcase == 'true' or str.downcase == 't'
end

# assembles text => { 'de' => .., 'fr' => ....} from text_de, text_fr etc
def fix_i18n(row)
  texts = {}
  ['de', 'fr', 'it', 'en'].each do |lang|
    key = "text_#{lang}"
     if row.has_key? key
       texts[lang] = row[key] unless row[key].blank?
       row.delete(key)
     end
  end
  texts
end

def save_code(model, row)
  trans = fix_i18n(row)
  code = model.new(row)
  code.text_translations = trans if code.fields.include?('text')
  code.save!
end

conn.exec("SELECT * FROM classifications.drgs" ).each do |row|
  # rename some attributes
  row['avg_duration'] = row.delete 'average_stay_duration'
  row['transfer_discount'] = row.delete 'transfer_flatrate'
  row['exception_from_reuptake_flag'] = row.delete 'exception_from_reuptake'
  save_code(Drg, row)
end

Icd.delete_all
conn.exec("SELECT * FROM classifications.icds limit 10").each do |row|
  save_code(Icd, row)
end
puts "Created #{Icd.count} icd entries!"

Chop.delete_all
conn.exec("SELECT * FROM classifications.chops").each do |row|
  save_code(Chop, row)
end
puts "Created #{Chop.count} chop entries!"

Mdc.delete_all
conn.exec("SELECT * FROM classifications.mdcs").each do |row|
  save_code(Mdc, row)
end
puts "Created #{Mdc.count} Mdc entries!"

Supplement.delete_all
conn.exec("SELECT * FROM classifications.supplements").each do |row|
  save_code(Supplement, row)
end
puts "Created #{Supplement.count} supplement entries!"

SupplementDescription.delete_all
conn.exec("SELECT * FROM classifications.supplement_descriptions").each do |row|
  save_code(SupplementDescription, row)
end
puts "Created #{SupplementDescription.count} supplement entries!"