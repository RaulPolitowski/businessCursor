//= require fullcalendar/fullcalendar.min.js
//= require fullcalendar/fullcalendar-rightclick.js
//= require datapicker/bootstrap-datepicker.js
//= require qtip/jquery.qtip.min.js
//= require typehead/bootstrap3-typeahead.min.js
//= require sweetalert/sweetalert2.all.js
//= require tagify/jQuery.tagify.min.js

var TAGS;
$(document).ready(function(){

    $.getJSON('/perguntas/get_tags', function(data) {
        TAGS = data;
    });

    $('#btnSalvarAgendamento').on('click', function(){ finalizarAgenda(); })

    $("#implantacao_observacoes").blur(function(){ alterarImplantacao(); });

    $('#btnNovoContato').on('click', function () {
        $('#novo_contato_cliente').val($('#cliente_razao_social').val());
        $('#novo_contato_cliente_id').val($('#cliente_id').val())
        $('#adicionar_contato').modal('show');
    });

    $('#btnChamarAgenda').on('click', function(){
        if($('#modal_motivo #text_motivo').val() == ''){
            $('#modal_motivo #error_motivo').show();
            return false;
        }
        $('#modal_motivo #error_motivo').hide();
        $('#modal_motivo').modal('toggle');
        chamarModalImplantacao();
        return false;
    });

    $('#btnAguardarTerceiros').on('click', function(){
        if($('#modal_motivo #text_motivo').val() == ''){
            $('#modal_motivo #error_motivo').show();
            return false;
        }
        $('#modal_motivo #error_motivo').hide();
        $('#modal_motivo').modal('toggle');

        agendarAguardarImplantacao(2);
        return false;
    });

    $('#btnSalvarComentario').on('click', function(){
        if($('#modal_comentario_implantacao #text_comentario').val() == ''){
            $('#error_comentario').show();
            return false;
        }
        $('#error_comentario').hide();

        if($('#retorno_data_retorno').val() != '' && !moment($('#retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()) {
            exibirErro('Informe uma data de retorno válida!');
            return false;
        }

        salvarComentario();
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

    $('#btnSubmitFinalizarImplantacao').click(function (event) {
        $('body').lmask('show');
        var bool = false;
        $('#perguntas').find('textarea').each(function (key, value) {
            if($(value).val() == '' || $(value).val().length < 10){
                bool = true;
            }
        });

        if(bool){
            exibirErro('É obrigatório responder todas as perguntas com no minímo 10 caracteres.');
            $('body').lmask('hide');
            return false;
        }

        form = new FormData();
        form.append('cliente_id', $('#cliente_id').val());
        form.append('tipo', 2);
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
                $('body').lmask('hide');
                exibirErro(data);
                return false;
            }
        });

        $('#btnSubmitFinalizarImplantacao').submit();
        $('body').lmask('hide');
    });

    buscar_perguntas();
});

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

function agendarAguardarImplantacao(status){
    $.ajax({
        url: '/implantacoes/'+ $('#implantacao_id').val() + '/reagendar_aguardar',
        data: getFormImplantacao(status),
        processData: false,
        contentType: false,
        type: 'PATCH',
        success: function (data) {
            window.location.href = "/implantacoes/" + $('#implantacao_id').val();
        }, error: function (data) {
            exibirErro('Ocorreu um erro.' + data);
        }
    });
}

function alterarImplantacao() {
    $.ajax({
        url: '/implantacoes/' + $('#implantacao_id').val(),
        data: getFormImplantacao(0),
        processData: false,
        contentType: false,
        type: 'PUT',
        success: function (data) {
        }, error: function (data) {
            exibirErro('Ocorreu um erro.' + data);
        }
    });
}

function getFormImplantacao(status) {
    form = new FormData();
    if(status == 1) {
        form.append('implantacao[status]', status);
        form.append('motivo', $('#modal_motivo #text_motivo').val())
    }
    if(status == 2) {
        form.append('implantacao[status]', status);
        form.append('motivo', $('#modal_motivo #text_motivo').val())
    }
    form.append('implantacao[observacao]', $('#implantacao_observacoes').val());
    return form;
}

function setDadosModalAgenda(){
    $('#agenda_cliente_id').val($('#cliente_id').val());
    $('#agenda_cliente').val($('#cliente_razao_social').val());

    $.getJSON('/clientes/' + $('#cliente_id').val(), function (data) {
        if($('#agenda_responsavel').val() == '' && data['contatos'][0] != null)
            $('#agenda #agenda_responsavel').val(data['contatos'][0]['nome']);
        else $('#agenda #agenda_responsavel').val($('#agenda_responsavel').val());

        if($('#agenda_telefone').val() == '' && data['telefone'] != null)
            $('#agenda #agenda_telefone').val(data['telefone']);
        else $('#agenda #agenda_telefone').val($('#agenda_telefone').val());

        if($('#agenda_responsavel2').val() ==  '' && data['contatos'][1] != null)
            $('#agenda #agenda_responsavel2').val(data['contatos'][1]['nome']);
        else $('#agenda #agenda_responsavel2').val($('#agenda_responsavel2').val());

        if($('#agenda_telefone2').val() == '' && data['telefone2'] != null)
            $('#agenda #agenda_telefone2').val(data['telefone2']);
        else $('#agenda #agenda_telefone2').val($('#agenda_telefone2').val());
    });

    $('#agenda #agenda_user').val($('#implantacao_responsavel').val());
    $('#agenda #agenda_user_id').val($('#implantacao_responsavel_id').val());
    $('#agenda #agenda_user').prop("readonly", true);
    $('#agenda #agenda_user_id').prop("readonly", true);
}

function reagendarImplantacao() {
    if ($('#implantacao_status').val() == 2 || $('#implantacao_status').val() > 3 || $('#agenda_id').val() == '')
        chamarModalImplantacao()
    else {
        $('#btnAguardarTerceiros').show();
        $('#btnChamarAgenda').show();
        $('#modal_motivo').modal('show');
    }
}

function chamarModalImplantacao() {
    setDadosModalAgenda();

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
            $('#agenda #agenda_data_inicio').text(moment(start).format("DD/MM/YYYY HH:mm"));
            $('#agenda #agenda_data_inicio').val(moment(start).format("DD/MM/YYYY HH:mm"));
            $('#agenda #agenda_data_fim').text(moment(end).format("DD/MM/YYYY HH:mm"));
            $('#agenda #agenda_data_fim').val(moment(end).format("DD/MM/YYYY HH:mm"));
            $('#agenda #agenda_user').focus()
        },
        events: function(start, end, timezone, callback) {
            $.getJSON('/agendamentos/get_agenda?start=' + start.unix() + "&end=" + end.unix() + "&status=0", function(data) {
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
    var validate = validarAgenda();
    if(validate != null) {
        exibirErro(validate);
        return;
    }

    $.ajax({
        url: '/agendamentos/salvar/',
        data: getFormAgendamento(),
        processData: false,
        contentType: false,
        type: 'POST',
        success: function (data) {
            if($('#implantacao_status').val() < 4 && $('#agenda_id').val() != '')
                agendarAguardarImplantacao(1);
            else window.location.href = "/implantacoes/" + $('#implantacao_id').val();
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
        }
    });

    return false;
}

function validarAgenda(){
    if(($("#agenda #agenda_data_inicio").val() == null || $("#agenda #agenda_data_inicio").val() == ''))
        return "É obrigatório informar data de início do agendamento."
    if(($("#agenda #agenda_data_fim").val() == null || $("#agenda #agenda_data_fim").val() == ''))
        return "É obrigatório informar data final do agendamento."
    if(($("#agenda #agenda_tipo_agendamento_id").val() == null || $("#agenda #agenda_tipo_agendamento_id").val() == ''))
        return "É obrigatório informar tipo do agendamento."
    if(($("#agenda #agenda_telefone").val() == null || $("#agenda #agenda_telefone").val() == ''))
        return "É obrigatório informar um telefone do agendamento."
    if(($("#agenda #agenda_responsavel").val() == null || $("#agenda #agenda_responsavel").val() == ''))
        return "É obrigatório informar responsavel pela empresa do agendamento."

    return null;
}


function getFormAgendamento(){
    form = new FormData();
    form.append('data_inicio', $("#agenda #agenda_data_inicio").val());
    form.append('data_fim', $("#agenda #agenda_data_fim").val());
    form.append('observacao', $("#agenda #agenda_observacao").val());
    form.append('user_id', $("#agenda #agenda_user_id").val());
    form.append('cliente_id', $("#agenda #agenda_cliente_id").val());
    form.append('tipo_agendamento_id', $("#agenda #agenda_tipo_agendamento_id").val());
    form.append('telefone', $("#agenda #agenda_telefone").val());
    form.append('contato', $("#agenda #agenda_responsavel").val());
    form.append('telefone2', $("#agenda #agenda_telefone2").val());
    form.append('contato2', $("#agenda #agenda_responsavel2").val());
    form.append('implantacao', false);
    form.append('implantacao_id', $('#implantacao_id').val());
    form.append('motivo', $('#text_motivo').val());

    return form;
}

function abrirModalComentario() {
    $('#modal_comentario_implantacao').modal('show');
}

function salvarComentario() {
    $.ajax({
        url: '/comentarios/',
        data: getFormComentario(),
        processData: false,
        contentType: false,
        type: 'POST',
        success: function (data) {
            window.location.href = "/implantacoes/" + $('#implantacao_id').val();
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}

function getFormComentario(){
    form = new FormData();
    form.append('comentario[comentario]', $("#modal_comentario_implantacao #text_comentario").val());
    form.append('comentario[implantacao_id]', $("#implantacao_id").val());
    if(moment($('#modal_comentario_implantacao #retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()){
        form.append('data_retorno', $('#modal_comentario_implantacao #retorno_data_retorno').val());
    }
    if($('#modal_comentario_implantacao #comentario_usuario_id').val() != null )
        form.append('usuario_id', $('#modal_comentario_implantacao #comentario_usuario_id').val());
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
                    window.location.href = "/implantacoes/" + $('#implantacao_id').val();
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
    $.getJSON('/perguntas/perguntas_implantacao', function (value) {
        preencherPerguntas(value);
    });
}
function setPref(id) {
    var checkBox;
    if(id == 'telefone') {
        checkBox = document.getElementById('telefone');
    }else if(id == 'telefone2'){
        checkBox = document.getElementById('telefone2');
    }else{
        checkBox = document.getElementById(id);
    }


    $.getJSON("/clientes/set_telefone_preferencial?id=" +id
        +'&preferencial=' + checkBox.checked + '&cliente_id=' + $('#cliente_id').val(), function (data) {
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

function setWhats(id) {
    var checkBox;
    if(id == 'telefone') {
        checkBox = document.getElementById('whatstelefone');
    }else if(id == 'telefone2'){
        checkBox = document.getElementById('whatstelefone2');
    }else{
        checkBox = document.getElementById('whats'+id);
    };

    $.getJSON("/clientes/set_telefone_whatsapp?id=" +id
        +'&enviado_whats=' + checkBox.checked + '&cliente_id=' + $('#cliente_id').val(), function (data) {
       
    });
}

function GerarContratoEmpresa(id){
    window.open('/contratos/emitir_contrato?id=' + id + '&local=implantacao', '_blank');
}
