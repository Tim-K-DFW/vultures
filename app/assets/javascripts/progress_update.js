$(document).ready(function() {
  // document.getElementById("results-link").style.visibility = "hidden";

  var pusher = new Pusher('5d80c1b3908b01bea17d');
  var channel = pusher.subscribe('100');
  channel.bind('update', function(data) {
    var messageBox = $('#progress-status').children('.messages');
    messageBox.html(data.message);

    // var progressBar = $('#realtime-progress-bar');
    // progressBar.width(data.progress+"%")

    if (data.progress == 100) {
      document.getElementById("results-link").style.visibility = "visibile";
    };
  });
});