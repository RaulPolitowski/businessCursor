
$('#agenda_user').typeahead({
    source: function (query, process) {
        return $.ajax({
            url: '/users/find_usuarios_agenda/',
            dataType: "json",
            data: {
                term: query
            },
            success: function(data) {
                var options = [];
                map = {}; //replace any existing map attr with an empty object
                $.each(data,function (i,val){
                    options.push(val.name);
                    map[val.name] = val.id; //keep reference from name -> id
                });
                return process(options);
            }
        });
    },
    updater: function (item) {
        $('#agenda_user_id').val(map[item]);
        return item;
    },
    minLength: 2
});

$("#agenda_user").focusout(function(){
    var user = $('#agenda_user_id').val();
    if(!user || user == ''){
        $('#agenda_user_id').val('');
    }
});

$('#cliente_razao_social').typeahead({
    rateLimitWait: 5000,
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
        $.getJSON('/clientes/' + map[item], function(data) {
            limparTela();
            $('#btnSalvarClienteManual').hide();
            getDadosCliente(data);
            setClienteEmAtendimento(data['id']);
        });
        return item;
    },
    minLength: 2
});

$('#q_ligacao_cliente').typeahead({
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
        $('#q_cliente_id_eq').val(map[item]);
        return item;
    },
    minLength: 2
});

$("#q_ligacao_cliente").focusout(function(){
    var cliente = $('#q_ligacao_cliente').val();
    if(!cliente || cliente == ''){
        $('#q_cliente_id_eq').val('');
    }
});

$('#escritorio_nome_fantasia').typeahead({
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
                    options.push(val.nome_fantasia);
                    map[val.nome_fantasia] = val.id; //keep reference from name -> id
                });
                return process(options);
            }
        });
    },
    updater: function (item) {
        $('#escritorio_id').val(map[item]);
        $.getJSON('/escritorios/' + map[item], function(data) {
            setDadosEscritorio(data);
        });
        return item;
    },
    minLength: 2
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
                    options.push(val.nome + '-' + val.estado.sigla);
                    map[val.nome + '-' + val.estado.sigla] = val.id; //keep reference from name -> id
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
