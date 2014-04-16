// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function toggleLoading() {
        $("#loading").show(100);
        $("#download_finished_hint").hide();
        return false;
    }
    
$(document).ready(function() {
    //make progress bar for displaying later
    $( "#loading-bar" ).progressbar({
        value: 100
    });
    $("#loading").hide();

    //make hint for displaying later
    var download_finished_hint = $('<div id="download_finished_hint" class="info">Download gestarted.</div>');
    $(".header").after(download_finished_hint);
    download_finished_hint.hide();

    var downloadTimer;
    $("#new_batchgrouper").bind("submit", function(event) {
  			toggleLoading();
            downloadTimer = window.setInterval( function() {
                var finished = $.cookie("download_finished");
                if (finished === "true") {
                    $("#loading").hide();
                    download_finished_hint.show(100);

                    //clean up
                    $.removeCookie('download_finished', {path: '/'});
                    window.clearInterval(downloadTimer);
                }
            }, 100);
    })

});