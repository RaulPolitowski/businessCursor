//= require mask_plugin/jquery.mask.js
//= require jquery-ui/jquery-ui.min.js
//= require qtip/jquery.qtip.min.js
//= require chosen/chosen.jquery.js

window.onload = function(){
    var url = document.location.toString();
    if (url.match('#')) {
        console.log(url.split('#')[1])
        $('.nav-tabs a[href="#' + url.split('#')[1] + '"]').tab('show');
    }

    $('.nav-tabs a[href="#' + url.split('#')[1] + '"]').on('shown', function (e) {
        window.location.hash = e.target.hash;
    });
}

$(document).ready(function () {
    $('.chosen-select').chosen({width: "100%", allow_single_deselect: true});

    $('#periodo_inerte #ignorar_inerte_ate').mask('00/00/0000');

    $('#q_cliente_cidade_estado_id_eq').on('change', function(){
        $('#q_cliente_cidade_id_eq').html('');
        if($('#q_cliente_cidade_estado_id_eq').val() != null && $('#q_cliente_cidade_estado_id_eq').val() != ''){
            $.ajax({
                url: '/cidades/find_by_estado?q[estado_id_eq]=' + $('#q_cliente_cidade_estado_id_eq').val(),
                type: 'GET',
                success: function (data) {
                    $('#q_cliente_cidade_id_eq').append('<option value=""></option>');
                    $.each(data, function (k, v) {
                        $('#q_cliente_cidade_id_eq').append('<option value="' + v['id'] + '">'+ v['nome'] + '-' + v['estado']['sigla'] +'</option>');
                    });
                    $('#q_cliente_cidade_id_eq').trigger("chosen:updated");
                },error: function(data){
                    exibirErro(data);
                }
            });
        }
        $('#q_cliente_cidade_id_eq').trigger("chosen:updated");
    });

    $('#btnAvaliarPesquisa').on('click', function () {
        if($('#registro_pesquisa_avaliacao #pesquisa_avaliacao').val() == '' || $('#registro_pesquisa_avaliacao #pesquisa_avaliacao').val().length < 10){
            exibirErro("Avaliação deve ter no minímo 10 caracteres");
            return false;
        }
        $.ajax({
            url: '/historico_cliente/registrar_avaliacao_pesquisa',
            data: getFormPesquisaAvaliacao(),
            processData: false,
            contentType: false,
            type: 'POST',
            success: function (data) {
                window.location.href = window.location.href;
            },error: function(data){
                exibirErro('Ocorreu um erro.');
                return false;
            }
        });
        return false;
    });

    $('#btnRegistrarFeedback').on('click', function () {
        if($('#periodo_inerte #periodo_inerte_feedback').val() == '' || $('#periodo_inerte #periodo_inerte_feedback').val().length < 10){
            exibirErro("Feedback deve ter no minímo 10 caracteres");
            return false;
        }

        $.ajax({
            url: '/historico_cliente/registrar_feedback',
            data: getFormPeriodo(),
            processData: false,
            contentType: false,
            type: 'POST',
            success: function (data) {
                window.location.href = window.location.href;
            },error: function(data){
                exibirErro('Ocorreu um erro.');
                return false;
            }
        });
        return false;
    });

    $('#btnRegistrarAvaliacao').on('click', function () {
        if($('#periodo_inerte_avaliacao #periodo_inerte_avaliacao').val() == '' || $('#periodo_inerte_avaliacao #periodo_inerte_avaliacao').val().length < 10){
            exibirErro("Avaliação deve ter no minímo 10 caracteres");
            return false;
        }
        $.ajax({
            url: '/historico_cliente/registrar_avaliacao',
            data: getFormPeriodoAvaliacao(),
            processData: false,
            contentType: false,
            type: 'POST',
            success: function (data) {
                window.location.href = window.location.href;
            },error: function(data){
                exibirErro('Ocorreu um erro.');
                return false;
            }
        });
        return false;
    });

    $('#btnRegistrarPesquisa').click(function (event) {
        var bool = false;
        $('#perguntas').find('textarea').each(function (key, value) {
            if($(value).val() == ''){
                bool = true;
            }
        });

        if(bool){
            exibirErro('É obrigatório responder todas as perguntas.');
            return false;
        }

        $('#perguntas').find('input').each(function (key, value) {
            if($(value).val() == ''){
                bool = true;
            }
        });

        if(bool){
            exibirErro('É obrigatório responder todas as perguntas.');
            return false;
        }

        form = new FormData();
        form.append('pesquisa_id', $('#registro_pesquisa #pesquisa_id').val());
        loop1:
            $('#registro_pesquisa #perguntas').find('.form-group').each(function (key, value) {
                var notFound = true;
                $(value).find('select').each(function  (k, v) {
                    form.append('perguntas[' + $(v)[0].name + ']', $(v).val());
                    notFound = false;
                });
                if(!notFound){
                    return true;
                }
                $(value).find('textarea').each(function (k, v) {
                    form.append('perguntas[' + $(v)[0].name + ']', $(v).val());
                });
                $(value).find('input').each(function (k, v) {
                    form.append('perguntas[' + $(v)[0].name + ']', $(v).val());
                });
            });

        $.ajax({
            url: '/perguntas/registrar_respostas_pesquisa',
            data: form,
            dataType: 'json',
            processData: false,
            contentType: false,
            type: 'POST',
            success: function(data) {
                window.location.href = window.location.href;
            },
            error: function(data) {
                exibirErro(data);
            }
        });

    });

    $('#btnSalvarComentario').on('click', function(){
        if($('#modal_comentario #text_comentario').val() == ''){
            $('#error_comentario').show();
            return false;
        }
        $('#error_comentario').hide();


        salvarComentario();

        return false;
    });
})

$('#btnVerCnaes').on('click', function(){
    carregarTodosCnaes();
    $('#cnaes_cliente').modal('show');
    return false;
})
function carregarTodosCnaes() {
    $.getJSON("/clientes/" +$("#cliente_id").val(), function(data) {
        $("#table-cnae-cliente tr").remove();
        $.each(data['cnae_clientes'], function(k, v) {
            var newRow = $("<tr>");
            var cols = "";
            cols += '<td>' + v['cnae']['codigo'] + '</td>';
            cols += '<td>' + v['cnae']['descricao'] + '</td>';
            cols += '<td>' + v['blacklist'] + '</td>';
            newRow.append(cols);

            $("#table-cnae-cliente").append(newRow);
        });
    });
}

function abrirModalComentario() {
    $("#modal_comentario_historico #text_comentario").val("");
    $('#modal_comentario_historico').modal('show');
}

function salvarComentario() {
    $.ajax({
        url: '/comentarios/historico',
        data: getFormComentario(),
        processData: false,
        contentType: false,
        type: 'POST',
        success: function (data) {
            window.location.href = "/historico_cliente/" + $('#cliente_id').val();
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}

function getFormComentario(){
    form = new FormData();
    form.append('comentario[comentario]', $("#modal_comentario_historico #text_comentario").val());
    form.append('comentario[cliente_id]', $("#cliente_id").val());

    return form;
}

function getFormPeriodo(){
    form = new FormData();
    form.append('periodo_id', $("#periodo_inerte #periodo_inerte_id").val());
    form.append('periodo_feedback', $("#periodo_inerte #periodo_inerte_feedback").val());
    if(moment( $("#periodo_inerte #ignorar_inerte_ate").val(),"DD/MM/YYYY HH:mm").isValid()){
        form.append('periodo_ignorar_inerte_ate', $("#periodo_inerte #ignorar_inerte_ate").val());
    }

    return form;
}

function getFormPeriodoAvaliacao(){
    form = new FormData();
    form.append('periodo_id', $("#periodo_inerte_avaliacao #periodo_inerte_id").val());
    form.append('periodo_avaliacao', $("#periodo_inerte_avaliacao #periodo_inerte_avaliacao").val());
    form.append('periodo_resultado', $("#periodo_inerte_avaliacao #periodo_inerte_positivo").val());
    if(moment( $("#periodo_inerte_avaliacao #ignorar_inerte_ate").val(),"DD/MM/YYYY HH:mm").isValid()){
        form.append('periodo_ignorar_inerte_ate', $("#periodo_inerte_avaliacao #ignorar_inerte_ate").val());
    }

    return form;
}

function getFormPesquisaAvaliacao(){
    form = new FormData();
    form.append('pesquisa_id', $("#registro_pesquisa_avaliacao #pesquisa_id").val());
    form.append('pesquisa_avaliacao', $("#registro_pesquisa_avaliacao #pesquisa_avaliacao").val());
    form.append('pesquisa_resultado', $("#registro_pesquisa_avaliacao #pesquisa_positivo").val());
    return form;
}

function abrirModalPeriodoInerte(empresa){
    $.getJSON('/historico_cliente/show_periodo_inerte?periodo_id=' + empresa + '&validar=true', function(data) {
        if(data != null){
            $('#periodo_inerte #periodo_inerte_cliente').val(data['cliente']['razao_social']);
            $('#periodo_inerte #periodo_inerte_cliente_cnpj').val(data['cliente']['cnpj']);
            $('#periodo_inerte #periodo_inerte_cliente_cidade').val(data['cliente']['cidade']['nome'] + '-' + data['cliente']['cidade']['estado']['sigla']);
            $('#periodo_inerte #periodo_inerte_cliente_id').val(data['cliente']['id']);
            $('#periodo_inerte #periodo_inerte_id').val(data['id']);
            $('#periodo_inerte #periodo_inerte_data').val(data['data_form']);
            $('#periodo_inerte #periodo_inerte_last_login').val(data['last_login_form']);
            $('#periodo_inerte #periodo_inerte_tempo_inerte').val(data['tempo_inerte']);
            $('#periodo_inerte #periodo_inerte_sistema').val(data['sistema']);
            $('#periodo_inerte #periodo_inerte_versao').val(data['versao']);
            $('#periodo_inerte #periodo_inerte_pendencia_financeira').val(data['com_pendencia_financeira_desc']);
            $('#periodo_inerte #periodo_inerte_status_financeiro').val(data['situacao_financeira']);

            carregarTabelaPeriodo(data);
            carregarTabelaPeriodoAvaliados(data);
            carregarTabelaFinanceiroInertes(data['cliente']['cnpj']);

            $('#periodo_inerte').modal('show');
        }else{
            exibirMsg("Processo finalizado. Ao realizar a verificação automática foi identificado que a empresa não está mais inerte.");
        }
    });
}

function abrirModalAvaliacaoPeriodoInerte(empresa){
    $.getJSON('/historico_cliente/show_periodo_inerte?periodo_id=' + empresa + '&validar=false', function(data) {
        $('#periodo_inerte_avaliacao #periodo_inerte_cliente').val(data['cliente']['razao_social']);
        $('#periodo_inerte_avaliacao #periodo_inerte_cliente_cnpj').val(data['cliente']['cnpj']);
        $('#periodo_inerte_avaliacao #periodo_inerte_cliente_cidade').val(data['cliente']['cidade']['nome'] + '-' + data['cliente']['cidade']['estado']['sigla']);
        $('#periodo_inerte_avaliacao #periodo_inerte_cliente_id').val(data['cliente']['id']);
        $('#periodo_inerte_avaliacao #periodo_inerte_id').val(data['id']);
        $('#periodo_inerte_avaliacao #periodo_inerte_data').val(data['data_form']);
        $('#periodo_inerte_avaliacao #periodo_inerte_last_login').val(data['last_login_form']);
        $('#periodo_inerte_avaliacao #periodo_inerte_tempo_inerte').val(data['tempo_inerte']);
        $('#periodo_inerte_avaliacao #periodo_inerte_feedback').val(data['feedback']);
        $('#periodo_inerte_avaliacao #periodo_inerte_sistema').val(data['sistema']);
        $('#periodo_inerte_avaliacao #periodo_inerte_versao').val(data['versao']);
        $('#periodo_inerte_avaliacao #periodo_inerte_pendencia_financeira').val(data['com_pendencia_financeira_desc']);
        $('#periodo_inerte_avaliacao #periodo_inerte_status_financeiro').val(data['situacao_financeira']);
        $("#periodo_inerte_avaliacao #ignorar_inerte_ate").val(data['ignorar_inerte_ate']);

        carregarTabelaPeriodo(data);
        carregarTabelaPeriodoAvaliados(data);
        carregarTabelaFinanceiroInertes(data['cliente']['cnpj']);

        $('#periodo_inerte_avaliacao').modal('show');
    });
}

function abrirModalPeriodoHistorico(empresa){
    $.getJSON('/historico_cliente/show_periodo_inerte?periodo_id=' + empresa + '&validar=false', function(data) {
        $('#periodo_inerte_historico #periodo_inerte_cliente').val(data['cliente']['razao_social']);
        $('#periodo_inerte_historico #periodo_inerte_cliente_cnpj').val(data['cliente']['cnpj']);
        $('#periodo_inerte_historico #periodo_inerte_cliente_cidade').val(data['cliente']['cidade']['nome'] + '-' + data['cliente']['cidade']['estado']['sigla']);
        $('#periodo_inerte_historico #periodo_inerte_cliente_id').val(data['cliente']['id']);
        $('#periodo_inerte_historico #periodo_inerte_id').val(data['id']);
        $('#periodo_inerte_historico #periodo_inerte_data').val(data['data_form']);
        $('#periodo_inerte_historico #periodo_inerte_last_login').val(data['last_login_form']);
        $('#periodo_inerte_historico #periodo_inerte_tempo_inerte').val(data['tempo_inerte']);
        $('#periodo_inerte_historico #periodo_inerte_feedback').val(data['feedback']);
        $('#periodo_inerte_historico #periodo_inerte_positivo').val(data['positivo']);
        $('#periodo_inerte_historico #periodo_inerte_positivo').prop('checked', data['positivo']);
        $('#periodo_inerte_historico #periodo_inerte_avaliacao').val(data['avaliacao']);
        $('#periodo_inerte_historico #periodo_inerte_data_feedback').val(data['data_feedback_form']);
        $('#periodo_inerte_historico #periodo_inerte_usuario_feed').val(data['user_feedback'] != null ? data['user_feedback']['name'] : '');
        $('#periodo_inerte_historico #periodo_inerte_data_avaliacao').val(data['data_avaliacao_form']);
        $('#periodo_inerte_historico #periodo_inerte_usuario_avaliacao').val(data['user_avaliacao'] != null ? data['user_avaliacao']['name']:'');
        $('#periodo_inerte_historico #periodo_inerte_sistema').val(data['sistema']);
        $('#periodo_inerte_historico #periodo_inerte_versao').val(data['versao']);
        $('#periodo_inerte_historico #periodo_inerte_pendencia_financeira').val(data['com_pendencia_financeira_desc']);
        $('#periodo_inerte_historico #periodo_inerte_status_financeiro').val(data['situacao_financeira']);
        $("#periodo_inerte_historico #ignorar_inerte_ate").val(data['ignorar_inerte_ate']);

        carregarTabelaFinanceiroInertes(data['cliente']['cnpj']);

        $('#periodo_inerte_historico').modal('show');
    });
}

function abrirModalPesquisa(empresa, cnpj){
    $('#registro_pesquisa #pesquisa_id').val(empresa);
    $('#registro_pesquisa #cnpj').val(cnpj);

    $.getJSON('/historico_cliente/show_pesquisa?pesquisa_id=' + empresa, function(data) {
        $('#registro_pesquisa #pesquisa_cliente').val(data['cliente']['razao_social']);
        $('#registro_pesquisa #pesquisa_cliente_cnpj').val(data['cliente']['cnpj']);
        $('#registro_pesquisa #pesquisa_cliente_cidade').val(data['cliente']['cidade']['nome'] + '-' + data['cliente']['cidade']['estado']['sigla']);
        $('#registro_pesquisa #pesquisa_data').val(data['data_form']);
        $('#registro_pesquisa #pesquisa_last_login').val(data['ultimo_login_form']);
        $('#registro_pesquisa #pesquisa_tempo_inerte').val(data['tempo']);
        $('#registro_pesquisa #pesquisa_sistema').val(data['sistema']);
        $('#registro_pesquisa #pesquisa_versao').val(data['versao']);
        $('#registro_pesquisa #pesquisa_pendencia_financeira').val(data['com_pendencia_financeira_desc']);
        $('#registro_pesquisa #pesquisa_status_financeiro').val(data['situacao_financeira']);

        carregarTabelaFinanceiroInertes(data['cliente']['cnpj']);
        $.getJSON('/perguntas/perguntas_pesquisa', function (value) {
            $('#registro_pesquisa #perguntas').html('');
            preencherPerguntas(value);
            $('#registro_pesquisa').modal('show');
        });
    });
}

function abrirModalAvaliacaoPesquisa(empresa, cnpj) {
    $('#registro_pesquisa_avaliacao #pesquisa_id').val(empresa);
    $('#registro_pesquisa_avaliacao #cnpj').val(cnpj);

    $.getJSON('/historico_cliente/show_pesquisa?pesquisa_id=' + empresa, function(data) {
        $('#registro_pesquisa_avaliacao #pesquisa_cliente').val(data['cliente']['razao_social']);
        $('#registro_pesquisa_avaliacao #pesquisa_cliente_cnpj').val(data['cliente']['cnpj']);
        $('#registro_pesquisa_avaliacao #pesquisa_cliente_cidade').val(data['cliente']['cidade']['nome'] + '-' + data['cliente']['cidade']['estado']['sigla']);
        $('#registro_pesquisa_avaliacao #pesquisa_data').val(data['data_form']);
        $('#registro_pesquisa_avaliacao #pesquisa_last_login').val(data['ultimo_login_form']);
        $('#registro_pesquisa_avaliacao #pesquisa_tempo_inerte').val(data['tempo']);
        $('#registro_pesquisa_avaliacao #pesquisa_sistema').val(data['sistema']);
        $('#registro_pesquisa_avaliacao #pesquisa_versao').val(data['versao']);
        $('#registro_pesquisa_avaliacao #pesquisa_pendencia_financeira').val(data['com_pendencia_financeira_desc']);
        $('#registro_pesquisa_avaliacao #pesquisa_status_financeiro').val(data['situacao_financeira']);

        carregarTabelaFinanceiroInertes(data['cliente']['cnpj']);
        $.getJSON('/historico_cliente/pesquisa_respostas?pesquisa_id=' + empresa , function (value) {
            $('#registro_pesquisa_avaliacao #perguntas').html('');
            preencherRespostas(value);
            $('#registro_pesquisa_avaliacao').modal('show');
        });
    });
}

function preencherRespostas(value) {
    $.each(value, function (k, perg) {
        $('#perguntas').append('<div class="form-group">' +
        '<div class="field">' +
        '<label>' +  perg['pergunta']['pergunta'] + '</label>' +
        '<textarea class="form-control" type="text" id="pergunta_' + perg['pergunta']['id'] + '" disabled>' + perg['resposta'] + '</textarea>' +
        '</div>' +
        '</div>');
    });
}

function abrirModalPesquisaHistorico(empresa) {
    $('#registro_pesquisa_avaliacao #pesquisa_id').val(empresa);
    $('#registro_pesquisa_avaliacao #pesquisa_avaliacao').prop( "disabled", true );
    $('#registro_pesquisa_avaliacao #pesquisa_positivo').prop( "disabled", true);
    $('#registro_pesquisa_avaliacao #btnAvaliarPesquisa').hide();

    $.getJSON('/historico_cliente/show_pesquisa?pesquisa_id=' + empresa, function(data) {
        $('#registro_pesquisa_avaliacao #pesquisa_cliente').val(data['cliente']['razao_social']);
        $('#registro_pesquisa_avaliacao #pesquisa_cliente_cnpj').val(data['cliente']['cnpj']);
        $('#registro_pesquisa_avaliacao #pesquisa_cliente_cidade').val(data['cliente']['cidade']['nome'] + '-' + data['cliente']['cidade']['estado']['sigla']);
        $('#registro_pesquisa_avaliacao #pesquisa_data').val(data['data_form']);
        $('#registro_pesquisa_avaliacao #pesquisa_last_login').val(data['ultimo_login_form']);
        $('#registro_pesquisa_avaliacao #pesquisa_tempo_inerte').val(data['tempo']);
        $('#registro_pesquisa_avaliacao #pesquisa_sistema').val(data['sistema']);
        $('#registro_pesquisa_avaliacao #pesquisa_versao').val(data['versao']);
        $('#registro_pesquisa_avaliacao #pesquisa_pendencia_financeira').val(data['com_pendencia_financeira_desc']);
        $('#registro_pesquisa_avaliacao #pesquisa_status_financeiro').val(data['situacao_financeira']);

        $('#registro_pesquisa_avaliacao #pesquisa_avaliacao').val(data['avaliacao']);
        $('#registro_pesquisa_avaliacao #pesquisa_positivo').val(data['positivo']);
        $('#registro_pesquisa_avaliacao #pesquisa_positivo').prop('checked', data['positivo']);

        carregarTabelaFinanceiroInertes(data['cliente']['cnpj']);

        setValueInAvaliacaoPesquisa();

        $.getJSON('/historico_cliente/pesquisa_respostas?pesquisa_id=' + empresa , function (value) {
            $('#registro_pesquisa_avaliacao #perguntas').html('');
            preencherRespostas(value);
        });
        $('#registro_pesquisa_avaliacao').modal('show');
    });




}

function carregarTabelaPeriodo(data){
    $.getJSON('/historico_cliente/get_periodos_inertes_cliente?cliente_id=' + data['cliente']['id'] + '&aguardando=true', function(response) {
        $("#body_periodo_inerte_modal").html('');
        $.each(response, function( key, value ) {
            $("#body_periodo_inerte_modal").append(gerarRowPeriodos(value));
        });
    });
}

function carregarTabelaPeriodoAvaliados(data){
    $.getJSON('/historico_cliente/get_periodos_inertes_cliente?cliente_id=' + data['cliente']['id'] + '&aguardando=false', function(response) {
        $("#body_periodo_inerte_avaliado_modal").html('');
        $.each(response, function( key, value ) {
            $("#body_periodo_inerte_avaliado_modal").append(gerarRowPeriodosAvaliados(value));
        });
    });
}

function carregarTabelaFinanceiroInertes(cnpj){
    $.getJSON('/historico_cliente/financeiro_cnpj?cnpj=' + cnpj, function(data) {
        $("#body_periodo_inerte_financeiro_modal").html('');
        $.each(data, function( key, value ) {
            $("#body_periodo_inerte_financeiro_modal").append(gerarRowFinanceiro(value));
        });
    });
}

function gerarRowFinanceiro(data){
    var newRow = $("<tr>");
    var cols = "";
    cols += '<td>' + data['complemento'] + '</td>';
    cols += '<td>' + data['vencimento'] + '</td>';
    cols += '<td>' + data['status'] + '</td>';
    cols += '<td>' + data['valor'] + '</td>';

    newRow.append(cols);
    return newRow;
}

function gerarRowPeriodos(data){
    var newRow = $("<tr>");
    var cols = "";
    cols += '<td>' + data['data_feedback_form'] + '</td>';
    cols += '<td>' + data['tempo_inerte'] + '</td>';
    cols += '<td>' + data['feedback'] + '</td>';

    newRow.append(cols);
    return newRow;
}

function gerarRowPeriodosAvaliados(data){
    var newRow = $("<tr>");
    var cols = "";
    cols += '<td>' + data['data_avaliacao_form'] + '</td>';
    cols += '<td>' + data['positivo_desc'] + '</td>';
    cols += '<td>' + data['avaliacao'] + '</td>';

    newRow.append(cols);

    return newRow;
}

function reprocessarInerte(){
    $('body').lmask('show');
    $.ajax({
        url: '/historico_cliente/reprocessar_inertes',
        processData: false,
        contentType: false,
        type: 'GET',
        success: function (data) {
            window.location.href = window.location.href;
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}
function chamarApiWhats(telefone) {
    if(telefone == '')
        return false;
    window.open('https://api.whatsapp.com/send?phone=55' + apenasNumeros(telefone), '_blank');
}


function reprocessarPesquisa(){
    $('body').lmask('show');
    $.ajax({
        url: '/historico_cliente/reprocessar_pesquisas',
        processData: false,
        contentType: false,
        type: 'GET',
        success: function (data) {
            window.location.href = window.location.href;
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}