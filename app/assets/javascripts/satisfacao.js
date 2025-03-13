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

$(document).ready(function () {
  if ($("#cliente_cnpj").val() != undefined && $("#cliente_cnpj").val() != "") {
    buscarCliente();
  }

  $("#cliente_cnpj").focusout(function () {
    if (
      $("#cliente_cnpj").val().length == 14 ||
      $("#cliente_cnpj").val().length == 11
    ) {
      buscarCliente();
    }
  });

  $("#cliente_cnpj").keypress(function (e) {
    if (e.keyCode == 13) {
      buscarCliente();
      return false;
    } else {
      return SomenteNumero(e);
    }
  });

  $("#btnLancarPesquisa").on("click", function () {
    var hasError = true;

    if ($("#cliente_id").val() === "") {
      $("#error_cnpj").show();
      return false;
    } else {
      $("#error_cnpj").hide();
    }
    if ($("#nome").val() === undefined || $("#nome").val() === "") {
      $("#error_nome_solicitante").show();
      return false;
    } else {
      $("#error_nome_solicitante").hide();
    }

    if ($("#setores").is(":visible")) {
      hasError = false;
      // setor.map((item) => {
      //     if($('#select-setor-' + item.id).val() <= 4 && $('#setor_textarea_' + item.id).val().length < 5){
      //         $('#error_setor_textarea_' + item.id).show();
      //         $('#setor_textarea_' + item.id).css("border", "1px solid red");
      //         hasError = true;
      //     }else{
      //         $('#error_setor_textarea_' + item.id).hide();
      //         $('#setor_textarea_' + item.id).css("border", "1px solid");
      //     }
      // })
    }
    if ($("#servicos").is(":visible")) {
      hasError = false;
      servicos.map((item) => {
        if ($("#servico-" + item.id).is(":visible")) {
          if (
            $("#select-servico-" + item.id).val() <= 4 &&
            $("#servico_textarea_" + item.id).val().length < 5
          ) {
            $("#error_servico_textarea_" + item.id).show();
            $("#servico_textarea_" + item.id).css("border", "1px solid red");
            hasError = true;
          } else {
            $("#error_servico_textarea_" + item.id).hide();
            $("#servico_textarea_" + item.id).css("border", "1px solid");
          }
        }
      });
    }

    if (hasError === false) {
      salvarSolicitacao();
    }

    return false;
  });
});

function limparTela(limparCnpj) {
  if (limparCnpj) {
    $("#cliente_cnpj").val("");
  }
  $("#cliente_id").val("");
  $("#nome").val("");
  $("#telefone").val("");
  $("#email").val("");

  $("#parceiro_razao_social").val("");
  $("#equipe_contabel").val("");
  $("#atendente_externo").val("");
  $("#responsavel_rh").val("");

  if ($("#servicos").is(":visible")) {
    servicos.map((item) => {
      if ($("#select-servico-" + item.id).length) {
        $("#select-servico-" + item.id).val("");
        $("#servico_textarea_" + item.id).val("");
        $("#error_servico_textarea_" + item.id).hide();
      }
      $("#servico-" + item.id).hide();
    });
  }

  if ($("#setores").is(":visible")) {
    setor.map((item) => {
      if ($("#select-setor-" + item.id).length) {
        $("#select-setor-" + item.id).val("");
        $("#setor_textarea_" + item.id).val("");
        $("#error_setor_textarea_" + item.id).hide();
      }
    });
  }

  $("#setores").hide();
  $("#servicos").hide();
  $("#instituicao_div").hide();
  $("#btn_salvar").hide();
}

function salvarSolicitacao() {
  $.ajax({
    url: "/satisfacao/criar_pesquisa",
    data: getForm(),
    type: "POST",
    success: function (data) {
      $("#pesquisaSatisfacao").hide();
      $("#msgSucesso").show();
      limparTela(true);
      return true;
    },
    error: function (data) {
      exibirErro(data.responseText.toString());
    },
  });

  return false;
}

function buscarCliente() {
  if ($("#cliente_cnpj").val() == undefined || $("#cliente_cnpj").val() == "") {
    $("#error_cnpj").show();
    return;
  }

  $("#error_cnpj").hide();

  $.ajax({
    url: "/satisfacao/buscar_cliente?cpfCnpj=" + $("#cliente_cnpj").val(),
    type: "GET",
    success: function (data) {
      if (data.temHonorario === true) {
        $("#setores").addClass("animated fadeInDown");
        $("#servicos").hide();

        // if(data.setores){
        //     $('#equipe_contabel').val(data.setores.contabil_nome)
        //     $('#atendente_externo').val(data.setores.atendimento_nome)
        //     $('#responsavel_rh').val(data.setores.rh_nome)
        // }

        $("#setores").show();
        $("#instituicao_div").show();
        $("#btn_salvar").show();

        $("#parceiro_razao_social").val(data.cliente.razaosocial);
      } else {
        let hasOneService = false;
        servicos.map((item) => {
          data.servicos_feitos.map((serv_feito) => {
            if (
              item.tipocobranca_id &&
              item.tipocobranca_id.toString() === serv_feito.tipocobranca_id
            ) {
              hasOneService = true;
              $("#servico-" + item.id).show();
            }
          });
        });
        if (!hasOneService) {
          limparTela(true);
          $("#modal_erro_cnpj").modal("show");
          return;
        } else {
          $("#setores").hide();
          $("#servicos").addClass("animated fadeInDown");
          $("#servicos").show();
          $("#instituicao_div").show();
          $("#btn_salvar").show();

          $("#nome").val(data.cliente.razaosocial);
        }
      }

      $("#email").val(data.cliente.email);
      $("#telefone").val(data.cliente.telefone);
      $("#cliente_id").val(data.cliente.id);
    },
    error: function (data) {
      $("#pesquisaSatisfacao").hide();
      $("#msgClienteNaoEncontrato").show();
      limparTela(false);
    },
  });
}

function exibirErro(msgErro) {
  toastr.options = {
    closeButton: true,
    showMethod: "slideDown",
  };
  toastr.error(msgErro);
}

function exibirMsg(msg) {
  toastr.options = {
    closeButton: true,
    showMethod: "slideDown",
  };
  toastr.success(msg);
}

function SomenteNumero(e) {
  var tecla = window.event ? event.keyCode : e.which;
  if (tecla > 47 && tecla < 58) return true;
  else {
    if (tecla == 8 || tecla == 0) return true;
    else return false;
  }
}

function getForm() {
  let serv = [];
  if ($("#servicos").is(":visible")) {
    servicos.map((item) => {
      if ($("#servico-" + item.id).is(":visible")) {
        if ($("#select-servico-" + item.id).length) {
          let nota = $("#select-servico-" + item.id).val();
          let motivo = $("#servico_textarea_" + item.id).val();
          serv.push({ servico_id: item.id, nota: nota, motivo: motivo });
        }
      }
    });
  }

  let setores = [];
  if ($("#setores").is(":visible")) {
    setor.map((item) => {
      if ($("#select-setor-" + item.id).length) {
        let nota = $("#select-setor-" + item.id).val();
        let motivo = $("#setor_textarea_" + item.id).val();
        setores.push({ setor_id: item.id, nota: nota, motivo: motivo });
      }
    });
  }

  return {
    satisfacao_cliente_id: $("#cliente_id").val(),
    satisfacao_cnpj: $("#cliente_cnpj").val(),
    satisfacao_nome: $("#nome").val(),
    satisfacao_telefone: $("#telefone").val(),
    satisfacao_email: $("#email").val(),
    satisfacao_instituicao_beneficiente: $("#instituicao").val(),
    satisfacao_servicos: serv,
    satisfacao_setores: setores,
  };
}

function voltarPesquisa() {
  limparTela(false);
  $("#pesquisaSatisfacao").show();
  $("#msgClienteNaoEncontrato").hide();
}
