$(document).ready(function() {
  var pusher = new Pusher('5d80c1b3908b01bea17d');
  var channel = pusher.subscribe('100');
  channel.bind('update', function(data) {
    var messageBox = $('#progress-status').children('.messages');
    messageBox.html(data.message);
  });
});