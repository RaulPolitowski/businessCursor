//= require jquery-ui/jquery-ui.min.js
//= require datapicker/bootstrap-datepicker.js
//= require chosen/chosen.jquery.js
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

    $('#data_fim').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });


    google.charts.load('current', {'packages': ['corechart', 'table']});

    $('.chosen-select').chosen({width: "100%", allow_single_deselect: true});

    $('#negociacao_reagendar_retorno #reagendar_negociacao_nova_data').mask('00/00/0000 00:00');

    atualizarPaineis();

    $('#btnAtualizarNegociacoes').on('click', function () {
        atualizarPaineis();
        return false;
    })

    $('#btnTransferirNegociacao').on('click', function () {
        if($('#modal_transferir_negociacao #transferir_novo_responsavel').val() == '') {
            exibirWarning("Selecione um responsável para fazer a transferencia.");
            return false;
        }

        $.post( "/negociacoes/transferir_negociacao", { id: $('#modal_transferir_negociacao #transferir_negociacao_id').val(),
        resp_id: $('#modal_transferir_negociacao #transferir_novo_responsavel').val() }, function (data) {
            atualizarPaineis();
            $('#modal_transferir_negociacao #transferir_novo_responsavel').val('').trigger('chosen:updated')
            $('#modal_transferir_negociacao').modal('toggle');
            return false;
        } )
        .fail(function(data) {
            exibirErro('Ocorreu um erro.');
            return false;
        });
        return false;
    });

    $('#btnTransferirNegociacoes').on('click', function () {
        if($('#modal_transferir_negociacao #transferir_novo_responsavel').val() == '') {
            exibirWarning("Selecione um responsável para fazer a transferencia.");
            return false;
        }

        $.post( "/negociacoes/transferir_negociacoes", { id: $('#modal_transferir_negociacao #transferir_negociacao_id').val(),
            resp_id: $('#modal_transferir_negociacao #transferir_novo_responsavel').val(),
            filtro: $('#modal_transferir_negociacao #filtro').val(),
            tipo: $('#modal_transferir_negociacao #tipo').val(),
            vendedor: $('#operador_id').val(),
            empresa: $('#empresa_id').val(),
            data_inicio: $('#data_inicio').val(),
            data_fim: $('#data_fim').val(),
            cliente: $('#filtro_cliente_id').val()}, function (data) {
            atualizarPaineis();
            $('#modal_transferir_negociacao #transferir_novo_responsavel').val('').trigger('chosen:updated')
            $('#modal_transferir_negociacao').modal('toggle');
            return false;
        } )
            .fail(function(data) {
                exibirErro('Ocorreu um erro.');
                return false;
            });
        return false;
    });

    $('#btnSalvarComentario').on('click', function () {
        if($('#modal_comentario #text_comentario').val() == ''){
            $('#error_comentario').show();
            return false;
        }
        $('#error_comentario').hide();
        $.ajax({
            url: '/comentarios/',
            data: { 'comentario[comentario]': $("#modal_comentario #text_comentario").val(), 'comentario[negociacao_id]': $('#novo_comentario_negociacao_id').val()},
            type: 'POST',
            success: function (data) {
                $('#modal_comentario').modal('toggle');
                $("#modal_comentario #text_comentario").val("");
                exibirMsg("Comentário cadastrado com sucesso.")
                return false;
            },error: function(data){
                exibirErro('Ocorreu um erro.');
            }
        });
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

    $('#negociacao_reagendar_retorno #btnReagendarRetorno').on('click', function () {
        if ($('#negociacao_reagendar_retorno #reagendar_negociacao_nova_data').val() == '' || !moment($('#negociacao_reagendar_retorno #reagendar_negociacao_nova_data').val(),"DD/MM/YYYY HH:mm").isValid()){
            exibirErro("Informe uma data válida.");
            return false;
        }
        if ($('#negociacao_reagendar_retorno #reagendar_negociacao_motivo').val() == ''){
            exibirErro("Informe o motivo do reagendamento.");
            return false;
        }

        //modificacao abaixo

        if(moment($('#negociacao_reagendar_retorno #reagendar_negociacao_nova_data').val(),"DD/MM/YYYY HH:mm") > moment().add(3, 'days')){
            $('#negociacao_reagendar_retorno').modal('toggle');
            swal({
                title: 'INFORME A SENHA',
                input: 'password',
                inputAttributes: {
                    id: 'senha_master',
                    autocapitalize: 'off'
                },
                allowOutsideClick: true,
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
                    salvarRetorno(false);
                }else{
                    exibirWarning('Retorno não foi salvo, tente novamente.');
                }
            });
        }else{
            salvarRetorno(true);
        }

        return false;
    });
});

function salvarRetorno(closeDialog) {
    $.post( "/agendamento_retornos/reagendar_retorno_negociacao", { id: $('#negociacao_reagendar_retorno #reagendar_negociacao_retorno_id').val(),
        motivo: $('#negociacao_reagendar_retorno #reagendar_negociacao_motivo').val(),
        data_agendamento_retorno:  $('#negociacao_reagendar_retorno #reagendar_negociacao_nova_data').val(),
        negociacao_id: $('#negociacao_reagendar_retorno #reagendar_negociacao_negociacao_id').val()}, function () {
        exibirMsg('Retorno reagendado.');
        if(closeDialog)
            $('#negociacao_reagendar_retorno').modal('toggle');
        atualizarPaineis();
        return false;
    } ).fail(function(data) {
        if(data['responseText'] == "\"FORA_HORARIO\"")
            exibirErro("O selecione um horário entre 8:00 e 21:00.")
        else if (data['responseText'] == "\"72_HORAS\"")
            exibirErro("O retorno não pode ter mais que 72 horas.")
        else exibirErro('Ocorreu um erro.');
        return false;
    });
}

function atualizarPaineis() {
    $('#totalNegociacoes').val(0);
    $('#totalNegociacoesConfirmacao').val(0);
    atualizarHoje();
    atualizarAtrasadas();
    atualizarProximos();
    atualizarDemais();
    atualizarHojeConfirmacao();
    atualizarAtrasadasConfirmacao();
    atualizarProximosConfirmacao();
    atualizarDemaisConfirmacao();
    drawDataTable_Consultor();

}

function atualizarHoje(){
    $.getJSON("/negociacoes/get_empresas_negociacao?filtro=hoje&tipo=0&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel0').empty();
        $('#text-painel0').text('HOJE (' + data.length + ')');
        $('#total_painel0').val(data.length);
        somarTotal(data.length);
        $.each(data,function (i,val){
            $('<li class="" id="negociacao-'+ val['id'] +'">')
                .prepend(getPainelHtml(val))
                .appendTo('#painel0');
        });
    });
}

function atualizarHojeConfirmacao(){
    $.getJSON("/negociacoes/get_empresas_negociacao?filtro=hoje&tipo=1&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel4').empty();
        $('#text-painel4').text('HOJE (' + data.length + ')');
        $('#total_painel4').val(data.length);
        somarTotalConfirmacao(data.length);
        $.each(data,function (i,val){
            $('<li class="" id="negociacao-'+ val['id'] +'">')
                .prepend(getPainelHtml(val))
                .appendTo('#painel4');
        });
    });
}

function atualizarAtrasadas(){
    $.getJSON("/negociacoes/get_empresas_negociacao?filtro=atrasadas&tipo=0&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel1').empty();
        $('#text-painel1').text('ATRASADAS (' + data.length + ')');
        $('#total_painel1').val(data.length);
        somarTotal(data.length);
        $.each(data,function (i,val){
            $('<li class="" id="negociacao-'+ val['id'] +'">')
                .prepend(getPainelHtml(val))
                .appendTo('#painel1');
        });
    });
}

function atualizarAtrasadasConfirmacao(){
    $.getJSON("/negociacoes/get_empresas_negociacao?filtro=atrasadas&tipo=1&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel5').empty();
        $('#text-painel5').text('ATRASADAS (' + data.length + ')');
        $('#total_painel5').val(data.length);
        somarTotalConfirmacao(data.length);
        $.each(data,function (i,val){
            $('<li class="" id="negociacao-'+ val['id'] +'">')
                .prepend(getPainelHtml(val))
                .appendTo('#painel5');
        });
    });
}


function atualizarProximos(){
    $.getJSON("/negociacoes/get_empresas_negociacao?filtro=prox&tipo=0&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel2').empty();
        $('#text-painel2').text('PROX. 7 DIAS (' + data.length + ')')
        $('#total_painel2').val(data.length);
        somarTotal(data.length);
        $.each(data,function (i,val){
            $('<li class="" id="negociacao-'+ val['id'] +'">')
                .prepend(getPainelHtml(val))
                .appendTo('#painel2');
        });
    });
}

function atualizarProximosConfirmacao(){
    $.getJSON("/negociacoes/get_empresas_negociacao?filtro=prox&tipo=1&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel6').empty();
        $('#text-painel6').text('PROX. 7 DIAS (' + data.length + ')');
        $('#total_painel6').val(data.length);
        somarTotalConfirmacao(data.length);
        $.each(data,function (i,val){
            $('<li class="" id="negociacao-'+ val['id'] +'">')
                .prepend(getPainelHtml(val))
                .appendTo('#painel6');
        });
    });
}

function atualizarDemais(){
    $.getJSON("/negociacoes/get_empresas_negociacao?filtro=demais&tipo=0&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel3').empty();
        $('#text-painel3').text('DEMAIS (' + data.length + ')')
        $('#total_painel3').val(data.length);
        somarTotal(data.length);
        $.each(data,function (i,val){
            $('<li class="" id="negociacao-'+ val['id'] +'">')
                .prepend(getPainelHtml(val))
                .appendTo('#painel3');
        });
    });
}

function atualizarDemaisConfirmacao(){
    $.getJSON("/negociacoes/get_empresas_negociacao?filtro=demais&tipo=1&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel7').empty();
        $('#text-painel7').text('DEMAIS (' + data.length + ')')
        $('#total_painel7').val(data.length);
        somarTotalConfirmacao(data.length);
        $.each(data,function (i,val){
            $('<li class="" id="negociacao-'+ val['id'] +'">')
                .prepend(getPainelHtml(val))
                .appendTo('#painel7');
        });
    });
}

function somarTotal(total){
    var aux = parseInt($('#totalNegociacoes').val());
    aux = aux + total;
    $('#totalNegociacoes').val(aux);
    $('#textTotal').text('Total ' + aux + ' negociações');
}

function somarTotalConfirmacao(total){
    var aux = parseInt($('#totalNegociacoesConfirmacao').val());
    aux = aux + total;
    $('#totalNegociacoesConfirmacao').val(aux);
    $('#textTotalConfirmacao').text('Total ' + aux + ' aguardando confirmação');
}

function getPainelHtml(data){
    var html = '<strong>' + getStringTamanho(data['razao_social']) + '</strong>' +
        '<div class="agile-detail">' +
        '<span class="pull-right">Em negociação a ' + data['qtd_dias'] +  ' dias' +'</span>' +
        'Início: <span class="text-muted"><strong>' + getInicio(data['data_inicio']) + '</strong> <i class="fa fa-clock-o"></i></span>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<span>Operador: <strong>' +  data['vendedor'] + '</strong></span>' +
        // '<i class="pull-right fa fa-info-circle" title="' + data['observacao'] + '"></i>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<span>Telefone: <strong>' + data['telefone'] +'</strong> <i class="fa fa-phone"></i></span>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<span>Contato: <strong>' + data['contato'] + '</strong></span>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<div class="small m-b-xs">' +
        getRetorno(data['retorno']) +
        '</div>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<div class="small m-b">Canal de atend.: ' +
        '<input class="whats" id="whats'+ data['id'] + '"  style="margin-right: 10px; margin-left: 10px" type="checkbox" title="Whatsapp" ' + (data['canal_atendimento'] == '1' ? 'checked' : '') +' disabled>' +
        '<input class="telefone" id="telefone'+ data['id'] + '"  type="checkbox" title="Telefone" ' + (data['canal_atendimento'] == '2'  ? 'checked' : '') +' disabled>' +
        '</div>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<div class="pull-center">' +
        '<button id="btn-'+ + data['id'] + '" style="margin-right: 5px" onclick="' + 'efetuarRetorno(\'' + data['cliente_id'] + '\')' + '" class="btn btn-primary btn-xs" title="Ligação"><span class="fa fa-phone Contato"></span></button>' +
        '<button class="btn btn-danger btn-xs" style="margin-right: 5px" onclick="' + 'cancelarNegociacao(\'' + data['id'] + '\')' + '" id="cancelar-'+data['id'] + '" type="button" title="Cancelar"><span class="fa fa-trash"></span></button>' +
        '<button class="btn btn-info btn-xs" style="margin-right: 5px" onclick="' + 'transferirNegociacao(\'' + data['id'] + '\')' + '" id="transferir-'+data['id'] + '" type="button" title="Transferir"><i class="fa fa-exchange"></i></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'comentarios(\'' + data['id'] + '\')' + '" id="comentarios-'+data['id'] + '" type="button" title="Comentários"><span class="fa fa-comments"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'novoComentario(\'' + data['id'] + '\')' + '" id="novocomentario-'+data['id'] + '" type="button" title="Novo comentário"><span class="fa fa-comment"></span></button>' +
        '<button class="btn btn-info btn-xs" onclick="reagendar(' + data['id'] + ')" id="reagendar-'+data['id'] + '" type="button" title="Reagendar"><i class="fa fa-clock-o"></i>' + '</button>' +
        '</div>' +
        '</div>' +
    '</div>' +
    '</li>';

    return html;
}

function getStringTamanho(txt) {
    if(window.innerWidth > 1366)
        return txt.substring(0,50)

    return txt.substring(0,29)
}

function getRetorno(retorno) {
    if(retorno == null)
        return "Sem retorno agendado!";
    else return "Retorno agendado " +  moment(retorno).format('DD/MM/YYYY HH:mm');
}

function getInicio(inicio) {
   return  moment(inicio).format('DD/MM/YYYY');
}

function cancelarNegociacao(id) {
    swal({
        title: "Deseja cancelar a negociação?",
        text: '',
        type: "warning",
        customClass: 'swal-width',
        showCancelButton: true,
        showConfirmButton: true,
        allowOutsideClick: false,
        html: '<form class="form-horizontal" id="form_motivo_cancelamento">\n' +
        '        <div class="modal-body">\n' +
        '          <div class="form-group">\n' +
        '            <div class="field">\n' +
        '              <div class="col-sm-12 padding">\n' +
        '                <textarea autocomplete="off" class="form-control" placeholder="Informe a motivo" name="motivo_cancelamento" id="motivo_cancelamento"></textarea>\n' +
        '              </div>\n' +
        '            </div>\n' +
        '          </div>\n' +
        '        </div>\n' +
        '      </form>',
        showLoaderOnConfirm: true,
        preConfirm: function() {
            return new Promise(function(resolve) {
                if($('#motivo_cancelamento').val() == null || $('#motivo_cancelamento').val() == ''){
                    swal.showValidationError(
                        'Informe o motivo.'
                    )
                }
                resolve();
            })
        }
    }).then(function(result) {
        if (result.value) {
            $.ajax({
                url: '/negociacoes/' + id + '/cancelar',
                data: { 'negociacao[obs]': $('#motivo_cancelamento').val() },
                type: 'PUT',
                success: function(data) {
                    exibirMsg("Negociação cancelada.")
                    atualizarPaineis();
                },
                error: function(data) {
                    exibirErro(data);
                }
            });
        }
    });
}

function reagendar(id){
    $.getJSON("/negociacoes/" + id, function(data) {
        if(data['retorno'])
            $('#negociacao_reagendar_retorno #reagendar_negociacao_retorno_id').val(data['retorno']['id']);
        $('#negociacao_reagendar_retorno #reagendar_negociacao_negociacao_id').val(data['id']);
        $('#negociacao_reagendar_retorno #reagendar_negociacao_cliente').val(data['cliente']['razao_social']);
        $('#negociacao_reagendar_retorno').modal('show');
    });
}

function transferirNegociacao(id) {
    $('#modal_transferir_negociacao #formCliente').show();
    $('#modal_transferir_negociacao #formOperador').show();
    $('#modal_transferir_negociacao #btnTransferirNegociacao').show();
    $('#modal_transferir_negociacao #btnTransferirNegociacoes').hide();

    $.getJSON("/negociacoes/" + id, function(data) {
        $('#modal_transferir_negociacao #transferir_negociacao_id').val(data['id']);
        $('#modal_transferir_negociacao #transferir_cliente').val(data['cliente']['razao_social']);
        $('#modal_transferir_negociacao #transferir_responsavel').val(data['user'] != null ? data['user']['name'] : '');
        $('#modal_transferir_negociacao').modal('show');
    });
}

function transferirNegociacoes(filtro, tipo){
    if($('#operador_id').val() == '' || $('#operador_id').val() == null){
        exibirWarning("Não é possivel transferir todas as negociações do card sem selecionar o operador nos filtros.");
        return false;
    }
    $('#modal_transferir_negociacao #filtro').val(filtro);
    $('#modal_transferir_negociacao #tipo').val(tipo);
    $('#modal_transferir_negociacao #formCliente').hide();
    $('#modal_transferir_negociacao #formOperador').hide();
    $('#modal_transferir_negociacao #btnTransferirNegociacao').hide();
    $('#modal_transferir_negociacao #btnTransferirNegociacoes').show();
    $('#modal_transferir_negociacao').modal('show');
}

function comentarios(id) {
    $.ajax({
        url: '/negociacoes/activities',
        data: {id: id},
        type: 'GET',
        success: function (data) {
            $("#modal_content_activities").html(data);
            $("#modal_activities_negociacao").modal('show')
        },error: function(data){
            exibirErro(data);
        }
    });
}

function novoComentario(id){
    if($('#novo_comentario_negociacao_id').val() != id){
        $("#modal_comentario #text_comentario").val("");
    }
    $('#novo_comentario_negociacao_id').val(id);
    $('#modal_comentario').modal('show');
}

function efetuarRetorno(cliente_id){
    $.ajax({
        url: '/ligacoes/cancelar_atendimentos_usuario',
        type: 'PUT',
        success: function (data) {
            window.open("../ligacoes/ligacao?cliente_retorno_id=" + cliente_id, '_blank');
        },error: function(data){
            exibirErro(data);
        }
    });
}


function deleteComentario(id) {
    swal({
        title: "Deseja excluir o comentário?",
        text: '',
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Sim!",
        cancelButtonText: "Não!",
        showConfirmButton: true,
        allowOutsideClick: false
    }).then(function(result) {
        if (result.value) {
            $.ajax({
                url: '/comentarios/' + id,
                processData: false,
                contentType: false,
                type: 'DELETE',
                success: function (data) {
                    $("#modal_content_activities").html('');
                    $("#modal_activities_negociacao").modal('toggle')
                },error: function(data){
                    exibirErro('Ocorreu um erro.');
                }
            });
            return false;
        }
    });
}

function drawDataTable_Consultor() {
    $.getJSON("/negociacoes/get_informacao_por_consultor?data_inicio="+ $('#data_inicio').val() +
        "&data_fim=" + $('#data_fim').val()+
        '&empresa=' + $('#empresa_id').val()
        , function (data) {
            console.log(data)
            var datatable = new google.visualization.DataTable();

            datatable.addColumn('string', 'Consultor')
            datatable.addColumn('number', 'Negociações Abertas no Período')
            datatable.addColumn('number', 'Negociações Baixadas no Período')
            datatable.addColumn('number', 'Total de Retornos Atrasados')
            datatable.addColumn('number', 'Total de Negociações Ativas')

            var total_abertas = 0
            var total_atrasados = 0
            var total_ativas = 0
            var total_baixadas = 0
            for (var i = 0; i < data.length; i++) {
                datatable.addRow([data[i].nome, parseInt(data[i].qtd_abertas), parseInt(data[i].qtd_baixadas), parseInt(data[i].qtd_atrasadas), 0]);
                total_abertas += parseInt(data[i].qtd_abertas)
                total_atrasados += parseInt(data[i].qtd_atrasadas)
                total_ativas += parseInt(data[i].qtd_ativas)
                total_baixadas += parseInt(data[i].qtd_baixadas)
                datatable.setCell(i , 4, parseInt(data[i].qtd_ativas), parseInt(data[i].qtd_ativas),{'className':'greencolor'});
            }

            datatable.addRow(['Totais', total_abertas,  total_baixadas ,total_atrasados, total_ativas]);
            datatable.setRowProperty(data.length, 'className', 'bold')
            datatable.setCell(data.length   , 4, total_ativas, total_ativas,{'className':'greencolor'});

            var table = new google.visualization.Table(document.getElementById('tabela_consultor'));

            table.draw(datatable, {allowHtml: true, width: '100%', height: '100%', frozenColumns: 1});


        });
}