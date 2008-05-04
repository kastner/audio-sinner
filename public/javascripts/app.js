$(function() {
  $("#search-field").Watermark("Search for a song");
  $("#search").submit(function() {
    $("#spinner").show();
  });
});
