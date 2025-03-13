//= require validate/jquery.validate.min.js
//= require iCheck/icheck.min.js
//= require jquery-ui/jquery-ui.min.js
//= require fullcalendar/fullcalendar.min.js
//= require peity/jquery.peity.min.js
//= require sparkline/jquery.sparkline.min.js
//= require mask_plugin/jquery.mask.js
//= require typehead/bootstrap3-typeahead.min.js
//= require fullcalendar/fullcalendar-rightclick.js
//= require sweetalert/sweetalert2.all.js
//= require qtip/jquery.qtip.min.js
//= require chosen/chosen.jquery.js
//= require datapicker/bootstrap-datepicker.js

$('.chosen-select').chosen({width: "100%"});

$(document).ready(function(){   
    drag_drop_solDesistencia();

    var date = new Date();
    $('#data_inicio').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
    $("#data_inicio").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), 1));

    $('#data_fim').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
    $("#data_fim").datepicker("setDate",  new Date(date.getFullYear(), date.getMonth() + 1, 0));
    atualizarPaineis();

    $('#btnSalvarComentario').on('click', function(){
        if($('#modal_comentario #text_comentario').val() == ''){
            $('#error_comentario').show();
            return false;
        }
        $('#modal_comentario #error_comentario').hide();

        // if(!usuarioAdmin && $('#retorno_data_retorno').val() == '' && !moment($('#retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()) {
        //     exibirErro('Informe uma data de retorno válida!');
        //     return false;
        // }

        //if(!moment($('#retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()){
        salvarComentario();        

        return false;
    });

    $('#btnSalvarComentarioIndex').on('click', function(){
        if($('#modal_comentario #text_comentario').val() == ''){
            $('#error_comentario').show();
            return false;
        }
        $('#modal_comentario #error_comentario').hide();
        salvarComentarioIndex();        

        return false;
    });

    $('#telefone').focusout(function() {    
        $('#table-contatos-cliente-whats > tbody:last tr:eq(0)').before('<tr><td>' + $('#solicitante').val() + '</td><td>'+ $('#telefone').val() + '</td><td> <button class="btn btn-sm btn-info btn-table" title="Whatsapp" onclick="chamarApiWhats('+$('#telefone').val() +')" data-toggle="tooltip" data-placement="right"> <i class="fa fa-whatsapp"></i></button></td></tr>');
    });
    
    $('#cliente_razao_social').typeahead({
        rateLimitWait: 5000,
        source: function (query, process) {
            return $.ajax({
                //url: '/clientes/find_cliente/',
                url: '/solicitacao_desistencias/find_cliente/', //buscar em todas empresas
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
            $.getJSON('/clientes/' + map[item], function(data) { //set_cliente (controller)
                limparTela();
                setDadosCliente(data);
            });
            return item;
        },
        minLength: 2
    });

    $('#btnDesistente').on('click', function(){
        document.getElementById("title_finalizar").innerHTML = "DESISTENTE";

        $("#modal_finalizar_solicitacao #group_desistente").show();
        $('#modal_finalizar_solicitacao').modal('show');
    });

    $('#btnRecuperado').on('click', function(){
        document.getElementById("title_finalizar").innerHTML = "RECUPERADO";

        $("#modal_finalizar_solicitacao #group_desistente").hide();
        $('#modal_finalizar_solicitacao').modal('show');
    });

    $('#btnSalvarNovaTag').on('click', function(){
        if($('#modal_nova_tag_desistencia #text_descricao').val() == ''){
            $('#error_descricao').show();
            return false;
        }
        $('#error_descricao').hide();

        $.ajax({
            url: '/solicitacao_desistencias/create_tag',
            data: {descricao: $("#modal_nova_tag_desistencia #text_descricao").val()},
            type: 'POST',
            success: function (data) {
                $("#modal_finalizar_solicitacao #tags").append('<option value="' + data['id'] + '">'+ data['descricao'] +'</option>');
                $('#modal_finalizar_solicitacao #tags').trigger("chosen:updated");
                return false;
            },error: function(data){
                exibirErro('Ocorreu um erro ao salvar nova tag.');
                return false;
            }
        });

        $('#modal_nova_tag_desistencia').modal('hide');
        return false;
    });

    $('#btnFinalizarDesistencia').on('click', function(){
        if($('#modal_finalizar_solicitacao #text_comentario').val() == '' ){
            $('#modal_finalizar_solicitacao #error_comentario').show();
            return false;
        }
        $('#error_comentario').hide();

        $.ajax({
            url: '/solicitacao_desistencias/finalizar',
            data: {tags: $("#modal_finalizar_solicitacao #tags").val(), 
                    motivo: $("#modal_finalizar_solicitacao #text_comentario").val(),
                    solicitacao_id: $('#desistencia_id').val(),
                    flag: document.getElementById("title_finalizar").innerHTML },
            type: 'POST',
            success: function (data) {
                $("#modal_finalizar_solicitacao").modal('hide');
                window.location.href = "/solicitacao_desistencias/" + $('#desistencia_id').val();
                return false;
            },error: function(data){
                exibirErro('Ocorreu um erro ao finalizar a desistência.');
                return false;
            }
        });
        return false;
    });

    $('#btnIniciar').on('click', function(){
        $.ajax({
            url: '/solicitacao_desistencias/iniciar_solicitacao',
            data: {id: $('#desistencia_id').val() },
            type: 'POST',
            success: function (data) {
                exibirMsg("Solicitação em andamento");
                $('#btnIniciar').hide();
                return false;
            },error: function(data){
                exibirErro('Ocorreu um erro ao iniciar a desistência.');
                return false;
            }
        });

        return false;
    });
    //============================= index =============
    $('#btn7dias').on('click', function () {
        $("#data_inicio").datepicker("setDate",  addDays(new Date(), -7));
        $("#data_fim").datepicker("setDate",  new Date());

        atualizarPaineis();
        return false;
    });

    $('#btnMes').on('click', function () {
        $("#data_inicio").datepicker("setDate",  new Date(date.getFullYear(), date.getMonth(), 1));
        $("#data_fim").datepicker("setDate",  new Date(date.getFullYear(), date.getMonth() + 1, 0));

        atualizarPaineis();
        return false;
    });

    $('#btnTodas').on('click', function () {
        $("#data_inicio").datepicker("setDate",  null);
        $("#data_fim").datepicker("setDate",  null);

        atualizarPaineis();
        return false;
    });

    $('#btnAno').on('click', function () {
        $("#data_inicio").datepicker("setDate",  new Date(date.getFullYear(), 0, 1));
        $("#data_fim").datepicker("setDate",  new Date(date.getFullYear(), 12, 0));

        atualizarPaineis();
        return false;
    });

    $('#btnFiltrar').on('click', function () {
        atualizarPaineis();
        return false;
    });
    
});

function limparTela(){
    $("#cliente_id").val("");
    $("#cliente_razao_social").val("");
    //$("#cliente_cnpj").val("");
    $("#cliente_cidade").val("");

    $("#vendedor").val("");
    $("#sistema").val("");
    $("#mensalidade").val("");
    $("#implantador").val("");
    $("#dias_cliente").val("");
    $("#ultimo_acesso").val("");
    $("#status").val("");
    $("#motivo").val("");
    $("#solicitante").val("");
    $("#telefone").val("");
}

function buscarCliente(){    
    limparTela();

    if ($('#cliente_cnpj').val() == '')
        $('#error_cnpj').show();
    
    $('#error_cnpj').hide();

    $.ajax({
        url: '/solicitacao_desistencia_externo/get_cliente_financeiro_ativo?cnpj=' + $('#cliente_cnpj').val(),
        type: 'GET',
        success: function(data) {
            setDadosCliente(data[0]);

        },error: function(data){
            $('#modal_erro_cnpj').modal('show');
        }
    });    
}

function setDadosCliente(data){
    $("#cliente_razao_social").val(data['razaosocial']);
    $("#cnpj").val(data['cpfcnpj']);
    $("#cliente_cidade").val(data['cidade_uf']);
    $("#sistema").val(data['sistema']);
    $("#mensalidade").val(data['valor_mensalidade']);
    $("#dias_cliente").val(data['dias_cliente']);
    $("#status").val(data['situacao']);

    $.getJSON('/clientes/find_cliente_cnpj?cnpj=' + data['cpfcnpj'], function(data_business) { 
        $("#cliente_id").val(data_business['id']);
        if (data_business['fechamento'])
            $("#vendedor").val(data_business['fechamento']['vendedor_nome']);
        else
            $("#vendedor").val('Não encontrado');
        
        if (data_business['implantacao'])
            $("#implantador").val(data_business['implantacao']['user']['name']);
        else
            $("#implantador").val('Não encontrado');
        
    });   

    $.getJSON('/solicitacao_desistencias/get_cliente_api?cnpj=' + data['cpfcnpj'], function(data2) { 
        //$("#dias_cliente").val(data2['dias_cliente']);
        $("#ultimo_acesso").val(data2['ultimo_acesso']);
        //$("#status").val(data2['status']);
    });

    $.getJSON('/solicitacao_desistencia_externo/get_cliente_financeiro_ativo?cnpj=' + data['cpfcnpj'], function(data3) {         
        if (data3[0]['parceiro'] == '')
            $("#tecnico").val(data3[0]['local']);
        else
            $("#tecnico").val(data3[0]['parceiro']);
    });

    $.getJSON('/solicitacao_desistencias/get_contatos_api?cnpj=' + data['cpfcnpj'], function(cont) { 
        $('#body-table-contatos-whats tr').remove();
        $('#body-table-contatos-whats2 tr').remove();
        var metade = Math.trunc(cont.length/2);

        for (var i=0 ; i < metade; i++){
            var nome = cont[i].name != null? cont[i].name : "Sem nome";
            $('#body-table-contatos-whats').append('<tr><td>' + nome + '</td>' +
                                        '<td>' + cont[i].phone + '</td>' + 
                                        '<td> <button class="btn btn-sm btn-white btn-table" title="Whatsapp" onclick="chamarApiWhats(' +cont[i].phone +')" data-toggle="tooltip" data-placement="right"> <i class="fa fa-whatsapp"></i></button></td></tr>');
        }
        
        for (var j= metade ; j < cont.length; j++){
            var nome = cont[j].name != null? cont[j].name : "Sem nome";
            $('#body-table-contatos-whats2').append('<tr><td>' + nome + '</td>' +
                                        '<td>' + cont[j].phone + '</td>' + 
                                        '<td> <button class="btn btn-sm btn-white btn-table" title="Whatsapp" onclick="chamarApiWhats(' +cont[j].phone +')" data-toggle="tooltip" data-placement="right"> <i class="fa fa-whatsapp"></i></button></td></tr>');
                                        
        }       
        
    });
}

function chamarApiWhats(telefone) {
    if(telefone == '')
        return false;
    window.open('https://api.whatsapp.com/send?phone=55' + telefone, '_blank');
}

function abrirModalComentario() {
    $("#modal_comentario #comentario_data_retorno").hide();
    $('#modal_comentario #novo_comentario_sol_des_id').val($('#desistencia_id').val());
    $("#modal_comentario #btnSalvarComentarioIndex").hide();
    $("#modal_comentario #is_acordo").val('true');
    
    $('#modal_comentario').modal('show');
}

function abrirModalComentarioRetorno() {
    $('#modal_comentario #retorno_data_retorno').mask('00/00/0000 00:00');
    $('#modal_comentario #novo_comentario_sol_des_id').val($('#desistencia_id').val());
    $("#modal_comentario #comentario_data_retorno").show();
    $("#modal_comentario #btnSalvarComentarioIndex").hide();
    $("#modal_comentario #is_acordo").val('false');
    $('#modal_comentario').modal('show');
}

function salvarComentario() {
    $.ajax({
        url: '/comentarios/',
        data: getFormComentario(),
        processData: false,
        contentType: false,
        type: 'POST',
        success: function (data) {
            window.location.href = "/solicitacao_desistencias/" + $('#modal_comentario #novo_comentario_sol_des_id').val();
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}

function salvarComentarioIndex() {
    $.ajax({
        url: '/comentarios/',
        data: getFormComentario(),
        processData: false,
        contentType: false,
        type: 'POST',
        success: function (data) {
            window.location.href = "/solicitacao_desistencias";
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}

function getFormComentario(){
    form = new FormData();
    form.append('comentario[comentario]', $("#modal_comentario #text_comentario").val());
    form.append('comentario[solicitacao_desistencia_id]', $("#modal_comentario #novo_comentario_sol_des_id").val());
    if(moment($('#retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()){
        form.append('data_retorno', $('#modal_comentario #retorno_data_retorno').val());
    }
    form.append('usuario_id', $('#modal_comentario #comentario_usuario_id').val());
    form.append('is_acordo', $('#modal_comentario #is_acordo').val());

    return form;
}

function btnNewTagDesistencia() {
    $('#modal_nova_tag_desistencia').modal('show');
}

function atualizarPaineis(){
    getAguardando();
    getAndamento();
    getRecuperadas();
    getDesistentes();
}

function getAguardando() {
    $.getJSON("/solicitacao_desistencias/get_solicitacoes_status?q[status_eq]=AGUARDANDO", function(data) {
        $('#text-painel0').text('AGUARDANDO (' + data.length + ')');
        $("#painel0 li").remove();
       $.each(data,function (i,val){
            $.getJSON("/solicitacao_desistencia_externo/get_cliente_financeiro?cnpj=" + val['cliente']['cnpj'], function(dados_fin) {
            $('<li class="' + getCorSistema(val['cliente']['sistema']) + '-element" id="solicitacao_desistencia-'+ val['id'] +'">')
                .prepend(getPainelHtml(val, dados_fin[0], 'agurdando'))
                .appendTo('#painel0');
            });
       });
    });
}

function getAndamento() {
    $.getJSON("/solicitacao_desistencias/get_solicitacoes_status?q[status_eq]=ANDAMENTO", function(data) {
        $('#text-painel1').text('EM ANDAMENTO (' + data.length + ')');
        $("#painel1 li").remove();
        $.each(data,function (i,val){
            $.getJSON("/solicitacao_desistencia_externo/get_cliente_financeiro?cnpj=" + val['cliente']['cnpj'], function(dados_fin) {
            $('<li class="' + getCorSistema(val['cliente']['sistema']) + '-element" id="solicitacao_desistencia-'+ val['id'] +'">')
                .prepend(getPainelHtml(val, dados_fin[0], 'andamento'))
                .appendTo('#painel1');
            });
       });
    });
}

function getRecuperadas() {
    $.getJSON("/solicitacao_desistencias/get_solicitacoes_status?q[status_eq]=RECUPERADO&data_inicio=" + $('#data_inicio').val() + "&data_fim=" + $('#data_fim').val(), function(data) {
        $('#text-painel2').text('RECUPERADOS (' + data.length + ')');
        $("#painel2 li").remove();
        $.each(data,function (i,val){
            $.getJSON("/solicitacao_desistencia_externo/get_cliente_financeiro?cnpj=" + val['cliente']['cnpj'], function(dados_fin) {
            $('<li class="' + getCorSistema(val['cliente']['sistema']) + '-element" id="solicitacao_desistencia-'+ val['id'] +'">')
                .prepend(getPainelHtml(val, dados_fin[0], 'recuperada'))
                .appendTo('#painel2');
            });
       });
    });
}

function getDesistentes() {
    $.getJSON("/solicitacao_desistencias/get_solicitacoes_status?q[status_eq]=DESISTENTE&data_inicio=" + $('#data_inicio').val() + "&data_fim=" + $('#data_fim').val(), function(data) {
        $('#text-painel3').text('DESISTENTES (' + data.length + ')');
        $("#painel3 li").remove();
        $.each(data,function (i,val){
            $.getJSON("/solicitacao_desistencia_externo/get_cliente_financeiro?cnpj=" + val['cliente']['cnpj'], function(dados_fin) {
            $('<li class="' + getCorSistema(val['cliente']['sistema']) + '-element" id="solicitacao_desistencia-'+ val['id'] +'">')
                .prepend(getPainelHtml(val, dados_fin[0], 'desistente'))
                .appendTo('#painel3');
            });
       });
    });
}

function getCorSistema(sistema){
    if(sistema == 'Manager')
        return 'warning';
    if(sistema == 'Light')
        return 'info';
    if(sistema == 'Gourmet')
        return 'success';
    if(sistema == 'Emissor')
        return 'danger';
}

function getDataFormatada(data){
    if(data != null)
     return moment(data).format('DD/MM/YYYY HH:MM:SS');
    else return 'Sem agenda'
}

function getTitleTooltip(ultimo_comentario, observacao) {
    var text = '';
    if(ultimo_comentario == null){
        text = 'Sem comentários'
    }else{
        text = '<h5>' + formatarData(ultimo_comentario) + ' - ' + moment(formatarData(ultimo_comentario), "DD/MM/YYYY HH:MM").fromNow() + '</h5>';
        text = text + '<h7>' + observacao + '</h7>';
    }

    return text;
}

function getTitleTooltipFidelidade(proposta) {
    var text = '';
    if(proposta['fidelidade'] == true){
        text = 'Sim'
    }else{
        text = 'Não'
    }

    return text;
}


function getPainelHtml(data, dados_financeiro, status){
    var html = dados_financeiro['razaosocial'] + ' - ' + dados_financeiro['cpfcnpj'] + ' - '+ dados_financeiro['cidade_uf'] + 
        '<div class="agile-detail">' +
        '<span class="pull-right">Mensalidade: ' +  dados_financeiro['valor_mensalidade'] + '</span>' + 
        'Sistema: ' + dados_financeiro['sistema'] +
        '</div>' +
        '<div class="agile-detail">'
        if (data['cliente']['fechamento'])        
            html += '<span>Vendedor: ' + data['cliente']['fechamento']['vendedor_nome']+ '</span>'
        else
            html += '<span>Vendedor: Não encontrado </span>'

        html += '</div>' +
        '<div class="agile-detail">' +
        '<span>Dias como cliente : ' + dados_financeiro['dias_cliente'] + '</span>' +
        '</div>' +
        '<div class="agile-detail">'
        if (data['cliente']['socio_admin'] != null)
            html += '<span>Responsável empresa : '+ data['cliente']['socio_admin'] + '</span>'
        else
            html += '<span>Responsável empresa : Não informado </span>'
        
        html += '</div>' +
        '<div class="agile-detail">' +
        '<div class="pull-center">' +
        '<a class="btn btn-xs btn-info" style="margin-right: 5px" href="/solicitacao_desistencias/'+data['id'] + '" title="Lançar"><span class="fa fa-eye"></span></a>' +
        '<button class="btn btn-primary btn-xs tooltipteste" style="margin-right: 5px" onclick="' + 'abrirModalComentarios(\'' + data['id'] + '\')' + '" id="activities-'+data['id'] + '" type="button" title=Comentários ><span class="fa fa-comments"></span></button>'
        if (data['cliente']['proposta'])
            html += '<a class="btn btn-xs btn-info" title="Contrato fidelidade ' + getTitleTooltipFidelidade(data['cliente']['proposta']) + '"><span class="fa fa-file-text "></span></a>';
        else
            html += '<a class="btn btn-xs btn-info" title="Contrato fidelidade Não"><span class="fa fa-file-text "></span></a>';
        
        if(data['telefone'] != null && data['telefone'] != '') {
            html = html + '<a class="btn btn-xs btn-white" style="margin-left: 5px" href="https://api.whatsapp.com/send?phone=55' + apenasNumeros(data['telefone']) + '" title="Whatsapp" target="_blank"><img alt="Avatar" class="img-circle" src="/assets/whats_enviado-48910f63828c36a6fa71b452fdc92993272672d48b6b907f4267f078799d0ce4.ico"></a>'
        } 
        html = html + '<button class="btn btn-danger btn-xs tooltipteste" style="margin-left: 5px" onclick="' + 'deletarDesistencia(\'' + data['id'] + '\')' + '" id="activities-'+data['id'] + '" type="button" title=Excluir ><span class="fa fa-remove"></span></button>';
        
        html = html +  '</div></div></li>';

    return html;
}

function abrirModalComentarios(id) {
    $.ajax({
        url: '/solicitacao_desistencias/activities',
        data: {id: id},
        type: 'GET',
        success: function (data) {
            $("#modal_content_activities").html(data);
            $("#modal_activities_solicitacao_desistencia").modal('show');
            addFuncoes(id);
        },error: function(data){
            exibirErro(data);
        }
    });
}

function deletarDesistencia(id){
    $.ajax({
      url: "/solicitacao_desistencias/deletar_solicitacao",
      data: {id: id},
      type: 'DELETE',
      success: function (data) {
          exibirMsg("Deletado com sucesso");
          window.location.href= '/solicitacao_desistencias';
          return true;
      },error: function(data){
          exibirErro('Não é possóvel excluir solicitação fora do status AGUARDANDO');
      }
    });
  
    return false;
  }

function addFuncoes(id){
    $('#novoComentarioActivitySolDesistencia').on('click', function () {
        $('#modal_comentario #novo_comentario_sol_des_id').val(id)
        $("#modal_comentario #text_comentario").val("");
        $('#modal_comentario #retorno_data_retorno').val('');

        $("#modal_comentario #btnSalvarComentario").hide();
        $("#modal_comentario #comentario_data_retorno").show();
        $('#modal_comentario').modal('show');
    });

}

function deleteComentario(id) {
    swal({
        title: "Deseja excluir o comentário?",
        text: '',
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Sim!",
        cancelButtonText: "Não!",
        showConfirmButton: true,
        allowOutsideClick: false
    }).then(function(result) {
        if (result.value) {
            $.ajax({
                url: '/comentarios/' + id,
                processData: false,
                contentType: false,
                type: 'DELETE',
                success: function (data) {
                    window.location.href = "/solicitacao_desistencias/" + $('#desistencia_id').val();
                },error: function(data){
                    exibirErro('Ocorreu um erro.');
                }
            });
            return false;
        }
    });
}

// Dragable panels
function drag_drop_solDesistencia() {
    var element = ".dragDropSolicitacaoDesistencia";
    $(element).sortable(
        {
            connectWith: ".list-andamento, .list-aguardando, .list-desistente, .list-recuperado",
            tolerance: 'pointer',
            opacity: 0.8,
            receive: function( event, ui ) {
                alterar_status(ui.item[0].id, event.target.id);
            }
        })
};

function alterar_status(id, painel) {
    var aux = id.split('-');
    $.ajax({
        url: '/solicitacao_desistencias/alterar_status',
        data: {id: aux[1], painel: painel},
        type: 'POST',
        success: function(data) {
            
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}
