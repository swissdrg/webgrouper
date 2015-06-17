$(document).ready(function() {
    initializeDatePickers();
    initializeForm();
    initializeAutocomplete();
});

// Recompute los when a field with class 'calc_los' is touched.
$(document).on("change focus blur", ".calc_los", computeTarpsyLos);

/**
 * Initializes certain fields in the form, which only allow a
 * certain kind of input of have to be disabled.
 */
function initializeForm() {
    $(".numeric").numeric({decimal: false, negative: false});
    computeTarpsyLos();

    $('#assessments')
        .on('cocoon:after-insert', function (_, added_item) {
            var input_selector = "input[id^=tarpsy_patient_case_assessments_attributes_][id$=_date]";
            var previous_date = parseDate(added_item.prev().find(input_selector).val());
            if (previous_date.isValid()) {
                var new_estimated_date = previous_date.add(14, 'days');
                added_item.find(input_selector).val(formatDate(new_estimated_date));
            }

            added_item.find(".date_picker").each(function () {
                addDatePicker(this.id);
            });
        }).on('cocoon:after-remove', function (_, removed_item) {
            // Fully remove removed items. Default behavior would be to send them to backend with _destroy attribute
            // set to true.
            removed_item.remove();
        });
}

$(document).on("change", "#tarpsy_patient_case_system_id", function () {
    this.form.submit();
});

function computeTarpsyLos() {
    var entry = parseDate($('#tarpsy_patient_case_entry_date').val());
    var exit = parseDate($('#tarpsy_patient_case_exit_date').val());
    // TODO: possibly use leave_days.
    var leave_days = $('#tarpsy_patient_case_leave_days').val();
    var diff = exit.diff(entry, 'days') + 1;

    if (entry.isValid() && exit.isValid()){
        $('#tarpsy_patient_case_los').val(diff);
        disableLosInput(true);
    } else {
        disableLosInput(false);
    }
}
