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
            splitPos = data.item.label.search(" ");
            event.target.value = data.item.label.substring(0, splitPos);
            event.target.title = data.item.label.substring(splitPos + 1);
        }
	});
}


