//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js

$(function() {

    $("#new_tipo_fechamento").validate({
        rules: {
            'status[descricao]': {
                required: true,
                minlength: 5
            }
        }
    });
    $('.edit_tipo_fechamento').validate({
        rules: {
            'status[descricao]': {
                required: true,
                minlength: 5
            }
        }
    });
});