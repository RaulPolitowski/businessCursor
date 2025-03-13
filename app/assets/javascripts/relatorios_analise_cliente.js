//= require typehead/bootstrap3-typeahead.min.js
//= require jquery-ui/jquery-ui.min.js
//= require maskmoney
//= require datapicker/bootstrap-datepicker.js

$(document).ready(function(){

    $('#hora_comercial').maskMoney({thousands:'.', decimal:','});
    $('#hora_sabado').maskMoney({thousands:'.', decimal:','});
    $('#hora_domingo').maskMoney({thousands:'.', decimal:','});

    $('#estado_id').on('change', function(){
        $('#cidade_id').html('');
        if($('#estado_id').val() != null && $('#estado_id').val() != ""){
            $.ajax({
                url: '/cidades/find_cidades_estado_financeiro?estado=' + $('#estado_id').val(),
                type: 'GET',
                success: function (data) {
                    $('#cidade_id').append('<option value=""></option>');
                    $.each(data, function (k, v) {
                        $('#cidade_id').append('<option value="' + v['id'] + '">'+ v['nome'] +'</option>');
                    });
                    $('#cidade_id').trigger("chosen:updated");
                },error: function(data){
                    exibirErro(data);
                }
            });
        }
    });

    $('#filtro_cliente').typeahead({
        source: function (query, process) {
            return $.ajax({
                url: '/clientes/find_cliente_financeiro/',
                dataType: "json",
                data: {
                    term: query
                },
                success: function(data) {
                    var options = [];
                    map = {}; //replace any existing map attr with an empty object
                    $.each(data,function (i,val){
                        options.push(val.razaosocial + ' - ' + val.cpfcnpj);
                        map[val.razaosocial + ' - ' + val.cpfcnpj] = val.id; //keep reference from name -> id
                    });
                    return process(options);
                }
            });
        },
        updater: function (item) {
            $('#cliente_id').val(map[item]);
            return item;
        },
        minLength: 2
    });

    $("#filtro_cliente").focusout(function(){
        var user = $('#filtro_cliente').val();
        if(!user || user == ''){
            $('#cliente_id').val('');
        }
    });

    var date = new Date();
    $('#competencia').datepicker({
        format: "mm/yyyy",
        viewMode: "months",
        minViewMode: "months",
        keyboardNavigation: false,
        autoclose: true
    });
    $("#competencia").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), 1));

})
