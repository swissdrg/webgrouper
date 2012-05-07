// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
	initializeDatePickers();
	admWeightControl(0);
	initializeAutocomplete();
	goToResult();
});

$("#system_SyID").live("change keyup", function () {
	this.form.submit();
});

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


procedures_fields_count = 0;
diagnoses_fields_count = 0;

/**
 * Adds diagnoses and procedures fields dynamically to the page
 * and increases the field_count for the specified kind of fields.
 * @param kind the kind of fields (diagnoses/procedures).
 * @param field_row the fields to be added.
 * @param value the value to be displayed in the fields.
 * value is needed to display previously entered information after page reload.
 * value is entered as a comma-seperated string (should be json, but is not...).
 */
function add_fields(kind, field_row, value) {
	var field_count = get_field_count(kind);	
	var	value_array = value.replace("[", "").replace("]", "").split(",");
  	var replaceID = new RegExp("ID", "");
	if (kind == "diagnoses") {
		var field_row = replace_diagnoses(field_count, value_array, field_row);
		field_count += 5;
	} else {
		var field_row = replace_procedures(field_count, value_array, field_row);
		field_count += 3;
	}
	append_field_row(kind, field_row, field_count);
	set_field_count(kind, field_count);
	add_buttons(kind);
}

/**
 * Removes the buttons from all field_rows and then appends the correct buttons behind the previously added field_row.
 * If the affected field_row is the first row of this kind, only the add_button will be appended.
 * If the affected field_row is the highest field_row of this kind, only the remove_button will be appended.
 * The highest field_row is defined in #max_fields.
 * @param kind the kind of fields to append the buttons to (diagnoses/procedures).
 * @see min_fields(), max_fields()
*/
function add_buttons(kind) {
	var field_count = get_field_count(kind);
	var add_button = get_add_button(kind);
	var remove_button = get_remove_button(kind);
	$("#"+kind+" > .sameline > ."+kind+"_buttons").empty();
	if (field_count < max_fields(kind)) {
		$("#"+kind+" > .sameline:last > ."+kind+"_buttons").append(add_button);
	};
	if (field_count > min_fields(kind)) {
		$("#"+kind+" > .sameline:last > ."+kind+"_buttons").append(remove_button);
	};
}

/**
 * Appends the field_row to the div with id '"#"+kind'.
 * The function prepends an empty label-tag if the field_row
 * @param kind the kind of fields (diagnoses/procedures).
 * @param field_row the fields to be added to the div with id '"#"+kind'.
*/
function append_field_row (kind, field_row, field_count) {
	$("#"+kind).append(field_row);
	if (field_count > min_fields(kind)) {
		$("#"+kind+" > .sameline > ."+kind+"_row:visible:last").before('<label><label\>')
	};
	$("#"+kind+" > .sameline > ."+kind+"_row:visible:last :input.autocomplete").bind('railsAutocomplete.select', function(event, data){
		splitPos = data.item.label.search(" ");
	  		event.target.value = data.item.label.substring(0, splitPos);
	  		event.target.title = data.item.label.substring(splitPos + 1);
	});
	$("#"+kind+" > .sameline > ."+kind+"_row:visible:last .date_picker").each(function() {
		addDatePicker(this.id);
	});
}

/**
 * Replaces the placeholders in the field_row string with the real ids and values.
 * This is needed in order to have the right ids for form submission and display previously entered information.
 * @param field_count counter for all fields of this kind. is used as field_id.
 * @param value_array array of values needed to display previously entered diagnoses.
 * @param field_row the diagnoses_fields to be displayed. The field_row string contains placeholders "ID" and "VALUE" which are replaced.
 * @return the field_row with real id's and correct value.
*/
function replace_diagnoses (field_count, value_array, field_row) {
	var id = new RegExp("ID", "g");
	var value = new RegExp("VALUE", "g");
	
	// split field_row in seperate fields
	var splitter = new RegExp("<span class='splitter'>*<\/span>");
	var temp_field_array = field_row.split(splitter);
	
	// iterate through each field and replace id and value placeholders
	for (var i=0; i < 5; i++) {
		var real_value = initialize_value(value_array, field_count+i);
		temp_field_array[i] = temp_field_array[i].replace(id, field_count+i);
		temp_field_array[i] = temp_field_array[i].replace(value, real_value);
	};
	
	// add fields back together to form complete field_row
	field_row = "";
	for(var i = 0; i < 6; i++) {
		field_row += temp_field_array[i];
	};
	return field_row;
}

/**
 * Replaces the placeholders in the field_row string with the real ids and values.
 * This is needed in order to have the right ids for form submission and display previously entered information.

 * Procedures are composed of three fields, thats why this method needs a to iterate over the value_array three times to fill in all information.
 * @param field_count counter for all fields of this kind. is used as field_id.
 * @param value_array array of values needed to display previously entered procedures.
 * @param field_row the procedures_fields to be displayed. The field_row string contains placeholders "ID" and "VALUE" which are replaced.
 * @return the field_row with real id's and correct value.
*/
function replace_procedures (field_count, value_array, field_row) {
	var id = new RegExp("ID", "g");
	
	var splitter = new RegExp("<span class='splitter'>*<\/span>");
	var temp_field_array = field_row.split(splitter);
	
	for(var i = 0; i < 3; i++) {
		var real_value = initialize_value(value_array, field_count+i);
		var proc_values = real_value.split(":");
		temp_field_array[i] = temp_field_array[i].replace(id, field_count+i);
		
		for(var j = 0; j < 3; j++) {
			if (proc_values[j] == undefined) {
				proc_values[j] = "";
			};
		};
		temp_field_array[i] = temp_field_array[i].replace("VALUE", proc_values[0]);
		var seitigkeit_value = "<option value=\""+proc_values[1]+"\">"+proc_values[1]+"</option>";
		var seitigkeit_selected = "<option value=\""+proc_values[1]+"\" selected=\"selected\">"+proc_values[1]+"</option>";
		temp_field_array[i] = temp_field_array[i].replace(seitigkeit_value, seitigkeit_selected);
		temp_field_array[i] = temp_field_array[i].replace("VALUE", proc_values[2]);
	};
	field_row = "";
	for(var i = 0; i < 4; i++) {
		field_row += temp_field_array[i];
	};
	return field_row;
}

/**
 * Helper method to parse the value_array and return the correct value for one input field.
 * @param value_array string array which contains the values for all previouly submitted values of this kind.
 * @param field_count counter for the fields of this kind, used as array index.
 * @return the real value to be displayed in a field, stripped of ""'s.
*/
function initialize_value (value_array, field_count) {
	var real_value = "";
	if (value_array[field_count] != undefined) {
		var real_value = value_array[field_count].replace("\"", "").replace("\"", "");
	}
	return real_value;
}

/**
 * Helper method to get the correct field_count based on the kind of fields.
 * @param kind the kind of fields (diagnoses/procedures).
 * @return field_count for either the diagnoses_fields or the procedures_fields.
*/
function get_field_count (kind) {
	return (kind == "diagnoses") ? diagnoses_fields_count : procedures_fields_count;
}

/**
 * Helper method to write the changed field_count back to the correct global variable, based on the kind of fields.
 * @param kind the kind of fields (diagnoses/procedures).
 * @param field_count the incremented/decremented field_count to be written back to one of the global counters.
 * @see diagnoses_fields_count, procedures_fields_count
*/
function set_field_count (kind, field_count) {
	(kind == "diagnoses") ? diagnoses_fields_count = field_count : procedures_fields_count = field_count;
}

diag_add_button = "";
diag_remove_button = "";
proc_add_button = "";
proc_remove_button = "";

/**
 * Setter for global variables which contain the buttons to add/remove diagnoses_fields.
 * @param add_button the button to add diagnoses_fields.
 * @param remove_button the button to remove diagnoses_fields.
*/
function set_diagnoses_buttons(add_button, remove_button) {
	diag_add_button = add_button;
	diag_remove_button = remove_button;
}

/**
 * Setter for global variables which contain the buttons to add/remove procedures_fields.
 * @param add_button the button to add procedures_fields.
 * @param remove_button the button to remove procedures_fields.
*/
function set_procedures_buttons(add_button, remove_button) {
	proc_add_button = add_button;
	proc_remove_button = remove_button;
}


/**
 * Helper method to get the correct add_button based on the kind of fields.
 * @param kind the kind of fields (diagnoses/procedures).
 * @return the button to add fields, either diagnoses_fields or procedures_fields.
*/
function get_add_button(kind) {
	return (kind == "diagnoses") ? diag_add_button : proc_add_button;
}

/**
 * Helper method to get the correct remove_button based on the kind of fields.
 * @param kind the kind of fields (diagnoses/procedures).
 * @return the button to remove fields, either diagnoses_fields or procedures_fields.
*/
function get_remove_button(kind) {
	return (kind == "diagnoses") ? diag_remove_button : proc_remove_button;
}

/**
 * Helper method, returns the maximal allowed number of fields per kind.
 * @param kind the kind of fields (diagnoses/procedures).
 * @return the maximal allowed number of fields per kind.
*/
function max_fields (kind) {
	return (kind == "diagnoses") ? 99 : 100;
}

/**
 * Helper method, returns the minimal number of fields to be displayed always. This is equal to the number of fields in one field_row.
 * @param kind the kind of fields (diagnoses/procedures).
 * @return the minimal number of fields to be constantly displayed.
*/
function min_fields (kind) {
	return (kind == "diagnoses") ? 5 : 3;
}

/**
 * Remove the fields dynamically from the form.
 * The last visible row of fields based on the kind is removed from the page and the field_count decreased.
 * @param kind the kind of fields to remove (diagnoses/procedures).
*/
function remove_fields(kind) {
		var field_count = get_field_count(kind);
	// decrease the field_count by the number of 'fields' per field_row.
	// NOTE: for procedures, the combination of three fields needed for one procedure counts as one 'field'.
	var field_count = field_count - $("#"+kind+" > .sameline > ."+kind+"_row:visible:last > .field").length;
	$("#"+kind+" > .sameline:visible:last").remove();
	set_field_count(kind, field_count);
	add_buttons(kind);
}
