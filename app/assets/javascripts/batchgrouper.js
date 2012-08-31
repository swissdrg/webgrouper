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
  	.bind('ajax:complete', function() {
  			toggleLoading();})
    .bind("ajax:success", function(event, data, status, xhr) {
    	var response = JSON.parse(xhr.responseText);
        $("#single_group_result").empty().append(response.result);
    })
    .bind("ajax:error", function(event, data, status, xhr) {
    	var response = JSON.parse(xhr.responseText);
        $("#single_group_result").empty().append("Failed, check your string again");
    });
});

$(function() {
		$( "#loading" ).progressbar({
			value: 100
		});
	});