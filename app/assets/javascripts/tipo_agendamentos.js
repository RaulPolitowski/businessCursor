//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require colorpicker/bootstrap-colorselector.min


$(function() {

    $('#tipo_agendamento_cor').colorselector({
        callback: function (value, color, title) {
            $("#cor_text").val(color);
        }
    });

    $("#new_tipo_agendamento").validate({
        rules: {
            'tipo_agendamento[descricao]': {
                required: true
            },
            'tipo_agendamento[cor]': {
                required: true
            }
        }
    });

    $('.edit_tipo_agendamento').validate({
        rules: {
            'tipo_agendamento[descricao]': {
                required: true
            },
            'tipo_agendamento[cor]': {
                required: true
            }
        }
    });
});
