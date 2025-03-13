//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js

$(function() {
    $("#new_sistema").validate({
        rules: {
            'sistema[nome]': {
                required: true,
                minlength: 5
            }
        }
    });
    $('.edit_sistema').validate({
        rules: {
            'sistema[nome]': {
                required: true,
                minlength: 5
            }
        }
    });
});