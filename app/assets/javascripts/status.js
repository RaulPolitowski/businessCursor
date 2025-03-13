//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require iCheck/icheck.min.js

$(function() {
    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green'
    });

    $("#new_status").validate({
        rules: {
            'status[descricao]': {
                required: true,
                minlength: 5
            }
        }
    });
    $('.edit_status').validate({
        rules: {
            'status[descricao]': {
                required: true,
                minlength: 5
            }
        }
    });
});