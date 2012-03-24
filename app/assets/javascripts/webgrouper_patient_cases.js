// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
	addDatePickers()
	admWeightControl(0);
	disableTabForLinks();
});

$(".calc_los").live("focus change", function() {
	var first = parseDate($('#webgrouper_patient_case_entry_date').val())
	var second = parseDate($('#webgrouper_patient_case_exit_date').val())
	var leave_days = $('#webgrouper_patient_case_leave_days').val()
	var diff = daydiff(first, second, leave_days);
	if(diff < 0){
		diff = ""
		this.style.backgroundColor = "red"
	}
	else{
		if (!(isNaN(diff))){
			$('#webgrouper_patient_case_los').val(diff);
			$(".calc_los").each(function() {
				this.style.backgroundColor = "transparent"
			});
		}
	}
});

$("#webgrouper_patient_case_birth_date").live("focus change", function() {
	var bd = parseDate($('#webgrouper_patient_case_birth_date').val());
	var today = new Date();
	var age = Math.floor(Math.ceil(today - bd) / (1000 * 60 * 60 * 24 * 365));
	
	if (!(isNaN(age)) && age > 0){
			$('#webgrouper_patient_case_age').val(age);
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

function parseDate(str) {
    var mdy = str.split('.')
    return new Date(mdy[2], mdy[1], mdy[0]-1);
}

function daydiff(first, second, leave_days) {
		return Math.floor(((second-first)/(1000*60*60*24))-leave_days)
}
