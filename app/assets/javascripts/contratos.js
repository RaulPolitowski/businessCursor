//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js

$(function() {
    Ladda.bind('.ladda-button', { timeout: 3000 } );

    $("#new_contrato").validate({
        rules: {
            'contrato[sistema_id]': {
                required: true
            },
            'contrato[nome]': {
                required: true
            },
            'contrato[descricao]': {
                required: true
            },
            'contrato[texto]': {
                required: true
            }
        }
    });

    $('.edit_contrato').validate({
        rules: {
            'contrato[sistema_id]': {
                required: true
            },
            'contrato[nome]': {
                required: true
            },
            'contrato[descricao]': {
                required: true
            },
            'contrato[texto]': {
                required: true
            }
        }
    });

});