$(document).ready(function(){
  $("#Registrarse").click(function(){

    var data = {name: $('#name').val(), email: $('#email').val(), nickname: $('#nickname').val(), password: $('#password').val()}


    $.ajax({

      url:'/signup',
      type: 'post',
      dataType: 'html',
      data: data,

      success: function(result){

        $("#text").hide();
        $("#text").html(result);
        $("#text").show(1000);

      }

    });


  });

});