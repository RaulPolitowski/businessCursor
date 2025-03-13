//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require typehead/bootstrap3-typeahead.min.js
//= require datapicker/bootstrap-datepicker.js
//= require mask_plugin/jquery.mask.js
//= require chosen/chosen.jquery.js
//= require jquery_nested_form


$(document).ready(function() {
    $('#data_1 #cliente_data_licenca').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });

    $('#data_1 #cliente_data_fechamento').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });

    $('#data_1 #cliente_proxima_pesquisa').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });

    $('.chosen-select').chosen({width: "100%"});

    $('#cliente_cpf').val($('#cliente_cpf').val().replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4'));

    $('#btnVerCnaes').on('click', function(){
        carregarTodosCnaes();
        $('#cnaes_cliente').modal('show');
        return false;
    })

    function carregarTodosCnaes() {
        $.getJSON("/clientes/" +$("#cliente_id").val(), function(data) {
            $("#table-cnae-cliente tr").remove();
            $.each(data['cnae_clientes'], function(k, v) {
                var newRow = $("<tr>");
                var cols = "";
                cols += '<td>' + v['cnae']['codigo'] + '</td>';
                cols += '<td>' + v['cnae']['descricao'] + '</td>';
                cols += '<td>' + v['blacklist'] + '</td>';
                newRow.append(cols);

                $("#table-cnae-cliente").append(newRow);
            });
        });
    }

    $('#cliente_cnae').typeahead({
        source: function (query, process) {
            return $.ajax({
                url: '/cnaes/find_cnaes/',
                dataType: "json",
                data: {
                    term: query
                },
                success: function(data) {
                    var options = [];
                    map = {}; //replace any existing map attr with an empty object
                    $.each(data,function (i,val){
                        options.push(val.codigo + '-' + val.descricao);
                        map[val.codigo + '-' + val.descricao] = val.id; //keep reference from name -> id
                    });
                    return process(options);
                }
            });
        },
        updater: function (item) {
            $('#cliente_cnae_id').val(map[item]);
            return item;
        },
        minLength: 3
    });

    $("#cliente_cliente_cnae").focusout(function(){
        var cliente = $('#cliente_cliente_cnae').val();
        if(!cliente || cliente == ''){
            $('#cliente_cnae_id').val('');
        }
    });
    $("#cliente_razao_social").focusout(function(){
       
        var validator = $( "#new_cliente" ).validate();
        validator.element( "#cliente_razao_social" );
    });
    $("#cliente_cidade").focusout(function(){
        var validator = $( "#new_cliente" ).validate();
        validator.element( "#cliente_cidade_id" );
        $( "#cliente_cidade" ).addClass( "error" );

    });
    $("#cliente_cnpj").focusout(function(){
        
        var validator = $( "#new_cliente" ).validate();
        validator.element( "#cliente_cnpj" );
        
    });

    $('#cliente_cidade').typeahead({
        source: function (query, process) {
            return $.ajax({
                url: '/clientes/find_cidades/',
                dataType: "json",
                data: {
                    term: query
                },
                success: function(data) {
                    console.log(data);
                    var options = [];
                    map = {}; //replace any existing map attr with an empty object
                    $.each(data,function (i,val){
                        options.push(val.nome + '-' + val['estado'].sigla);
                        map[val.nome + '-' + val['estado'].sigla] = val.id; //keep reference from name -> id
                    });
                    return process(options);
                }
            });
        },
        updater: function (item) {
            $('#cliente_cidade_id').val(map[item]);
            return item;
        },
        minLength: 2
    });

    $("#cliente_cidade").focusout(function(){
        var cliente = $('#cliente_cidade').val();
        if(!cliente || cliente == ''){
            $('#cliente_cidade_id').val('');
        }
    });

    $("#cliente_cpf").on('input', function(){
        let value = $(this).val().replace(/\D/g, '');
        if (value.length > 11)
            value = value.slice(0, 11);

        $(this).val(value.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4'));
    });

    $('#q_cliente_cidade').typeahead({
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
                        options.push(val.nome + '-' + val.sigla);
                        map[val.nome + '-' + val.sigla] = val.id; //keep reference from name -> id
                    });
                    return process(options);
                }
            });
        },
        updater: function (item) {
            $('#q_cidade_id_eq').val(map[item]);
            return item;
        },
        minLength: 2
    });

    $("#q_cliente_cidade").focusout(function(){
        var cliente = $('#q_cliente_cidade').val();
        if(!cliente || cliente == ''){
            $('#q_cliente_cidade_id_eq').val('');
        }
    });

    $('#cliente_escritorio').typeahead({
        source: function (query, process) {
            return $.ajax({
                url: '/escritorios/find_escritorios/',
                dataType: "json",
                data: {
                    term: query
                },
                success: function(data) {
                    var options = [];
                    map = {}; //replace any existing map attr with an empty object
                    $.each(data,function (i,val){
                        options.push(val.razao_social);
                        map[val.razao_social] = val.id; //keep reference from name -> id
                    });
                    return process(options);
                }
            });
        },
        updater: function (item) {
            $('#cliente_escritorio_id').val(map[item]);
            return item;
        },
        minLength: 2
    });

    $("#cliente_escritorio").focusout(function(){
        var cliente = $('#cliente_escritorio').val();
        if(!cliente || cliente == ''){
            $('#cliente_escritorio_id').val('');
        }
    });

    $("#new_cliente").validate({
        rules: {
            'cliente[razao_social]': {
                required: true,
                minlength: 5
            },
            'cliente[cnpj]': {
                required: true,
                minlength: 11,
                maxlength: 14
            },
            'cliente[cidade_id]': {
                required: true
            }
        }
    });

    $(".edit_cliente").validate({
        rules: {
            'cliente[razao_social]': {
                required: true,
                minlength: 5
            },
            'cliente[cnpj]': {
                required: true,
                minlength: 14
            },
            'cliente[cidade_id]': {
                required: true
            }
        }
    });

    window.NestedFormEvents.prototype.insertFields = function(content, assoc, link) {
        var $tr = $(link).closest('tr');
        return $(content).insertBefore($tr);
    }

    $('#cliente_cep').mask('00000-000');

    var receita = $('#btnReceita').ladda();

    receita.click(function(){
        receita.ladda( 'start' );

        form = new FormData();
        form.append('cnpj', $("#cliente_cnpj").val());
        form.append('empresa_id', $("#cliente_empresa_id").val());
        $.ajax({
            url: '/importacoes/importar_receita/',
            data: form,
            processData: false,
            contentType: false,
            type: 'POST',
            success: function (data) {
                window.location.href = window.location.href;
            },
            error: function (data) {
                exibirErro(data)
                window.location.href = window.location.href;
            }
        });
    });

    var cnpj = $('#btnCnpj').ladda();

    cnpj.click(function(){
        cnpj.ladda( 'start' );
        
        
        
        $.ajax({
            url: '/importacoes/importar_cnpj?cnpj='+$("#cliente_cnpj").val(),
            type: 'GET',
            dataType: 'json',
            cache : false,
            processData: false
        }).done(function(response) {
            console.log(response)
            cep = response.estabelecimento.cep.replace('.','');
            cep = cep.replace('-','');
            const telefone1 = response.estabelecimento.telefone1;
            const telefone2 = response.estabelecimento.telefone2;
            $("#cliente_razao_social").val(response.razao_social);
            $("#cliente_nome_fantasia").val(response.estabelecimento.nome_fantasia);
            carregarCnaes(response.estabelecimento.atividade_principal.id);
            $("#cliente_porte").val(response.estabelecimento.natureza_juridica);
            $("#cliente_data_importacao").val(response.atualizado_em);
            $("#cliente_data_licenca").val(response.estabelecimento.data_inicio_atividade);
            $("#cliente_endereco").val(response.estabelecimento.logradouro);
            $("#cliente_complemento").val(response.estabelecimento.complemento);
            $("#cliente_bairro").val(response.estabelecimento.bairro);
            $("#cliente_cep").val(cep);
            $("#cliente_numero_endereco").val(response.estabelecimento.numero);
            carregarCidade(cep);
            $("#cliente_email").val(response.estabelecimento.email);
            $("#cliente_telefone").val(`(${response.estabelecimento.ddd1}) ${telefone1 && telefone1.length == 8 ? telefone1.slice(0, 4) + '-' + telefone1.slice(4, 8) : telefone1}`);
            $("#cliente_telefone2").val(`(${response.estabelecimento.ddd2}) ${telefone2 && telefone2.length == 8 ? telefone2.slice(0, 4) + '-' + telefone2.slice(4, 8) : telefone2}`);
        }).fail(function(response) {
            exibirErro(response)
        });
    });

    function carregarCidade(cep) {
        
        $.ajax({
            url: '/cidades/cidades_buscar?cep='+cep,
            type: 'GET',
            dataType: 'json',
            cache : false,
            processData: false
        }).done(function(response) {
            $("#cliente_cidade").val(response.nome);
            $("#cliente_cidade_id").val(response.id);
        }).fail(function(response) {
            exibirErro(response)
        });
    }

    function carregarCnaes(qr) {
        var q =qr.replace(/[^0-9]/g,'');
        $.ajax({
            url: '/cnaes?q[codigo_eq]='+q,
            type: 'GET',
            dataType: 'json',
            cache : false,
            processData: false
        }).done(function(response) {
            $("#cliente_cnae_id").val(response[0].id);
            $("#cliente_cnae").val(response[0].codigo+"-"+response[0].descricao);
        }).fail(function(response) {
            exibirErro(response)
        });
    }


    var jucesp = $('#btnJucesp').ladda();

    jucesp.click(function(){
        jucesp.ladda( 'start' );
        form = new FormData();
        form.append('nire', $("#cliente_nire").val());
        form.append('empresa_id', $("#cliente_empresa_id").val());
        $.ajax({
            url: '/importacoes/importar_jucesp/',
            data: form,
            processData: false,
            contentType: false,
            type: 'POST',
            success: function (data) {
                window.location.href = window.location.href;
            },
            error: function (data) {
                exibirErro(data)

                window.location.href = window.location.href;
            }
        });
    });
});