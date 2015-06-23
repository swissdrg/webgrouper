$(document).ready(function() {
    //make progress bar for displaying later
    $( "#loading-bar" ).progressbar({
        value: 100
    });
    $("#loading").hide();

    //make hint for displaying later
    var download_started_hint = $('<div id="download_finished_hint" class="info">Download gestarted.</div>');
    $(".header").after(download_started_hint);
    download_started_hint.hide();

    var downloadTimer;
    $("form").bind("submit", function(event) {
        toggleLoading();
        download_started_hint.hide();
        $('div#additional_hint').remove();
        downloadTimer = window.setInterval( function() {
            var finished = $.cookie("download_finished");
            if (finished === "true") {
                $("#loading").hide();
                download_started_hint.show(100);
                if($.cookie("missing_fid") != null) {
                    download_started_hint.after('<div id="additional_hint" class="info">' +
                        $.cookie("missing_fid") + '</div>');
                    $.removeCookie('missing_fid', {path: '/'});
                }
                //clean up
                $.removeCookie('download_finished', {path: '/'});
                window.clearInterval(downloadTimer);
            }
        }, 100);
    })

});

function toggleLoading() {
    $("#loading").show(100);
    $("#download_finished_hint").hide();
    return false;
}