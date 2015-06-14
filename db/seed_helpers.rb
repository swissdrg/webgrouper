require 'active_record'

# Active Record Models for psql database
module PsqlModel
  def self.included(base)
    config = YAML.load_file('db/pg_config.yml')[Rails.env]
    base.establish_connection(
        :adapter => 'jdbcpostgresql',
        :host => config['host'],
        :username => config['user'],
        :password => config['password'],
        :database => config['dbname'],
        :schema_search_path => 'classifications'
    )
  end
end

class PsqlSupplement < ActiveRecord::Base
  include PsqlModel
  self.table_name = 'supplements'
end

class PsqlMdc < ActiveRecord::Base
  include PsqlModel
  self.table_name = 'mdcs'
end

class PsqlDrg < ActiveRecord::Base
  include PsqlModel
  self.table_name = 'drgs'
end

class PsqlIcd < ActiveRecord::Base
  include PsqlModel
  self.table_name = 'icds'
end

class PsqlChop < ActiveRecord::Base
  include PsqlModel
  self.table_name = 'chops'
end

module SeedHelpers

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
  def save_code(model, row, filter=true)
    row.select! { |k, _| /^(text|code|version)/.match(k) } if filter
    trans = fix_i18n(row)
    code = model.new(row)
    code.text_translations = trans if code.fields.include?('text')
    code.save!
  end

  def make_progress_bar(table_name)
    model = ('psql_' + table_name).classify.constantize
    count = model.count
    return ProgressBar.create(:title => table_name, :starting_at => 0, :total => count,
                              :throttle_rate => 1, :format => '%t: |%B| %P%%')
  end
end
