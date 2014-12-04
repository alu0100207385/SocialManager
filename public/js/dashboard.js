$('#text').keypress(
  function(e){
    if( e.keyCode==13 ){
      $.get('/send',{text:$('#text').val()});
      $('#text').val('');
    }
  }
);

$('#send').click(function(){
  
      $.get('/send',{text:$('#text').val()});
      $('#text').val('');
});


(function() {
  var last = 0;
  var users = 0;
  setInterval(
    function(){
      $.get('/updatepost',{last:last},
        function(response){
          last = $('<p>').html(response).find('span').data('last');
          $('#dashboard').append(response);
          var box = document.getElementById('dashboard');
          box.scrollTop = box.scrollHeight;
        }
      );
      $.get('/updateusers',{users:users},
          function(response){
          $('#users').html(response);

        }

      );
    },
  1000);
})();


window.onbeforeunload = function(event) {

  event = event || window.event;

  var confirmClose = 'Are you sure?';

  // For IE and Firefox prior to version 4
  if (event) {
    event.returnValue = confirmClose;
  }


  // For Safari
  return confirmClose;


}
window.onunload = function(){
  $.get('/logout/index');
};
