//= require mask_plugin/jquery.mask.js
//= require jquery-ui/jquery-ui.min.js
//= require qtip/jquery.qtip.min.js
//= require chosen/chosen.jquery.js
//= require datapicker/bootstrap-datepicker.js

$(document).ready(function(){
    $('#q_created_at_lteq').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });

    $('#q_created_at_gteq').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
});

function abrirModalPesquisaGruber(pesquisaId){
    $.getJSON('/satisfacao_gruber/' + pesquisaId, function(data) {
        if(data != null){
            $('#modal_pesquisa_gruber #pesquisa_cliente').val(data['cliente']['razaosocial']);
            $('#modal_pesquisa_gruber #pesquisa_cliente_id').val(data['cliente_id']);
            $('#modal_pesquisa_gruber #pesquisa_id').val(data['id']);
            $('#modal_pesquisa_gruber #pesquisa_cliente_cnpj').val(data['cliente']['cpfcnpj']);
            $('#modal_pesquisa_gruber #pesquisa_pendencia_financeira').val(data['pendencia_financeira']);
            $('#modal_pesquisa_gruber #pesquisa_cliente_cidade').val(data['cliente_municipio']);
            $('#modal_pesquisa_gruber #pesquisa_nome').val(data['cliente_nome']);
            $('#modal_pesquisa_gruber #pesquisa_email').val(data['cliente_email']);
            $('#modal_pesquisa_gruber #pesquisa_telefone').val(data['cliente_telefone']);
            $('#modal_pesquisa_gruber #pesquisa_data').val(data['created_at']);

            $("#body_pesquisa_respostas_modal").html('');
            $.each(data["gruber_pesquisa_respostas"], function( key, value ) {
                $("#body_pesquisa_respostas_modal").append(gerarRowPeriodos(value));
            });

            $('#modal_pesquisa_gruber').modal('show');
        }else{
            exibirMsg("Processo finalizado. Ao realizar a verificação automática foi identificado que a empresa não está mais inerte.");
        }
    });
}

function gerarRowPeriodos(data){
    var newRow = $("<tr>");
    var cols = "";
    if(data["setor"]){
        cols += '<td>' + data['setor']['nome_setor'] + '</td>';
    }else{
        cols += '<td>' + data['servico']['nome_servico'] + '</td>';
    }
    cols += '<td>' + (data['setor_financeiro_nome'] ? data['setor_financeiro_nome'] : "") + '</td>';
    cols += '<td>' + data['nota'] + '</td>';
    cols += '<td>' + data['motivo'] + '</td>';

    newRow.append(cols);
    return newRow;
}