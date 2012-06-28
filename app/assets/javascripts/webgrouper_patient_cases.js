/**
 * Initializer & general stuff for the form is here in this file
 */
$(document).ready(function() {
	initializeDatePickers();
	initializeForm();
	admWeightControl(0);
	initializeAutocomplete();
	goToResult();
	addZebraStripes();
});

$("#webgrouper_patient_case_system_id").live("change", function () {
	this.form.submit();
});

/**
 * Adds classes to the rows of the tables.
 * This is only a fix for IE < 9, but not used by other browsers.
 */
function addZebraStripes() {
	$("table tbody tr:nth-child(even)").addClass("even");
}

/**
 * Initializes certain fields in the form, which only allow a
 * certain kind of input of have to be disabled.
 */
function initializeForm() {
	$(".numeric").numeric({ decimal: false, negative: false });
	computeAge();
	computeLos();
}
/**
 * This method binds an alternative update method to every autocomplete field, so that
 * only the code itself is put into the field.
 * It also adds the name as title, making it available to see in a tooltip.
 */
function initializeAutocomplete() {
	$('#webgrouper_patient_case_pdx:input').bind('railsAutocomplete.select', function(event, data){
		splitPos = data.item.label.search(" ");
  		event.target.value = data.item.label.substring(0, splitPos);
  		event.target.title = data.item.label.substring(splitPos + 1);
	});
}


