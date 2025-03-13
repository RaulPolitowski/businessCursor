//= require validate/jquery.validate.min.js
//= require iCheck/icheck.min.js
//= require jquery-ui/jquery-ui.min.js
//= require fullcalendar/fullcalendar.min.js
//= require peity/jquery.peity.min.js
//= require sparkline/jquery.sparkline.min.js
//= require mask_plugin/jquery.mask.js
//= require typehead/bootstrap3-typeahead.min.js
//= require fullcalendar/fullcalendar-rightclick.js
//= require sweetalert/sweetalert2.all.js
//= require qtip/jquery.qtip.min.js
//= require chosen/chosen.jquery.js
//= require datapicker/bootstrap-datepicker.js

$(document).ready(function () {

    $('.chosen-select').chosen({width: "100%", allow_single_deselect: true});

    var date = new Date();
    $('#data_inicio').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
    $("#data_inicio").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), 1));

    $('#data_fim').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
    $("#data_fim").datepicker("setDate",  new Date(date.getFullYear(), date.getMonth() + 1, 0));

    atualizarPaineis();

    $('#btnDia').on('click', function () {
        $("#data_inicio").datepicker("setDate",  new Date());
        $("#data_fim").datepicker("setDate",  new Date());

        atualizarPaineis();
        return false;
    });

    $('#btnOntem').on('click', function () {
        $("#data_inicio").datepicker("setDate",  addDays(new Date(), -1));
        $("#data_fim").datepicker("setDate",  addDays(new Date(), -1));

        atualizarPaineis();
        return false;
    });

    $('#btnSemana').on('click', function () {
        $("#data_inicio").datepicker("setDate",  addDays(new Date(), -7));
        $("#data_fim").datepicker("setDate",  new Date());

        atualizarPaineis();
        return false;
    });

    $('#btnMes').on('click', function () {
        $("#data_inicio").datepicker("setDate",  new Date(date.getFullYear(), date.getMonth(), 1));
        $("#data_fim").datepicker("setDate",  new Date(date.getFullYear(), date.getMonth() + 1, 0));

        atualizarPaineis();
        return false;
    });

    $('#btnTodas').on('click', function () {
        $("#data_inicio").datepicker("setDate",  null);
        $("#data_fim").datepicker("setDate",  null);

        atualizarPaineis();
        return false;
    });

    $('#btnNovas').on('click', function () {
        if($("#novos").val() == "false"){
            $("#novos").val(true);
            $('#btnNovas').removeClass("btn-white");
            $('#btnNovas').addClass("btn-info");
        }else{
            $('#btnNovas').removeClass("btn-info");
            $('#btnNovas').addClass("btn-white");
            $("#novos").val(false);
        }
        atualizarPaineis();
        return false;
    });

    $('#btnFechamentos').on('click', function () {
        if($("#fechamentosMes").val() == "false"){
            $("#fechamentosMes").val(true);
            $('#btnFechamentos').removeClass("btn-white");
            $('#btnFechamentos').addClass("btn-info");
        }else{
            $('#btnFechamentos').removeClass("btn-info");
            $('#btnFechamentos').addClass("btn-white");
            $("#fechamentosMes").val(false);
        }
        atualizarPaineis();
        return false;
    });

    $('#btnAtualizarImplantacoes').on('click', function () {
        atualizarPaineis();
        return false;
    });

    $('#btnTransferirImplantacao').on('click', function () {
        if($('#modal_transferir_implantacao #transferir_novo_responsavel').val() == '') {
            exibirWarning("Selecione um implantador para fazer a transferencia.");
            return false;
        }
        $.post( "/implantacoes/transferir_implantacao", { id: $('#modal_transferir_implantacao #transferir_implantacao_id').val(),
            resp_id: $('#modal_transferir_implantacao #transferir_novo_responsavel').val() } )
            .done(function( data ) {
                window.location.href = "/implantacoes/";
            })
            .fail(function(data) {
            if(data['responseText'] == 'IMPLANTACAO_ANDAMENTO')
                exibirErro('Este implantador tem uma implantação em andamento.');
            if(data['responseText'] == 'SOMENTE_ADMIN')
               exibirErro('Você não tem permissão para transferir uma implantação da qual não é responsável.');
            return false;
        });

    });

    $('#btnTransferirVendedor').on('click', function () {
        if($('#modal_transferir_implantacao #vendedor_novo').val() == '') {
            exibirWarning("Selecione um vendedor para fazer a transferencia.");
            return false;
        }
        if($('#modal_transferir_implantacao #transferir_vendedor_comentario').val() == '') {
            exibirWarning("Informe um comentário para a transfêrencia de vendedor.");
            return false;
        }

        $.post( "/implantacoes/transferir_vendedor", { id: $('#modal_transferir_implantacao #transferir_implantacao_id').val(),
            resp_id: $('#modal_transferir_implantacao #vendedor_novo').val(), obs:  $('#modal_transferir_implantacao #transferir_vendedor_comentario').val()} )
            .done(function( data ) {
                window.location.href = "/implantacoes/";
            })
            .fail(function(data) {
                exibirErro(data);
                return false;
            });
        return false;
    });

    $('#btnSalvarComentarioIndex').on('click', function(){
        if($('#modal_comentario_implantacao #text_comentario').val() == ''){
            $('#modal_comentario_implantacao #error_comentario').show();
            return false;
        }
        $('#modal_comentario_implantacao #error_comentario').hide();

        if($('#retorno_data_retorno').val() != '' && !moment($('#retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()) {
            exibirErro('Informe uma data de retorno válida!');
            return false;
        }

        $.ajax({
            url: '/comentarios/',
            data: getFormComentarioIndex(),
            processData: false,
            contentType: false,
            type: 'POST',
            success: function (data) {
                $('#modal_comentario_implantacao').modal('toggle');
                $("#modal_comentario_implantacao #text_comentario").val("");
                exibirMsg("Comentário cadastrado com sucesso.")
                return false;
            },error: function(data){
                exibirErro('Ocorreu um erro.');
            }
        });
        return false;
    });

    $('#filtro_cliente').typeahead({
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
            $('#filtro_cliente_id').val(map[item]);
            return item;
        },
        minLength: 2
    });

    $("#filtro_cliente").focusout(function(){
        var user = $('#filtro_cliente').val();
        if(!user || user == ''){
            $('#filtro_cliente_id').val('');
        }
    });

    $('#implantacao_status_aguardando').on('change', function () {
       getAguardando();
    });

    $('#implantacao_status_andamento').on('change', function () {
        getAndamento();
    });

    $('#implantacao_status_desistente').on('change', function () {
        getDesistentes();
    });

    $('#modal_voltar_implantacao #btnVoltarImplantacao').on('click', function () {
        voltarImplantacao();
        return false;
    });

    $('#modal_voltar_implantacao #voltar_data_retorno').datetimepicker({
        mask:'39.19.9999 29:59',
        format: 'dd/mm/yyyy hh:ii',
        language: 'pt-BR',
        autoclose: true,
        todayBtn: true,
        pickerPosition: "bottom-left"
    });
});

function atualizarPaineis(){
    getAguardando();
    getAndamento();
    getConcluidas();
    getDesistentes();

    setTimeout(function () {
        $('.tooltipteste').each(function () {
            var sTitle = $(this).attr("title");
            $(this).qtip({
                content: {
                    text: sTitle
                },
                position: {
                    my: 'top right',
                    at: 'center left'
                },
                style: 'qtip-dark',
                show: { solo: true },
                hide: {
                    delay: 10
                }
            });
        });
    }, 1000)
}

function getAguardando() {
    var status = '(0,1,2,10)';
    var filtro = '';
    if($('#implantacao_status_aguardando').val() != '')
        filtro = '&filtro=' + $('#implantacao_status_aguardando').val();

    $.getJSON("/implantacoes/get_implantacoes?status=" + status +"&vendedor=" + $('#vendedor_id').val()
        + "&implantador=" + $('#implantador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&estado=" + $('#estado_financeiro_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&novas=" + $('#novos').val()
        + '&fechamento=' + $('#fechamentosMes').val()
        + filtro, function(data) {
        $('#text-painel0').text('AGUARDANDO (' + data.length + ')')
        $("#painel0 li").remove();
       $.each(data,function (i,val){
           $('<li class="' + getCorSistema(val['sistema']) + '-element" id="implantacao-'+ val['id'] +'">')
               .prepend(getPainelHtml(val, 1))
               .appendTo('#painel0');
        });
    });
}

function getAndamento() {
    var status = '(3,4,5,6)';
    var filtro = '';
    if($('#implantacao_status_andamento').val() != null && $('#implantacao_status_andamento').val() != ''){
        if($('#implantacao_status_andamento').val() == 'comagenda' || $('#implantacao_status_andamento').val() == 'semagenda')
            filtro = '&filtro=' + $('#implantacao_status_andamento').val();
        else status = '(' + $('#implantacao_status_andamento').val() + ')';
    }


    $.getJSON("/implantacoes/get_implantacoes?status="+ status + "&vendedor=" + $('#vendedor_id').val()
        + "&implantador=" + $('#implantador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&estado=" + $('#estado_financeiro_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + '&fechamento=' + $('#fechamentosMes').val()
        + "&novas=" + $('#novos').val()
        + filtro, function(data) {
        $('#text-painel1').text('EM ANDAMENTO (' + data.length + ')')
        $("#painel1 li").remove();
        $.each(data,function (i,val){
            $('<li class="' + getCorSistema(val['sistema']) + '-element" id="implantacao-'+ val['id'] +'">')
                .prepend(getPainelHtml(val, 1))
                .appendTo('#painel1');
        });
    });
}

function getConcluidas() {
    $.getJSON("/implantacoes/get_implantacoes?status=(9)&vendedor=" + $('#vendedor_id').val()
        + "&implantador=" + $('#implantador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&estado=" + $('#estado_financeiro_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + '&fechamento=' + $('#fechamentosMes').val()
        + "&novas=" + $('#novos').val(), function(data) {
        $('#text-painel3').text('CONCLUÍDA (' + data.length + ')')
        $("#painel3 li").remove();
        $.each(data,function (i,val){
            $('<li class="' + getCorSistema(val['sistema']) + '-element" id="implantacao-'+ val['id'] +'">')
                .prepend(getPainelHtml(val, 0))
                .appendTo('#painel3');
        });
    });
}

function getDesistentes() {
    var status = '(7,8)';
    if($('#implantacao_status_desistente').val() != null && $('#implantacao_status_desistente').val() != '')
        status = '(' + $('#implantacao_status_desistente').val() + ')';
    $.getJSON("/implantacoes/get_implantacoes?status=" + status +"&vendedor=" + $('#vendedor_id').val()
        + "&implantador=" + $('#implantador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&estado=" + $('#estado_financeiro_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + '&fechamento=' + $('#fechamentosMes').val()
        + "&novas=" + $('#novos').val(), function(data) {
        $('#text-painel2').text('DESISTENTE (' + data.length + ')')
        $("#painel2 li").remove();
        $.each(data,function (i,val){
            $('<li class="' + getCorSistema(val['sistema']) + '-element" id="implantacao-'+ val['id'] +'">')
                .prepend(getPainelHtml(val, 0))
                .appendTo('#painel2');
        });
    });
}

function getCorSistema(sistema){
    if(sistema == 'Manager')
        return 'warning';
    if(sistema == 'Light')
        return 'info';
    if(sistema == 'Gourmet')
        return 'success';
    if(sistema == 'Emissor')
        return 'danger';
}

function abrirModalActivities(id) {
    $.ajax({
        url: '/implantacoes/activities',
        data: {id: id},
        type: 'GET',
        success: function (data) {
            $("#modal_content_activities").html(data);
            $("#modal_activities_implantacao").modal('show');
            addFuncoes(id);
        },error: function(data){
            exibirErro(data);
        }
    });
}

function addFuncoes(id){
    $('#abrirComentarioActivityImplantacao').on('click', function () {
        if($('#modal_comentario_implantacao #novo_comentario_implantacao_id').val() != id)
            $("#modal_comentario_implantacao #text_comentario").val("");

        $('#modal_comentario_implantacao #btnSalvarComentario').hide();
        $('#modal_comentario_implantacao #btnSalvarComentarioIndex').hide();
        $('#modal_comentario_implantacao #btnSalvarComentarioActivity').show();
        $('#modal_comentario_implantacao #retorno_data_retorno').val('');

        $('#modal_comentario_implantacao').modal('show');
    });

}

$('#modal_comentario_implantacao #btnSalvarComentarioActivity').on('click', function(){
    if($('#modal_comentario_implantacao #text_comentario').val() == ''){
        $('#modal_comentario_implantacao #error_comentario').show();
        return false;
    }
    $('#modal_comentario_implantacao #error_comentario').hide();

    if($('#modal_comentario_implantacao #retorno_data_retorno').val() != '' && !moment($('#modal_comentario_implantacao #retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()) {
        exibirErro('Informe uma data de retorno válida!');
        return false;
    }

    salvarComentarioActivity();
    return false;
});


function salvarComentarioActivity() {
    $.ajax({
        url: '/comentarios/',
        data: getFormComentarioActivity(),
        processData: false,
        contentType: false,
        type: 'POST',
        success: function (data) {
            $('#modal_comentario_implantacao').modal('toggle');
            $('#modal_activities_implantacao').modal('toggle');
            $('#modal_comentario_implantacao #text_comentario').val('');
            exibirMsg("Comentário cadastrado com sucesso.");
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}

function getFormComentarioActivity(){
    form = new FormData();
    form.append('comentario[comentario]', $("#modal_comentario_implantacao #text_comentario").val());
    form.append('comentario[implantacao_id]', $("#implantacao_id").val());
    if(moment($('#modal_comentario_implantacao #retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()){
        form.append('data_retorno', $('#modal_comentario_implantacao #retorno_data_retorno').val());
    }
    if($('#modal_comentario_implantacao #comentario_usuario_id').val() != null )
        form.append('usuario_id', $('#modal_comentario_implantacao #comentario_usuario_id').val());
    return form;
}

function getPainelHtml(data, flag){
    var html = data['razao_social'] +
        '<div class="agile-detail">' +
        '<span class="pull-right">Sistema: ' +  data['sistema'] + '</span>' +
        '<i class="fa fa-clock-o"></i> ' + getDataFormatada(data['data_agenda']) +
        '</div>' +
        '<div class="agile-detail">' +
        '<span>Vendedor: ' + data['vendedor']+ '</span>' +
        '</div>' +
        '<div class="agile-detail">' +
        '</div>' +
        '<div class="agile-detail">' +
        '<span>Responsável: '+ data['implantador'] + '</span>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<div class="pull-center">' +
        '<a class="btn btn-xs btn-info" style="margin-right: 5px" href="/implantacoes/'+data['id'] + '" title="Lançar"><span class="fa fa-eye"></span></a>' +
        '<button class="btn btn-primary btn-xs tooltipteste" style="margin-right: 5px" onclick="' + 'abrirModalActivities(\'' + data['id'] + '\')' + '" id="activities-'+data['id'] + '" type="button" title="' + getTitleTooltip(data['ultimo_comentario'], data['observacao']) + '"><span class="fa fa-comments"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px"  onclick="' + 'novoComentario(\'' + data['id'] + '\')' + '" id="novocomentario-'+data['id'] + '" type="button" title="Novo comentário"><span class="fa fa-comment"></span></button>' +
        '<button class="btn btn-xs btn-warning" style="margin-right: 5px" onclick="transferirImplantacao(' + data['id'] + ')" title="Transferir"><span class="fa fa-exchange"></span></button>'+
        '<a class="btn btn-xs btn-info" href="/contratos/emitir_contrato?id='+data['id'] + '&local=implantacao" title="Contrato"><span class="fa fa-file-text "></span></a>';

        if(data['telefone'] != null) {
            html = html + '<a class="btn btn-xs btn-white" style="margin-left: 5px" href="https://api.whatsapp.com/send?phone=55' + apenasNumeros(data['telefone']) + '" title="Whatsapp" target="_blank"><img alt="Avatar" class="img-circle" src="/assets/whats_enviado-48910f63828c36a6fa71b452fdc92993272672d48b6b907f4267f078799d0ce4.ico"></a>'
        }
        if (flag == 1 && $('#user_is_admin').val() == 'true')
            html = html + '<button class="btn btn-xs btn-primary" style="margin-left: 5px" onclick="openModalvoltarImplantacao(' + data['id'] + ')" title="Voltar pra negociação"><span class="fa fa-undo"></span></button>';
            
        html = html +  '</div></div></li>';

    return html;
}

function getTitleTooltip(ultimo_comentario, observacao) {
    var text = '';
    if(ultimo_comentario == null){
        text = 'Sem comentários'
    }else{
        text = '<h5>' + formatarData(ultimo_comentario) + ' - ' + moment(formatarData(ultimo_comentario), "DD/MM/YYYY HH:MM").fromNow() + '</h5>';
        text = text + '<h7>' + observacao + '</h7>';
    }

    return text;
}

function voltarImplantacao() {
    if($('#modal_voltar_implantacao #voltar_implantacao_responsavel').val() == null) {
        exibirErro("É obrigatório informar um vendedor.");
        return false;
    }

    if($('#modal_voltar_implantacao #voltar_data_retorno').val() == '') {
        exibirErro("É obrigatório informar data de retorno.");
        return false;
    }    

    $.ajax({
        url: '/implantacoes/' + $('#modal_voltar_implantacao #voltar_implantacao_id').val() + '/voltar_negociacao',
        data: { id: $('#modal_voltar_implantacao #voltar_implantacao_id').val(),
            responsavel: $('#modal_voltar_implantacao #voltar_implantacao_responsavel').val(),
            data_retorno: $('#modal_voltar_implantacao #voltar_data_retorno').val(),
            cliente_id: $('#modal_voltar_implantacao #voltar_implantacao_cliente_id').val(),
            motivo: $('#modal_voltar_implantacao #voltar_implantacao_motivo').val()},
        type: 'PUT',
        success: function(data) {
            $('#modal_voltar_implantacao').modal('hide');
            exibirMsg("Implantação voltou para negociação.");
            atualizarPaineis();       
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

function novoComentario(id){
    if($('#modal_comentario_implantacao #novo_comentario_implantacao_id').val() != id)
        $("#modal_comentario_implantacao #text_comentario").val("");

    $('#modal_comentario_implantacao #novo_comentario_implantacao_id').val(id);
    $("#modal_comentario_implantacao #btnSalvarComentario").hide();
    $("#modal_comentario_implantacao #btnSalvarComentarioActivity").hide();
    $("#modal_comentario_implantacao #btnSalvarComentarioIndex").show();
    $('#modal_comentario_acompanhamento #retorno_data_retorno').mask('00/00/0000 00:00');
    $('#modal_comentario_implantacao').modal('show');
}

function getDataFormatada(data){
    if(data != null)
     return moment(data).format('DD/MM/YYYY HH:MM:SS');
    else return 'Sem agenda'
}

function transferirImplantacao(id) {
    $.getJSON("/implantacoes/" + id, function(data) {
        $('#modal_transferir_implantacao #transferir_implantacao_id').val(data['id']);
        $('#modal_transferir_implantacao #transferir_cliente').val(data['cliente']['razao_social']);
        $('#modal_transferir_implantacao #transferir_responsavel').val(data['user'] != null ? data['user']['name'] : '');
        $('#modal_transferir_implantacao #vendedor_atual').val(data['vendedor']);
        $('a[href="#tabTransferirImplantacao-1"]').click();
        $('#modal_transferir_implantacao').modal('show');
    });
}

function openModalvoltarImplantacao(id) {
    $.getJSON("/implantacoes/" + id, function(data) {
        $('#modal_voltar_implantacao #form_recuperar_acompanhamento')[0].reset();
        $('#modal_voltar_implantacao #voltar_implantacao_responsavel').val('').trigger("chosen:updated");

        $('#modal_voltar_implantacao #voltar_implantacao_id').val(data['id']);
        $('#modal_voltar_implantacao #voltar_implantacao_cliente_id').val(data['cliente']['id']);
        $('#modal_voltar_implantacao #voltar_implantacao_cliente').val(data['cliente']['razao_social']);
        $('#modal_voltar_implantacao #voltar_implantacao_vendedor').val(data['cliente']['fechamento']['user']['name']);
        $('#modal_voltar_implantacao #voltar_implantacao_responsavel').val(data['user'] != null ? data['user']['name'] : '');
        ''
        $('#modal_voltar_implantacao').modal('show');
    });
}


function getFormComentarioIndex(){
    form = new FormData();
    form.append('comentario[comentario]', $("#modal_comentario_implantacao #text_comentario").val());
    form.append('comentario[implantacao_id]', $('#modal_comentario_implantacao #novo_comentario_implantacao_id').val());
    if(moment($('#modal_comentario_implantacao #retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()){
        form.append('data_retorno', $('#modal_comentario_implantacao #retorno_data_retorno').val());
    }
    if($('#modal_comentario_implantacao #comentario_usuario_id').val() != null )
        form.append('usuario_id', $('#modal_comentario_implantacao #comentario_usuario_id').val());
    return form;
}

