$(document).ready(function(){

  $("#cambiar").click(function(){

    var name = $('#new_name').val();

    var email = $('#new_email').val();

    var actpass = $('#act_pass').val();

    var newpass = $('#new_pass').val();



    if(name == '' && email == '' && actpass == '' && newpass == ''){

      $("#infotext").hide();
      $("#infotext").html('<p class = "text-danger"> <strong> Error, los campo de texto no pueden estar vacios.');
      $("#infotext").show(1000);

      setTimeout(function(){$("#infotext").hide(1000)},3000);


    }else if(newpass != actpass){


      $("#infotext").hide();
      $("#infotext").html('<p class = "text-danger"> <strong> Error, las contraseñas no coinciden.');
      $("#infotext").show(1000);

      setTimeout(function(){$("#infotext").hide(1000)},3000);



    }else{


      var data = {new_name: name, new_email: email, act_pass: actpass, new_pass: newpass}

      $.ajax({

        url:'/edit_profile',
        type: 'post',
        dataType: 'json',
        data: data,

        success: function(data){

          if(data.key1 == 'ok'){

            $("#infotext").hide();
            $("#infotext").html('<p class = "text-success"> <strong> Cuenta modificada.');
            $("#infotext").show(1000);

            setTimeout(function(){$("#infotext").hide(1000)}, 3000);


          }

        }

      });

    }


  });

    $("#delete").click(function(e){

      var retVal = confirm("Do you want to continue?");
      if( retVal == true ){
        window.location = '/killuser'
        return true;
      }else{
        return false;
      }
    });




});
