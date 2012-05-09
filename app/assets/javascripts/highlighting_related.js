/**
 * Scrolls to the bottom of the page, if there is a result.
 */
function goToResult(){
	if ($("#result").length) {
		jQuery('html,body').animate({
			scrollTop: $("#bottom").offset().top - 100
		},'slow');
	};
}
