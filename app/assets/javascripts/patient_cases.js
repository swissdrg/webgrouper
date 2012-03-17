// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
	addDatePickers()
	admWeightControl(0);
	disableTabForLinks();
});


/**
 * Kinda funny, but doesn't work for all browsers
 */
function disableTabForLinks() {
	$('a').each(function() {
	    this.setAttribute( 'tabindex', '-1' );
	});
}
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
