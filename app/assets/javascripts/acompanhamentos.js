//= require mask_plugin/jquery.mask.js
//= require validate/jquery.validate.min.js
//= require jquery-ui/jquery-ui.min.js
//= require sweetalert/sweetalert2.all.js
//= require datapicker/bootstrap-datepicker.js
//= require fullcalendar/fullcalendar.min.js
//= require fullcalendar/fullcalendar-rightclick.js
//= require qtip/jquery.qtip.min.js
//= require typehead/bootstrap3-typeahead.min.js
//= require tagify/jQuery.tagify.min.js

var TAGS;
$(document).ready(function(){

    $.getJSON('/perguntas/get_tags', function(data) {
        TAGS = data;
    });

    Ladda.bind('.ladda-button', { timeout: 3000 } );

    buscar_perguntas();

    $('#modal_comentario #retorno_data_retorno').datetimepicker({
        format: 'dd/mm/yyyy hh:ii',
        language: 'pt-BR',
        autoclose: true,
        todayBtn: true,
        pickerPosition: "bottom-left"
    });

    $('#btnSubmitPausar').click(function (event) {
        if(moment($('#pausar_acompanhamento_form #data_retorno').val(),"DD/MM/YYYY HH:mm") > moment().add(2, 'days')){
            $('#modal_pausar_acompanhamento').modal('toggle');
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
                    $('#pausar_acompanhamento_form').submit();
                    return false;
                }else{
                    exibirErro('Processo cancelado.')
                    return false;
                }
            });
        }else{
            $('#pausar_acompanhamento_form').submit();
        }

        return false;
    });

    $("#acompanhamento_observacoes").blur(function(){ alterarAcompanhamento(); });

    $('#btnNovoContato').on('click', function () {
        $('#novo_contato_cliente').val($('#cliente_razao_social').val());
        $('#novo_contato_cliente_id').val($('#cliente_id').val())
        $('#adicionar_contato').modal('show');
    });

    $('#btnSalvarComentario').on('click', function(){
        if($('#modal_comentario_acompanhamento #text_comentario').val() == ''){
            $('#error_comentario').show();
            return false;
        }
        $('#error_comentario').hide();

        if(!usuarioAdmin && $('#retorno_data_retorno').val() == '' && !moment($('#retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()) {
            exibirErro('Informe uma data de retorno válida!');
            return false;
        }

        if(!moment($('#retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()){
            salvarComentario();
        }else {
            $.getJSON('/agendamento_retornos/verificar_horario_acompanhamento?data_retorno='+ $('#retorno_data_retorno').val(), function(data) {
                if(parseInt(data) > 0){
                    exibirWarning('Já existe um retorno agendado para o mesmo horário!');
                    return false;
                }else{
                    if(moment($('#retorno_data_retorno').val(),"DD/MM/YYYY HH:mm") > moment().add(2, 'days')){
                        $('#modal_comentario_acompanhamento').modal('toggle');
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
                                salvarComentario();
                            }else{
                                exibirWarning('Comentário não cadastrado!');
                            }
                        });
                    }else{
                        salvarComentario();
                    }
                }
            });
        }

        return false;
    });

    $('#agenda_user').typeahead({
        source: function (query, process) {
            return $.ajax({
                url: '/users/find_usuarios_agenda/',
                dataType: "json",
                data: {
                    term: query
                },
                success: function(data) {
                    var options = [];
                    map = {}; //replace any existing map attr with an empty object
                    $.each(data,function (i,val){
                        options.push(val.name);
                        map[val.name] = val.id; //keep reference from name -> id
                    });
                    return process(options);
                }
            });
        },
        updater: function (item) {
            $('#agenda_user_id').val(map[item]);
            return item;
        },
        minLength: 2
    });

    $("#agenda_user").focusout(function(){
        var user = $('#agenda_user_id').val();
        if(!user || user == ''){
            $('#agenda_user_id').val('');
        }
    });

    $('#btnSubmitFinalizarAcompanhamento').click(function (event) {
        var bool = false;
        $('#perguntas').find('textarea').each(function (key, value) {
            if($(value).val() == '' || $(value).val().length < 10){
                bool = true;
            }
        });

        if(bool){
            exibirErro('É obrigatório responder todas as perguntas com no minímo 10 caracteres.');
            return false;
        }

        form = new FormData();
        form.append('cliente_id', $('#cliente_id').val());
        form.append('tipo', 3);
        loop1:
            $('#perguntas').find('.form-group').each(function (key, value) {
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
            });

        $.ajax({
            url: '/perguntas/registrar_respostas_cliente',
            data: form,
            dataType: 'json',
            processData: false,
            contentType: false,
            type: 'POST',
            success: function(data) {
            },
            error: function(data) {
                exibirErro(data);
            }
        });

        $('#btnSubmitFinalizarAcompanhamento').submit();
    });
    $('#btnSalvarAgendamento').on('click', function(){ finalizarAgenda();})
});

function alterarAcompanhamento() {
    $.ajax({
        url: '/acompanhamentos/' + $('#acompanhamento_id').val(),
        data: getFormAcompanhamento(),
        processData: false,
        contentType: false,
        type: 'PUT',
        success: function (data) {
        },error: function(data){
            exibirErro('Ocorreu um erro.' + data);
        }
    });
}

function getFormAcompanhamento() {
    form = new FormData();
    form.append('acompanhamento[observacao]', $('#acompanhamento_observacoes').val());
    return form;
}

function alterarProposta(funcao, ativa) {
    $.ajax({
        url: '/propostas/',
        data: getFormProposta(funcao, ativa),
        processData: false,
        contentType: false,
        type: 'POST',
        success: function (data) {
            atualizarPropostas(data['cliente_id']);

            limparModalProposta();

            if(funcao == 'cadastro')
                $('#proposta').modal('toggle');
            exibirMsg('Proposta registrada.');
        },error: function(data){
            exibirErro(data);
        }
    });
}

function atualizarPropostas(data){
    $("#body_table_proposta tr").remove();

    $.getJSON('/propostas/find_propostas?cliente_id='+ data, function(data) {
        $.each(data, function( key, value ) {
            var newRow = gerarRowProposta(value);
            $("#table-proposta").append(newRow);
        });
    });
}
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
    $('#modal_comentario_acompanhamento #retorno_data_retorno').mask('00/00/0000 00:00');
    $("#modal_comentario_acompanhamento #comentario_data_retorno").show();
    $('#modal_comentario_acompanhamento').modal('show');
}

function salvarComentario() {
    $.ajax({
        url: '/comentarios/',
        data: getFormComentario(),
        processData: false,
        contentType: false,
        type: 'POST',
        success: function (data) {
            window.location.href = "/acompanhamentos/" + $('#acompanhamento_id').val();
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}

function getFormComentario(){
    form = new FormData();
    form.append('comentario[comentario]', $("#modal_comentario_acompanhamento #text_comentario").val());
    form.append('comentario[acompanhamento_id]', $("#acompanhamento_id").val());
    if(moment($('#retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()){
        form.append('data_retorno', $('#modal_comentario_acompanhamento #retorno_data_retorno').val());
    }
    form.append('usuario_id', $('#modal_comentario_acompanhamento #comentario_usuario_id').val());

    return form;
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
                    window.location.href = "/acompanhamentos/" + $('#acompanhamento_id').val();
                },error: function(data){
                    exibirErro('Ocorreu um erro.');
                }
            });
            return false;
        }
    });
}

function chamarApiWhats(telefone) {
    if(telefone == '')
        return false;
    window.open('https://api.whatsapp.com/send?phone=55' + apenasNumeros(telefone), '_blank');
}

function buscar_perguntas() {
    $.getJSON('/perguntas/perguntas_acompanhamento', function (value) {
        preencherPerguntas(value);
    });
}

function setDadosModalAgenda(){
    $('#agenda_cliente_id').val($('#cliente_id').val());
    $('#agenda_cliente').val($('#cliente_razao_social').val());

    $.getJSON("/clientes/find_cliente_id?id=" + $('#cliente_id').val(), function(data) {
        $('#agenda_responsavel').val(data['contatos'][0]? data['contatos'][0]['nome'] : '');
        $('#agenda_responsavel2').val(data['contatos'][1]? data['contatos'][1]['nome'] : '');
        $('#agenda_telefone').val(data['telefone']);
        $('#agenda_telefone2').val(data['telefone2']);
        if (data['telefone_preferencial'] == true)
            $('input[id="telefone_preferencial1"]').prop('checked', true);
        if (data['telefone2_preferencial'] == true)
            $('input[id="telefone_preferencial2"]').prop('checked', true);
        if (data['telefone_enviado_whats'] == true)
            $('input[id="telefone_whats1"]').prop('checked', true);
        if (data['telefone2_enviado_whats'] == true)
            $('input[id="telefone_whats2"]').prop('checked', true);
    });

}

function abrirModalAgenda(local) {
    setDadosModalAgenda();
    $('#local').val(local);

    $('#agenda').modal('show');

    $('#calendar').fullCalendar({
        header: {
            left: 'prev,next, today',
            right: 'agendaDay agendaThreeDay'
        },
        views: {
            agendaThreeDay: {
                type: 'agenda',
                duration: { days: 3 },
            }
        },
        defaultView:'agendaThreeDay',
        timezone:'local',
        height: 400,
        defaultDate: Date(),
        scrollTime :  new Date().getTime() - 3600000,
        eventLimit: true, // allow "more" link when too many events
        allDaySlot: false,
        minTime: "07:00:00",
        maxTime: "19:30:00",
        nowIndicator: true,
        selectable: true,
        selectHelper: true,
        select: function(start, end){
            $('#agenda_data_inicio').text(moment(start).format("DD/MM/YYYY HH:mm"));
            $('#agenda_data_inicio').val(moment(start).format("DD/MM/YYYY HH:mm"));
            $('#agenda_data_fim').text(moment(end).format("DD/MM/YYYY HH:mm"));
            $('#agenda_data_fim').val(moment(end).format("DD/MM/YYYY HH:mm"));
            $('#agenda_user').focus()
        },
        events: function(start, end, timezone, callback) {
            $.getJSON('/agendamentos/get_agenda?start=' + start.unix() + "&end=" + end.unix()+ "&status=true", function(data) {
                var events = [];
                $.each(data,function (i,agendamento){
                    events.push({
                        id: agendamento['id'],
                        title: agendamento['tipo_agendamento'] + '\n' + agendamento['cliente_razao_social'],
                        start: moment(agendamento['data_inicio']),
                        end: moment(agendamento['data_fim']),
                        obs: agendamento['observacao'],
                        backgroundColor : agendamento['color'],
                        borderColor: agendamento['color'],
                        user_id: agendamento['user_id'],
                        user: agendamento['user_name'],
                        tipo_id: agendamento['tipo_agendamento_id'],
                        tipo: agendamento['tipo_agendamento'],
                        cliente: agendamento['cliente_razao_social'],
                        cliente_id: agendamento['cliente_id'],
                        empresa: agendamento['empresa'],
                        solicitante: agendamento['user_registro'],
                        telefone: agendamento['telefone'],
                        responsavel: agendamento['responsavel'],
                        telefone2: agendamento['telefone2'],
                        resposavel2: agendamento['responsavel2'],
                        implantacao_id: agendamento['implantacao_id'],
                        sistema: agendamento['sistema'],
                        vendedor: agendamento['vendedor'],
                        tipo_fechamento: agendamento['tipo_fechamento']
                    });
                });
                callback(events);
            });
        },
        eventRender: function eventRender( event, element, view ) {
            var content = '<h3>'+event.cliente+'</h3>' +
                '<p><b>Tipo:</b> '+event.tipo+'<br />' +
                '<p><b>Atendente:</b> '+event.user+'</p>';
            if(event.sistema != null)
                content = content + '<p><b>Sistema:</b> '+event.sistema+'</p>';
            if(event.vendedor != null)
                content = content + '<p><b>Vendedor:</b> '+event.vendedor+'</p>';
            element.qtip({
                content: {
                    text: content
                },
                position: {
                    my: 'bottom center',
                    at: 'top center',
                    viewport: $('#fullcalendar'),
                    adjust: {
                        mouse: false,
                        scroll: false
                    }
                },
                style: 'qtip-light',
                show: { solo: true },
                hide: {
                    delay: 10
                }
            });

            if(event.end.add(2, 'hours') < moment()){
                var css = $(element).css('background-color');
                if(css != '') {
                    css = css.substring(4, css.length - 1);
                    var array = css.split(',')
                    var color1 = parseInt(array[0].trim());
                    color1 = Math.round((color1 + 255)/2);

                    var color2 = parseInt(array[1].trim());
                    color2 = Math.round((color2 + 255)/2);

                    var color3 = parseInt(array[2].trim());
                    color3 = Math.round((color3 + 255)/2);

                    $(element).css('background-color', 'rgb(' + color1 + ', ' + color2 + ', ' + color3 + ')');
                    var css = $(element).css('background-color');
                }
            }
        },
    });
}

function finalizarAgenda() {
    $('body').lmask('show');
    var validate = validarAgenda();
    if(validate != null) {
        exibirErro(validate);
        $('body').lmask('hide');
        return;
    }

    $.ajax({
        url: '/agendamentos/salvar/',
        data: getFormAgendamento(),
        processData: false,
        contentType: false,
        type: 'POST',
        success: function (data) {
            if ($('#local').val() == 'fechamento'){
                salvarPerguntasCliente();
                finalizarLigacaoJson();
            }else{
                $('#agenda').modal('hide');
                exibirMsg('Agendamento realizado com sucesso.');
                $('body').lmask('hide');
            }
        },error: function(data){
            if(data['responseJSON'] == 'CONFLITO_HORARIO'){
                exibirErro('Horário do agendamento em conflito com outro agendamento do atendente.');
            }else if(data['responseJSON'] == 'HORARIO_INICIO_MAIOR') {
                exibirErro('Horário de início não pode ser maior que data final.');
            }else if(data['responseJSON'] != null){
                exibirErro(data['responseJSON']);
            }else{
                exibirErro('Ocorreu algum erro.');
            }
            $('body').lmask('hide');
        }
    });
    return false;
}

function validarAgenda(){
    if(($("#agenda_data_inicio").val() == null || $("#agenda_data_inicio").val() == ''))
        return "É obrigatório informar data de início do agendamento."
    if(($("#agenda_data_fim").val() == null || $("#agenda_data_fim").val() == ''))
        return "É obrigatório informar data final do agendamento."
    if(($("#agenda_tipo_agendamento_id").val() == null || $("#agenda_tipo_agendamento_id").val() == ''))
        return "É obrigatório informar tipo do agendamento."
    if(($("#agenda_telefone").val() == null || $("#agenda_telefone").val() == ''))
        return "É obrigatório informar um telefone do agendamento."
    if(($("#agenda_responsavel").val() == null || $("#agenda_responsavel").val() == ''))
        return "É obrigatório informar responsavel pela empresa do agendamento."
    checkBox = document.getElementById('telefone_preferencial1');
    checkBox2 = document.getElementById('telefone_preferencial2');
    if(!checkBox.checked && !checkBox.checked)
        return "É obrigatório informar um telefone como favorito."

    return null;
}

function getFormAgendamento(){
    form = new FormData();
    form.append('data_inicio', $("#agenda_data_inicio").val());
    form.append('data_fim', $("#agenda_data_fim").val());
    form.append('observacao', $("#agenda_observacao").val());
    form.append('user_id', $("#agenda_user_id").val());
    form.append('cliente_id', $("#agenda_cliente_id").val());
    form.append('tipo_agendamento_id', $("#agenda_tipo_agendamento_id").val());
    form.append('telefone', $("#agenda_telefone").val());
    checkBox = document.getElementById('telefone_preferencial1');
    form.append('telefone_preferencial',checkBox.checked);        
    form.append('contato', $("#agenda_responsavel").val());
    form.append('telefone2', $("#agenda_telefone2").val());
    checkBox = document.getElementById('telefone_preferencial2');
    form.append('telefone_preferencial2',checkBox.checked);
    form.append('contato2', $("#agenda_responsavel2").val());
    checkBox = document.getElementById('telefone_whats1');
    form.append('telefone_whats',checkBox.checked);
    checkBox = document.getElementById('telefone_whats2');
    form.append('telefone_whats2',checkBox.checked);
    form.append('implantacao', ($('#local').val() == 'fechamento'? true : false));
    return form;
}

function GerarContratoEmpresa(id){
    window.open('/contratos/emitir_contrato?id=' + id + '&local=acompanhamento', '_blank');
}