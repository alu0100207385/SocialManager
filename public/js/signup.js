$(document).ready(function(){
  $("#Registrarse").click(function(){

    var name = $('#name').val()
    var mail= $('#mail').val()
    var nickname= $('#nickname').val()
    var password= $('#password').val()

    if(name == '' || mail == '' || nickname == '' || password == ''){

      $("#text").hide();
      $("#text").html('<p class = "text-danger"> <strong> Error, Falta un campo por rellenar');
      $("#text").show(1000);



    }else{

    var data = {name: name, mail: mail, nickname: nickname , password: password}


    $.ajax({

      url:'/signup',
      type: 'post',
      dataType: 'json',
      data: data,

      success: function(data){

        if(data.key1 == 'ok'){

          $("#text").hide();
          $("#text").html('<p class = "text-success"> <strong> Usuario creado con exito.');
          $("#text").show(1000);

          setTimeout(function(){window.location = "/user/index";}, 3000);


        }
        if(data.key1 == 'error'){

          $("#text").hide();
          $("#text").html('<p class = "text-danger"> <strong> Error, el nickname ya esta siendo utilizado.');
          $("#text").show(1000);

        }

      }

    });

  }


  });

  document.onkeypress = function(event){


  var holder;

  if(window.event){

    holder = window.event.keyCode;

  }else{

    holder = event.which;

  }

  if(holder == 13 ){


    var name = $('#name').val()
    var mail= $('#mail').val()
    var nickname= $('#nickname').val()
    var password= $('#password').val()

    if(name == '' || mail == '' || nickname == '' || password == ''){

      $("#text").hide();
      $("#text").html('<p class = "text-danger"> <strong> Error, Falta un campo por rellenar');
      $("#text").show(1000);



    }else{

      var data = {name: name, mail: mail, nickname: nickname , password: password}




      $.ajax({

        url:'/signup',
        type: 'post',
        dataType: 'json',
        data: data,

        success: function(data){

          if(data.key1 == 'ok'){

            $("#text").hide();
            $("#text").html('<p class = "text-success"> <strong> Usuario creado con exito.');
            $("#text").show(1000);

            setTimeout(function(){window.location = "/user/index";}, 3000);


          }
          if(data.key1 == 'error'){

            $("#text").hide();
            $("#text").html('<p class = "text-danger"> <strong> Error, el nickname ya esta siendo utilizado.');
            $("#text").show(1000);

          }

        }

      });

    }
   }

  }

});
