// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
	addDatePickers()
	admWeightControl(0);
	initializeAutocomplete()
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
  		event.target.value = data.item.label.split(" ", 1)[0];
  		event.target.title = data.item.IcName;
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


procedures_count = 0;
diagnoses_count = 0;

function add_fields(kind, content, value) {
	if (kind == "diagnoses") {
		var field_count = diagnoses_count;
	} else {
		var field_count = procedures_count;
	}
	var	array = value.replace("[", "").replace("]", "").split(",");
  var replaceID = new RegExp("ID", "");
	while(replaceID.test(content)) {
		if (kind == "diagnoses") {
			var real_value = "";
			if (array[field_count] != undefined) {
				var real_value = array[field_count].replace("\"", "").replace("\"", "");
			}
			content = content.replace("ID", field_count);
			content = content.replace("ID", field_count);
			content = content.replace("VALUE", real_value);
		} else {
			for(var i = 0; i < 3; i++) {
				var real_value = "";
				if (array[field_count] != undefined) {
					var real_value = array[field_count].replace("\"", "").replace("\"", "");
				}
				proc_values = real_value.split(":");
				var proc_value = "";
				if (proc_values[i] != undefined) {
					var proc_value = proc_values[i];
				}
				content = content.replace("ID", field_count);
				content = content.replace("ID", field_count);
				content = content.replace("VALUE", proc_value);
			}
		}
		field_count++;
	}
	$("#"+kind).append(content);
	if (kind == "diagnoses") {
		diagnoses_count = field_count;
	} else {
		procedures_count = field_count;
	}
	add_buttons(kind);
}

diag_add_button = "";
diag_remove_button = "";
function set_diagnoses_buttons(add_button, remove_button) {
	diag_add_button = add_button;
	diag_remove_button = remove_button;
}

proc_add_button = "";
proc_remove_button = "";
function set_procedures_buttons(add_button, remove_button) {
	proc_add_button = add_button;
	proc_remove_button = remove_button;
}

function get_add_button(kind) {
	if (kind == "diagnoses") {
		var add_button = diag_add_button;
	} else {
		var add_button = proc_add_button;
	}
	return add_button;
}

function get_remove_button(kind) {
	if (kind == "diagnoses") {
		var remove_button = diag_remove_button;
	} else {
		var remove_button = proc_remove_button;
	}
	return remove_button;
}

function add_buttons(kind) {
	$("#"+kind+" > .sameline > ."+kind+"_buttons").empty();
	if (kind == "diagnoses") {
		var field_count = diagnoses_count;
	} else {
		var field_count = procedures_count;
	}
	add_button = get_add_button(kind);
	remove_button = get_remove_button(kind);
	if (field_count < max_fields(kind)) {
		$("#"+kind+" > .sameline:last > ."+kind+"_buttons").append(add_button);
	};
	if (field_count > min_fields(kind)) {
		$("#"+kind+" > .sameline:last > ."+kind+"_buttons").append(remove_button);
	};
}

function max_fields (kind) {
	if (kind == "diagnoses") {
		return 99;
	} else {
		return 100;
	}
}

function min_fields (kind) {
	if (kind == "diagnoses") {
		return 5;
	} else {
		return 3;
	}
}

function remove_fields(kind) {
	if (kind == "diagnoses") {
		var field_count = diagnoses_count;
	} else {
		var field_count = procedures_count;
	}
	var field_count = field_count - $("#"+kind+" > .sameline > ."+kind+"_row:visible:last > .field").length;
	$("#"+kind+" > .sameline > ."+kind+"_row:visible:last > input").val("");
	$("#"+kind+" > .sameline:visible:last").remove();
	if (kind == "diagnoses") {
		diagnoses_count = field_count;
	} else {
		procedures_count = field_count;
	}
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

