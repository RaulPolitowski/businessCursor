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

$('#data_fim').mask('00/00/0000 00:00');
$('#data_inicio').mask('00/00/0000 00:00');
$('.chosen-select').chosen({width: "100%"});

$(document).ready(function() {
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

    $('#btnAtualizarAcompanhamentos').on('click', function () {
        atualizarPaineis();
        return false;
    });


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

    $('#modal_comentario_acompanhamento #btnSalvarComentarioIndex').on('click', function(){
        if($('#modal_comentario_acompanhamento #text_comentario').val() == ''){
            $('#modal_comentario_acompanhamento #error_comentario').show();
            return false;
        }
        $('#modal_comentario_acompanhamento #error_comentario').hide();

        if($('#modal_comentario_acompanhamento #retorno_data_retorno').val() == '' &&
            !moment($('#modal_comentario_acompanhamento #retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()) {
            exibirErro('Informe uma data de retorno válida!');
            return false;
        }
        $('#modal_comentario_acompanhamento').modal('hide');
        if(moment($('#modal_comentario_acompanhamento #retorno_data_retorno').val(),"DD/MM/YYYY HH:mm") > moment().add(2, 'days')){
            swal({
                title: 'INFORME A SENHA',
                input: 'password',
                inputAttributes: {
                    id: 'senha_master',
                    autocapitalize: 'off'
                },
                showConfirmButton: true,
                allowOutsideClick: false,
                showLoaderOnConfirm: true,
                preConfirm: function() {
                    return new Promise(function(resolve) {
                        $.post( "/parametros/senha_master_valida", { senha_master: $('#senha_master').val() }, function( data ) {
                            if(data == false){
                                swal.showValidationError(
                                    'Senha Inválida.'
                                )
                            }
                            resolve();
                        });
                    })
                }
            }).then(function(result) {
                if(result == true || result['value']){
                    salvarComentarioIndex();
                    $("#modal_comentario_acompanhamento #text_comentario").val("");
                }else{
                    exibirWarning('Comentário não cadastrado!');
                }
            });
        }else{
            salvarComentarioIndex();
            $("#modal_comentario_acompanhamento #text_comentario").val("");
        }
        return false;
    });

    $('#modal_transferir_acompanhamento #btnTransferirAcompanhamento').on('click', function () {
        if($('#modal_transferir_acompanhamento #transferir_novo_resp_acomp').val() == '') {
            exibirWarning("Selecione um responsável para fazer a transferencia.");
            return false;
        }

        $.ajax({
            url: '/acompanhamentos/transferir',
            data: { id: $('#modal_transferir_acompanhamento #transferir_acompanhamento_id').val(),
                    resp_id: $('#modal_transferir_acompanhamento #transferir_novo_resp_acomp').val() },
            type: 'POST',
            success: function (data) {
                $('#modal_transferir_acompanhamento').modal('hide');
                atualizarPaineis();
                exibirMsg("Acompanhamento transferido.")
                return false;
            },error: function(data){
                if(data['responseText'] == 'SOMENTE_ADMIN')
                    exibirErro('Você não tem permissão para transferir um acompanhamento da qual não é responsável.');
                else exibirErro("Ocorreu um erro.")
                return false;
            }
        });
        return false;
    });

    $('#btnTransferirImplantacao').on('click', function () {
        if($('#modal_transferir_acompanhamento #transferir_novo_responsavel_i').val() == '') {
            exibirWarning("Selecione um implantador para fazer a transferencia.");
            return false;
        }
        $.post( "/implantacoes/transferir_implantacao", { id: $('#modal_transferir_acompanhamento #transferir_implantacao_id').val(),
            resp_id: $('#modal_transferir_acompanhamento #transferir_novo_responsavel_i').val() } )
            .done(function( data ) {
                window.location.href = "/acompanhamentos/";
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
        if($('#modal_transferir_acompanhamento #vendedor_novo_v').val() == '') {
            exibirWarning("Selecione um vendedor para fazer a transferencia.");
            return false;
        }
        if($('#modal_transferir_acompanhamento #transferir_vendedor_comentario').val() == '') {
            exibirWarning("Informe um comentário para a transfêrencia de vendedor.");
            return false;
        }

        $.post( "/implantacoes/transferir_vendedor", { id: $('#modal_transferir_acompanhamento #transferir_implantacao_id').val(),
            resp_id: $('#modal_transferir_acompanhamento #vendedor_novo_v').val(), obs:  $('#modal_transferir_acompanhamento #transferir_vendedor_comentario').val()} )
            .done(function( data ) {
                window.location.href = "/acompanhamentos/";
            })
            .fail(function(data) {
                exibirErro(data);
                return false;
            });
        return false;
    });

    $('#modal_voltar_acompanhamento #voltar_acomp_data_retorno').datetimepicker({
        mask:'39.19.9999 29:59',
        format: 'dd/mm/yyyy hh:ii',
        language: 'pt-BR',
        autoclose: true,
        todayBtn: true,
        pickerPosition: "bottom-left"
    });

    $('#modal_voltar_acompanhamento #btnVoltarAcompanhamento').on('click', function () {
        voltarAcompanhamento();
        return false;
    });
});

function salvarComentarioIndex() {
    $.ajax({
        url: '/comentarios/',
        data: { 'comentario[comentario]': $("#modal_comentario_acompanhamento #text_comentario").val(),
            'comentario[acompanhamento_id]': $('#modal_comentario_acompanhamento #novo_comentario_acompanhamento_id').val(),
            'usuario_id':  $('#modal_comentario_acompanhamento #comentario_usuario_id').val(),
            'data_retorno': $('#modal_comentario_acompanhamento #retorno_data_retorno').val()},
        type: 'POST',
        success: function (data) {
            exibirMsg("Comentário cadastrado com sucesso.")
            return false;
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}

function atualizarPaineis(){
    getAguardando();
    getAndamento();
    getStandBy();
    getConcluidas();
    // getDesistentes();

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
    $.getJSON("/acompanhamentos/get_acompanhamentos?status=(0)&vendedor=" + $('#vendedor_id').val()
        + "&implantador=" + $('#implantador_id').val()
        + "&responsavel=" + $('#responsavel_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&estado=" + $('#estado_financeiro_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&novas=" + $('#novos').val(), function(data) {

        $('#text-painel0').text('AGUARDANDO (' + data.length + ')')
        $("#painel0 li").remove();
       $.each(data,function (i,val){
           $('<li class="' + getCorSistema(val['sistema']) + '-element" id="acompanhamento-'+ val['id'] +'">')
               .prepend(getPainelHtml(val, 0))
               .appendTo('#painel0');
           get_dias_sem_uso(val['id']);
        });
    });
}

function getAndamento() {
    $.getJSON("/acompanhamentos/get_acompanhamentos?status=(1)&vendedor=" + $('#vendedor_id').val()
        + "&implantador=" + $('#implantador_id').val()
        + "&responsavel=" + $('#responsavel_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&estado=" + $('#estado_financeiro_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&novas=" + $('#novos').val(), function(data) {
        $('#text-painel1').text('EM ANDAMENTO (' + data.length + ')')
        $("#painel1 li").remove();
        $.each(data,function (i,val){
            $('<li class="' + getCorSistema(val['sistema']) + '-element" id="acompanhamento-'+ val['id'] +'">')
                .prepend(getPainelHtml(val, 1))
                .appendTo('#painel1');
            get_dias_sem_uso(val['id']);
        });
    });
}

function getStandBy() {
    $.getJSON("/acompanhamentos/get_acompanhamentos?status=(2)&vendedor=" + $('#vendedor_id').val()
        + "&implantador=" + $('#implantador_id').val()
        + "&responsavel=" + $('#responsavel_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&estado=" + $('#estado_financeiro_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&novas=" + $('#novos').val(), function(data) {
        $('#text-painel3').text('STAND BY (' + data.length + ')')
        $("#painel3 li").remove();
        $.each(data,function (i,val){
            $('<li class="' + getCorSistema(val['sistema']) + '-element" id="acompanhamento-'+ val['id'] +'">')
                .prepend(getPainelHtml(val, 2))
                .appendTo('#painel3');
            get_dias_sem_uso(val['id']);
        });
    });
}

function getDesistentes() {
    $.getJSON("/acompanhamentos/get_acompanhamentos?status=(3,4)&vendedor=" + $('#vendedor_id').val()
        + "&implantador=" + $('#implantador_id').val()
        + "&responsavel=" + $('#responsavel_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&estado=" + $('#estado_financeiro_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&novas=" + $('#novos').val(), function(data) {
        $('#text-painel3').text('DESISTENTE (' + data.length + ')')
        $("#painel3 li").remove();
        $.each(data,function (i,val){
            $('<li class="' + getCorSistema(val['sistema']) + '-element" id="acompanhamento-'+ val['id'] +'">')
                .prepend(getPainelHtml(val, 3))
                .appendTo('#painel3');
            // get_dias_sem_uso(val['id']);
        });
    });

}

function getConcluidas() {
    $.getJSON("/acompanhamentos/get_acompanhamentos?status=(5)&vendedor=" + $('#vendedor_id').val()
        + "&implantador=" + $('#implantador_id').val()
        + "&responsavel=" + $('#responsavel_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&estado=" + $('#estado_financeiro_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&novas=" + $('#novos').val(), function(data) {
        $('#text-painel2').text('CONCLUÍDA (' + data.length + ')')
        $("#painel2 li").remove();
        $.each(data,function (i,val){
            $('<li class="' + getCorSistema(val['sistema']) + '-element" id="acompanhamento-'+ val['id'] +'">')
                .prepend(getPainelHtml(val, 5))
                .appendTo('#painel2');
            get_dias_sem_uso(val['id']);
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


function getPainelHtml(data, status){
    var html = data['razao_social']

    if( parseInt(data['status']) < 3){
        html = html +  '<div class="agile-detail">' +
        '<i class="fa fa-clock-o"></i> ' + getDataFormatada(data['data_agendamento_retorno']) +
        '</div>';
    }
        html = html + '<div class="agile-detail">' +
        '<span class="pull">Sistema: ' +  data['sistema'] + '</span>' +
        '</div>';

        html = html + '<div class="agile-detail pull-center">' +
        '<a class="btn btn-xs btn-info" style="margin-right: 5px" href="/acompanhamentos/'+ data['id'] +'" title="Lançar"><span class="fa fa-eye"></span></a>' +
        '<button class="btn btn-primary btn-xs tooltipteste" style="margin-right: 5px" onclick="' + 'abrirModalActivities(\'' + data['id'] + '\')' + '" id="activities-'+data['id'] + '" type="button" title="' + getTitleTooltip(data['ultimo_comentario'], data['observacao']) + '"><span class="fa fa-comments"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px"  onclick="' + 'novoComentario(\'' + data['id'] + '\')' + '" id="novocomentario-'+data['id'] + '" type="button" title="Novo comentário"><span class="fa fa-comment"></span></button>' +
        '<button class="btn btn-xs btn-warning" style="margin-right: 5px" onclick="transferirAcompanhamento(' + data['id'] + ')" title="Transferir"><span class="fa fa-exchange"></span></button>'+
        '<a class="btn btn-xs btn-info" href="/contratos/emitir_contrato?id='+data['id'] + '&local=acompanhamento" title="Contrato"><span class="fa fa-file-text "></span></a>';
        if(data['telefone'] != null) {
            html = html + '<a class="btn btn-xs btn-white" style="margin-left: 5px" href="https://api.whatsapp.com/send?phone=55' + apenasNumeros(data['telefone']) + '" title="Whatsapp" target="_blank"><img alt="Avatar" class="img-circle" src="/assets/whats_enviado-48910f63828c36a6fa71b452fdc92993272672d48b6b907f4267f078799d0ce4.ico"></a>'
        }
        if ((status < 3 || status == 5)  && $('#user_is_admin').val() == 'true') //status 0,1,2
            html = html + '<button class="btn btn-xs btn-primary" style="margin-left: 5px" onclick="openModalvoltarAcompanhamento(' + data['id'] + ', ' + status + ')" title="Voltar etapa"><span class="fa fa-undo"></span></button>';
                      
        html = html +  '</div></li>';

    return html;
}

function getTitleTooltip(ultimo_comentario, observacao) {
    var text = '<h5>' + formatarData(ultimo_comentario) + ' - ' + moment(formatarData(ultimo_comentario), "DD/MM/YYYY HH:mm").fromNow() + '</h5>';
    text = text + '<h7>' + observacao + '</h7>';
    return text;
}

function get_dias_sem_uso(id){
    $.getJSON("/acompanhamentos/"+id+"/get_dias_sem_uso", function(data) {
        $('#dias_sem_uso-'+ id).text('Dias sem uso: ' + data)
    });
}

function getDataFormatada(data){
    if(data != null)
        return formatarData(data);
    else return 'Sem retorno'
}

function novoComentario(id){
    if($('#modal_comentario_acompanhamento #novo_comentario_acompanhamento_id').val() != id)
        $("#modal_comentario_acompanhamento #text_comentario").val("");

    $('#modal_comentario_acompanhamento #novo_comentario_acompanhamento_id').val(id);
    $('#modal_comentario_acompanhamento #btnSalvarComentario').hide();
    $('#modal_comentario_acompanhamento #btnSalvarComentarioActivity').hide();
    $('#modal_comentario_acompanhamento #btnSalvarComentarioIndex').show();
    $('#modal_comentario_acompanhamento #retorno_data_retorno').mask('00/00/0000 00:00');
    $('#modal_comentario_acompanhamento #comentario_data_retorno').show();
    $('#modal_comentario_acompanhamento').modal('show');
}

function abrirModalActivities(id) {
    $.ajax({
        url: '/acompanhamentos/activities',
        data: {id: id},
        type: 'GET',
        success: function (data) {
            $("#modal_content_activities").html(data);
            $("#modal_activities_acompanhamentos").modal('show')
            addFuncoes(id);
        },error: function(data){
            exibirErro(data);
        }
    });
}

function addFuncoes(id){
    $('#abrirComentarioActivityAcompanhamento').on('click', function () {
        if($('#modal_comentario_acompanhamento #novo_comentario_acompanhamento_id').val() != id)
            $("#modal_comentario_acompanhamento #text_comentario").val("");

        $('#modal_comentario_acompanhamento #btnSalvarComentario').hide();
        $('#modal_comentario_acompanhamento #btnSalvarComentarioIndex').hide();
        $('#modal_comentario_acompanhamento #btnSalvarComentarioActivity').show();
        $('#modal_comentario_acompanhamento #comentario_data_retorno').show();
        $('#modal_comentario_acompanhamento #text_comentario').val('');
        $('#modal_comentario_acompanhamento #retorno_data_retorno').val('');
        $('#modal_comentario_acompanhamento').modal('show');
    });
}

$('#modal_comentario_acompanhamento #btnSalvarComentarioActivity').on('click', function(){
    if($('#modal_comentario_acompanhamento #text_comentario').val() == ''){
        $('#error_comentario').show();
        return false;
    }
    $('#modal_comentario_acompanhamento #error_comentario').hide();
    if($('#modal_comentario_acompanhamento #retorno_data_retorno').val() == '' && !moment($('#modal_comentario_acompanhamento #retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()) {
        exibirErro('Informe uma data de retorno válida!');
        return false;
    }
    $.getJSON('/agendamento_retornos/verificar_horario_acompanhamento?data_retorno='+ $('#modal_comentario_acompanhamento #retorno_data_retorno').val(), function(data) {
        if(parseInt(data) > 0){
            exibirWarning('Já existe um retorno agendado para o mesmo horário!');
            return false;
        }else{
            if(moment($('#modal_comentario_acompanhamento #retorno_data_retorno').val(),"DD/MM/YYYY HH:mm") > moment().add(2, 'days')){
                $('#modal_comentario_acompanhamento').modal('hide');
                swal({
                    title: 'INFORME A SENHA',
                    input: 'password',
                    inputAttributes: {
                        id: 'senha_master',
                        autocapitalize: 'off'
                    },
                    showConfirmButton: true,
                    allowOutsideClick: false,
                    showLoaderOnConfirm: true,
                    preConfirm: function() {
                        return new Promise(function(resolve) {
                            $.post( "/parametros/senha_master_valida", { senha_master: $('#senha_master').val() }, function( data ) {
                                if(data == false){
                                    swal.showValidationError(
                                        'Senha Inválida.'
                                    )
                                }
                                resolve();
                            });
                        })
                    }
                }).then(function(result) {
                    if(result == true || result['value']){
                        salvarComentarioActivity();
                    }else{
                        exibirWarning('Comentário não cadastrado!');
                    }
                });
            }else{
                salvarComentarioActivity();
            }
        }
    });

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
            $('#modal_comentario_acompanhamento').modal('hide');
            $('#modal_activities_acompanhamentos').modal('hide');
            exibirMsg("Comentário cadastrado com sucesso.");
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}

function getFormComentarioActivity(){
    form = new FormData();
    form.append('comentario[comentario]', $("#modal_comentario_acompanhamento #text_comentario").val());
    form.append('comentario[acompanhamento_id]', $("#acompanhamento_id").val());
    if(moment($('#modal_comentario_acompanhamento #retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()){
        form.append('data_retorno', $('#modal_comentario_acompanhamento #retorno_data_retorno').val());
    }
    form.append('usuario_id', $('#modal_comentario_acompanhamento #comentario_usuario_id').val());

    return form;
}

function transferirAcompanhamento(id) {
    $.getJSON("/acompanhamentos/" + id, function(data) {
        $('#modal_transferir_acompanhamento #transferir_acompanhamento_id').val(data['id']);
        $('#modal_transferir_acompanhamento #transferir_cliente_a').val(data['cliente']['razao_social']);
        $('#modal_transferir_acompanhamento #transferir_responsavel_a').val(data['user'] != null ? data['user']['name'] : '');
        //console.log(data['implantacao_id']['id']);
        $('a[href="#tabTransferirAcompanhamento-1"]').click();
        $.getJSON("/implantacoes/" + data['implantacao_id']['id'], function(data2) {
            $('#modal_transferir_acompanhamento #transferir_implantacao_id').val(data2['id']);
            $('#modal_transferir_acompanhamento #transferir_cliente_i').val(data2['cliente']['razao_social']);
            $('#modal_transferir_acompanhamento #transferir_cliente_v').val(data2['cliente']['razao_social']);
            $('#modal_transferir_acompanhamento #transferir_responsavel_i').val(data2['user'] != null ? data2['user']['name'] : '');
            $('#modal_transferir_acompanhamento #vendedor_atual').val(data2['vendedor']);
            $('a[href="#tabTransferirImplantacao-1"]').click();
        });

        $('#modal_transferir_acompanhamento').modal('show');
    });
}

function openModalvoltarAcompanhamento(id, status) {
    $.getJSON("/acompanhamentos/" + id, function(data) {
        $('#modal_voltar_acompanhamento #form_voltar_acompanhamento')[0].reset();
        $('#modal_voltar_acompanhamento #voltar_acomp_status_implantacao').val('').trigger("chosen:updated");
        $('#modal_voltar_acompanhamento #voltar_acompanhamento_responsavel').val('').trigger("chosen:updated");

        $('#modal_voltar_acompanhamento #voltar_acompanhamento_id').val(data['id']);
        $('#modal_voltar_acompanhamento #voltar_acompanhamento_cliente_id').val(data['cliente']['id']);
        $('#modal_voltar_acompanhamento #voltar_acompanhamento_cliente').val(data['cliente']['razao_social']);
        if (status == 0){
            $('#modal_voltar_acompanhamento #status_atual_acompanhamento').val('AGUARDANDO');
            $('#voltar_acompanhamento_etapa').find('[value="2"]').remove();
        }else if (status == 1){
            $('#modal_voltar_acompanhamento #status_atual_acompanhamento').val('EM ANDAMENTO');
            $('#voltar_acompanhamento_etapa').find('[value="2"]').remove();
        }else if (status == 2){
            $('#modal_voltar_acompanhamento #status_atual_acompanhamento').val('STAND BY');
            $('#voltar_acompanhamento_etapa').find('[value="2"]').remove();
        }else if (status == 5){
            $('#modal_voltar_acompanhamento #status_atual_acompanhamento').val('CONCLUÍDA');
            $('#voltar_acompanhamento_etapa').find('[value="2"]').remove();
            $('#voltar_acompanhamento_etapa').append('<option value="'+ 2 + '">' + "Acompanhamento" + '</option>'); 
        }
        $('#voltar_acompanhamento_etapa').trigger("chosen:updated");
        $('#modal_voltar_acompanhamento #voltar_acompanhamento_responsavel').val(data['user'] != null ? data['user']['name'] : '');
        $('#modal_voltar_acompanhamento #voltar_acompanhamento_vendedor').val(data['cliente']['fechamento']['user']['name']);
        
        $('#modal_voltar_acompanhamento').modal('show');
    });
}

function voltarAcompanhamento() {
    if($('#modal_voltar_acompanhamento #voltar_acompanhamento_etapa').val() == '') {
        exibirErro("É obrigatório informar uma etapa para voltar.");
        return false;
    }

    if($('#modal_voltar_acompanhamento #voltar_acomp_data_retorno').val() == '') {
        exibirErro("É obrigatório informar data de retorno.");
        return false;
    }
    if($('#modal_voltar_acompanhamento #voltar_acompanhamento_responsavel').val() == null) {
        exibirErro("É obrigatório informar um vendedor.");
        return false;
    }

    if($('#modal_voltar_acompanhamento #voltar_acompanhamento_etapa').val() == 0) {
        //voltar acompanhamento pra implantacao
        $.ajax({
            url: '/acompanhamentos/' + $('#modal_voltar_acompanhamento #voltar_acompanhamento_id').val() + '/voltar_acomp_pra_impl',
            data: { id: $('#modal_voltar_acompanhamento #voltar_acompanhamento_id').val(),
                responsavel: $('#modal_voltar_acompanhamento #voltar_acompanhamento_responsavel').val(),
                data_retorno: $('#modal_voltar_acompanhamento #voltar_acomp_data_retorno').val(),
                cliente_id: $('#modal_voltar_acompanhamento #voltar_acompanhamento_cliente_id').val(),
                status: parseInt($('#modal_voltar_acompanhamento #voltar_acomp_status_implantacao').val()),
                motivo: $('#modal_voltar_acompanhamento #voltar_acompanhamento_motivo').val()},
            type: 'PUT',
            success: function(data) {
                $('#modal_voltar_acompanhamento').modal('hide');
                exibirMsg("Acompanhamento voltou para implantação.")
                atualizarPaineis();           
            },
            error: function(data) {
                exibirErro(data);
            }
        });
    }else if($('#modal_voltar_acompanhamento #voltar_acompanhamento_etapa').val() == 1){
        //voltar pra negociacao
        $.ajax({
            url: '/acompanhamentos/' + $('#modal_voltar_acompanhamento #voltar_acompanhamento_id').val() + '/voltar_negociacao',
            data: { id: $('#modal_voltar_acompanhamento #voltar_acompanhamento_id').val(),
                responsavel: $('#modal_voltar_acompanhamento #voltar_acompanhamento_responsavel').val(),
                data_retorno: $('#modal_voltar_acompanhamento #voltar_acomp_data_retorno').val(),
                cliente_id: $('#modal_voltar_acompanhamento #voltar_acompanhamento_cliente_id').val(),
                motivo: $('#modal_voltar_acompanhamento #voltar_acompanhamento_motivo').val()},
            type: 'PUT',
            success: function(data) {
                $('#modal_voltar_acompanhamento').modal('hide');
                exibirMsg("Acompanhamento voltou para negociação.")
                atualizarPaineis();         
            },
            error: function(data) {
                exibirErro(data);
            }
        });
    }else if($('#modal_voltar_acompanhamento #voltar_acompanhamento_etapa').val() == 2){
        //voltar pra acompanhamento
        $.ajax({
            url: '/acompanhamentos/' + $('#modal_voltar_acompanhamento #voltar_acompanhamento_id').val() + '/voltar_acomp_pra_acomp',
            data: { id: $('#modal_voltar_acompanhamento #voltar_acompanhamento_id').val(),
                responsavel: $('#modal_voltar_acompanhamento #voltar_acompanhamento_responsavel').val(),
                data_retorno: $('#modal_voltar_acompanhamento #voltar_acomp_data_retorno').val(),
                cliente_id: $('#modal_voltar_acompanhamento #voltar_acompanhamento_cliente_id').val(),
                status: parseInt($('#modal_voltar_acompanhamento #voltar_acomp_status_acompanhamento').val()),
                motivo: $('#modal_voltar_acompanhamento #voltar_acompanhamento_motivo').val()},
            type: 'PUT',
            success: function(data) {
                $('#modal_voltar_acompanhamento').modal('hide');
                exibirMsg("Empresa voltou para acompanhamento.")
                atualizarPaineis();         
            },
            error: function(data) {
                exibirErro(data);
            }
        });
    }
}
