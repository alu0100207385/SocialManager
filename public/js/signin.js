$(document).ready(function(){
  $("#login").click(function(){

    var data = {nickname: $('#nickname').val(), password: $('#password').val()}

    $.ajax({

      url:'/login',
      type: 'post',
      dataType: 'json',
      data: data,

      success: function(data){

        if(data.key1 == 'error1'){

        $("#text").hide();
        $("#text").html('<p class = "text-danger"> <strong> El usuario no existe en la base de datos.');
        $("#text").show(1000);

        }
        if(data.key1 == 'error2'){

          $("#text").hide();
          $("#text").html('<p class = "text-danger"> <strong> La contraseña no coincide con el usuario.');
          $("#text").show(1000);

        }
        if(data.key1 == 'ok'){

          window.location= '/user/index';

        }



      }

    });


  });

  document.onkeypress = function(event){

    var holder;

    if(window.event){

      holder = window.event.keyCode;

    }else{

      holder = event.which;

    }

    if(holder == 13 ){

    var data = {nickname: $('#nickname').val(), password: $('#password').val()}

    $.ajax({

      url:'/login',
      type: 'post',
      dataType: 'json',
      data: data,

      success: function(data){

        if(data.key1 == 'error1'){

          $("#text").hide();
          $("#text").html('<p class = "text-danger"> <strong> El usuario no existe en la base de datos.');
          $("#text").show(1000);

        }
        if(data.key1 == 'error2'){

          $("#text").hide();
          $("#text").html('<p class = "text-danger"> <strong> La contraseña no coincide con el usuario.');
          $("#text").show(1000);

        }
        if(data.key1 == 'ok'){

          window.location= '/user/index';

        }



      }

    });

    }


  }



});
