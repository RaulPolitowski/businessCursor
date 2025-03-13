//= require chosen/chosen.jquery.js
//= require maskmoney
//= require iCheck/icheck.min.js

$('.chosen-select').chosen({width: "100%"});
$(document).ready(function(){
    var date = new Date();
    $('#proposta_data_pri_men').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });

    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green'
    });
    
    $('#form_proposta').validate({
        rules: {
            'proposta_cliente_id': {
                required: true
            },
            'proposta_pacote_id': {
                required: true
            },
            'proposta_tipo_mensalidade': {
                required: true
            },
            'proposta_valor_mensalidade': {
                required: true
            },
            'proposta_tipo_implantacao': {
                required: true
            },
            'proposta_valor_implantacao': {
                required: true
            },
            'proposta_fidelidade': {
                required: true
            },
            
        },
        submitHandler: function (form) {
            event.preventDefault()
            $("#form_proposta").validate()
            alterarProposta('cadastro', false);
            return false;
        }
    });


    $('#proposta_formas_pagamento_id').on('change', function() {
        if($("#proposta_formas_pagamento_id").val() == '')
            return;

        $.getJSON('/formaspagamento/' + $("#proposta_formas_pagamento_id").val(), function (data) {
            if (data['parcelado'] == true)
                $('#parcelas').show();
            else $('#parcelas').hide();
        });
    });

    $('#proposta_fidelidade').on('change', function() {
        if($('#proposta_fidelidade').val() == 'true'){
            $('#meses_fidelidade').show();
        }else{
            $('#meses_fidelidade').hide();
        }
    });
    $('#proposta_tipo_implantacao').on('change', function() {
        if($('#proposta_tipo_implantacao').val() == 'Isenta'){
            $('#fieldFormaPagamento').hide();
        }else{
            $('#fieldFormaPagamento').show();
        }
    });

    $('#proposta_tipo_implantacao').on('change', function() {
        if($("#proposta_pacote_id").val() == '')
            return;

        $.getJSON('/pacotes/' + $("#proposta_pacote_id").val(), function (data) {
            $('#proposta_valor_implantacao').attr('disabled', false);
            if ($('#proposta_tipo_implantacao').val() == "Presencial Normal")
                $('#proposta_valor_implantacao').val(data['implantacao']).trigger('mask.maskMoney');
            else if($('#proposta_tipo_implantacao').val() == "Presencial Promocional")
                $('#proposta_valor_implantacao').val(data['implantacao_promocional']).trigger('mask.maskMoney');
            else if($('#proposta_tipo_implantacao').val() == "Online Normal")
                $('#proposta_valor_implantacao').val(data['implantacao_remota']).trigger('mask.maskMoney');
            else if($('#proposta_tipo_implantacao').val() == "Online Promocional")
                $('#proposta_valor_implantacao').val(data['implantacao_remota_promocional']).trigger('mask.maskMoney');
            else if($('#proposta_tipo_implantacao').val() == "Isenta") {
                $('#proposta_valor_implantacao').val('0').trigger('mask.maskMoney');
                $('#proposta_valor_implantacao').attr('disabled', true);
            }
        });
    });

    $('#proposta_tipo_mensalidade').on('change', function() {
        if($("#proposta_pacote_id").val() == '')
            return;

        $.getJSON('/pacotes/' + $("#proposta_pacote_id").val(), function (data) {
            if ($('#proposta_tipo_mensalidade').val() == "Normal")
                $('#proposta_valor_mensalidade').val(data['mensalidade']).trigger('mask.maskMoney');
            else $('#proposta_valor_mensalidade').val(data['mensalidade_promocional']).trigger('mask.maskMoney');
        });
    });

    $("#proposta_qtde_parcela").on('focusout', function(){
        calcularValorParcela();
    });
})

function calcularValorParcela(){
    var parcela = parseInt( $('#proposta_qtde_parcela').val() );
    var valor = parseFloat( $('#proposta_valor_implantacao').val().replace(".", "").replace(",", "."));
    $('#proposta_valor_parcelas').val((valor/parcela).toFixed(2)).trigger('mask.maskMoney');
}

function getFormProposta(funcao, ativa){
    var form = new FormData();
    if(funcao == 'cadastro'){
        form.append('id', $("#proposta_id").val());
        form.append('proposta[cliente_id]', $("#proposta_cliente_id").val());
        form.append('proposta[pacote_id]', $("#proposta_pacote_id").val());
        form.append('proposta[tipo_mensalidade]', $("#proposta_tipo_mensalidade").val());
        form.append('proposta[valor_mensalidade]', $("#proposta_valor_mensalidade").val().replace('.', '').replace(',', '.'));
        form.append('proposta[tipo_implantacao]', $("#proposta_tipo_implantacao").val());
        form.append('proposta[valor_implantacao]', $("#proposta_valor_implantacao").val().replace('.', '').replace(',', '.'));
        form.append('proposta[formas_pagamento_id]', $("#proposta_formas_pagamento_id").val());
        form.append('proposta[qtd_maquinas]', $("#qtd_maquinas").val() ? $("#qtd_maquinas").val() : 3);
        form.append('proposta[data_primeira_mensalidade]', $("#proposta_data_pri_men").val());
        form.append('proposta[fidelidade]', $("#proposta_fidelidade").val());
        form.append('proposta[meses_fidelidade]', $("#proposta_meses_fidelidade").val());
        if($("#proposta_qtde_parcela").val() != null && $("#proposta_qtde_parcela").val() != '')
            form.append('proposta[qtde_parcela]', $("#proposta_qtde_parcela").val());
        if($("#proposta_valor_parcelas").val() != null && $("#proposta_valor_parcelas").val() != '')
            form.append('proposta[valor_parcelas]', $("#proposta_valor_parcelas").val());
        if($("#proposta_observacao").val() != null && $("#proposta_observacao").val() != '')
            form.append('proposta[observacao]', $("#proposta_observacao").val());
    }else{
        form.append('id', $("#proposta_id").val());
        form.append('proposta[ativa]', ativa);
    }

    return form;
}

function limparModalProposta() {
    $("#proposta_cliente_id").val("");
    $("#proposta_cliente").val("");
    $("#proposta_pacote_id").val("");
    $("#proposta_tipo_mensalidade").val("");
    $("#proposta_valor_mensalidade").val("");
    $("#proposta_tipo_implantacao").val("");
    $("#proposta_valor_implantacao").val("");
    $("#proposta_id").val("");
    $("#proposta_formas_pagamento_id").val("");
    $("#proposta_qtde_parcela").val("");
    $("#proposta_valor_parcelas").val("");
    $("#proposta_observacao").val("");
    $("#qtd_maquinas").val("");
    $("#proposta_data_pri_men").val("");
    $("#proposta_meses_fidelidade").val("");
    $('#error_meses_fidelidade').hide();
    $('#error_pri_mensalidade').hide();
}

function setDadosFormProposta(data){
    if(data != null){
        $("#proposta_id").val(data['id']);
        $("#proposta_cliente_id").val(data['cliente_id']);
        $('#proposta_cliente').val($('#cliente_razao_social').val())
        $("#proposta_pacote_id").val(data['pacote_id']).trigger("chosen:updated");
        $("#proposta_tipo_mensalidade").val(data['tipo_mensalidade']).trigger("chosen:updated");
        $("#proposta_valor_mensalidade").val(data['valor_mensalidade']);
        $("#proposta_tipo_implantacao").val(data['tipo_implantacao']).trigger("chosen:updated");
        $("#proposta_valor_implantacao").val(data['valor_implantacao']);
        $("#proposta_formas_pagamento_id").val(data['formas_pagamento_id']).trigger("chosen:updated");
        $("#proposta_qtde_parcela").val(data['qtde_parcela']);
        $("#proposta_valor_parcelas").val(data['valor_parcelas']);
        $("#proposta_observacao").val(data['observacao']);
        $("#qtd_maquinas").val(data['qtd_maquinas']);
        $("#proposta_data_pri_men").val(data['data_primeira_mensalidade']);        
        
        if (data['fidelidade'] == true){
            $("#proposta_fidelidade").val('true').trigger("chosen:updated");
            $('#meses_fidelidade').show();
            $("#proposta_meses_fidelidade").val(data['meses_fidelidade']);
        }else{
            $("#proposta_fidelidade").val('false').trigger("chosen:updated");
            $('#meses_fidelidade').hide();
        }
        
        if(data['qtde_parcela'] != null && parseInt(data['qtde_parcela']) > 0){
            $('#parcelas').show();
            calcularValorParcela();
        }
        else $('#parcelas').hide();

        $("#form_proposta").find("input, select, textarea").prop("disabled", true).trigger("chosen:updated");

    }else{
        $("#proposta_cliente_id").val($('#cliente_id').val());
        $('#proposta_cliente').val($('#cliente_razao_social').val())
        $('#parcelas').hide();
        $("#form_proposta").find("input, select, textarea").prop("disabled", false).trigger("chosen:updated");
    }

    $('#proposta').modal('show');
}

function abrirModalProposta(id){
    limparModalProposta();
    if(id == null){
        setDadosFormProposta(null);
    }else{
        $.getJSON("/propostas/" + id, function( data ) {
            setDadosFormProposta(data);
        });
    }
}

function setPropostaAtiva(id) {
    var checkBox = document.getElementById("propostaAtiva-"+ id);
    if ($("#body_table_proposta tr").length == 1){
        exibirWarning("É obrigatório ter uma proposta ativa.")
        $("#propostaAtiva-"+id).prop("checked", true);
        return;
    }
    $("#proposta_id").val(id);

    alterarProposta('ativa', checkBox.checked);
}

function gerarRowProposta(data){
    var newRow = $("<tr>");
    var cols = "";
    cols += '<td>' + data['data_formatada'] + '</td>';
    cols += '<td>' + data['sistema'] + '</td>';
    cols += '<td>' + (data['user'] != null ? data['user']['name'] : '') + '</td>';
    cols += '<td>' + data['valor_mensalidade'] + '</td>';
    cols += '<td>' + data['tipo_implantacao'] + '</td>';
    cols += '<td>' + data['valor_implantacao'] + '</td>';
    cols += '<td>' + data['forma_pagamento'] + '</td>';
    cols += '<td><input class="pref pref-celular"  type="checkbox" title="Ativa?" id="propostaAtiva-'+ data['id'] + '" onclick="setPropostaAtiva('+ data['id']+ ')" ' + (data['ativa'] ? 'checked' : '')  + '></td>';
    cols += '<td>';
    cols += '<a class="btn btn-sm btn-primary" onclick="abrirModalProposta('+ data['id'] + ')"><i class="fa fa-eye" aria-hidden="true"></i></a>';
    cols += '</td>';

    newRow.append(cols);

    return newRow;
}