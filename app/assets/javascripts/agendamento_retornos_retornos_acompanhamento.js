$(document).ready(function(){
    $('#btnAtualizarRetornos').on('click', function () {
        atualizarPaineis();
        return false;
    });
    atualizarPaineis();

    $('#btnSalvarRetorno').on('click', function () {
        if($('#modal_novo_retorno_acompanhamento #retorno_data_retorno').val() == '' && !moment($('#modal_novo_retorno_acompanhamento #retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()) {
            exibirErro('Informe uma data de retorno válida!');
            return false;
        }

        $.getJSON('/agendamento_retornos/verificar_horario_acompanhamento?data_retorno='+ $('#modal_novo_retorno_acompanhamento #retorno_data_retorno').val(), function(data) {
            if(parseInt(data) > 0){
                exibirWarning('Já existe um retorno agendado para o mesmo horário!');
                return false;
            }else{
                if(moment($('#modal_novo_retorno_acompanhamento #retorno_data_retorno').val(),"DD/MM/YYYY HH:mm") > moment().add(2, 'days')){
                    $('#modal_novo_retorno_acompanhamento #retorno_data_retorno').modal('toggle');
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
                            salvarRetorno();
                        }else{
                            exibirWarning('Comentário não cadastrado!');
                        }
                    });
                }else{
                    salvarRetorno();
                }
            }
        });

        return false;
    });
});

function atualizarPaineis() {
    $('#totalRetornos').val(0);
    getHoje();
    getAtrasadas();
    getAmanha();
    getProximo();
    getDemais();
    getSemAgenda();
}

function somarTotal(total){
    var aux = parseInt($('#totalRetornos').val());
    aux = aux + total;
    $('#totalRetornos').val(aux);
    $('#textTotal').text('Total ' + aux + ' retornos');
}

function getHoje() {
    $.getJSON("/agendamento_retornos/get_retornos?filtro=hoje&tipo=acompanhamento"
        + "&responsavel=" + $('#responsavel_id').val()
        + "&cidade=" + $('#cidade_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&qtd=" + $('#qtd_ligacoes').val(), function(data) {

        $('#tab1').text('HOJE (' + data.length + ')')
        $("#tab-1 #body_table_retornos tr").remove();
        somarTotal(data.length);
        $.each(data,function (i,val){
            var newRow = $("<tr id='" + val['id'] +"'>");
            var cols = criarLinhaTabelaRetorno(val);
            newRow.append(cols);
            $("#tab-1 #body_table_retornos").append(newRow);
        });
    });
}

function getAtrasadas() {
    $.getJSON("/agendamento_retornos/get_retornos?filtro=atrasadas&tipo=acompanhamento"
        + "&responsavel=" + $('#responsavel_id').val()
        + "&cidade=" + $('#cidade_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&qtd=" + $('#qtd_ligacoes').val(), function(data) {
        $('#tab2').text('ATRASADAS (' + data.length + ')')
        $("#tab-2 #body_table_retornos tr").remove();
        somarTotal(data.length);
        $.each(data,function (i,val){
            var newRow = $("<tr id='" + val['id'] +"'>");
            var cols = criarLinhaTabelaRetorno(val);
            newRow.append(cols);
            $("#tab-2 #body_table_retornos").append(newRow);
        });
    });
}

function getAmanha() {
    $.getJSON("/agendamento_retornos/get_retornos?filtro=amanha&tipo=acompanhamento"
        + "&responsavel=" + $('#responsavel_id').val()
        + "&cidade=" + $('#cidade_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&qtd=" + $('#qtd_ligacoes').val(), function(data) {

        $('#tab3').text('AMANHÃ (' + data.length + ')')
        $("#tab-3 #body_table_retornos tr").remove();
        somarTotal(data.length);
        $.each(data,function (i,val){
            var newRow = $("<tr id='" + val['id'] +"'>");
            var cols = criarLinhaTabelaRetorno(val);
            newRow.append(cols);
            $("#tab-3 #body_table_retornos").append(newRow);
        });
    });
}

function getProximo() {
    $.getJSON("/agendamento_retornos/get_retornos?filtro=prox&tipo=acompanhamento"
        + "&responsavel=" + $('#responsavel_id').val()
        + "&cidade=" + $('#cidade_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&qtd=" + $('#qtd_ligacoes').val(), function(data) {

        $('#tab4').text('PROX. SEMANA (' + data.length + ')')
        $("#tab-4 #body_table_retornos tr").remove();
        somarTotal(data.length);
        $.each(data,function (i,val){
            var newRow = $("<tr id='" + val['id'] +"'>");
            var cols = criarLinhaTabelaRetorno(val);
            newRow.append(cols);
            $("#tab-4 #body_table_retornos").append(newRow);
        });
    });
}

function getDemais() {
    $.getJSON("/agendamento_retornos/get_retornos?filtro=demais&tipo=acompanhamento"
        + "&responsavel=" + $('#responsavel_id').val()
        + "&cidade=" + $('#cidade_id').val()
        + "&cliente=" + $('#filtro_cliente_id').val()
        + "&qtd=" + $('#qtd_ligacoes').val(), function(data) {

        $('#tab5').text('DEMAIS (' + data.length + ')')
        $("#tab-5 #body_table_retornos tr").remove();
        somarTotal(data.length);
        $.each(data,function (i,val){
            var newRow = $("<tr id='" + val['id'] +"'>");
            var cols = criarLinhaTabelaRetorno(val);
            newRow.append(cols);
            $("#tab-5 #body_table_retornos").append(newRow);
        });
    });
}

function criarLinhaTabelaRetorno(val) {
    var cols = "";
    cols += '<td style="width: 8%; padding: 2px; text-align: center">' + moment(val['created_at']).format("DD/MM/YYYY")  + '</td>';
    cols += '<td style="width: 9%; padding: 2px; text-align: center">' + val['name'] + '</td>';
    cols += '<td style="width: 10%; padding: 2px; text-align: center">' + moment(val['data_agendamento_retorno']).format("DD/MM/YYYY HH:mm") + '</td>';
    cols += '<td style="width: 20%; padding: 2px;">' + getStringTamanho(val['razao_social']) + '</td>';
    cols += '<td style="width: 10%; padding: 2px;">' + getStringTamanho(val['cidade']) + '</td>';
    cols += '<td style="width: 6%; padding: 2px; text-align: center">' + val['qtd_dias'] + '</td>';
    cols += '<td style="width: 8%; padding: 2px; text-align: center">' + val['dias_sem_uso'] + '</td>';
    cols += '<td style="width: 32%; padding: 2px;">' + val['ultimo_comentario_acompanhamento'] + '</td>';
    cols += '<td style="padding: 2px;"><a id="btn-' + val['id'] + '" href="/acompanhamentos/' + val['acompanhamento_id'] + '" class="btn btn-success retornoLigacao" value="' + val['id'] + '" target="_blank" style="padding: 2px 6px"><i class="fa fa-eye"></i></button> </a></td>';
    cols += '<td style="padding: 2px;"><button id="btn-cancelar-' + val['id'] + '"  onclick="cancelarRetorno(' + val['id'] + ')" class="btn btn-warning cancelarRetorno" value="' + val['id'] + '" title="Cancelar Retorno" style="padding: 2px 6px"><i class="fa fa-trash"></i></button></td>';
    cols += '<td style="padding: 2px;"><button id="btn-activities-' + val['id'] + '"  onclick="atividades_retorno_acompanhamento(' + val['acompanhamento_id'] + ')" class="btn btn-info activitiesRetorno" value="' + val['id'] + '" title="Atividades" style="padding: 2px 6px"><i class="fa fa-search"></i></button></td>';
    return cols;
}

function getStringTamanho(txt) {
    if(txt.length > 40)
        return txt.substring(0,38) + '..'

    return txt
}

function atividades_retorno_acompanhamento(id) {
    $.ajax({
        url: '/acompanhamentos/activities',
        data: {id: id},
        type: 'GET',
        success: function (data) {
            $("#modal_content_activities").html(data);
            $("#modal_activities_acompanhamentos").modal('show')
        },error: function(data){
            exibirErro(data);
        }
    });
}

function getSemAgenda() {
    $.getJSON("/acompanhamentos/acompanhamentos_sem_agendamento_retorno", function(data) {
        $('#tab6').text('NÃO AGENDADO (' + data.length + ')')
        $("#tab-6 #body_table_retornos tr").remove();

        $.each(data,function (i,val){
            var newRow = $("<tr id='" + val['id'] +"'>");
            var cols = "";
            cols += '<td style="width: 40%; padding: 2px;">' + getStringTamanho(val['razao_social']) + '</td>';
            cols += '<td style="width: 10%; padding: 2px; text-align: center">' +val['sistema']  + '</td>';
            cols += '<td style="width: 10%; padding: 2px; text-align: center">' + val['vendedor'] + '</td>';
            cols += '<td style="width: 15%; padding: 2px; text-align: center">' + val['implantador'] + '</td>';
            cols += '<td style="width: 10%; padding: 2px; text-align: center">' + val['telefone'] + '</td>';
            cols += '<td style="width: 10%; padding: 2px; text-align: center">' + val['dias_sem_uso'] + '</td>';
            cols += '<td style="padding: 2px;"><a id="btn-' + val['id'] + '" href="/acompanhamentos/' + val['id'] + '" class="btn btn-success retornoLigacao" value="' + val['id'] + '" target="_blank" style="padding: 2px 6px"><i class="fa fa-eye"></i></button> </a></td>';
            cols += '<td style="padding: 2px;"><button id="btn-novo"  onclick="novoRetorno(' + val['id'] + ')" class="btn btn-primary" value="' + val['id'] + '" title="Novo Retorno" style="padding: 2px 6px"><i class="fa fa-plus"></i></button></td>';
            cols += '<td style="padding: 2px;"><button id="btn-activities-' + val['id'] + '"  onclick="atividades_retorno_acompanhamento(' + val['id'] + ')" class="btn btn-info activitiesRetorno" value="' + val['id'] + '" title="Atividades" style="padding: 2px 6px"><i class="fa fa-search"></i></button></td>';

            newRow.append(cols);
            $("#tab-6 #body_table_retornos").append(newRow);
        });
    });
}

function novoRetorno(acompanhamento_id) {
    $('#modal_novo_retorno_acompanhamento #acompanhamento_id').val(acompanhamento_id);
    $('#modal_novo_retorno_acompanhamento').modal('show');
}

function salvarRetorno() {
    $.ajax({
        url: '/agendamento_retornos/novo_retorno_acompanhamento',
        data: getFormRetorno(),
        processData: false,
        contentType: false,
        type: 'POST',
        success: function (data) {
            window.location.href = window.location.href;
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}

function getFormRetorno(){
    form = new FormData();
    form.append('acompanhamento_id', $('#modal_novo_retorno_acompanhamento #acompanhamento_id').val());
    form.append('user_id', $('#modal_novo_retorno_acompanhamento #usuario_id').val());
    if(moment($('#modal_novo_retorno_acompanhamento #retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()){
        form.append('data_retorno', $('#modal_novo_retorno_acompanhamento #retorno_data_retorno').val());
    }

    return form;
}