/**
 * This method binds an alternative update method to every autocomplete field, so that
 * only the code itself is put into the field.
 * It also adds the name as title, making it available to see in a tooltip.
 */
function initializeAutocomplete() {
    $('.autocomplete:input').bind('railsAutocomplete.select', function(event, data){
        if (data.item.label === "no existing match") {
            event.target.value = "";
            event.target.title = "";
        }
        else {
            event.target.value = data.item.code;
            event.target.title = data.item.text;
        }
    });
}