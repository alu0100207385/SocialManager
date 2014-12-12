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
                        </div>\
                        <div class = 'col-md-9'>\
                        <p> " + obj.message + "\
                        </div>\
                      </div>\
                    </div>").fadeIn('slow');



  }

});
