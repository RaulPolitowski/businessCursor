//= require jquery/jquery-3.1.1.min.js
//= require jquery_ujs
//= require bootstrap-sprockets
//= require metisMenu/jquery.metisMenu.js
//= require pace/pace.min.js
//= require peity/jquery.peity.min.js
//= require slimscroll/jquery.slimscroll.min.js
//= require inspinia.js
//= require toastr/toastr.min.js
//= require dropzone
//= require validate/jquery.validate.min.js
//= require maskmoney
//= require sweetalert/sweetalert2.all.js
//= require mask_plugin/jquery.mask.js
//= require push/push.min.js
//= require push/serviceWorker.min.js
//= require datetimepicker/bootstrap-datetimepicker.js
//= require datetimepicker/locales/bootstrap-datetimepicker.pt-BR.js
//= require moment/moment-with-locales.min.js
//= require ladda/spin.min.js
//= require ladda/ladda.min.js
//= require ladda/ladda.jquery.min.js
//= require loading_mask
//= require dataTables/datatables.min.js
//= require dataTables/date-eu.js
//= require touchspin/jquery.bootstrap-touchspin.min.js
//= require typehead/bootstrap3-typeahead.min.js
//= require tinymce-jquery
//= require switchery
//= require chosen/chosen.jquery.js

$('.chosen-select').chosen({width: "100%"});

$(document).ready(function(){

    $('#btnLancarDesistencia').on('click', function(){
        if($('#motivo').val() == ''){
            $('#error_motivo').show();
            return false;
        }
        if($('#solicitante').val() == ''){
            $('#error_solicitante').show();
            return false;
        }
        $('#error_motivo').hide();
        $('#error_solicitante').hide();

        salvarSolicitacao();        

        return false;
    });

});

function limparTela(){
    $("#cliente_id").val("");
    $("#cliente_razao_social").val("");
    $("#cliente_cnpj").val("");
    $("#cliente_cidade").val("");    
    $("#solicitante").val("");    
    $("#telefone").val("");    
    $("#motivo").val("");
    $("#nome_solicitante").val("");    
    $("#email_solicitante").val("");   
    $("#tecnico").val(""); 
}

function setDadosCliente(data){
    $("#cliente_id").val(data['id']);
    $("#cliente_razao_social").val(data['razao_social']);
    $("#cliente_cnpj").val(data['cnpj']);
    $("#cliente_cidade").val(data['cidade']['nome'] + '/' + data['cidade']['estado']['sigla']);
}

function salvarSolicitacao(){
    $.ajax({
        url: '/solicitacao_desistencia_externo/criar_desistencia',
        data: {nome_solicitante: $("#nome_solicitante").val(), email_solicitante: $("#email_solicitante").val(),
                cnpj: $("#cliente_cnpj").val(),
                 solicitante: $("#solicitante").val(), telefone: $("#telefone").val(), motivo: $("#motivo").val()},
        type: 'POST',
        success: function (data) {
            exibirMsg("Solicitação cadastrada com sucesso");
            limparTela();
            return true;
        },error: function(data){
            exibirErro(data.responseText);
        }
    });

    return false;
}

function buscarCliente(){    
    if ($('#cliente_cnpj').val() == '')
        $('#error_cnpj').show();
    
    $('#error_cnpj').hide();

    $.ajax({
        url: '/solicitacao_desistencia_externo/get_cliente_financeiro_ativo?cnpj=' + $('#cliente_cnpj').val(),
        type: 'GET',
        success: function(data) {
            //$("#cliente_id").val(data['id']);
            $("#cliente_razao_social").val(data[0]['razaosocial']);
            $("#cliente_cidade").val(data[0]['cidade_uf']);

            if (data[0]['parceiro'] == '')
                $("#tecnico").val(data[0]['local']);
            else
                $("#tecnico").val(data[0]['parceiro']);

        },error: function(data){
            $('#modal_erro_cnpj').modal('show');
        }
    });    
}

function exibirErro(msgErro) {
    toastr.options = {
        closeButton: true,
        showMethod: 'slideDown'
    };
    toastr.error(msgErro);
}

function exibirMsg(msg){
    toastr.options = {
        closeButton: true,
        showMethod: 'slideDown'
    };
    toastr.success(msg);
}
