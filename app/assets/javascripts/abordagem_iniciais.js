//= require dataTables/datatables.min.js
//= require jquery-ui/jquery-ui.min.js
//= require datapicker/bootstrap-datepicker.js
//= require mask_plugin/jquery.mask.js

function openModalAbordagem(modalHtml = ""){
  if (modalHtml){
    $('#panel-modal-abordagem').html('');
    $('#panel-modal-abordagem').append(modalHtml);
    $('#modal_abordagem').modal('show');
  }
}

function createAbordagem(){
  $.ajax({
    url: `/abordagem_iniciais/new`,
    type: 'GET',
    success: function (data) {
      console.log({data});
      openModalAbordagem(data)
      return true;
    },error: function(data){
      exibirErro(data);
    }
  });

  return false;
}

function ativarAbordagem(id, tipo){
  $.ajax({
    url: `/abordagem_iniciais/ativar_abordagem?id=${id}&tipo=${tipo}`,
    type: 'GET',
    success: function (data) {
      exibirMsg("Ativada com sucesso");
      window.location.href= '/abordagem_iniciais';
      return true;
    },error: function(data){
      exibirErro(data);
    }
  });

  return false;
}

function deletarAbordagem(id){
  $.ajax({
    url: "/abordagem_iniciais/deletar_abordagem",
    data: {id: id},
    type: 'POST',
    success: function (data) {
      exibirMsg("Deletado com sucesso");
      window.location.href= '/abordagem_iniciais';
      return true;
    },error: function(data){
      exibirErro(data);
    }
  });

  return false;
}

function editarAbordagem(id){
  $.ajax({
    url: `/abordagem_iniciais/${id}`,
    type: 'get',
    success: function (data) {
      openModalAbordagem(data);
      return true;
    },error: function(data){
      console.log({dataErro: data});
    }
  });

  return false;
}

function desativarAbordagem(id){
  $.ajax({
    url: "/abordagem_iniciais/desativar_abordagem",
    data: {id: id},
    type: 'POST',
    success: function (data) {
      exibirMsg("Desativado com sucesso");
      window.location.href= '/abordagem_iniciais';
      return true;
    },error: function(data){
      exibirErro(data);
    }
  });
  return false;
}