// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
	//should find everything einding in "date"
	$("[id$='_date']").each(function() {
		var form_id = this.id;
		var eles = {};
		eles[form_id] = "d-m-Y";
		datePickerController.createDatePicker({formElements: eles});
	});
});