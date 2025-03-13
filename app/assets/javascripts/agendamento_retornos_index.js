$(document).ready(function(){
    $('#btnAtualizarRetornos').on('click', function () {
        atualizarPaineis();
        return false;
    });
    atualizarPaineis();
});

function atualizarPaineis() {
    $('#totalRetornos').val(0);
    getHoje();
    getAtrasadas();
    getAmanha();
    getProximo();
    getDemais();
}

function somarTotal(total){
    var aux = parseInt($('#totalRetornos').val());
    aux = aux + total;
    $('#totalRetornos').val(aux);
    $('#textTotal').text('Total ' + aux + ' retornos');
}

function getHoje() {
    $.getJSON("/agendamento_retornos/get_retornos?filtro=hoje&tipo=retorno"
        + "&responsavel=" + $('#responsavel_id').val()
        + "&cidade=" + $('#cidade_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&preferencial=" + $('#telefone_preferencial').val()
        + "&telefone=" + $('#telefone').val()
        + "&qtd=" + $('#qtd_ligacoes').val(), function(data) {

        $('#tab1').text('HOJE (' + data.length + ')')
        $("#tab-1 #body_table_retornos tr").remove();
        somarTotal(data.length);
        $.each(data,function (i,val){
            var newRow = $("<tr id='" + val['id'] +"'>");
            var cols = criarLinhaTabela(val);
            newRow.append(cols);
            $("#tab-1 #body_table_retornos").append(newRow);
        });
    });
}

function getAtrasadas() {
    $.getJSON("/agendamento_retornos/get_retornos?filtro=atrasadas&tipo=retorno"
        + "&responsavel=" + $('#responsavel_id').val()
        + "&cidade=" + $('#cidade_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&preferencial=" + $('#telefone_preferencial').val()
        + "&telefone=" + $('#telefone').val()
        + "&qtd=" + $('#qtd_ligacoes').val(), function(data) {

        $('#tab2').text('ATRASADAS (' + data.length + ')')
        $("#tab-2 #body_table_retornos tr").remove();
        somarTotal(data.length);
        $.each(data,function (i,val){
            var newRow = $("<tr id='" + val['id'] +"'>");
            var cols = criarLinhaTabela(val);
            newRow.append(cols);
            $("#tab-2 #body_table_retornos").append(newRow);
        });
    });
}

function getAmanha() {
    $.getJSON("/agendamento_retornos/get_retornos?filtro=amanha&tipo=retorno"
        + "&responsavel=" + $('#responsavel_id').val()
        + "&cidade=" + $('#cidade_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&preferencial=" + $('#telefone_preferencial').val()
        + "&telefone=" + $('#telefone').val()
        + "&qtd=" + $('#qtd_ligacoes').val(), function(data) {

        $('#tab3').text('AMANHÃ (' + data.length + ')')
        $("#tab-3 #body_table_retornos tr").remove();
        somarTotal(data.length);
        $.each(data,function (i,val){
            var newRow = $("<tr id='" + val['id'] +"'>");
            var cols = criarLinhaTabela(val);
            newRow.append(cols);
            $("#tab-3 #body_table_retornos").append(newRow);
        });
    });
}

function getProximo() {
    $.getJSON("/agendamento_retornos/get_retornos?filtro=prox&tipo=retorno"
        + "&responsavel=" + $('#responsavel_id').val()
        + "&cidade=" + $('#cidade_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&preferencial=" + $('#telefone_preferencial').val()
        + "&telefone=" + $('#telefone').val()
        + "&qtd=" + $('#qtd_ligacoes').val(), function(data) {

        $('#tab4').text('PROX. SEMANA (' + data.length + ')')
        $("#tab-4 #body_table_retornos tr").remove();
        somarTotal(data.length);
        $.each(data,function (i,val){
            var newRow = $("<tr id='" + val['id'] +"'>");
            var cols = criarLinhaTabela(val);
            newRow.append(cols);
            $("#tab-4 #body_table_retornos").append(newRow);
        });
    });
}

function getDemais() {
    $.getJSON("/agendamento_retornos/get_retornos?filtro=demais&tipo=retorno"
        + "&responsavel=" + $('#responsavel_id').val()
        + "&cidade=" + $('#cidade_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&preferencial=" + $('#telefone_preferencial').val()
        + "&telefone=" + $('#telefone').val()
        + "&qtd=" + $('#qtd_ligacoes').val(), function(data) {

        $('#tab5').text('DEMAIS (' + data.length + ')')
        $("#tab-5 #body_table_retornos tr").remove();
        somarTotal(data.length);
        $.each(data,function (i,val){
            var newRow = $("<tr id='" + val['id'] +"'>");
            var cols = criarLinhaTabela(val);
            newRow.append(cols);
            $("#tab-5 #body_table_retornos").append(newRow);
        });
    });
}
