// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function loadingStuff() {
        $("#loading").toggle();
        return false;
    }
    
$(document).ready(function() {
    loadingStuff()
    $("#new_batchgrouper")
  	.bind("ajax:before",  loadingStuff())
  	.bind('ajax:complete', loadingStuff())
    .bind("ajax:success", function(event, data, status, xhr) {
    	var response = JSON.parse(xhr.responseText);
        $("#single_group_result").empty().append(response.result);
    })
    .bind("ajax:error", function(event, data, status, xhr) {
    	var response = JSON.parse(xhr.responseText);
        $("#single_group_result").empty().append("Failed, check your string again");
    });
  });

$("#new_batchgrouper").submit(function() {
	alert("Loading stuff");
    return false;
})
