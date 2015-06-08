/**
 * Initializer & general stuff for the form is here in this file
 */
$(document).ready(function() {
	initializeDatePickers();
	initializeForm();
	admWeightControl(0);
	initializeAutocomplete();
	goToResult();
	addZebraStripes();
    initialize_buttons();

    /*
     * Turns links with class jQueryBookmark into bookmarking-links
     */
    $("a.jQueryBookmark").click(function(e){
        e.preventDefault(); // this will prevent the anchor tag from going the user off to the link
        var bookmarkUrl = this.href;
        var bookmarkTitle = this.title;

        if (window.sidebar && window.sidebar.addPanel) { // For Mozilla Firefox Bookmark
            window.sidebar.addPanel(bookmarkTitle, bookmarkUrl,"");
        } else if( window.external && document.all) { // For IE Favorite
            window.external.AddFavorite( bookmarkUrl, bookmarkTitle);
        } else if(window.opera && window.print) { // For Opera Browsers
            $("a.jQueryBookmark").attr("href",bookmarkUrl);
            $("a.jQueryBookmark").attr("title",bookmarkTitle);
            $("a.jQueryBookmark").attr("rel","sidebar");
        } else { // for other browsers which does not support
            alert('Your browser does not support this bookmark action, ' +
                'please add a bookmark manually by pressing ctrl + D');
            window.location = bookmarkUrl;
            return false;
        }
    });

    // Capture flash popup and display as Jquery UI Dialog
    $( ".flash-popup" ).dialog({
        dialogClass: "no-close",
        modal: true,
        buttons: [
            {
                text: "OK",
                click: function() {
                    $( this ).dialog( "close" );
                }
            }
        ]
    });
});

/**
 * Adds classes to the rows of the tables.
 * This is only a fix for IE < 9, but not used by other browsers.
 */
function addZebraStripes() {
	$("table tbody tr:nth-child(even)").addClass("even");
}

/**
 * Initializes certain fields in the form, which only allow a
 * certain kind of input of have to be disabled.
 */
function initializeForm() {
	$(".numeric").numeric({ decimal: false, negative: false });
	computeAge();
	computeLos();
}

/**
 * Initializes add/remove buttons for diagnoses and procedures.
 */
function initialize_buttons() {
    $("img.add_diagnoses_row").on("click", append_diagnoses_row);
    $("img.remove_diagnoses_row").on("click", remove_last_diagnoses_row);

    $("img.add_procedures_row").on("click", append_procedures_row);
    $("img.remove_procedures_row").on("click", remove_last_procedures_row);
}

/**
 * Mainly used for submitting the form in another language
 * @param url
 */
function submitFormTo(url) {
    var form = $('form');
    form.attr('action', url)
    form.submit()
}

