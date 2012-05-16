/**
 * Everything that modifies values in the form or the form itself 
 * belongs here. 
 * (Except the javascripts concerning the dynamic creation of fields for diagnoses and procedures.)
 */

/** Some bindings */
$(document).on("change focus", "#webgrouper_patient_case_birth_date", computeAge);
$(document).on("change focus", ".calc_los", computeLos);
$(document).on("change", '#webgrouper_patient_case_age_mode_decoy', set_age_mode)

/**
 * Lets the id "admWeight" disappear according to the
 * settings in the field age_mode_decoy
 * @param fade_time the time used to fade it in/out
 */
function admWeightControl(fade_time) {
	if ($('[id$="age_mode_decoy"]').val() == "days") {
		$("#admWeight").show(fade_time);
	}
	else {
		$("#admWeight").hide(fade_time);
	}
}

function computeLos() {
	var first = parseDate($('#webgrouper_patient_case_entry_date').val())
	var second = parseDate($('#webgrouper_patient_case_exit_date').val())
	var leave_days = $('#webgrouper_patient_case_leave_days').val()
	var diff = daydiff(first, second, leave_days);
	if (!(isNaN(diff))){
		$('#webgrouper_patient_case_los').val(diff);
		disableLosInput(true);
	} else {
		disableLosInput(false);
	}	
}

function set_age_mode() {
	var decoy_age_mode = $('#webgrouper_patient_case_age_mode_decoy').val();
	$('#webgrouper_patient_case_age_mode').val(decoy_age_mode);
}


function computeAge() {
	if ($('#webgrouper_patient_case_birth_date').val() == "") {
		disableAgeInput(false);
		return;
	}
	var bd = parseDate($('#webgrouper_patient_case_birth_date').val());
	var today = new Date();
	var year_diff = Math.floor(Math.ceil(today - bd) / (1000 * 60 * 60 * 24 * 365));
	if (!(isNaN(year_diff)) && bd < today) {
		if (year_diff >= 1) {
			$('#webgrouper_patient_case_age_mode_decoy').val("years");
			set_age_mode();
			$('#webgrouper_patient_case_age').val(year_diff);
		}
		else {
			$('#webgrouper_patient_case_age_mode_decoy').val("days");
			set_age_mode();
			$('#webgrouper_patient_case_age').val(daydiff(bd, today, 0));
		}
		disableAgeInput(true);
		admWeightControl(500);
	}
	else {
		disableAgeInput(false);
		$('#webgrouper_patient_case_age').val("");
	}
}

/**
 * Disables or enables the input field for length of stay.
 * @param boolean doDisable
 */
function disableLosInput(doDisable) {
	if (doDisable) {
		$('#webgrouper_patient_case_los').prop('readonly', 'readonly');
	} else {
		$('#webgrouper_patient_case_los').prop('readonly', false);
	}
}

/**
 * Disables or enables the input of the two fields concerning age.
 * @param boolean doDisable
 */
function disableAgeInput(doDisable) {
	if (doDisable) {
		$('#webgrouper_patient_case_age').prop('readonly', 'readonly');
		$('#webgrouper_patient_case_age_mode_decoy').prop('disabled', true);
	} else {
		$('#webgrouper_patient_case_age').prop('readonly', false);
		$('#webgrouper_patient_case_age_mode_decoy').prop('disabled', false);
	}
}
function parseDate(str) {
    var mdy = str.split('.')
    return new Date(mdy[2], mdy[1]-1, mdy[0]-1);
}

function daydiff(first, second, leave_days) {
		return Math.floor(((second-first)/(1000*60*60*24))-leave_days)
}
