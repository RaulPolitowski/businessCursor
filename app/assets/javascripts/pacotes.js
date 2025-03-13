//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require maskmoney
//= require typehead/bootstrap3-typeahead.min.js

$(function() {

    $('#pacote_sistema').typeahead({
        source: function (query, process) {
            return $.ajax({
                url: '/sistemas/find_sistemas/',
                dataType: "json",
                data: {
                    term: query
                },
                success: function(data) {

                    var options = [];
                    map = {}; //replace any existing map attr with an empty object
                    $.each(data,function (i,val){
                        options.push(val.nome);
                        map[val.nome] = val.id; //keep reference from name -> id
                    });
                    return process(options);
                }
            });
        },
        updater: function (item) {
            $('#pacote_sistema_id').val(map[item]);
            return item;
        }
    });

    $("#new_pacote").validate({
        messages: {'pacote[sistema_id]': 'O sistema não está cadastrado. Para prosseguir, realize o cadastro primeiro.'},
        rules: {
            'pacote[sistema_id]': {
                required: true
            },
            'pacote[mensalidade]': {
                required: true
            },
            'pacote[mensalidade_promocional]': {
                required: true
            },
            'pacote[implantacao]': {
                required: true
            },
            'pacote[implantacao_promocional]': {
                required: true
            },
            'pacote[implantacao_remota]': {
                required: true
            },
            'pacote[implantacao_remota_promocional]': {
                required: true
            }
        }
    });

    $('.edit_pacote').validate({
        rules: {
            'pacote[sistema_id]': {
                required: true
            },
            'pacote[mensalidade]': {
                required: true
            },
            'pacote[mensalidade_promocional]': {
                required: true
            },
            'pacote[implantacao]': {
                required: true
            },
            'pacote[implantacao_promocional]': {
                required: true
            },
            'pacote[implantacao_remota]': {
                required: true
            },
            'pacote[implantacao_remota_promocional]': {
                required: true
            }
        }
    });

    $('#pacote_mensalidade').maskMoney({thousands:'.', decimal:','});
    $('#pacote_mensalidade_promocional').maskMoney({thousands:'.', decimal:','});
    $('#pacote_implantacao').maskMoney({thousands:'.', decimal:','});
    $('#pacote_implantacao_promocional').maskMoney({thousands:'.', decimal:','});
    $('#pacote_implantacao_remota').maskMoney({thousands:'.', decimal:','});
    $('#pacote_implantacao_remota_promocional').maskMoney({thousands:'.', decimal:','});
});