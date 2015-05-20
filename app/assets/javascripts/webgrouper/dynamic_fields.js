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

function pop_diagnoses_row(){
    rows = $('.diagnoses_row');
    if (rows.length > 1) {
        rows.last().remove();
        $('.diagnoses_row').last().find('img').show();
    }
}

function append_diagnoses_row() {
    prototype_diagnoses_row = $('.diagnoses_row').first();

    // Retrieve number in id of last diagnosis input.
    var ids = jQuery.map($('input.diagnosis'), function(e, i) { return parseInt(e.id.match(/\d+$/i))});
    var id_without_number = 'webgrouper_patient_case_diagnoses_';
    var last_id_number = Math.max.apply(Math, ids);

    var new_row = prototype_diagnoses_row.clone().insertAfter($('.diagnoses_row').last());
    // Prepend an empty label for layout.
    $(new_row).prepend("<label></label>");

    // Update ids and delete values.
    $(new_row).find($('input.diagnosis')).each(function() {
        last_id_number++;
        $(this).attr("id", id_without_number + last_id_number);
        $(this).attr("value", "");
    });
    $(new_row).find('.diagnoses_buttons').remove();
    initializeAutocomplete();
}

/**
 * Initializes add/remove buttons for diagnoses in the children of the given node.
 */
function initialize_buttons() {
    $("img.add_diagnoses_row").on("click", append_diagnoses_row);
    $("img.remove_diagnoses_row").on("click", pop_diagnoses_row);
}
