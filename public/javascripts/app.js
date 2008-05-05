$(function() {
  $("#search-field").Watermark("Search for a song");
  $("#search").submit(function() {
    $("#spinner").show();
  });
  if ($("#notice").length > 0) {
    var key = $("#notice").attr("class");
    var interval = setInterval(function() {
      $.get("/check?key=" + key, function(data) {
        if (data == 1) {
          clearInterval(interval);
          $("#notice").html("All done... Redirecting");
          setTimeout(function() { window.location = "/#" + key; }, 1000);
        }
      });
    }, 10000);
  }
  if (location.hash) {
/*    $(location.hash).addClass("highlight");//.animate("font-size", "200%");*/
/*    alert($(location.hash).length);*/
    $(location.hash).animate({fontSize: "150%"}, 1500);
  }
});
