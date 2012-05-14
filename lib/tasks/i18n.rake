LOCALES_PATH  = "#{Rails.root}/config/locales/en.yml"
ORIGINAL_PATH = "#{Rails.root}/config/locales/messages_en.properties"
MASTER_LOCALE = "#{Rails.root}/config/locales/de.yml"

class Hash
  def to_yaml( opts = {} )
    YAML::quick_emit( object_id, opts ) do |out|
      out.map( taguri, to_yaml_style ) do |map|
        sort.each do |k, v| # "sort" added
          map.add( k, v )
        end
      end
    end
  end
end

namespace :locales do
  task :merge do
    require 'yaml'
    master = YAML::load_file MASTER_LOCALE
    master_language_code = File.basename(MASTER_LOCALE, '.yml')
    Dir[LOCALES_PATH].each do |file_name|
      if file_name == MASTER_LOCALE
        puts "=> skipping master locale #{File.basename(MASTER_LOCALE)}"
        next
      end
      language_code = File.basename(file_name, '.yml')
      slave = YAML::load_file(file_name)
      unless slave[language_code]
        puts "-> ERROR on #{File.basename(file_name)}: can't find key '#{language_code}'!"
        next
      end
      
      original = File.read(ORIGINAL_PATH).split("\n").map{|i|i.split('=')}
      puts original
      #puts master[master_language_code]
      #master[master_language_code].each do |key, value|
       # puts "#{key} \n #{value}"
      #end
      merged = master[master_language_code].deep_merge(slave[language_code])
      final = { language_code => merged } # remove other keys
      File.open(file_name, 'w') do |file|
        file.write final.to_yaml.gsub(/\s+$/, '')
      end
      puts "+ merged #{File.basename(file_name)} with master"
    end
  end
end