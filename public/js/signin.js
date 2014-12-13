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
        $("#text").html('<p class = "text-danger"> <strong> The user does not exist in the database.');
        $("#text").show(1000);

        }
        if(data.key1 == 'error2'){

          $("#text").hide();
          $("#text").html('<p class = "text-danger"> <strong> The password does not match the user.');
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
          $("#text").html('<p class = "text-danger"> <strong> The user does not exist in the database.');
          $("#text").show(1000);

        }
        if(data.key1 == 'error2'){

          $("#text").hide();
          $("#text").html('<p class = "text-danger"> <strong> The password does not match the user.');
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
