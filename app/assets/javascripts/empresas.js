//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require typehead/bootstrap3-typeahead.min.js
//= require iCheck/icheck.min.js

$(document).ready(function() {
    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green'
    });

     $('#empresa_cidade').typeahead({
        source: function (query, process) {
            return $.ajax({
                url: '/clientes/find_cidades/',
                dataType: "json",
                data: {
                    term: query
                },
                success: function(data) {
                    var options = [];
                    map = {}; //replace any existing map attr with an empty object
                    $.each(data,function (i,val){
                        console.log(val)
                        options.push(val.nome + '-' + val.estado.sigla);
                        map[val.nome + '-' + val.estado.sigla] = val.id; //keep reference from name -> id
                    });
                    return process(options);
                }
            });
        },
        updater: function (item) {
            $('#empresa_cidade_id').val(map[item]);
            return item;
        },
        minLength: 2
    });

    $("#empresa_cidade").focusout(function(){
        var empresa = $('#empresa_cidade').val();
        if(!empresa || empresa == ''){
            $('#empresa_cidade_id').val('');
        }
    });

    $("#new_empresa").validate({
        rules: {
            'empresa[razao_social]': {
                required: true,
                minlength: 5
            },
            'empresa[cnpj]': {
                required: true,
                minlength: 14
            },
            'empresa[cidade_id]': {
                required: true
            }
        }
    });

    $(".edit_empresa").validate({
        rules: {
            'empresa[razao_social]': {
                required: true,
                minlength: 5
            },
            'empresa[cnpj]': {
                required: true,
                minlength: 14
            },
            'empresa[cidade_id]': {
                required: true
            }
        }
    });
});
