/**
 * Everything that modifies values in the form or the form itself 
 * belongs here. 
 * (Except the javascripts concerning the dynamic creation of fields for diagnoses and procedures.)
 * 
 * Some of these javascripts also use translations. See config/i18n-js.yml for how to access more translations.
 */

/** Some bindings */
$(document).on("change focus blur", "#webgrouper_patient_case_birth_date", computeAge);
$(document).on("change focus blur", ".calc_los", computeLos);
$(document).on("change focus blur", '#webgrouper_patient_case_age_mode_decoy', set_age_mode);

/** submit form if these values are changed */
$(document).on("change", "#webgrouper_patient_case_system_id", function () {
	this.form.submit();
});
$(document).on("change", "#batchgrouper_system_id", function () {
	this.form.submit();
});
$(document).on("change", "#webgrouper_patient_case_house", function () {
	this.form.submit();
});

/**
 * Lets the id "admWeight" disappear according to the
 * settings in the field age_mode_decoy
 * @param fade_time the time used to fade it in/out
 */
function admWeightControl(fade_time) {
	if ($("#webgrouper_patient_case_age_mode_decoy").val() == "days") {
		$("#admWeight").show(fade_time);
	}
	else {
		$("#admWeight").hide(fade_time);
	}
}

function set_age_mode() {
	var decoy_age_mode = $('#webgrouper_patient_case_age_mode_decoy').val();
	$('#webgrouper_patient_case_age_mode').val(decoy_age_mode);
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
	computeAge();
}


function computeAge() {
	if ($('#webgrouper_patient_case_birth_date').val() == "") {
		disableAgeInput(false);
		return;
	}
	var bd = parseDate($('#webgrouper_patient_case_birth_date').val());
	
	var entry_date = parseDate($('#webgrouper_patient_case_entry_date').val());
	
	var year_diff = Math.floor(daydiff(bd, entry_date, 0)/365);
	if (bd != null) {
		if (year_diff >= 1) {
			$('#webgrouper_patient_case_age_mode_decoy').val("years");
			set_age_mode();
			$('#webgrouper_patient_case_age').val(year_diff);
		}
		else if (year_diff < 1) {
			$('#webgrouper_patient_case_age_mode_decoy').val("days");
			set_age_mode();
			$('#webgrouper_patient_case_age').val(daydiff(bd, entry_date, 0));
		} else {
			//in case of NaN, fill with nothing
			$('#webgrouper_patient_case_age').val("");
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
	var tooltip = I18n.t("simple_form.hints.webgrouper_patient_case.disabled_los");
	var $los = $('#webgrouper_patient_case_los')
	if (doDisable) {
		$los.prop('readonly', 'readonly');
		$los.prop('title', tooltip);
	} else {
		$los.prop('readonly', false);
		$los.prop('title', "");
	}
}

/**
 * Disables or enables the input of the two fields concerning age.
 * @param boolean doDisable
 */
function disableAgeInput(doDisable) {
	var $age = $('#webgrouper_patient_case_age')
	var $age_decoy = $('#webgrouper_patient_case_age_mode_decoy')
	if (doDisable) {
		var tooltip = I18n.t("simple_form.hints.webgrouper_patient_case.disabled_age");
		$age.prop('readonly', 'readonly');
		$age.prop('title', tooltip);
		$age_decoy.prop('disabled', true);
		$age_decoy.prop('title', tooltip);
	} else {
		$age.prop('readonly', false);
		$age.prop('title', "");
		$age_decoy.prop('disabled', false);
		$age_decoy.prop('title', "");
	}
}
function parseDate(str) {
	return $.datepicker.parseDate("dd.mm.yy", str)
}

function daydiff(first, second, leave_days) {
	if (first == null || second == null)
		return Number.NaN
	var diffMiliSec = second-first;
	diffMiliSec+=2*1000*60*60 // plus to hours to account for Summer/Wintertime
	diffDays = Math.floor((diffMiliSec/(1000*60*60*24))-leave_days)
	if (diffDays == 0) {
		return 1
	}
	else {
		return diffDays
		}
}
