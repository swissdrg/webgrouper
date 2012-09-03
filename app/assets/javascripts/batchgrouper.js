// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function toggleLoading() {
        $("#loading").toggle();
        return false;
    }
    
$(document).ready(function() {
    toggleLoading()
    $("#new_batchgrouper")
    .bind("submit", function(event) {
  			toggleLoading(); })
});

$(function() {
		$( "#loading" ).progressbar({
			value: 100
		});
	});