// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
	addDatePickers();
	admWeightControl(0);
	initializeAutocomplete();
	goToResult();
});

$("#system_SyID").live("change keyup", function () {
	this.form.submit();
});

$(".calc_los").live("focus change", function() {
	var first = parseDate($('#webgrouper_patient_case_entry_date').val())
	var second = parseDate($('#webgrouper_patient_case_exit_date').val())
	var leave_days = $('#webgrouper_patient_case_leave_days').val()
	var diff = daydiff(first, second, leave_days);
	if (!(isNaN(diff))){
		$('#webgrouper_patient_case_los').val(diff);
		flashYellow($("#webgrouper_patient_case_los"),'transparent',75,20,4 );
	}
});

$("#webgrouper_patient_case_birth_date").live("focus change", function() {
	if ($('#webgrouper_patient_case_birth_date').val() == "") {
		return;
	}
	var bd = parseDate($('#webgrouper_patient_case_birth_date').val());
	var today = new Date();
	var year_diff = Math.floor(Math.ceil(today - bd) / (1000 * 60 * 60 * 24 * 365));
	if (!(isNaN(year_diff)) && bd < today) {
		if (year_diff >= 1) {
			$('#webgrouper_patient_case_age_mode').val("year");
			$('#webgrouper_patient_case_age').val(year_diff);
		}
		else {
			$('#webgrouper_patient_case_age_mode').val("days");
			$('#webgrouper_patient_case_age').val(daydiff(bd, today, 0));
		}
		admWeightControl(500);
	}
	else {
		$('#webgrouper_patient_case_age').val("");
	}
	flashYellow($("#webgrouper_patient_case_age_mode"),'transparent',75,20,4 );
	flashYellow($("#webgrouper_patient_case_age"),'transparent',75,20,4 );
});

/**
 * This method binds an alternative update method to every autocomplete field, so that
 * only the code itself is put into the field.
 * It also adds the name as title, making it available to see in a tooltip.
 */
function initializeAutocomplete() {
	$(':input.autocomplete').bind('railsAutocomplete.select', function(event, data){
		splitPos = data.item.label.search(" ");
  		event.target.value = data.item.label.substring(0, splitPos);
  		event.target.title = data.item.label.substring(splitPos + 1);
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
 * Lets the id "admWeight" disappear according to the
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
	while(replaceID.test(field_row)) {
		if (kind == "diagnoses") {
			var field_row = replace_diagnoses(field_count, value_array, field_row);
		} else {
			var field_row = replace_procedures(field_count, value_array, field_row);
		}
		field_count++;
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
 * Appends the field_row to the div with id "#"+kind'.
 * The function prepends an empty label-tag if the field_row
 * @param kind the kind of fields (diagnoses/procedures).
 * @param field_row the fields to be added to the div with id '"#"+kind'.
*/
function append_field_row (kind, field_row, field_count) {
	$("#"+kind).append(field_row);
	if (field_count > min_fields(kind)) {
		$("#"+kind+" > .sameline > ."+kind+"_row:visible:last").before('<label><label\>')
	};
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
	var real_value = initialize_value(value_array, field_count);
	field_row = field_row.replace("ID", field_count);
	field_row = field_row.replace("ID", field_count);
	field_row = field_row.replace("VALUE", real_value);
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
	for(var i = 0; i < 3; i++) {
		var real_value = initialize_value(value_array, field_count);
		var proc_values = real_value.split(":");
		var proc_value = "";
		if (proc_values[i] != undefined) {
			var proc_value = proc_values[i];
		}
		field_row = field_row.replace("ID", field_count);
		field_row = field_row.replace("ID", field_count);
		if (i == 1) {
			var temp_field_array = new Array();
			var to_replace = new RegExp("<option value=\""+proc_value+"\">"+proc_value+"</option>");
			var end_select = new RegExp("<\/select>");
			var replacement = "<option value=\""+proc_value+"\" selected=\"selected\">"+proc_value+"</option>";
			temp_field_array = field_row.split(end_select);
			for (var i = temp_field_array.length - 1; i >= 0; i--){
				alert(temp_field_array[i]);
			};
		} else {
			field_row = field_row.replace("VALUE", proc_value);	
		};
	};
	return field_row;
}

// function replaceAt (field_row, regexp_to_replace, replacement, occurence) {
// 	var match_count = 0;
// 	var temp_row = field_row;
// 
// 	
// 		alert("startIndex: "+startIndex.index)
// 		
// 		
// 		alert("ARRAY with "+replacement+": "+temp_field_array[i]);
// 		alert("remaining row: "+field_row);
// 	}
// 	for (var i = 0; i < temp_field_array.length; i++) {
// 		field_row += temp_field_array[i];
// 	}
// 	return field_row;
// }

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

function parseDate(str) {
    var mdy = str.split('.')
    return new Date(mdy[2], mdy[1]-1, mdy[0]-1);
}

function daydiff(first, second, leave_days) {
		return Math.floor(((second-first)/(1000*60*60*24))-leave_days)
}

/**
 * To highlight an element for a short time, this method will
 * change it's color to yellow for a short time and then fade it back to 
 * the background color.
 */
function flashYellow(elem,finalColor,steps,intervals,powr) {
	var startRGB = [245,255,159]
	var endRGB = [255,255,255]
    if (elem.bgFadeInt) window.clearInterval(elem.bgFadeInt);
    var actStep = 0;
    elem.bgFadeInt = window.setInterval(
        function() {
                elem.css("backgroundColor", "rgb("+
                        easeInOut(startRGB[0],endRGB[0],steps,actStep,powr)+","+
                        easeInOut(startRGB[1],endRGB[1],steps,actStep,powr)+","+
                        easeInOut(startRGB[2],endRGB[2],steps,actStep,powr)+")"
                );
                actStep++;
                if (actStep > steps) {
                elem.css("backgroundColor", finalColor);
                window.clearInterval(elem.bgFadeInt);
                }
        }
        ,intervals)
}

/**
 * Helper method for flashYellow
 */
function easeInOut(minValue,maxValue,totalSteps,actualStep,powr) {
    var delta = maxValue - minValue;
    var stepp = minValue+(Math.pow(((1 / totalSteps)*actualStep),powr)*delta);
    return Math.ceil(stepp)
}

function goToResult(){
	if ($("#result").length) {
		jQuery('html,body').animate({
			scrollTop: $("#result").offset().top - 100
		},'slow');
	};
}

