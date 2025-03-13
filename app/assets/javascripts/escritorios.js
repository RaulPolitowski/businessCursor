//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require typehead/bootstrap3-typeahead.min.js
//= require datapicker/bootstrap-datepicker.js
//= require jquery_nested_form
//= require chosen/chosen.jquery.js

$(document).ready(function(){

    $('#created_at_q #q_created_at_lteq').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });

    $('#created_at_q #q_created_at_gteq').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });

    $('.chosen-select').chosen({width: "100%"});

    $("#new_escritorio").validate({
        rules: {
            'escritorio[nome_fantasia]': {
                required: true,
                minlength: 5
            },
            'escritorio[telefone]': {
                required: true
            },
            'escritorio[responsavel]': {
                required: true
            }
        }
    });
    $('.edit_escritorio').validate({
        rules: {
            'escritorio[nome_fantasia]': {
                required: true,
                minlength: 5
            },
            'escritorio[telefone]': {
                required: true
            },
            'escritorio[responsavel]': {
                required: true
            }
        }
    });

    $('#escritorio_cidade').typeahead({
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
            $('#escritorio_cidade_id').val(map[item]);
            return item;
        },
        minLength: 2
    });

    $("#escritorio_cidade").focusout(function(){
        var cliente = $('#escritorio_cidade').val();
        if(!cliente || cliente == ''){
            $('#escritorio_cidade_id').val('');
        }
    });

    $('#escritorio_empresa_parceira_field').hide();
    $('#escritorio_obs_parceria').hide();

    $('#escritorio_possui_parceria').on('change', function () {
        if($('#escritorio_possui_parceria').val() == "true"){
            $('#escritorio_empresa_parceira_field').show();
            $('#escritorio_obs_parceria').show();
        }else{
            $('#escritorio_empresa_parceira_field').hide();
            $('#escritorio_obs_parceria').hide();
            $('#escritorio_parceria_obs').val("");
            $('#escritorio_parceria_obs').val("");
        }
    });

    window.NestedFormEvents.prototype.insertFields = function(content, assoc, link) {
        var $tr = $(link).closest('tr');
        return $(content).insertBefore($tr);
    }

    $('#tab2').click(function () {
        if ($("#DataTables_Table_0_wrapper").length == 0 || $("#DataTables_Table_1_wrapper").length == 0){

            $('.table-clientes').DataTable({
                pageLength: 10,
                rowReorder: {
                    selector: 'td:nth-child(2)'
                },
                responsive: true,
                dom: '<"html5buttons"B>lTfgitp',
                buttons: [
                    {extend: 'excel', title: 'Clientes'},
                    {extend: 'pdf', title: 'Clientes'}
                ],
                "ordering": false,
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.10.16/i18n/Portuguese-Brasil.json"
                }
            });
        }
    });

    $('#removeCliente').on('click', function () {
        form = new FormData();
        form.append('cliente_id', this.value);
        form.append('escritorio_id', $("#escritorio_id").val());

        $.ajax({
            url: '/escritorios/remove_cliente/', // Url do lado server que vai receber o arquivos
            data: form,
            processData: false,
            contentType: false,
            type: 'POST',
            success: function (data) {
                var table = $('.table-clientes').DataTable();
                table.row('#' + data['id']).remove().draw( false );
            },
            error: function (xhr, ajaxOptions, thrownError) {
                exibirErro('Ocorreu um erro.');
            }
        });
    });

    $('#addCliente').on( 'click', function () {
        var t = $('.table-clientes').DataTable();
        form = new FormData();
        form.append('cliente_id', $("#cliente_id").val());
        form.append('escritorio_id', $("#escritorio_id").val());
        $.ajax({
            url: '/escritorios/add_cliente/', // Url do lado server que vai receber o arquivos
            data: form,
            processData: false,
            contentType: false,
            type: 'POST',
            success: function (data) {
                if(data == 'JA_EXISTE'){
                    exibirErro('Cliente já esta vinculado à este escritório.');
                }else{
                    t.row.add( [
                        data['cnpj'],
                        data['razao_social'],
                        data['cidade'],
                        data['cnae'],
                        '<a class="btn btn-sm btn-success" title="Editar" data-toggle="tooltip" data-placement="right" href="/clientes/' + data['id'] + '/editar">'+
                        '<i class="fa fa-pencil" aria-hidden="true"></i>' +
                        '</a>',

                        '<a class="btn btn-sm btn-danger" title="Remover" data-toggle="tooltip" data-placement="right" href="/clientes/628/editar">' +
                        '<i class="fa fa-remove" aria-hidden="true"></i>' +
                        '</a>'
                    ] ).draw( false );
                }

            },
            error: function (xhr, ajaxOptions, thrownError) {
                exibirErro('Ocorreu um erro.');
            }
        });
    } );

    $('#cliente').typeahead({
        source: function (query, process) {
            return $.ajax({
                url: '/clientes/find_cliente/',
                dataType: "json",
                data: {
                    term: query
                },
                success: function(data) {
                    var options = [];
                    map = {}; //replace any existing map attr with an empty object
                    $.each(data,function (i,val){
                        options.push(val.razao_social + ' - ' + val.cnpj);
                        map[val.razao_social + ' - ' + val.cnpj] = val.id; //keep reference from name -> id
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

    $("#cliente").focusout(function(){
        var cliente = $('#cliente').val();
        if(!cliente || cliente == ''){
            $('#cliente_id').val('');
        }
    });

});
