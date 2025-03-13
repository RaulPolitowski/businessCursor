//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require iCheck/icheck.min.js
//= require colorpicker/bootstrap-colorselector.min
//= require chosen/chosen.jquery.js


$(function() {

    $('#user_color').colorselector({
        callback: function (value, color, title) {
            $("#color_text").val(color);
        }
    });

    $('.chosen-select').chosen({width: "100%"});

    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green'
    });

    $("#new_user").validate({
        rules: {
            'user[name]': {
                required: true
            },
            'user[email]': {
                required: true,
                email: true
            },
            'user[password]': {
                required: true,
                minlength:6
            },
            'user[color]':{
                required: true
            },
            'user[password_confirmation]': {
                required: true,
                minlength:6
            },
            'user[avatar]': {
                required: true
            }
        }
    });

});