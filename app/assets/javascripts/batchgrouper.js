// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function showLoadingScreen() {
        alert("Loading stuff");
        return false;
    }
$(document).ready(function() {
    $("#progressbar").progressbar({ value: 37 });
  });

$("#new_batchgrouper").submit(function() {
	alert("Loading stuff");
    return false;
})
