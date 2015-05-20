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
    initialize_buttons($('.diagnoses_row'));
});

/**
 * Fills the given diagnoses into the input fields in the form.
 * @param diagnoses_array
 */
function initialize_diagnoses(diagnoses_array) {
    var i = 0;
    $('input.diagnosis').each(function() {
        if (i < diagnoses_array.length) {
            this.value = diagnoses_array[i];
        }
        else {
            this.value = '';
        }
        i++;
    });
}

var regex = /^(.*)(\d)+$/i;
var cloneIndex = $(".clonedInput").length;

function clone(){
    $(this).parents(".clonedInput").clone()
        .appendTo("body")
        .attr("id", "clonedInput" +  cloneIndex)
        .find("*")
        .each(function() {
            var id = this.id || "";
            var match = id.match(regex) || [];
            if (match.length == 3) {
                this.id = match[1] + (cloneIndex);
            }
        })
    cloneIndex++;
}

function pop_diagnoses_row(){
    rows = $('.diagnoses_row');
    if (rows.length > 1)
        rows.last().remove();
}

function append_diagnoses_row() {
    prototype_diagnoses_row = $('.diagnoses_row').first();

    // Retrieve number in id of last diagnosis input.
    var ids = jQuery.map($('input.diagnosis'), function(e, i) { return parseInt(e.id.match(/\d+$/i))});
    var id_without_number = 'webgrouper_patient_case_diagnoses_';
    var last_id_number = Math.max.apply(Math, ids);

    var new_row = prototype_diagnoses_row.clone().insertAfter(prototype_diagnoses_row);
    // Prepend an empty label for layout.
    $(new_row).prepend("<label></label>");

    // Update id's:
    $(new_row).find($('input.diagnosis')).each(function() {
        last_id_number++;
        $(this).attr("id", id_without_number + last_id_number);
        console.log(id_without_number + last_id_number);
    });

    initialize_buttons(new_row);
}

/**
 * Initializes add/remove buttons for diagnoses in the children of the given node.
 */
function initialize_buttons(parent_node) {
    parent_node.find("img#add_diagnoses_row").on("click", append_diagnoses_row);
    parent_node.find("img#remove_diagnoses_row").on("click", pop_diagnoses_row);
}
