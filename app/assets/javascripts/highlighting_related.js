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
			scrollTop: $("#bottom").offset().top - 100
		},'slow');
	};
}
