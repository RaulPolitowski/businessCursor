//= require jquery-ui/jquery-ui.min.js
//= require datapicker/bootstrap-datepicker.js
//= require chosen/chosen.jquery.js
//= require auditoria_desistencia/auditoria_acompanhamento.js

$(document).ready(function() {
    drag_drop_implantacoes();

   $('#modal_comentario_implantacao #btnSalvarComentario').on('click', function () {
        if($('#modal_comentario_implantacao #text_comentario').val() == ''){
            $('#modal_comentario_implantacao #error_comentario').show();
            return false;
        }
        $('#modal_comentario_implantacao #error_comentario').hide();
        $.ajax({
            url: '/comentarios/',
            data: { 'comentario[comentario]': $("#modal_comentario_implantacao #text_comentario").val(),
                'comentario[implantacao_id]': $('#modal_comentario_implantacao #novo_comentario_implantacao_id').val()},
            type: 'POST',
            success: function (data) {
                $('#modal_comentario_implantacao').modal('hide');
                exibirMsg("Comentário cadastrado com sucesso.")
                return false;
            },error: function(data){
                exibirErro('Ocorreu um erro.');
            }
        });
        return false;
    });

    $('#implantacao_recuperar #btnRecuperarImplantacao').on('click', function () {
        recuperarImplantacao();
        return false;
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

function atualizar_paineis_implantacao() {
    implantacoesDesistentesPre();
    implantacoesDesistentesDurante();
    implantacoesDesistentesConferidas();
}

function somarTotalImplantacao(total){
    var aux = parseInt($('#total_implantacao').val());
    aux = aux + total;
    $('#total_implantacao').val(aux);
    $('#tabImplantacao').text('Implantações (' + aux + ')');
}

function implantacoesDesistentesPre() {
    $('#total_implantacao').val(0);
    $.getJSON("/implantacoes/implantacoes_desistentes?status=7&conferido=false&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel5').empty();
        $('#text-painel5').text('IMPLANTAÇÕES PRÉ (' + data.length + ')');

        somarTotalImplantacao(data.length);
        $.each(data,function (i,val){
            $('<li class="line-implantacao-pre" id="'+ val['id'] +'">')
                .prepend(getPainelHtmlImplantacoes(val, 1))
                .appendTo('#painel5');
        });
    });
}

function implantacoesDesistentesDurante() {
    $.getJSON("/implantacoes/implantacoes_desistentes?status=8&conferido=false&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel6').empty();
        $('#text-painel6').text('IMPLANTAÇÕES DURANTE (' + data.length + ')');

        somarTotalImplantacao(data.length);
        $.each(data,function (i,val){
            $('<li class="line-implantacao-durante" id="'+ val['id'] +'">')
                .prepend(getPainelHtmlImplantacoes(val, 1))
                .appendTo('#painel6');
        });
    });
}

function implantacoesDesistentesConferidas() {
    $.getJSON("/implantacoes/implantacoes_desistentes?status=7,8&conferido=true&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel7').empty();
        $('#text-painel7').text('CONFERIDAS (' + data.length + ')');

        // somarTotalImplantacao(data.length);
        $.each(data,function (i,val){
            $('<li class="line-implantacao-conferida" id="'+ val['id'] +'">')
                .prepend(getPainelHtmlImplantacoes(val, 0))
                .appendTo('#painel7');
        });
    });
}

function getPainelHtmlImplantacoes(data, flag){
    var html = '<strong>' + getStringTamanho(data['razao_social']) + '</strong>' +
        '<div class="agile-detail">' +
        '<span class="pull-right">Fim: <span class="text-muted"><strong>' + getInicio(data['data_fim']) + '</strong> <i class="fa fa-clock-o"></i></span></span>' +
        'Início: <span class="text-muted"><strong>' + getInicio(data['data_inicio']) + '</strong> <i class="fa fa-clock-o"></i></span>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<span>Tempo de duração ' + data['qtd_dias'] +  ' dias' +'</span>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<span>Operador: <strong>' +  data['responsavel'] + '</strong></span>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<span class="pull-right">Telefone: <strong>' + data['telefone'] +'</strong> <i class="fa fa-phone"></i></span>' +
        '<span>Contato: <strong>' + data['contato'] + '</strong></span>' +
        '</div>' +
        '<div class="agile-detail">' +
        '<div class="pull-center">' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'historico(\'' + data['cliente_id'] + '\')' + '" id="historico-'+data['cliente_id'] + '" type="button" title="Histórico"><span class="fa fa-history"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'novoComentarioImplantacao(\'' + data['id'] + '\')' + '" id="novoComentarioAcompanhamento-'+data['id'] + '" type="button" title="Novo comentário"><span class="fa fa-comment"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'comentarios(\'' + data['id'] + '\', \'IMPLANTACAO\' )' + '" id="comentarios-'+data['id'] + '" type="button" title="Comentários"><span class="fa fa-comments"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'ligacoes(' + data['cliente_id'] + ',' + data['id'] + ', \'IMPLANTACAO\')' + '" id="ligacoes-'+data['id'] + '" type="button" title="Ligações"><span class="fa fa-phone"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'recuperar(\'' + data['id'] + '\', \'IMPLANTACAO\')' + '" id="recuperar-'+data['id'] + '" type="button" title="Recuperar"><span class="fa fa-recycle"></span></button>';
    if (flag == 1 && $('#user_is_admin').val() == 'true')
        html = html + '<button class="btn btn-xs btn-primary" style="margin-right: 5px" onclick="openModalvoltarImplantacao(' + data['id'] + ')" title="Voltar pra negociação"><span class="fa fa-undo"></span></button>';
     
    if(data['conferido'] == 't'){
        html = html + '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'baixar(\'' + data['id'] + '\', \'IMPLANTACAO\')' + '" id="baixar-'+data['id'] + '" type="button" title="Baixar"><span class="fa fa-check"></span></button>';
    }else{
        html = html + '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'conferir(\'' + data['id'] + '\', \'IMPLANTACAO\')' + '" id="conferir-'+data['id'] + '" type="button" title="Conferido"><span class="fa fa-check"></span></button>';
    }
    html = html + '</div>' +
        '</div>' +
        '</div>' +
        '</li>';

    return html;
}



function conferir_implantacao(id){
    $.ajax({
        url: '/implantacoes/' + id + '/conferir',
        type: 'PUT',
        success: function(data) {
            exibirMsg("Implantação conferida.")
            $("#modal_activities_implantacao").modal('hide');
            atualizar_paineis_implantacao();
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

function baixar_implantacao(id){
    $.ajax({
        url: '/implantacoes/' + id + '/baixar',
        type: 'PUT',
        success: function(data) {
            if(data != '')
                exibirWarning(data);
            else exibirMsg("Implantação baixada.")
            atualizar_paineis_implantacao();
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

function novoComentarioImplantacao(id) {
    if($('#modal_comentario_implantacao #novo_comentario_implantacao_id').val() != id)
        $("#modal_comentario_implantacao  #text_comentario").val("");
    $('#modal_comentario_implantacao #novo_comentario_implantacao_id').val(id);
    $('#modal_comentario_implantacao #comentario_data_retorno').hide();
    $('#modal_comentario_implantacao ').modal('show');
}

function comentarios_implantacao(id) {
    $.ajax({
        url: '/implantacoes/activities',
        data: {id: id, auditoria: true},
        type: 'GET',
        success: function (data) {
            $("#modal_content_activities_impl").html(data);
            $("#modal_activities_implantacao").modal('show')
            addFuncoes(id);
        },error: function(data){
            exibirErro(data);
        }
    });
}

function addFuncoes(id){
    $('#abrirComentarioActivityImplantacao').on('click', function () {
        if($('#modal_comentario_implantacao #novo_comentario_implantacao_id').val() != id)
            $("#modal_comentario_implantacao  #text_comentario").val("");

        $('#modal_comentario_implantacao #btnSalvarComentario').hide();
        $('#modal_comentario_implantacao #btnSalvarComentarioIndex').hide();
        $('#modal_comentario_implantacao #btnSalvarComentarioActivity').show();
        $('#modal_comentario_implantacao #comentario_data_retorno').hide();
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
            $('#modal_comentario_implantacao').modal('hide');
            $('#modal_activities_implantacao').modal('hide');
            $("#modal_comentario_implantacao  #text_comentario").val("");
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


function recuperar_implantacao(id) {
    $('#implantacao_recuperar #recuperar_implantacao_id').val(id);
    $('#implantacao_recuperar #recuperar_implantacao_comentario').val('');
    $.getJSON("/implantacoes/" + id, function(data) {
        $('#implantacao_recuperar #recuperar_implantacao_cliente').val(data['cliente']['razao_social']);
        if(data['user'] != null)
            $('#implantacao_recuperar #recuperar_implantacao_responsavel').val(data['user']['id']).trigger("chosen:updated");

    });

    $('#implantacao_recuperar').modal('show');
}

function recuperarImplantacao() {
    if($('#implantacao_recuperar #recuperar_implantacao_status').val() == '') {
        exibirErro("Selecione um status para qual a implantação voltará.");
        return false;
    }

    $.ajax({
        url: '/implantacoes/' + $('#implantacao_recuperar #recuperar_implantacao_id').val() + '/recuperar',
        data: { responsavel: $('#implantacao_recuperar #recuperar_implantacao_responsavel').val(),
            comentario: $('#implantacao_recuperar #recuperar_implantacao_comentario').val(),
            status: $('#implantacao_recuperar #recuperar_implantacao_status').val()},
        type: 'PUT',
        success: function(data) {
            exibirMsg("Implantação recuperada.")
            atualizar_paineis_implantacao();
            $("#modal_activities_implantacao").modal('hide');
            $('#implantacao_recuperar').modal('hide');
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

// Dragable panels
function drag_drop_implantacoes() {
    var element = ".implantacaosort";
    var connect = ".list-conferido-impl";
    $(element).sortable(
        {
            connectWith: connect,
            tolerance: 'pointer',
            opacity: 0.8,
            receive: function( event, ui ) {
                conferir(ui.item[0].id, 'IMPLANTACAO')
            }
        })
};

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