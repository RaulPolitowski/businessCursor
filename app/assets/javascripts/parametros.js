//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require typehead/bootstrap3-typeahead.min.js
//= require iCheck/icheck.min.js
//= require chosen/chosen.jquery.js


$(document).ready(function() {
    $('.chosen-select').chosen({width: "100%"});

    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green'
    });

    $(".edit_parametro").validate({
        rules: {
            'parametro[tipo_telefone_preferencial]': {
                required: true
            }
        }
    });
});