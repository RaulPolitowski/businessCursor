//= require jquery-ui/jquery-ui.min.js
//= require datapicker/bootstrap-datepicker.js
//= require chosen/chosen.jquery.js
//= require auditoria_desistencia/auditoria_acompanhamento.js
//= require auditoria_desistencia/auditoria_implantacao.js
//= require auditoria_desistencia/auditoria_negociacao.js
//= require auditoria_desistencia/auditoria_retornos.js

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

    $('.chosen-select').chosen({width: "100%", allow_single_deselect: true});

    atualizarPaineis();

    $('#btnAtualizarNegociacoes').on('click', function () {
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
});

function atualizarPaineis() {
    atualizar_paineis_negociacao();

    atualizar_paineis_acompanhamento();

    atualizar_paineis_implantacao();

    atualizar_paineis_retorno();
}

function getStringTamanho(txt) {
    if(window.innerWidth > 1366)
        return txt.substring(0,50)

    return txt.substring(0,29)
}

function getInicio(inicio) {
    return  moment(inicio).format('DD/MM/YYYY');
}

function ligacoes(cliente_id, modelo_id, tipo) {
    $("#negociacao_table_ligacoes tr").remove();
    $("#modal_ligacoes_tipo").val(tipo);
    $("#modal_ligacoes_modelo_id").val(modelo_id);

    $.getJSON('/ligacoes?q[cliente_id_eq]=' + cliente_id, function(data) {
        $.each(data, function(k, v) {
            addRowLigacoesNegociacao(v);
        });
        $('#modal_ligacoes_negociacao').modal('show');
    });
}



function addRowLigacoesNegociacao(data){
    var newRow = $("<tr>");
    var cols = "";
    cols += '<td>' + data['data_inicio_formatada'] + '</td>';
    cols += '<td>' + data['usuario'] + '</td>';
    cols += '<td>' + ( data['status_ligacao'] != null ? data['status_ligacao'] : "")  + '</td>';
    cols += '<td>' + ( data['status_cliente'] != null ? data['status_cliente'] : "") + '</td>';
    cols += '<td>' + ( data['observacao'] != null ? data['observacao'] : "") + '</td>';

    newRow.append(cols);
    $("#negociacao_table_ligacoes").append(newRow);
}

function conferir(id, tipo){
    if(tipo == 'NEGOCIACAO'){
        conferir_negociacao(id);
    }
    if(tipo == 'ACOMPANHAMENTO'){
        conferir_acompanhamento(id);
    }
    if(tipo == 'IMPLANTACAO'){
        conferir_implantacao(id);
    }
    if(tipo == 'RETORNO'){
        conferir_retorno(id);
    }
}

function baixar(id, tipo){
    if(tipo == 'NEGOCIACAO'){
        baixar_negociacao(id);
    }
    if(tipo == 'ACOMPANHAMENTO'){
        baixar_acompanhamento(id);
    }
    if(tipo == 'IMPLANTACAO'){
        baixar_implantacao(id);
    }
    if(tipo == 'RETORNO'){
        baixar_retorno(id);
    }
}

function comentarios(id, tipo) {
    if(tipo == 'NEGOCIACAO'){
        comentarios_negociacao(id);
    }
    if(tipo == 'ACOMPANHAMENTO'){
        comentarios_acompanhamento(id);
    }
    if(tipo == 'IMPLANTACAO'){
       comentarios_implantacao(id);
    }
}

function recuperar(id, tipo) {
    if(tipo == 'NEGOCIACAO'){
        recuperar_negociacao(id);
    }
    if(tipo == 'ACOMPANHAMENTO'){
        recuperar_acompanhamento(id);
    }
    if(tipo == 'IMPLANTACAO'){
        recuperar_implantacao(id);
    }
    if(tipo == 'RETORNO'){
        recuperar_retorno(id);
    }
}

function historico(cliente_id){
    window.open('/historico_cliente/' + cliente_id, '_blank');
}