$(document).ready(function() {
    drag_drop_acompanhamentos();

    $('#modal_comentario_acompanhamento #btnSalvarComentario').on('click', function () {
        if($('#modal_comentario_acompanhamento #text_comentario').val() == ''){
            $('#modal_comentario_acompanhamento #error_comentario').show();
            return false;
        }
        $('#modal_comentario_acompanhamento #error_comentario').hide();
        $.ajax({
            url: '/comentarios/',
            data: { 'comentario[comentario]': $("#modal_comentario_acompanhamento #text_comentario").val(),
                'usuario_id':  $('#modal_comentario_acompanhamento #comentario_usuario_id').val(),
                'comentario[acompanhamento_id]': $('#modal_comentario_acompanhamento #novo_comentario_acompanhamento_id').val()},
            type: 'POST',
            success: function (data) {
                $('#modal_comentario_acompanhamento').modal('hide');
                $("#modal_comentario_acompanhamento #text_comentario").val("");
                exibirMsg("Comentário cadastrado com sucesso.")
                return false;
            },error: function(data){
                exibirErro('Ocorreu um erro.');
            }
        });
        return false;
    });

    $('#acompanhamento_recuperar #btnRecuperarAcompanhamento').on('click', function () {
        recuperarAcompanhamento();
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

function atualizar_paineis_acompanhamento() {
    acompanhamentosDesistentesDurante();
    acompanhamentosDesistentesStandBy();
    acompanhamentosDesistentesConferidos();
}

function somarTotalAcompanhamento(total){
    var aux = parseInt($('#total_acompanhamento').val());
    aux = aux + total;
    $('#total_acompanhamento').val(aux);
    $('#tabAcompanhamento').text('Acompanhamentos (' + aux + ')');
}

function acompanhamentosDesistentesDurante() {
    $('#total_acompanhamento').val(0);
    $.getJSON("/acompanhamentos/acompanhamentos_desistentes?status=(4)&conferido=false&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel1').empty();
        $('#text-painel1').text('EM ANDAMENTO (' + data.length + ')');

        somarTotalAcompanhamento(data.length);
        $.each(data,function (i,val){
            $('<li class="line-acompanhamento" id="'+ val['id'] +'">')
                .prepend(getPainelHtmlAcompanhamentos(val, 1))
                .appendTo('#painel1');
        });
    });
}

function acompanhamentosDesistentesStandBy() {
    $.getJSON("/acompanhamentos/acompanhamentos_desistentes?status=(3)&conferido=false&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel2').empty();
        $('#text-painel2').text('STAND BY (' + data.length + ')');

        somarTotalAcompanhamento(data.length);
        $.each(data,function (i,val){
            $('<li class="line-acompanhamento" id="'+ val['id'] +'">')
                .prepend(getPainelHtmlAcompanhamentos(val, 1))
                .appendTo('#painel2');
        });
    });
}

function acompanhamentosDesistentesConferidos() {
    $.getJSON("/acompanhamentos/acompanhamentos_desistentes?status=(3,4)&conferido=true&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel3').empty();
        $('#text-painel3').text('CONFERIDOS (' + data.length + ')');

        // somarTotalAcompanhamento(data.length);
        $.each(data,function (i,val){
            $('<li class="line-acompanhamento" id="'+ val['id'] +'">')
                .prepend(getPainelHtmlAcompanhamentos(val, 0))
                .appendTo('#painel3');
        });
    });
}

function getPainelHtmlAcompanhamentos(data, status){
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
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'novoComentarioAcompanhamento(\'' + data['id'] + '\')' + '" id="novoComentarioAcompanhamento-'+data['id'] + '" type="button" title="Novo comentário"><span class="fa fa-comment"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'comentarios(\'' + data['id'] + '\', \'ACOMPANHAMENTO\' )' + '" id="comentarios-'+data['id'] + '" type="button" title="Comentários"><span class="fa fa-comments"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'ligacoes(' + data['cliente_id'] + ',' + data['id'] + ', \'ACOMPANHAMENTO\')' + '" id="ligacoes-'+data['id'] + '" type="button" title="Ligações"><span class="fa fa-phone"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'recuperar(\'' + data['id'] + '\', \'ACOMPANHAMENTO\')' + '" id="recuperar-'+data['id'] + '" type="button" title="Recuperar"><span class="fa fa-recycle"></span></button>';

    if (status == 1 && $('#user_is_admin').val() == 'true') //status 0 ou 1 apenas pra mostrar a opção de voltar
        html = html + '<button class="btn btn-xs btn-primary" style="margin-right: 5px" onclick="openModalvoltarAcompanhamento(' + data['id'] + ', ' + data['status'] + ')" title="Voltar etapa"><span class="fa fa-undo"></span></button>';
     
    if(data['conferido'] == 't'){
        html = html + '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'baixar(\'' + data['id'] + '\', \'ACOMPANHAMENTO\')' + '" id="baixar-'+data['id'] + '" type="button" title="Baixar"><span class="fa fa-check"></span></button>';
    }else{
        html = html + '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'conferir(\'' + data['id'] + '\', \'ACOMPANHAMENTO\')' + '" id="conferir-'+data['id'] + '" type="button" title="Conferido"><span class="fa fa-check"></span></button>';
    }    
    html = html + '</div>' +
        '</div>' +
        '</div>' +
        '</li>';

    return html;
}

function conferir_acompanhamento(id) {
    $.ajax({
        url: '/acompanhamentos/' + id + '/conferir',
        type: 'PUT',
        success: function(data) {
            exibirMsg("Acompanhamento conferido.");
            $("#modal_activities_acompanhamentos").modal('hide');
            atualizar_paineis_acompanhamento();
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

function baixar_acompanhamento(id) {
    $.ajax({
        url: '/acompanhamentos/' + id + '/baixar',
        type: 'PUT',
        success: function(data) {
            if(data != '')
                exibirWarning(data);
            else exibirMsg("Acompanhamento baixado.")
            atualizar_paineis_acompanhamento();
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

function novoComentarioAcompanhamento(id){
    if($('#modal_comentario_acompanhamento #novo_comentario_acompanhamento_id').val() != id)
        $("#modal_comentario_acompanhamento #text_comentario").val("");

    $('#modal_comentario_acompanhamento #novo_comentario_acompanhamento_id').val(id);
    $('#modal_comentario_acompanhamento #btnSalvarComentario').show();
    $('#modal_comentario_acompanhamento #btnSalvarComentarioIndex').hide();
    $('#modal_comentario_acompanhamento #btnSalvarComentarioActivity').hide();
    $("#modal_comentario_acompanhamento #comentario_data_retorno").hide();
    $('#modal_comentario_acompanhamento').modal('show');
}

function comentarios_acompanhamento(id) {
    $.ajax({
        url: '/acompanhamentos/activities',
        data: {id: id, auditoria: true},
        type: 'GET',
        success: function (data) {
            $("#modal_content_activities_acomp").html(data);
            $("#modal_activities_acompanhamentos").modal('show');
            addFuncoesAcompanhamento(id);

        },error: function(data){
            exibirErro(data);
        }
    });
}

function addFuncoesAcompanhamento(id){
    $('#abrirComentarioActivityAcompanhamento').on('click', function () {
        if($('#modal_comentario_acompanhamento #novo_comentario_acompanhamento_id').val() != id)
            $("#modal_comentario_acompanhamento #text_comentario").val("");
        $('#modal_comentario_acompanhamento #btnSalvarComentario').hide();
        $('#modal_comentario_acompanhamento #btnSalvarComentarioIndex').hide();
        $('#modal_comentario_acompanhamento #btnSalvarComentarioActivity').show();
        $('#modal_comentario_acompanhamento #comentario_data_retorno').hide();
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
    salvarComentarioAcompanhamentoActivity();
    return false;
});

function salvarComentarioAcompanhamentoActivity() {
    $.ajax({
        url: '/comentarios/',
        data: getFormComentarioAcompanhamentoActivity(),
        processData: false,
        contentType: false,
        type: 'POST',
        success: function (data) {
            $('#modal_comentario_acompanhamento').modal('hide');
            $('#modal_activities_acompanhamentos').modal('hide');
            $('#modal_comentario_acompanhamento #text_comentario').val('');
            exibirMsg("Comentário cadastrado com sucesso.");
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}

function getFormComentarioAcompanhamentoActivity(){
    form = new FormData();
    form.append('comentario[comentario]', $("#modal_comentario_acompanhamento #text_comentario").val());
    form.append('comentario[acompanhamento_id]', $("#acompanhamento_id").val());
    form.append('usuario_id', $('#modal_comentario_acompanhamento #comentario_usuario_id').val());

    return form;
}

function recuperar_acompanhamento(id) {
    $('#acompanhamento_recuperar #recuperar_acompanhamento_id').val(id);
    $('#acompanhamento_recuperar #recuperar_acompanhamento_retorno').val('');
    $('#acompanhamento_recuperar #recuperar_acompanhamento_comentario').val('');
    $.getJSON("/acompanhamentos/" + id, function(data) {
        $('#acompanhamento_recuperar #recuperar_acompanhamento_cliente').val(data['cliente']['razao_social']);
        $('#acompanhamento_recuperar #recuperar_acompanhamento_responsavel').val(data['user']['id']).trigger("chosen:updated");

    });

    $('#acompanhamento_recuperar').modal('show');
}

function recuperarAcompanhamento() {
    if($('#acompanhamento_recuperar #recuperar_acompanhamento_responsavel').val() == '') {
        exibirErro("Selecione um responsável.");
        return false;
    }

    if($('#acompanhamento_recuperar #recuperar_acompanhamento_retorno').val() == '') {
        exibirErro("Selecione uma nova data de retorno.");
        return false;
    }

    if($('#acompanhamento_recuperar #recuperar_acompanhamento_status').val() == '') {
        exibirErro("Selecione um status para qual o acompanhamento voltará.");
        return false;
    }

    $.ajax({
        url: '/acompanhamentos/' + $('#acompanhamento_recuperar #recuperar_acompanhamento_id').val() + '/recuperar',
        data: { retorno: $('#acompanhamento_recuperar #recuperar_acompanhamento_retorno').val(),
            responsavel: $('#acompanhamento_recuperar #recuperar_acompanhamento_responsavel').val(),
            comentario: $('#acompanhamento_recuperar #recuperar_acompanhamento_comentario').val(),
            status: $('#acompanhamento_recuperar #recuperar_acompanhamento_status').val()},
        type: 'PUT',
        success: function(data) {
            exibirMsg("Acompanhamento recuperado.")
            atualizar_paineis_acompanhamento();
            $("#modal_activities_acompanhamentos").modal('hide');
            $('#acompanhamento_recuperar').modal('hide');
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

// Dragable panels
function drag_drop_acompanhamentos() {
    var element = ".acompanhamentosort";
    var connect = ".list-conferido-acomp";
    $(element).sortable(
        {
            connectWith: connect,
            tolerance: 'pointer',
            opacity: 0.8,
            receive: function( event, ui ) {
                conferir(ui.item[0].id, 'ACOMPANHAMENTO')
            }
        })
};


function openModalvoltarAcompanhamento(id, status) {
    $.getJSON("/acompanhamentos/" + id, function(data) {
        $('#modal_voltar_acompanhamento #form_voltar_acompanhamento')[0].reset();
        $('#modal_voltar_acompanhamento #voltar_acomp_status_implantacao').val('').trigger("chosen:updated");
        $('#modal_voltar_acompanhamento #voltar_acompanhamento_responsavel').val('').trigger("chosen:updated");

        $('#modal_voltar_acompanhamento #voltar_acompanhamento_id').val(data['id']);
        $('#modal_voltar_acompanhamento #voltar_acompanhamento_cliente_id').val(data['cliente']['id']);
        $('#modal_voltar_acompanhamento #voltar_acompanhamento_cliente').val(data['cliente']['razao_social']);
        if (status == 3)
            $('#modal_voltar_acompanhamento #status_atual_acompanhamento').val('EM ANDAMENTO');
        else if (status == 4)
            $('#modal_voltar_acompanhamento #status_atual_acompanhamento').val('STAND BY');

        $('#modal_voltar_acompanhamento #voltar_acompanhamento_responsavel').val(data['user'] != null ? data['user']['name'] : '');
        $('#modal_voltar_acompanhamento #voltar_acompanhamento_vendedor').val(data['cliente']['fechamento']['user']['name']);
        
        $('#modal_voltar_acompanhamento').modal('show');
    });
}

function voltarAcompanhamento() {
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
    }else{
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
    }
}