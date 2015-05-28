$(document).ready(function(){
  var test = 'test';
  alert('Ready!' + test);
  var uID = Math.floor((Math.random()*100)+1);
  var pusher = new Pusher('5d80c1b3908b01bea17d');
  var channel = pusher.subscribe('signup_process_'+uID);
  alert('Second - after assigments');
  channel.bind('update', function(data) {
    // data = {message: "Hello you", progress: 40}
    alert('Got the message:' + data.message);

    var messageBox = $('#progress-status').children('.messages');
    var progressBar = $('#realtime-progress-bar');

    // progressBar.width(data.progress+"%")
    messageBox.html(data.message);

    if (data.progress == 100) {
        // options:
        // 1. render button in original view with 'invsible', then this function will:
            // i. make it visible
            // ii. attach the results json to it
        // 2. redirect to a separate action in EnginesController
          // i. passing results as param/data
          // ii. that action will render link with results attached
        // going with no.2, will possibly switch to no.1 later (extra tinkering with jQuery)
        $.ajax({
          type:'POST',
          url: '/results_link', 
          data: { results: data.message } ,
        });
    };
  });
  alert('Third one - after bind...');
});