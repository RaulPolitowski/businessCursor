// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
//
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
//= require notificacoes.js
//= require sweetalert/sweetalert2.all.js
//= require mask_plugin/jquery.mask.js
//= require push/push.min.js
//= require push/serviceWorker.min.js
//= require notificacoes_chrome.js
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

$(document).ready(function(){
    moment.locale('pt-br');
    $('.navbar-minimalize').on('click', function () {
        var param = true;
        if($(".mini-navbar").length == 0){
            param = false;
        }
        $.getJSON('/users/set_preference?hide=' + param, function(data) {
            console.log('Alterado preference...')
        });
    });

    setInterval(function() {
        if( $('#modal_retorno').is(':visible') ||  $('#modal_nao_perturbe').is(':visible')) {
        } else {
            verificarRetorno();
            verificarNaoPerturbe();
        }
    }, 60000);
    verificarNaoPerturbe();     
    verificarRetorno();
    verificarAtendimentoEmAndamento();
    


    var now = new Date();
    var data_inicial = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 11, 0, 0, 0);
    var data_final = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 12, 10, 0, 0);

    if(now > addMinutes(data_inicial, -10) && now < data_final)
        verificarAgendamentoNaoConfirmado(data_inicial, data_final, 1);

    now = new Date();
    data_inicial = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 17, 0, 0, 0);
    data_final = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 18, 10, 0, 0);
    if(now > addMinutes(data_inicial, -10) && now < data_final){
        verificarAgendamentoNaoConfirmado(data_inicial, data_final,2);
    }


    $('#modal_retorno #retorno_obrigatorio_retorno_reagendar').mask('00/00/0000 00:00');
    $('#modal_retorno #retorno_obrigatorio_btnReagendar').on('click', function () {

        $('#modal_retorno #retorno_obrigatorio_painelRetorno').hide();
        $('#modal_retorno #retorno_obrigatorio_btnReagendar').hide();
        $('#modal_retorno #retorno_obrigatorio_painelReagendar').show();
        $('#modal_retorno #retorno_obrigatorio_btnSalvarReagendamento').show();
        // $("#modal_retorno #tabsRetorno" ).tabs({ active: 0 });
        $('a[href="#tabRetornoObrigatorio-1"]').click();

        return false;
    });
    $('#btnAgendarLigacao').on('click', function(){ agendarRetorno() });
    $('#modal_retorno #nao_perturbe').on('click', function () {inverterStadoOcupado(20)});
    $('#nao_perturbe').on('click', function () { AtivarNaoPerturbe()});

    $('#desativar_nao_perturbe').on('click', function () { 
        $.ajax({
            url: '/users/inverter_status_ocupado',
            data: {'desativar': 1},
            success: function(data) {
                if (data["ocupado"] == false)
                    exibirMsg("Modo não perturbe desativado");
            }
        })
        window.location.reload(true);
    });

    $('#modal_retorno #retorno_obrigatorio_btnEfetuarRetorno').on('click', function () {
        $.getJSON('/agendamento_retornos/set_retorno_andamento', function(data) {
            if($('#modal_retorno #retorno_obrigatorio_tipo').val() == 'NEGOCIACAO'){
                window.location.href = "/ligacoes/ligacao?cliente_retorno_id=" + $('#modal_retorno #retorno_obrigatorio_reagendar_cliente_id').val() + "&retorno_id=" + $('#modal_retorno #retorno_obrigatorio_retorno_id').val();
            }else if($('#modal_retorno #retorno_obrigatorio_tipo').val() == 'IMPLANTACAO'){
                window.location.href = "/implantacoes/" + $('#modal_retorno #retorno_obrigatorio_implantacao_id').val();
            }else{
                window.location.href = "/acompanhamentos/" + $('#modal_retorno #retorno_obrigatorio_acompanhamento_id').val();
            }
        });
        return false;
    });

    $(document).on('show.bs.modal', '.modal', function (event) {
        var zIndex = 2050 + (10 * $('.modal:visible').length);
        $(this).css('z-index', zIndex);
        setTimeout(function() {
            $('.modal-backdrop').not('.modal-stack').css('z-index', zIndex - 1).addClass('modal-stack');
        }, 0);
    });

    $('#modal_retorno #retorno_obrigatorio_btnAdiar').on('click', function () {
        $.getJSON('/agendamento_retornos/set_retorno_andamento', function(data) {
            $('#modal_retorno').modal('hide');
        });
        return false;
    });

    $('#modal_retorno #retorno_obrigatorio_btnSalvarReagendamento').on('click', function () {
        if ($('#modal_retorno #retorno_obrigatorio_retorno_reagendar').val() == '' || !moment($('#modal_retorno #retorno_obrigatorio_retorno_reagendar').val(),"DD/MM/YYYY HH:mm").isValid()){
            exibirErro("Informe uma data válida.");
            return false;
        }
        if ($('#modal_retorno #retorno_obrigatorio_retorno_reagendar_motivo').val() == ''){
            exibirErro("Informe o motivo do reagendamento.");
            return false;
        }

        if($('#modal_retorno #retorno_obrigatorio_tipo').val() == 'NEGOCIACAO'){
            console.log($('#modal_retorno #retorno_obrigatorio_tipo').val());
            $.post( "/agendamento_retornos/reagendar_retorno_negociacao", { id: $('#modal_retorno #retorno_obrigatorio_retorno_id').val(),
                motivo: $('#modal_retorno #retorno_obrigatorio_retorno_reagendar_motivo').val(),
                data_agendamento_retorno:  $('#modal_retorno #retorno_obrigatorio_retorno_reagendar').val(),
                negociador: $('#modal_retorno #negociador_id').val(),
                negociacao_id: $('#modal_retorno #retorno_obrigatorio_negociacao_id').val()}, function () {
                exibirMsg('Retorno reagendado.');
                $('#modal_retorno').modal('toggle');
                return false;
            } ).fail(function(data) {
                if(data['responseText'] == "\"FORA_HORARIO\"")
                    exibirErro("O selecione um horário entre 8:00 e 21:00.")
                else if (data['responseText'] == "\"72_HORAS\"")
                    exibirErro("O retorno não pode ter mais que 72 horas.")
                else exibirErro('Ocorreu um erro.');
                return false;
            });
        }else if($('#modal_retorno #retorno_obrigatorio_tipo').val() == 'IMPLANTACAO'){
            $.post( "/agendamento_retornos/reagendar_retorno_implantacao", { id: $('#modal_retorno #retorno_obrigatorio_retorno_id').val(),
                motivo: $('#modal_retorno #retorno_obrigatorio_retorno_reagendar_motivo').val(),
                data_agendamento_retorno:  $('#modal_retorno #retorno_obrigatorio_retorno_reagendar').val(),
                implantacao_id: $('#modal_retorno #retorno_obrigatorio_implantacao_id').val()}, function () {
                exibirMsg('Retorno reagendado.');
                $('#modal_retorno').modal('toggle');
                return false;
            } ).fail(function(data) {
                if(data['responseText'] == "\"FORA_HORARIO\"")
                    exibirErro("O selecione um horário entre 8:00 e 21:00.")
                else exibirErro('Ocorreu um erro.');
                return false;
            });
        }else{
            $.post( "/agendamento_retornos/reagendar_retorno_acompanhamento", { id: $('#modal_retorno #retorno_obrigatorio_retorno_id').val(),
                motivo: $('#modal_retorno #retorno_obrigatorio_retorno_reagendar_motivo').val(),
                data_agendamento_retorno:  $('#modal_retorno #retorno_obrigatorio_retorno_reagendar').val(),
                acompanhamento_id: $('#modal_retorno #retorno_obrigatorio_acompanhamento_id').val()}, function () {
                exibirMsg('Retorno reagendado.');
                $('#modal_retorno').modal('toggle');
                return false;
            } ).fail(function(data) {
                if(data['responseText'] == "\"FORA_HORARIO\"")
                    exibirErro("O selecione um horário entre 8:00 e 21:00.")
                else exibirErro('Ocorreu um erro.');
                return false;
            });
        }
        return false;
    });

    $('#whatsapp-retorno-obrigatorio').on('click', function () {
        setWhatsNegocicao();
    });
    $('#telefonePref-retorno-obrigatorio').on('click', function () {
        setTelefonePrefNegocicao();
    });

    $('#modal_retorno #retorno_obrigatorio_btnWhats').on('click', function () {
        window.open('https://api.whatsapp.com/send?phone=55' + apenasNumeros($('#modal_retorno #retorno_obrigatorio_telefone').val()), '_blank');
        return false;
    });

    $('#modal_aviso_confirmacao #btnVerificarAgendamento').on('click', function () {
        $.getJSON('/agendamentos/' + + $('#modal_aviso_confirmacao #agendamento_id').val() + '/nao_confimado_avisado', function(data) {
            window.open("../agenda?agenda_index_id=" + $('#modal_aviso_confirmacao #agendamento_id').val(), '_blank');
        });

        return false;
    });

    $('#top-search').typeahead({
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
            window.location.href = "/historico_cliente/" + map[item];
            return item;
        },
        minLength: 2
    });

    $('#modal_nao_perturbe #nao_perturbe_10m').on('click', function () {inverterStadoOcupado(10)});
    $('#modal_nao_perturbe #nao_perturbe_20m').on('click', function () {inverterStadoOcupado(20)});
    $('#modal_nao_perturbe #nao_perturbe_30m').on('click', function () {inverterStadoOcupado(30)});
});

function inverterStadoOcupado(tempo) {
    $.ajax({
        url: '/users/inverter_status_ocupado',
        data: {'tempo': tempo},
        success: function(data) {
            $('#modal_nao_perturbe').modal('hide');
            if (data["ocupado"])
                exibirMsg("Modo não perturbe ativado por "+ tempo + "minutos");
        }
        //error: exibirErro("Não foi possível ativar o modo não perturbe")
    })
    window.location.reload();
}
function setarData(minutes, field) {
    var data = addMinutes(new Date(), minutes)
    field.val(moment(data).format("DD/MM/YYYY HH:mm"));
}

function verificarAtendimentoEmAndamento(){
    var teste = window.location.href
    if(teste.includes("/ligacoes/ligacao") || teste.includes("/agenda"))
        return false;

    $.getJSON('/ligacoes/user_em_atendimento', function(data) {
        if(data == null)
            return false;

        window.location.href = "/ligacoes/ligacao?obrigacao=true" + "&cliente_retorno_id=" + data['id'];
    });
}

function SomenteNumero(e){
    var tecla=(window.event)?event.keyCode:e.which;
    if((tecla>47 && tecla<58)) return true;
    else{
        if (tecla==8 || tecla==0) return true;
        else  return false;
    }
}

function apenasNumerosGeral(string){
    var numsStr = string.replace(/[^0-9]/g,'');
    if(numsStr.substring(0,1) == '0')
        numsStr = numsStr.substring(1);

    return parseInt(numsStr);
}


function apenasNumeros(string){
    var numsStr = string.replace(/[^0-9]/g,'');
    if(numsStr.substring(0,1) == '0')
        numsStr = numsStr.substring(1);

    // if(numsStr.length < 11)
    //     numsStr = numsStr.substring(0,2) + '9' + numsStr.substring(2);

    return parseInt(numsStr);
}

function mascaraValor(valor) {
    if(valor == null || valor == '') {
        return '';
    }
    var isNegativo = valor < 0

    valor = valor.toString().replace(/\D/g,"");
    valor = valor.toString().replace(/(\d)(\d{8})$/,"$1.$2");
    valor = valor.toString().replace(/(\d)(\d{5})$/,"$1.$2");
    valor = valor.toString().replace(/(\d)(\d{2})$/,"$1,$2");
    if(isNegativo)
        return 'R$-' + valor
    return 'R$' + valor
}

function humanBoolean(value) {
    return value == 't' || value == 'true' || value == true ? "Sim" : "Não";
}

function addDays(date, days) {
    var result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
}

function addMinutes(date, minutes) {
    var result = new Date(date);
    result.setMinutes(result.getMinutes() + minutes);
    return result;
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

function exibirWarning(msg){
    toastr.options = {
        closeButton: true,
        showMethod: 'slideDown'
    };
    toastr.warning(msg);
}

function setWhatsNegocicao() {
    var checkBox = document.getElementById('whatsapp-retorno-obrigatorio');

    $.getJSON("/negociacoes/set_canal_atendimento?negociacao_id=" + $('#retorno_obrigatorio_negociacao_id').val() +'&tipo=1&valor=' + checkBox.checked, function (data) {
    });
}

function setTelefonePrefNegocicao() {
    var checkBox = document.getElementById('telefonePref-retorno-obrigatorio');

    $.getJSON("/negociacoes/set_canal_atendimento?negociacao_id=" + $('#retorno_obrigatorio_negociacao_id').val() +'&tipo=2&valor=' + checkBox.checked, function (data) {
    });
}

function verificarRetorno() {
    $.getJSON('/agendamento_retornos/proximo_retorno_usuario', function(data) {
        if(data == null || data['ocupado'] == true)
            return false;
        
        $('#modal_retorno #retorno_obrigatorio_painelRetorno').show();
        $('#modal_retorno #retorno_obrigatorio_painelReagendar').hide();
        $('#modal_retorno #retorno_obrigatorio_retorno_id').val(data['retorno_id']);
        $('#modal_retorno #retorno_obrigatorio_retorno_cliente').val(data['razao_social']);
        $('#modal_retorno #retorno_obrigatorio_reagendar_cliente_id').val(data['cliente_id']);
        $('#modal_retorno #retorno_obrigatorio_retorno_empresa').val(data['empresa']);
        $('#modal_retorno #retorno_obrigatorio_retorno_empresa_id').val(data['empresa_id']);
        $( "#modal_retorno #whatsapp-retorno-obrigatorio" ).prop( "checked", data['atendimento_whatsapp'] == 't' );
        $( "#modal_retorno #telefonePref-retorno-obrigatorio" ).prop( "checked", data['atendimento_telefone'] == 't' );
        $('#modal_retorno #retorno_obrigatorio_tipo').val(data['tipo']);
        $('#modal_retorno #retorno_obrigatorio_tipo_retorno').val(data['descricao']);
        $('#modal_retorno #retorno_obrigatorio_telefone').val(data['telefone']);
        $('#modal_retorno #retorno_obrigatorio_retorno_reagendar_cliente').val(data['razao_social']);
        $('#modal_retorno #retorno_obrigatorio_retorno_data').val(data['retorno'] == null ? 'Sem retorno agendado' : moment(data['retorno']).format('DD/MM/YYYY HH:mm'));
        $('#modal_retorno #retorno_obrigatorio_retorno_observacao').val(data['observacao']);
        $('#modal_retorno #retorno_obrigatorio_retorno_reagendar').val('');
        $('#modal_retorno #retorno_obrigatorio_retorno_reagendar_motivo').val('');

        if(data['retorno'] == null)
            $('#modal_retorno #retorno_obrigatorio_btnEfetuarRetorno').hide();
        else $('#modal_retorno #retorno_obrigatorio_btnEfetuarRetorno').show();
        $('#modal_retorno #retorno_obrigatorio_btnSalvarReagendamento').hide();
        $('#modal_retorno #retorno_obrigatorio_btnReagendar').show();

        
        var array = ['7', '1', '28'];
        if(jQuery.inArray( data['status_id'], array) != -1)
            $('#modal_retorno #negociadorGroup').show();
        else 
            $('#modal_retorno #negociadorGroup').hide();

        if(data['tipo'] == 'NEGOCIACAO'){
            $.ajax({
                url: '/negociacoes/activities',
                data: {id: data['id'], ligacao: 123},
                type: 'GET',
                success: function (data) {
                    $("#modal_content_activities_retorno").html(data);
                },error: function(data){
                    exibirErro(data);
                }
            });
            $("#body_retorno_table_ligacoes tr").remove();
            $.getJSON('/ligacoes?q[cliente_id_eq]=' + data['cliente_id'], function(data) {
                $.each(data, function(k, v) {
                    addRowLigacoesRetorno(v);
                });
            });
            $('#tabRetornoObrigatorio2').show();
            $('#tabRetornoObrigatorio3').text('Histórico negociação')
            $('#modal_retorno #retorno_obrigatorio_negociacao_id').val(data['id']);
            $('#modal_retorno #retorno_obrigatorio_btnAdiar').hide();
            $.getJSON('/ligacoes/user_em_atendimento', function(data) {
                if(data == null)
                    return false;
                $('#modal_retorno #retorno_obrigatorio_btnAdiar').show();
                $('#modal_retorno #retorno_obrigatorio_btnEfetuarRetorno').hide();
            });

        }else if(data['tipo'] == 'IMPLANTACAO'){
            $.ajax({
                url: '/implantacoes/activities',
                data: {id: data['id'], ligacao: 123},
                type: 'GET',
                success: function (data) {
                    $("#modal_content_activities_retorno").html(data);
                },error: function(data){
                    exibirErro(data);
                }
            });
            $('#tabRetornoObrigatorio2').hide();
            $('#tabRetornoObrigatorio3').text('Histórico implantações')
            $('#modal_retorno #retorno_obrigatorio_implantacao_id').val(data['id']);
            $('#modal_retorno #retorno_obrigatorio_btnAdiar').hide();
            var teste = window.location.href
            if(teste.includes("/implantacoes/")){
                $('#modal_retorno #retorno_obrigatorio_btnAdiar').show();
            }
        }else{
            $.ajax({
                url: '/acompanhamentos/activities',
                data: {id: data['id'], ligacao: 123},
                type: 'GET',
                success: function (data) {
                    $("#modal_content_activities_retorno").html(data);
                },error: function(data){
                    exibirErro(data);
                }
            });
            $('#tabRetornoObrigatorio2').hide();
            $('#tabRetornoObrigatorio3').text('Histórico acompanhamentos')
            $('#modal_retorno #retorno_obrigatorio_acompanhamento_id').val(data['id']);
            $('#modal_retorno #retorno_obrigatorio_btnAdiar').hide();
            var teste = window.location.href
            if(teste.includes("/acompanhamentos/")){
                $('#modal_retorno #retorno_obrigatorio_btnAdiar').show();
            }
        }
        
        $('#modal_retorno').modal('show');
    });

}

function verificarNaoPerturbe() {
    $.getJSON('/nao_perturbe_retornos/fim_nao_perturbe', function(data) {
        if(data == 1)
            exibirMsg("Modo não perturbe desativado");
        return true;
    });
}
function addRowLigacoesRetorno(data){
    var newRow = $("<tr>");
    var cols = "";
    cols += '<td>' + data['data_inicio_formatada'] + '</td>';
    cols += '<td>' + data['usuario'] + '</td>';
    cols += '<td>' + ( data['status_ligacao'] != null ? data['status_ligacao'] : "")  + '</td>';
    cols += '<td>' + ( data['status_cliente'] != null ? data['status_cliente'] : "") + '</td>';
    cols += '<td>' + ( data['observacao'] != null ? data['observacao'] : "") + '</td>';

    newRow.append(cols);
    $("#body_retorno_table_ligacoes").append(newRow);
}

function verificarAgendamentoNaoConfirmado(data_inicial, data_final, periodo) {
    var teste = window.location.href
    if(teste.includes("/agenda"))
        return false;

    createInterval(data_inicial, addMinutes(data_inicial, 20), data_final, periodo);
}

function createInterval(dataMenor, dataMaior, dataFinal, periodo) {
    var interval = setInterval(function () {
        //console.log(new Date() > dataFinal)
        if(new Date() > dataFinal) {
            clearInterval(interval);
        }else if(new Date() > dataMenor) {
            if( $('#modal_aviso_confirmacao').is(':visible') ) {
                //console.log('Tem modal aberto...')
            } else {
                buscarAgendamentoNaoConfirmado(interval, dataMenor, dataMaior, dataFinal, periodo);
            }
         }else{ //console.log('Esperando...')
            }
    }, 3000);
}

function buscarAgendamentoNaoConfirmado(interval, dataMenor, dataMaior, dataFinal, periodo) {
    $.getJSON('/agendamentos/agendamento_nao_confirmado?periodo=' + periodo +
                '&data_comentario=' + dataMenor, function(data) {
        if (data == null || data.length < 1){
            clearInterval(interval);
            createInterval(dataMaior, addMinutes(dataMaior, 20), dataFinal, periodo);
            return false;
        }
        $('#modal_aviso_confirmacao #agendamento_id').val(data['id']);
        $('#modal_aviso_confirmacao #agendamento_cliente').val(data['razao_social']);
        $('#modal_aviso_confirmacao #agendamento_data_inicio').val(data['data']);
        $('#modal_aviso_confirmacao #agendamento_user').val(data['name']);
        $('#modal_aviso_confirmacao').modal('show');
    });
}

function formatarData(data) {
    if(data != null && data != '')
        return moment(data).format('DD/MM/YYYY HH:mm:SS')
    return '';
}

function preencherPerguntas(value) {
    $.each(value, function (k, perg) {
        var id = perg['id'];
        if(perg['pergunta_gatilho'] == null){

            if(perg['tipo'] == 'CONFIRMACAO'){
                $('#perguntas').append('<div class="form-group" id="form_' + id + '"><div class="field" id="pergunta_div_' + id + '"><label>' + perg['pergunta'] + '</label>' +
                    '<select class="form-control input-sm chosen-select" name="pergunta_'+id+'" id="pergunta_' + id + '"><option value="true">Sim</option><option value="false" selected>Não</option></select></div></div>');

                $('.chosen-select').chosen({width: "100%"});

                $("#pergunta_" + id).on('change', function () {
                    $.ajax({
                        url: '/perguntas/perguntas_fechamento_condicional?pergunta_id= ' + perg['id'],
                        async: false,
                        success: function(data) {
                            $.each(data, function (key, perg) {
                                if($("#pergunta_" + id).val() == 'true'){
                                    if(perg['tipo'] == 'NORMAL'){
                                        $('#form_' + id).append('<div class="form-group" id="form_' + perg['id'] + '"><div class="field" id="pergunta_div_' + perg['id'] + '"><label>' + perg['pergunta'] + '</label>' +
                                            '<textarea class="form-control" type="text" name="pergunta_' +  perg['id'] + '" id="pergunta_' +  perg['id'] + '"></textarea></div></div>');

                                    }else{
                                        $('#form_' + id).append('<div class="form-group" id="form_' + perg['id'] + '"><div class="field" id="pergunta_div_' + perg['id'] + '"><label>' + perg['pergunta'] + '</label>' +
                                            '<textarea  name="pergunta_' +  perg['id'] + '" id="pergunta_' +  perg['id'] + '"></textarea></div></div>');

                                        $("#pergunta_" + perg['id'])
                                            .tagify();
                                    }
                                }else{
                                    $('#form_' + perg['id']).remove();
                                }
                            });

                        }
                    });
                });
            }else if(perg['tipo'] == 'TAGS') {
                $('#perguntas').append('<div class="form-group" id="form_' + id + '"><div class="field" id="pergunta_div_' + id + '"><label>' + perg['pergunta'] + '</label>' +
                    '<textarea name="pergunta_' + id + '" id="pergunta_' +  id + '"></textarea></div></div>');

                $("#pergunta_" + id)
                    .tagify({
                        whitelist : TAGS
                    });
            }else if(perg['tipo'] == 'NOTA') {
                $('#perguntas').append('<div class="form-group" id="form_' + id + '"><div class="field" id="pergunta_div_' + id + '">' +
                    '<label>' + perg['pergunta'] + '</label>' +
                    '<input class="touchspin3" id="pergunta_' + id + '" name="pergunta_' +  perg['id'] + '" type="text" value=""></div></div>');

                $("#pergunta_" + id).TouchSpin({
                    buttondown_class: 'btn btn-white',
                    buttonup_class: 'btn btn-white',
                    min: 0,
                    max: 10,
                    step: 1,
                    booster: true
                });
            }else{
                $('#perguntas').append('<div class="form-group" id="form_' + id + '"><div class="field" id="pergunta_div_' + id + '"><label>' + perg['pergunta'] + '</label>' +
                    '<textarea class="form-control" type="text" name="pergunta_' + id + '" id="pergunta_' + id + '"></textarea></div></div>');
            }
        }
    });
}

function AtivarNaoPerturbe() {
    $('#modal_retorno').modal('hide'); 

    $('#modal_nao_perturbe').modal('show');

    return false;
}

function remover_anexo(id)
{
    $.ajax({
        type: "GET",
        url: "/upload/remove_file",
        data: {
        id: id
        },
        success: function(result) {
            $('#anexo-' + id).remove();
            exibirMsg("Anexo removido com sucesso");
        }
    });
}

function formatarValorMonetario(value){
    return parseFloat(value).toLocaleString('pt-br',{style: 'currency', currency: 'BRL'})
}