/**
 * Everything related to the datepicker goes here.
 * The javascript of the datepicker itself can be found under vendor/assets/javascripts
 */

/**
 * Adds date pickers to every input field of the class "date_picker"
 */
function initializeDatePickers() {
	$(".date_picker").each(function() {
		addDatePicker(this.id);
	});
}

/**
 * Adds a date picker to the field with the given id
 * The format of the date picker is DD.MM.YYYY (eg 15.04.2011)
 * @param id the id of the field you want to add a datepicker
 */
function addDatePicker(id) {
	var eles = {};
	eles[id] = "d-dt-m-dt-Y";
	datePickerController.createDatePicker({formElements: eles});
}

