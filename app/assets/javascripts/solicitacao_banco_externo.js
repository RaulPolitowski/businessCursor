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
//= require datapicker/bootstrap-datepicker.js

$(document).ready(function(){

    $('#data_vencimento').datepicker({
        format: 'dd/mm/yyyy',
        language: 'pt-BR',
        autoclose: true,
        todayBtn: true,
        pickerPosition: "bottom-left"
      });

      $('#data_implantacao').datepicker({
        format: 'dd/mm/yyyy',
        language: 'pt-BR',
        autoclose: true,
        todayBtn: true,
        pickerPosition: "bottom-left"
      });
    
      $('#mensalidade').maskMoney({thousands:'.', decimal:','});
      $('#implantacao').maskMoney({thousands:'.', decimal:','});

    $('#btnLancarSolicitacaoBanco').on('click', function(){
        //error parceiro
        if($('#nome_solicitante').val() == ''){
            $('#error_nome_solicitante').show();
            return false;
        }
        if($('#telefone_parceiro').val() == ''){
            $('#error_telefone_parceiro').show();
            return false;
        }
        if($('#email_parceiro').val() == ''){
            $('#error_email_solicitante').show();
            return false;
        }

        //errors cliente
        if($('#socio_adm').val() == ''){
            $('#error_socio').show();
            return false;
        }
        if($('#telefone1').val() == ''){
            $('#error_telefone').show();
            return false;
        }
        if($('#email_cliente').val() == ''){
            $('#error_email').show();
            return false;
        }

        if($('#parceiro_cnpj').val() == ''){
            $('#error_cnpj_parceiro').show();
            return false;
        }
        if($('#cliente_cnpj').val() == ''){
            $('#error_cnpj').show();
            return false;
        }
        $('#error_telefone').hide();
        $('#error_cnpj_parceiro').hide();
        $('#error_cnpj').hide();
        $('#error_email').hide();
        $('#error_socio').hide();
        $('#error_email_solicitante').hide();
        $('#error_telefone_parceiro').hide();
        $('#error_nome_solicitante').hide();

        salvarSolicitacao();        

        return false;
    });
});

function limparTela(){
    $("#cliente_id").val("");
    $("#cliente_razao_social").val("");
    $("#cliente_cnpj").val("");
    $("#cliente_cidade").val("");    
    $("#socio_adm").val("");   
    $("#telefone1").val("");   
    $("#telefone2").val("");   
    $("#observacao").val("");
    $("#sistema").val("");    
    $("#mensalidade").val("");   
    $("#data_vencimento").val(""); 
    $("#implantacao").val(""); 
}

function salvarSolicitacao(){
    $.ajax({
        url: '/solicitacao_banco_externo/criar_solicitacao',
        data: {cnpj_parceiro: $("#parceiro_cnpj").val(), nome_solicitante: $("#nome_solicitante").val(), telefone_parceiro: $("#telefone_parceiro").val(), email_parceiro: $("#email_parceiro").val(), 
                cnpj: $("#cliente_cnpj").val(), regime: $("#regime").val(),
                socio: $("#socio_adm").val(), telefone1: $("#telefone1").val(), telefone2: $("#telefone2").val(), email_cliente: $("#email_cliente").val(),
                sistema: $("#sistema").val(), mensalidade: $("#mensalidade").val(), data_vencimento: $("#data_vencimento").val(), implantacao: $("#implantacao").val(), data_implantacao: $("#data_implantacao").val(),
                local: $("#local_banco").val(), tipo: $("#tipo_banco").val(), observacao: $("#observacao").val()},
        type: 'POST',
        success: function (data) {
            exibirMsg("Solicitação cadastrada com sucesso");
            limparTela();
            return true;
        },error: function(data){
            exibirErro(data);
        }
    });

    return false;
}

function buscarCliente(parceiro){ 
    if (parceiro == false) {
        if ($('#cliente_cnpj').val() == '')
            $('#error_cnpj').show();
    }else{
        if ($('#parceiro_cnpj').val() == '')
            $('#error_cnpj_parceiro').show();
    }   
    $('#error_cnpj').hide();
    $('#error_cnpj_parceiro').hide();

    if(parceiro){
        $.ajax({
            url: '/solicitacao_bancos/get_parceiro_financeiro?cnpj=' + $('#parceiro_cnpj').val(),
            type: 'GET',
            success: function(data) {
                $("#parceiro_razao_social").val(data[0]['razaosocial']);    
                $("#email_parceiro").val(data[0]['email']);    
                $("#telefone_parceiro").val(data[0]['telefone']);    
            },error: function(data){
                $('#modal_erro_cnpj').modal('show');
            }
        });   
    }else{
        $.ajax({
        url: '/clientes/find_cliente_cnpj?cnpj=' + $('#cliente_cnpj').val(),
        type: 'GET',
        success: function(data) {
            $("#cliente_id").val(data['id']);
            $("#cliente_razao_social").val(data['razao_social']);
            $("#cliente_cidade").val(data['cidade']['nome'] + '/'+data['cidade']['estado']['sigla']);
            $("#socio_adm").val(data['socio_adm']);
            $("#telefone1").val(data['telefone']);
            $("#telefone2").val(data['telefone2']);
            $("#email_cliente").val(data['email']);          

        },error: function(data){
            $('#modal_erro_cnpj').modal('show');
        }
    });  
    }

      
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