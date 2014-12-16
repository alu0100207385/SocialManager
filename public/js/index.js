$(document).ready(function(){

  var src = new EventSource('/event');

  src.onmessage = function(e) {

    console.log(e.data);

    var obj = $.parseJSON(e.data);

    console.log(e);

    $('#div1').hide().html("<div class = 'div-custom'>\
                      <div class = 'row'>\
                        <div class = 'col-md-3'> \
                          <img src = 'http://cdn.flaticon.com/png/256/37943.png' width = '100px' height = '90px'> \
                        </div>\
                        <div class = 'col-md-9'>\
                          <h3>" + obj.name + "</h3>\
                        </div>\
                      </div>\
                      <div class ='row'>\
                        <div class = 'col-md-3'>\
                        <p> "+ obj.time + "\
                        </div>\
                        <div class = 'col-md-9 message'>\
                        <p> " + obj.message + "\
                        </div>\
                      </div>\
                    </div>").fadeIn('slow');

  }

$("#bshare").click(function){
	$('#text').val('The development team reminds make responsible use of the Application. Enjoy your stay.');

});


  $("#bsend").click(function(){

    var text = $('#text').val();

    $('#text').val('');

    var publico, twitter, linkedin;


    if(document.getElementById('public').checked){

      publico = true;

    }

    if(document.getElementById('twitter').checked){

      twitter = true;

    }

    if(document.getElementById('linkedin').checked){

      linkedin = true;
    }
    

    if(text == ''){

      $("#infotext").hide();
      $("#infotext").html('<p class = "text-danger"> <strong> Error, el campo de texto no puede estar vacio');
      $("#infotext").show(1000);

      setTimeout(function(){$("#infotext").hide(1000)},3000);


    }else{

      console.log(publico);

      var data = {text: text, publico: publico,twitter: twitter, linkedin: linkedin}

    $.ajax({

      url:'/user/index',
      type: 'post',
      dataType: 'json',
      data: data,

      success: function(data){

        if(data.key1 == 'ok'){

          $("#infotext").hide();
          $("#infotext").html('<p class = "text-success"> <strong> Mensaje enviado.');
          $("#infotext").show(1000);

          setTimeout(function(){$("#infotext").hide(1000)}, 3000);


        }

      }

    });

   }


  });



});
