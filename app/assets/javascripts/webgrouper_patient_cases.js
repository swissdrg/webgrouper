// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
	addDatePickers()
	admWeightControl(0);
});

$(".calc_los").live("focus change", function() {
	var first = parseDate($('#webgrouper_patient_case_entry_date').val())
	var second = parseDate($('#webgrouper_patient_case_exit_date').val())
	var leave_days = $('#webgrouper_patient_case_leave_days').val()
	var diff = daydiff(first, second, leave_days);
	if (!(isNaN(diff))){
		$('#webgrouper_patient_case_los').val(diff);
	}
});

$("#webgrouper_patient_case_birth_date").live("focus change", function() {
	var bd = parseDate($('#webgrouper_patient_case_birth_date').val());
	var today = new Date();
	var year_diff = Math.floor(Math.ceil(today - bd) / (1000 * 60 * 60 * 24 * 365));
	
	if (!(isNaN(year_diff)) && bd < today) {
		if (year_diff >= 1) {
			$('#webgrouper_patient_case_age_mode').val("year");
			$('#webgrouper_patient_case_age').val(year_diff);
		}
		else {
			$('#webgrouper_patient_case_age_mode').val("days");
			$('#webgrouper_patient_case_age').val(daydiff(bd, today, 0));
		}
		admWeightControl(500);
	}
	else {
		$('#webgrouper_patient_case_age').val("");
	}
});

/**
 * Adds date pickers to every input field of the class "date_picker"
 * The format of the date picker is eg 02.04.2011
 */
function addDatePickers() {
	$(".date_picker").each(function() {
		var form_id = this.id;
		var eles = {};
		eles[form_id] = "d-dt-m-dt-Y";
		datePickerController.createDatePicker({formElements: eles});
	});
}

/**
 * Lets the id "admWeight" dissapear according to the
 * settings in the field age_mode
 * @param fade_time the time used to fade it in/out
 */
function admWeightControl(fade_time) {
	if ($('[id$="age_mode"]').val() == "days") {
		$("#admWeight").show(fade_time);
	}
	else {
		$("#admWeight").hide(fade_time);
	}
}

function showFields(fade_time, row_nr) {
	$("#row_field_buttons_"+row_nr).toggle(false);
	row_nr++;
	$("#row_"+row_nr).toggle(true);
}

function hideFields(fade_time, row_nr) {
	$("#row_"+row_nr).toggle(false);
	row_nr--;
	$("#row_field_buttons_"+row_nr).toggle(true);
}

function parseDate(str) {
    var mdy = str.split('.')
    return new Date(mdy[2], mdy[1]-1, mdy[0]-1);
}

function daydiff(first, second, leave_days) {
		return Math.floor(((second-first)/(1000*60*60*24))-leave_days)
}
