//= require jquery-ui/jquery-ui.min.js
//= require datapicker/bootstrap-datepicker.js
//= require chosen/chosen.jquery.js
//= require auditoria_desistencia/auditoria_acompanhamento.js
//= require auditoria_desistencia/auditoria_implantacao.js

$(document).ready(function() {
    drag_drop_negociacoes();

    $('#negociacao_reagendar_retorno #reagendar_negociacao_nova_data').mask('00/00/0000 00:00');

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

    $('#negociacao_recuperar #btnRecuperarNegociacao').on('click', function () {
        recuperarNegociacao();
        return false;
    });
});

function atualizar_paineis_negociacao() {
    negociacoesCanceladas();
    aguardandoConfirmacaoCanceladas();
    conferidasCanceladas();
}

function somarTotalNegociacao(total){
    var aux = parseInt($('#total_negociacao').val());
    aux = aux + total;
    $('#total_negociacao').val(aux);
    $('#tabNegociacao').text('Negociações (' + aux + ')');
}

function negociacoesCanceladas(){
    $('#total_negociacao').val(0);
    $.getJSON("/negociacoes/get_empresas_negociacao_canceladas?tipo=0&conferido=false&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel10').empty();
        $('#text-painel10').text('NEGOCIAÇÕES (' + data.length + ')');
        somarTotalNegociacao(data.length);
        $.each(data,function (i,val){
            $('<li class="line-negociacao" id="'+ val['id'] +'">')
                .prepend(getPainelHtmlNegociacao(val))
                .appendTo('#painel10');
        });
    });
}
function aguardandoConfirmacaoCanceladas(){
    $.getJSON("/negociacoes/get_empresas_negociacao_canceladas?tipo=1&conferido=false&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel11').empty();
        $('#text-painel11').text('AGUARD. CONFIRMAÇÃO (' + data.length + ')');
        somarTotalNegociacao(data.length);
        $.each(data,function (i,val){
            $('<li class="line-negociacao" id="'+ val['id'] +'">')
                .prepend(getPainelHtmlNegociacao(val))
                .appendTo('#painel11');
        });
    });
}

function conferidasCanceladas(){
    $.getJSON("/negociacoes/get_empresas_negociacao_canceladas?conferido=true&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel12').empty();
        $('#text-painel12').text('CONFERIDAS (' + data.length + ')');
        // somarTotalNegociacao(data.length);
        $.each(data,function (i,val){
            $('<li id="'+ val['id'] +'">')
                .prepend(getPainelHtmlNegociacao(val))
                .appendTo('#painel12');
        });
    });
}

function getPainelHtmlNegociacao(data){
    var html = '<strong>' + getStringTamanho(data['razao_social']) + '</strong>' +
        '<div class="agile-detail">' +
        '<span class="pull-right">Fim: <span class="text-muted"><strong>' + getInicio(data['data_fim']) + '</strong> <i class="fa fa-clock-o"></i></span></span>' +
        'Início: <span class="text-muted"><strong>' + getInicio(data['data_inicio']) + '</strong> <i class="fa fa-clock-o"></i></span>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<span>Tempo de duração ' + data['qtd_dias'] +  ' dias' +'</span>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<span>Operador: <strong>' +  data['vendedor'] + '</strong></span>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<span class="pull-right">Telefone: <strong>' + data['telefone'] +'</strong> <i class="fa fa-phone"></i></span>' +
        '<span>Contato: <strong>' + data['contato'] + '</strong></span>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<div class="small m-b">Canal de atend.: ' +
        '<input class="whats" id="whats'+ data['id'] + '"  style="margin-right: 10px; margin-left: 10px" type="checkbox" title="Whatsapp" ' + (data['canal_atendimento'] == '1' ? 'checked' : '') +' disabled>' +
        '<input class="telefone" id="telefone'+ data['id'] + '"  type="checkbox" title="Telefone" ' + (data['canal_atendimento'] == '2'  ? 'checked' : '') +' disabled>' +
        '</div>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<div class="pull-center">' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'historico(\'' + data['cliente_id'] + '\')' + '" id="historico-'+data['cliente_id'] + '" type="button" title="Histórico"><span class="fa fa-history"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'novoComentario(\'' + data['id'] + '\')' + '" id="novocomentario-'+data['id'] + '" type="button" title="Novo comentário"><span class="fa fa-comment"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'comentarios(\'' + data['id'] + '\', \'NEGOCIACAO\' )' + '" id="comentarios-'+data['id'] + '" type="button" title="Comentários"><span class="fa fa-comments"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'ligacoes(' + data['cliente_id'] + ',' + data['id'] + ', \'NEGOCIACAO\')' + '" id="ligacoes-'+data['id'] + '" type="button" title="Ligações"><span class="fa fa-phone"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'recuperar(\'' + data['id'] + '\', \'NEGOCIACAO\')' + '" id="recuperar-'+data['id'] + '" type="button" title="Recuperar"><span class="fa fa-recycle"></span></button>';

    if(data['conferido'] == 't'){
        html = html + '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'baixar(\'' + data['id'] + '\',  \'NEGOCIACAO\')' + '" id="baixar-'+data['id'] + '" type="button" title="Baixar"><span class="fa fa-check"></span></button>';
    }else{
        html = html + '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'conferir(\'' + data['id'] + '\',  \'NEGOCIACAO\')' + '" id="conferir-'+data['id'] + '" type="button" title="Conferido"><span class="fa fa-check"></span></button>';
    }
    html = html + '</div>' +
        '</div>' +
        '</div>' +
        '</li>';

    return html;
}

function conferir_negociacao(id){
    $.ajax({
        url: '/negociacoes/' + id + '/conferir',
        type: 'PUT',
        success: function(data) {
            exibirMsg("Negociação conferida.");
            $("#modal_activities_negociacao").modal('hide')
            atualizar_paineis_negociacao();
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

function baixar_negociacao(id){
    $.ajax({
        url: '/negociacoes/' + id + '/baixar',
        type: 'PUT',
        success: function(data) {
            exibirMsg("Negociação baixada.")
            atualizar_paineis_negociacao();
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

function novoComentario(id){
    if($('#novo_comentario_negociacao_id').val() != id)
        $("#modal_comentario #text_comentario").val("");
    $('#novo_comentario_negociacao_id').val(id);
    $('#modal_comentario').modal('show');
}

function comentarios_negociacao(id) {
    $.ajax({
        url: '/negociacoes/activities',
        data: {id: id, auditoria: true},
        type: 'GET',
        success: function (data) {
            $("#modal_content_activities").html(data);
            $("#modal_activities_negociacao").modal('show')
        },error: function(data){
            exibirErro(data);
        }
    });
}

function recuperar_negociacao(id) {
    $('#negociacao_recuperar #recuperar_negociacao_id').val(id);
    $('#negociacao_recuperar #recuperar_negociacao_retorno').val('');
    $('#negociacao_recuperar #recuperar_negociacao_comentario').val('');
    $.getJSON("/negociacoes/" + id, function(data) {
        $('#negociacao_recuperar #recuperar_negociacao_cliente').val(data['cliente']['razao_social']);
        $('#negociacao_recuperar #recuperar_negociacao_responsavel').val(data['user']['id']).trigger("chosen:updated");

    });

    $('#negociacao_recuperar').modal('show');
}

function recuperarNegociacao() {
    if($('#negociacao_recuperar #recuperar_negociacao_responsavel').val() == '') {
        exibirErro("Selecione um operador.");
        return false;
    }

    if($('#negociacao_recuperar #recuperar_negociacao_retorno').val() == '') {
        exibirErro("Selecione uma nova data de retorno.");
        return false;
    }

    $.ajax({
        url: '/negociacoes/' + $('#negociacao_recuperar #recuperar_negociacao_id').val() + '/recuperar',
        data: { retorno: $('#negociacao_recuperar #recuperar_negociacao_retorno').val(),
            negociador: $('#negociacao_recuperar #recuperar_negociacao_responsavel').val(),
            comentario: $('#negociacao_recuperar #recuperar_negociacao_comentario').val()},
        type: 'PUT',
        success: function(data) {
            exibirMsg("Negociação recuperada.")
            atualizar_paineis_negociacao();
            $("#modal_activities_negociacao").modal('hide')
            $('#negociacao_recuperar').modal('toggle');
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

// Dragable panels
function drag_drop_negociacoes() {
    var element = ".negociacaosort";
    var connect = ".list-conferidas";
    $(element).sortable(
        {
            connectWith: connect,
            tolerance: 'pointer',
            opacity: 0.8,
            receive: function( event, ui ) {
                conferir(ui.item[0].id, 'NEGOCIACAO')
            }
        })

};
