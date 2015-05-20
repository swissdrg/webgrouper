/** This file contains all JS functions required for adding and removing new fields for both secondary diagnoses and procedures
*/

$(document).ready(function () {
	if ($(".errorflash").is(":visible")) {
		var kinds = ["diagnoses", "procedures"]
		for (var i=0; i < kinds.length; i++) {
			var kind = kinds[i];
			$("#"+kind+" > .sameline > ."+kind+"_row:visible:last :input*").each(function () {
				if ($(this).val() != "" && $(".errorflash > ul >li:contains("+$(this).val()+")").length > 0) {
					$(this).css("background-color", "#FBE3E4");
				}
			});
		}
	}
    initialize_buttons();
});

/**
 * Initializes add/remove buttons for diagnoses and procedures.
 */
function initialize_buttons() {
    $("img.add_diagnoses_row").on("click", append_diagnoses_row);
    $("img.remove_diagnoses_row").on("click", remove_last_diagnoses_row);

    $("img.add_procedures_row").on("click", append_procedures_row);
    $("img.remove_procedures_row").on("click", remove_last_procedures_row);
}

function remove_last_row(rows) {
    if (rows.length > 1) {
        rows.last().remove();
    }
}

function remove_last_diagnoses_row(){
    remove_last_row($('.diagnoses_row'));
}

function remove_last_procedures_row(){
    remove_last_row($('.procedures_row'));
}

function append_row(rows) {
    prototype_row = rows.first();

    // Retrieve number in id of last input. We assume there is only one number in the whole id string.
    var ids = jQuery.map(rows.find('input'), function(e, i) { return parseInt(e.id.match(/\d+/i))});
    var last_id_number = Math.max.apply(Math, ids);

    var new_row = prototype_row.clone().insertAfter(rows.last());
    // Prepend an empty label for layout.
    $(new_row).prepend("<label></label>");

    // Remove unused autocomplete stuff, buttons
    $(new_row).find('.ui-helper-hidden-accessible').remove();
    $(new_row).find('.dynamic_field_buttons').remove();

    // Update ids and delete values, titles.
    // TODO: this does not fully work for procedures, since 3 inputs have the same id, but causes no issues right now.
    $(new_row).find('input, select').each(function () {
        var e = $(this);
        last_id_number++;
        var new_id = e.attr('id').replace(/\d+/i, last_id_number);
        e.attr("id", new_id);
        e.val('');
        e.attr("title", "");
    });
    $(new_row).find(".date_picker").each(function() {
        addDatePicker(this.id);
    });
    initializeAutocomplete();
}

function append_diagnoses_row() {
    append_row($('.diagnoses_row'));
}

function append_procedures_row() {
    append_row($('.procedures_row'));
}

