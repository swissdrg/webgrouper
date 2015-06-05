module TarpsyPatientCasesHelper

  # Assembles the errors of an assessment at its items to one html list for easier displaying.
  def render_assessment_errors(assessment)
    if assessment.errors.any?
      # accumulate errors from date field and from assessment items.
      errors = assessment.errors[:date]
      errors += assessment.assessment_items.map &:errors
      errors = errors.map! {|i| i.full_messages }.flatten
      errors = errors.uniq.map {|i| content_tag :li, i}.join("\n").html_safe
      content_tag :div, content_tag(:ul, errors), class: 'errorflash'
    else
      ''
    end
  end
end
