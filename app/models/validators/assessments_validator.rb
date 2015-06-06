
class AssessmentsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    first_assessment = value.first
    if first_assessment.date < record.entry_date
      first_assessment.errors.add(:date, make_error_message('on_or_after', record.entry_date))
    end
    last_possible_date_for_first_assessment = record.entry_date + 3.days
    if first_assessment.date > last_possible_date_for_first_assessment
      first_assessment.errors.add(:date, make_error_message('on_or_before', last_possible_date_for_first_assessment))
    end
    # TODO: Make sure that assessment are not further than 14 days apart.
  end

  private

  def make_error_message(type, date)
    # TODO: possibly add in brackets attribute name, where constraint is comming from.
    I18n.t("errors.messages.#{type}", restriction: I18n.l(date))
  end
end