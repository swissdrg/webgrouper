/**
 * Initializer & general stuff for the form is here in this file
 */
$(document).ready(function() {
	initializeDatePickers();
	initializeForm();
	admWeightControl(0);
	initializeAutocomplete();
	goToResult();
});

$("#system_SyID").live("change", function () {
	this.form.submit();
});

function initializeForm() {
	$(".numeric").numeric({ negative : false });
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


