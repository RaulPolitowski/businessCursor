//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require iCheck/icheck.min.js

$(function() {
    $("#new_formapagamento").validate({
        rules: {
            'formapagamento[descricao]': {
                required: true,
                minlength: 2
            }
        }
    });
    $('.edit_formapagamento').validate({
        rules: {
            'formapagamento[descricao]': {
                required: true,
                minlength: 2
            }
        }
    });

    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green'
    });
});