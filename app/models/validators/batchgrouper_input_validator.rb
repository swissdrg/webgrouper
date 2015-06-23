# Quite basic validation of batchgrouper input, takes into account the file ending and then tries to read the first line
# of the file under the assumption it's a text file.
class BatchgrouperInputValidator < ActiveModel::Validator

  # TODO: Check if this also works on windows.
  VALID_MIMES = %W(octet-stream text)

  def initialize(options)
    super
    @field_name = options[:field_name]
  end

  def validate(record)
    value = record.send(@field_name)
    return if value.blank?

    # Check file extension
    file_extension = File.extname(value.file.path)
    if %w(.zip .rar .7z).include? file_extension
      record.errors.add(@field_name, 'Archives are not allowed, please unpack and try to upload again.')
      return
    end
    if %w(.doc .xls .xlsx .ods .pdf).include? file_extension
      record.errors.add(@field_name, 'Invalid file ending detected. Only use text files in the swissdrg format, not .doc or .xls')
      return
    end

    unless VALID_MIMES.any? {|m| value.file.content_type.include? m }
      record.errors.add(@field_name, 'might not be a text file.')
      return
    end
    # Read first line of file and try some validations.
    File.open(value.file.path) do |f|
      line = f.readline
      if line.include?('|')
        record.errors.add(@field_name, raw(I18n.t("batchgrouper.detected_bfs") +
                                               '<a href="https://apps.swissdrg.org/converter">Online Converter</a>'))
      end
    end
  end
end