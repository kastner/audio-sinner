$(function() {
  $("#search").submit(function() {
    if ($("#search-field").val()) {
      $("#results").show();
/*      $("#results ul").load("/search?q=" + escape($("#search-field").val()));*/
    }
    else {
      $("#results ul").html('<img src="/images/ajax-loader.gif" id="spinner" />');
      $("#results").hide();
    }
/*    return false;*/
  })
})