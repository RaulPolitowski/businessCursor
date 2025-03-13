//= require jquery-ui/jquery-ui.min.js
//= require datapicker/bootstrap-datepicker.js
//= require chosen/chosen.jquery.js
//= require auditoria_desistencia/auditoria_acompanhamento.js
//= require auditoria_desistencia/auditoria_implantacao.js

$(document).ready(function() {
    drag_drop_retornos();

   $('#retorno_recuperar #btnRecuperarRetorno').on('click', function () {
       recuperarRetorno();
       return false;
   });
});

function atualizar_paineis_retorno() {
    retornosCancelados();
    retornosCanceladosAtrasado();
    retornosConferidoCancelados();
}

function somarTotalRetorno(total){
    var aux = parseInt($('#total_retorno').val());
    aux = aux + total;
    $('#total_retorno').val(aux);
    $('#tabRetorno').text('Retorno inicial (' + aux + ')');
}

function retornosCancelados(){
    $('#total_retorno').val(0);
    $.getJSON("/agendamento_retornos/retornos_cancelados?atrasado=false&conferido=false&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel15').empty();
        $('#text-painel15').text('RETORNOS (' + data.length + ')');
        somarTotalRetorno(data.length);
        $.each(data,function (i,val){
            $('<li class="line-retorno" id="'+ val['id'] +'">')
                .prepend(getPainelHtmlRetorno(val))
                .appendTo('#painel15');
        });
    });
}
function retornosCanceladosAtrasado(){
    $.getJSON("/agendamento_retornos/retornos_cancelados?atrasado=true&conferido=false&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel16').empty();
        $('#text-painel16').text('RETORNOS ATRASADOS (' + data.length + ')');
        somarTotalRetorno(data.length);
        $.each(data,function (i,val){
            $('<li class="line-retorno" id="'+ val['id'] +'">')
                .prepend(getPainelHtmlRetorno(val))
                .appendTo('#painel16');
        });
    });
}

function retornosConferidoCancelados(){
    $.getJSON("/agendamento_retornos/retornos_cancelados?conferido=true&vendedor=" + $('#operador_id').val()
        + "&empresa=" + $('#empresa_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val()
        + "&cliente=" + $('#filtro_cliente_id').val(), function(data) {
        $('#painel17').empty();
        $('#text-painel17').text('CONFERIDAS (' + data.length + ')');
        // somarTotalRetorno(data.length);
        $.each(data,function (i,val){
            $('<li id="'+ val['id'] +'">')
                .prepend(getPainelHtmlRetorno(val))
                .appendTo('#painel17');
        });
    });
}

function getPainelHtmlRetorno(data){
    var html = '<strong>' + getStringTamanho(data['razao_social']) + '</strong>' +
        '<div class="agile-detail">' +
        'Data retorno: <span class="text-muted"><strong>' + formatarData(data['data_agendamento_retorno']) + '</strong> <i class="fa fa-clock-o"></i></span>' +
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
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'ligacoes(' + data['cliente_id'] + ',' + data['id'] + ', \'RETORNO\')' + '" id="ligacoes-'+data['id'] + '" type="button" title="Ligações"><span class="fa fa-history"></span></button>' +
        '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'recuperar(\'' + data['id'] + '\', \'RETORNO\')' + '" id="recuperar-'+data['id'] + '" type="button" title="Recuperar"><span class="fa fa-recycle"></span></button>';

    if(data['conferido'] == 't'){
        html = html + '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'baixar(\'' + data['id'] + '\',  \'RETORNO\')' + '" id="baixar-'+data['id'] + '" type="button" title="Baixar"><span class="fa fa-check"></span></button>';
    }else{
        html = html + '<button class="btn btn-primary btn-xs" style="margin-right: 5px" onclick="' + 'conferir(\'' + data['id'] + '\',  \'RETORNO\')' + '" id="conferir-'+data['id'] + '" type="button" title="Conferido"><span class="fa fa-check"></span></button>';
    }
    html = html + '</div>' +
        '</div>' +
        '</div>' +
        '</li>';

    return html;
}

function conferir_retorno(id){
    $.ajax({
        url: '/agendamento_retornos/' + id + '/conferir',
        type: 'PUT',
        success: function(data) {
            exibirMsg("Retorno conferido.")
            atualizar_paineis_retorno();
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

function baixar_retorno(id){
    $.ajax({
        url: '/agendamento_retornos/' + id + '/baixar',
        type: 'PUT',
        success: function(data) {
            exibirMsg("Retorno baixado.")
            atualizar_paineis_retorno();
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

function recuperar_retorno(id) {
    $('#retorno_recuperar #recuperar_retorno_id').val(id);
    $('#retorno_recuperar #recuperar_retorno_data').val('');
    $('#retorno_recuperar #recuperar_retorno_comentario').val('');
    $.getJSON("/agendamento_retornos/" + id, function(data) {
        $('#retorno_recuperar #recuperar_retorno_cliente').val(data['razao_social_cliente']);
        $('#retorno_recuperar #recuperar_retorno_responsavel').val(data['user_id']).trigger("chosen:updated");
    });

    $('#retorno_recuperar').modal('show');
}

function recuperarRetorno() {
    if($('#retorno_recuperar #recuperar_retorno_responsavel').val() == '') {
        exibirErro("Selecione um operador.");
        return false;
    }

    if($('#retorno_recuperar #recuperar_retorno_data').val() == '') {
        exibirErro("Selecione uma nova data de retorno.");
        return false;
    }

    $.ajax({
        url: '/agendamento_retornos/' + $('#retorno_recuperar #recuperar_retorno_id').val() + '/recuperar',
        data: { retorno: $('#retorno_recuperar #recuperar_retorno_data').val(),
            operador: $('#retorno_recuperar #recuperar_retorno_responsavel').val(),
            comentario: $('#retorno_recuperar #recuperar_retorno_comentario').val()},
        type: 'PUT',
        success: function(data) {
            exibirMsg("Retorno recuperado.")
            atualizar_paineis_retorno();

            $('#retorno_recuperar').modal('toggle');
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

// Dragable panels
function drag_drop_retornos() {
    var element = ".retornosort";
    var connect = ".list-conferido-retorno";
    $(element).sortable(
        {
            connectWith: connect,
            tolerance: 'pointer',
            opacity: 0.8,
            receive: function( event, ui ) {
                conferir(ui.item[0].id, 'RETORNO')
            }
        })

};
