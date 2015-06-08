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
}

$(document).on("change", "#tarpsy_patient_case_system_id", function () {
    this.form.submit();
});

function computeTarpsyLos() {
    var entry = parseDate($('#tarpsy_patient_case_entry_date').val());
    var exit = parseDate($('#tarpsy_patient_case_exit_date').val());
    var leave_days = $('#tarpsy_patient_case_leave_days').val();
    var diff = exit.diff(entry, 'days') + 1;

    if (entry.isValid() && exit.isValid()){
        $('#tarpsy_patient_case_los').val(diff);
        disableLosInput(true);
    } else {
        disableLosInput(false);
    }
}
