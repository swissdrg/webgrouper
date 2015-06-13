# app/inputs/image_preview_input.rb
class DatePickerInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options = nil)
    input_html_classes.unshift('string')
    input_html_classes << 'date_picker'
    unless object.send(attribute_name).nil?
      input_html_options[:value] = localize(object.send(attribute_name))
    end
    input_html_options[:title] ||= t("simple_form.hints.webgrouper_patient_case.date")
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    @builder.text_field(attribute_name, merged_input_options)
  end
end