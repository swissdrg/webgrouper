// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
	addDatePickers()
	admWeightControl(0);
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


var procedures_count = 0;
var diagnoses_count = 0;

function add_fields(kind, content, value) {
	if (kind == "diagnoses") {
		field_count = diagnoses_count;
	} else {
		field_count = procedures_count;
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
	if (kind == "diagnoses") {
		diagnoses_count = field_count;
	} else {
		procedures_count = field_count;
	}
	$("#"+kind).append(content);
}

function remove_fields(kind) {
		$("#"+kind+" > ."+kind+"_row:visible:last > input").val("");
		$("#"+kind+" > ."+kind+"_row:visible:last").hide();
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

