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
                        <p id = 'tn'> " + obj.message + "\
                        </div>\
                      </div>\
                    </div>").fadeIn('slow');

  }


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

  $("#bshare").click(function(){

    $("#text").val($('#tn').text());
  });

  function posts(){

    $.ajax({

      url:'/posts',
      type: 'get',
      dataType: 'json',


      success: function(data){

        $('#div2').hide().html("<div class = 'div-custom'>\
        <div class = 'row'>\
        <div class = 'col-md-3'> \
        <img src = '"+ data.img +"' width = '100px' height = '90px'> \
        </div>\
        <div class = 'col-md-1'>\
        <img src = '"+ data.imgred +"' width = '20px' height = '20px' style = 'position:relative; top:13px;'> \
        </div>\
        <div class = 'col-md-8'>\
        <h3>" + data.persona + "</h3>\
        </div>\
        </div>\
        <div class ='row'>\
        <div class = 'col-md-3'>\
        <p>\
        </div>\
        <div class = 'col-md-9 message'>\
        <p id = 'tn'> " + data.comentario + "\
        </div>\
        </div>\
        </div>").fadeIn('slow');

      }

    });

  }

  posts();

  setInterval(posts,50000);


});
