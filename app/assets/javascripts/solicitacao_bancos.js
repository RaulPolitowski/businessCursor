//= require datapicker/bootstrap-datepicker.js
//= require chosen/chosen.jquery.js

var date = new Date();
$(document).ready(function () {
  $('.chosen-select').chosen({width: "100%"});

  $('#data_q #created_at_gteq').datepicker({
    format: 'dd/mm/yyyy',
    language: 'pt-BR',
    autoclose: true,
    todayBtn: true,
    pickerPosition: "bottom-left"
  });
  $("#created_at_gteq").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), 1));

  $('#data_q #created_at_lteq').datepicker({
    format: 'dd/mm/yyyy',
    language: 'pt-BR',
    autoclose: true,
    todayBtn: true,
    pickerPosition: "bottom-left"
  });
  $("#created_at_lteq").datepicker("setDate",  new Date(date.getFullYear(), date.getMonth() + 1, 0));

  $('#q_cliente_bd').typeahead({
    source: function (query, process) {
        return $.ajax({
            url: '/clientes/find_cliente/',
            dataType: "json",
            data: {
                term: query
            },
            success: function(data) {
                var options = [];
                map = {}; //replace any existing map attr with an empty object
                $.each(data,function (i,val){
                    options.push(val.razao_social + ' - ' + val.cnpj);
                    map[val.razao_social + ' - ' + val.cnpj] = val.id; //keep reference from name -> id
                });
                return process(options);
            }
        });
    },
    updater: function (item) {
        $('#q_cliente_id_eq').val(map[item]);
        return item;
    },
    minLength: 2
  });

  $("#q_cliente_bd").focusout(function(){
      var cliente = $('#q_cliente_bd').val();
      if(!cliente || cliente == ''){
          $('#q_cliente_id_eq').val('');
      }
  });

  $('#solicitar_banco_cliente').typeahead({
      source: function (query, process) {
          return $.ajax({
              url: '/clientes/find_cliente/',
              dataType: "json",
              data: {
                  term: query
              },
              success: function(data) {
                  var options = [];
                  map = {}; //replace any existing map attr with an empty object
                  $.each(data,function (i,val){
                      options.push(val.razao_social + ' - ' + val.cnpj);
                      map[val.razao_social + ' - ' + val.cnpj] = val.id; //keep reference from name -> id
                  });
                  return process(options);
              }
          });
      },
      updater: function (item) {
          limparForm();
          $('#cliente_id').val(map[item]);
          $.getJSON('/clientes/' + map[item], function(data) {
              $('#solicitar_banco_cidade').val(data['cidade']['nome'] + '-' + data['cidade']['estado']['sigla']);
              $('#solicitar_banco_sistema').val(data['fechamento']['proposta']['sistema']);
              $('#solicitar_banco_implantacao').val(data['data_implantacao']);
              $('#solicitar_banco_socio').val(data['socio_admin']);
          });
          return item;
      },
      minLength: 2
  });

  $("#solicitar_banco_cliente").focusout(function(){
      var cliente = $('#solicitar_banco_cliente').val();
      if(!cliente || cliente == ''){
          $('#cliente_id').val('');
      }
  });

  function limparForm() {
    $('#cliente_id').val('');
    $('#solicitar_banco_cliente').val('');
    $('#solicitar_banco_cidade').val('');
    $('#solicitar_banco_sistema').val('');
    $('#solicitar_banco_implantacao').val('');
    $('#solicitar_banco_motivo').val('');
    $('#solicitar_banco_socio').val('');
  }

  $('#btnNovoBancoAvulso').on('click', function () {
    if($('#solicitar_banco_motivo').val() == ''){
      $('#error_motivo').show();
      return false;
    }
    if($('#cliente_id').val() == ''){
      $('#error_cliente').show();
      return false;
    }
    if($('#solicitar_banco_socio').val() == ''){
      $('#error_socio').show();
      return false;
    }

    $.ajax({
        url: '/solicitacao_bancos/create_banco',
        data: {cliente_id: $("#cliente_id").val(), tipo: $('#solicitar_banco_tipo').val(),
                responsavel: $("#responsavel").val(),
                local_banco: $("#solicitar_banco_tipo_banco").val(),
                socio_admin: $("#solicitar_banco_socio").val(),
                motivo: $("#solicitar_banco_motivo").val()},
        type: 'GET',
        success: function (data) {
            $('#modalNovoBanco').modal('hide');
            var id = Number(val['id']);
            var options = '<button class="btn btn-sm btn-default btn-table" onclick="editarSolicitacao('+id+')" title="Editar"><i class="fa fa-pencil" aria-hidden="true"></i></button> &nbsp;'
                        + '<button class="btn btn-sm btn-danger btn-table" onclick="desativarSolicitacao('+id+')" title="Desativar"><i class="fa fa-trash" aria-hidden="true"></i></button>&nbsp;' + '<button class="btn btn-sm btn-info btn-table" onclick="gerarDatabase('+id+')" title="Gerar database"><i class="fa fa-database" aria-hidden="true"></i></button>'

            var table = $('.table-banco').DataTable();
            table.row.add( [
                data['cliente']['razao_social'], 
                data['cidade'], 
                data['data_solicitacao'],
                data['data_implantacao'],
                data['status'], 
                data['user']['name'],
                data['responsavel'] ? data['responsavel']['name'] : 'Sem responsável',
                options
              ] ).draw( false );  
            
            limparForm();

            exibirMsg('Banco solicitado');
            //window.location.reload();
        },error: function(data){
            exibirErro(data);
        }
    });
  });

  $('#btnDesativarBanco').on('click', function () {
    if($('#modalDesativarBanco #solicitar_banco_motivo').val() == ''){
      $('#modalDesativarBanco #error_motivo').show();
      return false;
    }
    
    $.ajax({
        url: '/solicitacao_bancos/desativar_banco',
        data: {id: $("#modalDesativarBanco #solicitacao_id").val(), 
              motivo: $('#modalDesativarBanco #solicitar_banco_motivo').val()},
        type: 'GET',
        success: function (data) {
            $('#modalDesativarBanco #solicitar_banco_motivo').val() == '';
            $('#modalDesativarBanco').modal('hide');
            carregarSolicitacao();
            exibirMsg('Solicitação de banco desativada');
        },error: function(data){
            exibirErro(data);
        }
    });
  });

  $('#btnUpdateBanco').on('click', function () {
    if($('#modalEditarBanco #solicitar_banco_contribuinte_icms').val() == 0 && $('#modalEditarBanco #solicitar_banco_inscricao_estadual').val() == ''){
      exibirErro('Informe a inscrição estadual para o tipo contribuinte!')
      return false;
    }
      if($('#modalEditarBanco #solicitar_banco_nome_usuario').val() == '' || $('#modalEditarBanco #solicitar_banco_username').val() == '' || $('#modalEditarBanco #solicitar_banco_password').val() == ''){
          exibirErro('Informe dados do usuário!');
          return false;
      }

    $.ajax({
        url: '/solicitacao_bancos/editar_solicitacao/',
        data: {
            solicitacao_banco: {
                id: $("#modalEditarBanco #solicitacao_id").val(),
                responsavel: $("#modalEditarBanco #solicitar_banco_responsavel").val(),
                local_banco: $("#modalEditarBanco #solicitar_banco_tipo_banco").val(),
                observacao: $('#modalEditarBanco #solicitar_banco_obs').val(),
                inscricao_estadual: $('#modalEditarBanco #solicitar_banco_inscricao_estadual').val(),
                contribuinte_icms: $('#modalEditarBanco #solicitar_banco_contribuinte_icms').val(),
                nota_fiscal_modulo: $('#modalEditarBanco #solicitar_banco_nota_fiscal_modulo')[0].checked,
                nota_fiscal_consumidor_modulo: $('#modalEditarBanco #solicitar_banco_nota_fiscal_consumidor_modulo')[0].checked,
                conhecimento_transporte_modulo: $('#modalEditarBanco #solicitar_banco_conhecimento_transporte_modulo')[0].checked,
                manifesto_eletronico_modulo: $('#modalEditarBanco #solicitar_banco_manifesto_eletronico_modulo')[0].checked,
                nota_fiscal_servico_modulo: $('#modalEditarBanco #solicitar_banco_nota_fiscal_servico_modulo')[0].checked,
                cupom_fiscal_modulo: $('#modalEditarBanco #solicitar_banco_cupom_fiscal_modulo')[0].checked,
                nome_usuario: $('#modalEditarBanco #solicitar_banco_nome_usuario').val(),
                username: $('#modalEditarBanco #solicitar_banco_username').val(),
                password: $('#modalEditarBanco #solicitar_banco_password').val()
            }
        },
        type: 'GET',
        success: function (data) {
            $('#modalEditarBanco').modal('hide');
            exibirMsg('Solicitação de banco atualizada');
            carregarSolicitacao();
        },error: function(data){
            exibirErro(data);
        }
    });
  });
  
});

function desativarSolicitacao(id){
  $.getJSON('/solicitacao_bancos/get_solicitacao?id=' + id, function(data) {
    $('#modalDesativarBanco #solicitacao_id').val(id);
    $('#modalDesativarBanco #cliente_id').val(data['cliente']['id']);
    $('#modalDesativarBanco #solicitar_banco_cliente').val(data['cliente']['razao_social']);
    $('#modalDesativarBanco #solicitar_banco_cidade').val(data['cidade']);
    $('#modalDesativarBanco #solicitar_banco_sistema').val(data['sistema']);
    $('#modalDesativarBanco #solicitar_banco_implantacao').val(data['data_implantacao']);
    $('#modalDesativarBanco #solicitar_banco_solicitante').val(data['user']['name']);
    $('#modalDesativarBanco #solicitar_banco_responsavel').val(data['responsavel']['name']);
    $('#modalDesativarBanco #solicitar_banco_created_at').val(data['data_solicitacao']);
    $('#modalDesativarBanco #solicitar_banco_status').val(data['status']);

    if (data['local_banco'] == 1)
      $('#modalDesativarBanco #solicitar_banco_tipo_banco').val('Local');
    else
      $('#modalDesativarBanco #solicitar_banco_tipo_banco').val('Em Nuvem');

    if (data['tipo'] == 1)
      $('#modalDesativarBanco #solicitar_banco_tipo').val('Novo banco de dados');
    else if (data['tipo'] == 2)
      $('#modalDesativarBanco #solicitar_banco_tipo').val('Agrupamento de bancos');
    else
      $('#modalDesativarBanco #solicitar_banco_tipo').val('Agrupamento de bancos com migração');
  });
  $('#modalDesativarBanco').modal('show');
}

function gerarDatabase(id){
    $('body').lmask('show');
    $.ajax({
        url: '/solicitacao_bancos/' + id + '/gerar_database',
        data: {},
        type: 'POST',
        success: function (data) {
            carregarSolicitacao();
            exibirMsg('Banco enviado a fila para geração');
            $('body').lmask('hide');
        },error: function(data){
            exibirErro(data.responseJSON['error']);
            $('body').lmask('hide');
        }
    });
}

function showErrorDatabase(id){
    $.getJSON('/solicitacao_bancos/get_solicitacao?id=' + id, function(data) {
        swal({
            title: "Error",
            text: data['motivo_erro'],
            type: "warning",
            customClass: 'swal-width'
        }).then(function(result) {
        })
    });
}

function openCadastroCliente(cliente_id){
    window.open('/clientes/' + cliente_id + '/editar', '_blank');
}

function editarSolicitacao(id){
  $.getJSON('/solicitacao_bancos/get_solicitacao?id=' + id, function(data) {
    if (data['finalizado'] != null){ 
      exibirErro("Banco já foi criado, portanto, a solicitação não pode ser editada. ");
      return false;
    }
    
    $('#modalEditarBanco #solicitacao_id').val(id);
    $('#modalEditarBanco #cliente_id').val(data['cliente']['id']);
    $('#modalEditarBanco #solicitar_banco_cliente').val(data['cliente']['razao_social']);
    $('#modalEditarBanco #solicitar_banco_cidade').val(data['cidade']);
    $('#modalEditarBanco #solicitar_banco_sistema').val(data['sistema']);
    $('#modalEditarBanco #solicitar_banco_implantacao').val(data['data_implantacao']);
    if (data['user'] != null)
      $('#modalEditarBanco #solicitar_banco_solicitante').val(data['user']['name']);
    else
      $('#modalEditarBanco #solicitar_banco_solicitante').val('Parceiro');

    if (data['responsavel'] != null)
      $('#modalEditarBanco #solicitar_banco_responsavel').val(data['responsavel']['name']);

    $('#modalEditarBanco #solicitar_banco_created_at').val(data['data_solicitacao']);
    $('#modalEditarBanco #solicitar_banco_status').val(data['status']).trigger("chosen:updated");
    if (data['tipo'] == 1)
      $('#modalEditarBanco #solicitar_banco_tipo').val('Novo banco de dados');
    else if (data['tipo'] == 2)
      $('#modalEditarBanco #solicitar_banco_tipo').val('Agrupamento de bancos');
    else
      $('#modalEditarBanco #solicitar_banco_tipo').val('Agrupamento de bancos com migração');

    if (data['motivo_solicitacao'] == null){
      $('#modalEditarBanco #motivo').hide();
    }else{
      $('#modalEditarBanco #motivo_solicitacao').val(data['motivo_solicitacao']);
    }
    $('#modalEditarBanco #solicitar_banco_tipo_banco').val(data['local_banco']).trigger("chosen:updated");

      $('#modalEditarBanco #solicitar_banco_inscricao_estadual').val(data['inscricao_estadual']);
      if(data['contribuinte_icms']){
          $('#modalEditarBanco #solicitar_banco_contribuinte_icms').val(data['contribuinte_icms']).trigger("chosen:updated");
      }
      $('#modalEditarBanco #solicitar_banco_nota_fiscal_modulo').prop('checked', data['nota_fiscal_modulo']),
      $('#modalEditarBanco #solicitar_banco_nota_fiscal_consumidor_modulo').prop('checked', data['nota_fiscal_consumidor_modulo']);
      $('#modalEditarBanco #solicitar_banco_conhecimento_transporte_modulo').prop('checked', data['conhecimento_transporte_modulo']),
      $('#modalEditarBanco #solicitar_banco_manifesto_eletronico_modulo').prop('checked', data['manifesto_eletronico_modulo']),
      $('#modalEditarBanco #solicitar_banco_nota_fiscal_servico_modulo').prop('checked', data['nota_fiscal_servico_modulo']),
      $('#modalEditarBanco #solicitar_banco_cupom_fiscal_modulo').prop('checked', data['cupom_fiscal_modulo']),
      $('#modalEditarBanco #solicitar_banco_nome_usuario').val(data['nome_usuario']),
      $('#modalEditarBanco #solicitar_banco_username').val(data['username']),
      $('#modalEditarBanco #solicitar_banco_password').val(data['password'])

    //dados informado pelo parceiro
    $('#modalEditarBanco #solicitar_banco_parceiro').val(data['nome_solicitante']);
    $('#modalEditarBanco #solicitar_banco_telefone_parceiro').val(data['telefone_parceiro']);
    $('#modalEditarBanco #solicitar_banco__email_parceiro').val(data['email_solicitante']);
    $('#modalEditarBanco #solicitar_banco_regime').val(data['regime']);
    $('#modalEditarBanco #solicitar_banco_socio').val(data['socio_admin']);
    $('#modalEditarBanco #solicitar_banco_telefone1').val(data['telefone1']);
    $('#modalEditarBanco #solicitar_banco_telefone2').val(data['telefone2']);
    $('#modalEditarBanco #solicitar_banco_email_cliente').val(data['email_cliente']);
    $('#modalEditarBanco #solicitar_banco_sistema_p').val(data['sistema_p']);
    $('#modalEditarBanco #solicitar_banco_mensalidade_parceiro').val(data['valor_mensalidade']);
    $('#modalEditarBanco #solicitar_banco_implantacao_parceiro').val(data['valor_implantacao']);
    $('#modalEditarBanco #solicitar_banco_data_impl').val(data['data_implantacao_p']);
    $('#modalEditarBanco #solicitar_banco_data').val(data['data_vencimento']);

    $('#modalEditarBanco').modal('show');
  });
  
}

function abrirGuiaCliente(){
  window.open('/clientes/' + $('#modalEditarBanco #cliente_id').val() + '/editar', '_blank');
}