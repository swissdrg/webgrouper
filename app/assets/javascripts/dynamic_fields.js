/** This file contains all JS functions required for adding and removing new fields for both secondary diagnoses and procedures
*/


/**
 * Counter for the number of diagnoses fields that are visible.
 * This is needed to know when to display which add-/removebuttons beneath the diagnoses fields.
*/
diagnoses_fields_count = 0;

/**
 * Counter for the number of procedures fields that are visible.
 * This is needed to know when to display which add-/remove buttons beneath the procedures fields.
*/
procedures_fields_count = 0;

/**
 * Stores the HTML code for the add_diagnoses button. The variable is initialized on page load in index.html.haml
*/
diag_add_button = "";
/**
 * Stores the HTML code for the remove_diagnoses button. The variable is initialized on page load in index.html.haml
*/
diag_remove_button = "";
/**
 * Stores the HTML code for the add_procedures button. The variable is initialized on page load in index.html.haml
*/
proc_add_button = "";
/**
 * Stores the HTML code for the remove_procedures button. The variable is initialized on page load in index.html.haml
*/
proc_remove_button = "";

/**
 * Adds diagnoses and procedures fields dynamically to the page
 * and increases the field_count for the specified kind of fields.
 * The field_row is split into an array containing the HTML code for each field.
 * This array is then modified, depending on the kind of fields. 
 * @param kind the kind of fields (diagnoses/procedures).
 * @param field_row the fields to be added.
 * @param value the value to be displayed in the fields.
 * value is needed to display previously entered information after page reload.
 * value is entered as a comma-seperated string (should be json, but is not...).
 */
function add_fields(kind, field_row, value) {
	var field_count = get_field_count(kind);
	
	// split the values into array
	var	value_array = value.replace("[", "").replace("]", "").split(",");
	
	// split field_row in seperate fields
	var splitter = new RegExp("<span class='splitter'>*<\/span>");
	var field_array = field_row.split(splitter);
	
	if (kind == "diagnoses") {
		field_array = replace_diagnoses(field_count, value_array, field_array);
		field_count += 5;
	} else {
		field_array = replace_procedures(field_count, value_array, field_array);
		field_count += 3;
	}
	
	var field_row = reassemble_field_row(field_array);
	append_field_row(kind, field_row, field_count);
	set_field_count(kind, field_count);
	add_buttons(kind);
}

/**
 * Removes the fields dynamically from the form.
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

/**
 * Replaces the placeholders in the field_row string with the real ids and values.
 * This is needed in order to have the right ids for form submission and display previously entered information (as values in input fields).
 * @param field_count counter for all fields of this kind. is used as field_id.
 * @param value_array array of values needed to display the previously entered diagnoses.
 * @param field_array the diagnoses_fields to be displayed. The field_array contains multiple strings of HTML code
 * (each field) which contain placeholders "ID" and "VALUE" which are replaced.
 * @return the field_row with real id's and correct value.
*/
function replace_diagnoses (field_count, value_array, field_array) {
	var id = new RegExp("ID", "g");
	var value = new RegExp("VALUE", "g");
		
	// iterate through each field and replace id and value placeholders
	for (var i=0; i < 5; i++) {
		var real_value = initialize_value(value_array, field_count+i);
		field_array[i] = field_array[i].replace(id, field_count+i);
		field_array[i] = field_array[i].replace(value, real_value);
	};
	
	return field_array;
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
function replace_procedures (field_count, value_array, field_array) {
	var id = new RegExp("ID", "g");
	
	// iterate through all procedure fields and replace ID and VALUE placeholders with the real id's and values
	for(var i = 0; i < 3; i++) {
		var proc_triplet = initialize_value(value_array, field_count+i);
		var proc_values = initialize_proc_values(proc_triplet)
		
		// replace ID placeholder with the real id for this field
		field_array[i] = field_array[i].replace(id, field_count+i);
		
		// replace the procedure code
		field_array[i] = field_array[i].replace("VALUE", proc_values[0]);
		// set the preselected option for select_tag 'seitigkeit'
		var seitigkeit_value = "<option value=\""+proc_values[1]+"\">"+proc_values[1]+"</option>";
		var seitigkeit_selected = "<option value=\""+proc_values[1]+"\" selected=\"selected\">"+proc_values[1]+"</option>";
		field_array[i] = field_array[i].replace(seitigkeit_value, seitigkeit_selected);
		// replace the date
		field_array[i] = field_array[i].replace("VALUE", proc_values[2]);
	};

	return field_array;
}

/**
 * Appends the field_row to the div with id '"#"+kind'.
 * The function prepends an empty label-tag if the field_row
 * @param kind the kind of fields (diagnoses/procedures).
 * @param field_row the fields to be added to the div with id '"#"+kind'.
*/
function append_field_row (kind, field_row, field_count) {
	$("#"+kind).append(field_row);
	
	// prepend empty label if nessecary to ensure layout is not broken
	if (field_count > min_fields(kind)) {
		$("#"+kind+" > .sameline > ."+kind+"_row:visible:last").before('<label><label\>')
	};
	
	// bind autocomplete function to field which sets only the diagnoses/procedures code as value instead of whole string with description
	$("#"+kind+" > .sameline > ."+kind+"_row:visible:last :input.autocomplete").bind('railsAutocomplete.select', function(event, data){
		splitPos = data.item.label.search(" ");
	  		event.target.value = data.item.label.substring(0, splitPos);
	  		event.target.title = data.item.label.substring(splitPos + 1);
	});
	
	// add datepicker to procedure date fields
	$("#"+kind+" > .sameline > ."+kind+"_row:visible:last .date_picker").each(function() {
		addDatePicker(this.id);
	});
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
	// remove all add-/remove buttons for this kind of fields
	$("#"+kind+" > .sameline > ."+kind+"_buttons").empty();
	
	if (field_count < max_fields(kind)) {
		$("#"+kind+" > .sameline:last > ."+kind+"_buttons").append(add_button);
	};
	if (field_count > min_fields(kind)) {
		$("#"+kind+" > .sameline:last > ."+kind+"_buttons").append(remove_button);
	};
}

/**
 * Helper method which takes the array with the seperated fields and puts them back together to one row.
 * @param field_arrray the array containing the fields and the div reserved for the buttons.
 * @return the complete field_row, a string of HTML, containing all fields and buttons, to be rendered on the page.
*/ 
function reassemble_field_row (field_array) {
	var field_row = "";
	for(var i = 0; i < field_array.length; i++) {
		field_row += field_array[i];
	};
	return field_row
}

/**
 * Helper method to parse the value_array and return the correct value for one input field.
 * @param value_array string array which contains the values for all previouly submitted values of this kind.
 * @param field_count counter for the fields of this kind, used as array index.
 * @return for diagnoses: the real value to be displayed in a field, stripped of ""'s.
 * 		   for procedures: a triplet of the form <proc_code:'seitigkeit':date>
*/
function initialize_value (value_array, field_count) {
	var real_value = "";
	if (value_array[field_count] != undefined) {
		var real_value = value_array[field_count].replace("\"", "").replace("\"", "");
	}
	return real_value;
}

/** 
 * Helper method to split the proc_triplet into array containing the code, 'seitigkeit' and date of a procedure
 * the proc_triplet has the form <proc_code:'seitigkeit':date>
 * this triplet is then split into an array to be used in #replace_procedures
 * if one value is undefined, it will be replaced by an empty string ""
 * @param proc_triplet the triplet containing the information for a procedure
 * @return array with three elements: proc_code, 'seitigkeit', date
*/
function initialize_proc_values (proc_triplet) {
	var proc_values = proc_triplet.split(":");
	for(var i = 0; i < 3; i++) {
		if (proc_values[i] == undefined) {
			proc_values[i] = "";
		};
	};
	return proc_values
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
