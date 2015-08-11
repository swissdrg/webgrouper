class ParseStringValidator < ActiveModel::Validator

  def validate(record)
    if record.parse_string.include?('|')
      record.errors.add(:parse_string, record.errors.add(:parse_string,
                                                         (I18n.t('batchgrouper.detected_bfs') + ' ' +
                                                                 '<a href="https://apps.swissdrg.org/converter">Online Converter</a>').html_safe))
    end
    split_character_count = if record.parse_string.include? (';')
                              record.parse_string.scan(';').count
                            else
                              record.parse_string.scan('-').count
                            end
    if split_character_count != 210
      record.errors.add(:parse_string, I18n.t('errors.messages.wrong_number_of_split_characters', count: 210))
    end
  end
end