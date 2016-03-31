module SeedHelpers
  require 'pg'

  PG_SEARCH_PATH = 'classifications'

  # Returns a connection to a postgress database, defind in db/pg_config.yml (environment dependent!)
  def conn
    config = YAML.load_file('db/pg_config.yml')[Rails.env]
    PG.connect(host: config['host'], port: 5432, dbname: config['dbname'],
               user: config['user'], password: config['password'])
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

  # Saves the given code the the specified model. It will try to fix any text_{lang} columns it finds by turning it
  # into localized mongoid entries.
  # In case saving fails, an exception is thrown
  def save_code(model, row)
    trans = fix_i18n(row)
    code = model.new(row)
    code.text_translations = trans if code.fields.include?('text')
    code.save!
  end

  def iterate_table(table_name)
    conn.exec("SELECT * FROM #{PG_SEARCH_PATH}.#{table_name}").each do |row|
      yield row
    end
  end

  def make_progress_bar(table_name)
    count = conn.exec("SELECT COUNT(*) from #{PG_SEARCH_PATH}.#{table_name}").first['count'].to_i
    return ProgressBar.create(:title => table_name, :starting_at => 0, :total => count,
                              :throttle_rate => 1, :format => '%t: |%B| %P%%')
  end
end
