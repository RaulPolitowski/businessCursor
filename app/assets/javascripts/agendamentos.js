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

$('#data_fim').mask('00/00/0000 00:00');
$('#data_inicio').mask('00/00/0000 00:00');

$('.chosen-select').chosen({width: "100%", allow_single_deselect: true});

$.validator.addMethod("date_end_bigger_date_start", function(value, element) {
    var data_inicio = moment($('#data_inicio').val(),"DD/MM/YYYY HH:mm");
    var data_fim = moment($('#data_fim').val(),"DD/MM/YYYY  HH:mm");
    if(data_fim.isValid() && data_inicio.isValid()){
        return data_fim > data_inicio
    }
    return true;
}, "Data fim deve ser maior que data inicial");

$.validator.addMethod("date_start_smaller_date_end", function(value, element) {
    var data_inicio = moment($('#data_inicio').val(),"DD/MM/YYYY HH:mm");
    var data_fim = moment($('#data_fim').val(),"DD/MM/YYYY  HH:mm");
    if(data_fim.isValid() && data_inicio.isValid()){
        return data_fim > data_inicio
    }
    return true;

}, "Data inicio deve ser menor que data fim");

jQuery.validator.addMethod("brazilianDate", function(value, element) {
    return moment(value,"DD/MM/YYYY  HH:mm").isValid()
}, "Data inválida");


$(document).ready(function () {

    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green'
    });

    $('#datetimepicker1').datetimepicker({
        format: 'dd/mm/yyyy hh:ii',
        language: 'pt-BR',
        autoclose: true,
        todayBtn: true,
        pickerPosition: "bottom-left"
    });
    $('#datetimepicker2').datetimepicker({
        format: 'dd/mm/yyyy hh:ii',
        language: 'pt-BR',
        autoclose: true,
        todayBtn: true,
        pickerPosition: "bottom-left"
    });

    $('#btnAtualizarAgenda').on('click', function () {
        $('#calendar').fullCalendar('rerenderEvents');
        return false;
    });

    $('#filtro_status').on('change', function () {
        $('#calendar').fullCalendar('refetchEvents');
    });

    $('#filtro_confirmado').on('change', function () {
        $('#calendar').fullCalendar('refetchEvents');
    });

    $("#somente_sem_tecnico").on("ifChanged", function() {
        $('#calendar').fullCalendar('refetchEvents')
    });

    if($('#agenda_index_id').val() != ""){
        $.getJSON('/agendamentos/' + $('#agenda_index_id').val(), function(data) {
            showAgendamento(data);
        });
        window.history.pushState({}, document.title, "/agenda");
    }

    if($('#cliente_index_id').val() != ""){

        $.getJSON('/agendamentos/find_agendamento_by_fechamento?cliente_id=' + $('#cliente_index_id').val(), function(data) {
            showAgendamento(data);
        }).fail(function(data) { exibirErro(data) });
        window.history.pushState({}, document.title, "/agenda");
    }

    $('#btnAbrirImplantacao').click(function () {
        window.location.href = '/implantacoes/' + $('#implantacao_id').val();
    });

    $('#btnAbrirLigacao').click(function () {
        window.location.href = '/ligacoes/ligacao?cliente_retorno_id=' + $('#cliente_id').val();
    });

    $('#btnExcluirEvento').click(function () {
        $('#agendamento').modal('toggle');
        /*if($('#form_agendamento #implantacao_id').val() != '')
            $('#modal_motivo #comentario_data_retorno').show();
        else $('#modal_motivo #comentario_data_retorno').hide();*/

        if ($('#form_agendamento #user_id').val() != '')
            $('#modal_motivo #usuario_id').val($('#form_agendamento #user_id').val()).trigger("chosen:updated");
        else if ($('#form_agendamento #fechamento_vendedor').val() == '')
            $('#modal_motivo #usuario_id').val($('#form_agendamento #negociador_id').val()).trigger("chosen:updated");
        
        $('#modal_motivo #comentario_data_retorno').show();
        $('#modal_motivo').modal('show');
    });

    $('#modal_motivo #btnFechar').on('click', function () {
        $('#modal_motivo').modal('toggle');
        $('#agendamento').modal('show');
    });

    $('#novo_comentario').click(function () {
        $("#modal_comentario_agendamento #novo_comentario_agendamento_id").val($('#form_agendamento #id').val())
        if($('#form_agendamento #implantacao_id').val() != '' || $('#form_agendamento #negociacao_id').val() != '')
            $('#modal_comentario_agendamento #comentario_data_retorno').show();
        else $('#modal_comentario_agendamento #comentario_data_retorno').hide();
        $('#modal_comentario_agendamento').modal('show');
        return false;
    });

    $('#modal_comentario_agendamento #btnSalvarComentario').on('click', function () {
        if($('#modal_comentario_agendamento #text_comentario').val() == ''){
            $('#modal_comentario_agendamento #error_comentario').show();
            return false;
        }
        $('#modal_comentario_agendamento #error_comentario').hide();
        if(($('#form_agendamento #implantacao_id').val() != null && $('#form_agendamento #implantacao_id').val() != "") || 
            ($('#form_agendamento #negociacao_id').val() != null && $('#form_agendamento #negociacao_id').val() != "")){
            if($('#retorno_data_retorno').val() != '' && !moment($('#retorno_data_retorno').val(),"DD/MM/YYYY HH:mm").isValid()) {
                exibirErro('Informe uma data de retorno válida!');
                return false;
            }

            salvarComentarioImplantacao($("#modal_comentario_agendamento #text_comentario").val(), $('#form_agendamento #implantacao_id').val(), $('#form_agendamento #negociacao_id').val(), $("#modal_comentario_agendamento #retorno_data_retorno").val(), $('#modal_comentario_agendamento #comentario_usuario_id').val());
        }else{
            salvarComentario($("#modal_comentario_agendamento #text_comentario").val(), $("#modal_comentario_agendamento #novo_comentario_agendamento_id").val());
        }

        $("#modal_comentario_agendamento #text_comentario").val('');
        $("#modal_comentario_agendamento").modal('toggle');
        buscarAtividades($("#modal_comentario_agendamento #novo_comentario_agendamento_id").val());
        return false;
    });

    $('#modal_motivo #btnCancelarAgenda').on('click', function () {
        if ($('#modal_motivo #retorno_data_retorno').val() == ''){
            exibirErro('Data de retorno deve ser informado.');
            return false
        }
        if($('#modal_motivo #text_motivo').val() == ''){
            $('#error_motivo').show();
        }else{
            $.ajax({
                url: '/agendamentos/' + $("#id").val(),
                data: { motivo: $('#modal_motivo #text_motivo').val(), retorno: $('#modal_motivo #retorno_data_retorno').val(), user_id: $('#modal_motivo #usuario_id').val()},
                type: 'DELETE',
                success: function (data) {
                    $('#calendar').fullCalendar('refetchEvents');
                    $('#modal_motivo').modal('toggle');
                    exibirMsg('Evento removido.');
                    return false;
                }, error: function () {
                    exibirErro('Ocorreu um erro ao remover evento.');
                    return false;
                }
            });
        }
        return false;
    });

    $('#filtro_cliente').typeahead({
        source: function (query, process) {
            return $.ajax({
                url: '/agendamentos/find_cliente_agenda/',
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
            $('#filtro_cliente_id').val(map[item]);
            return item;
        },
        minLength: 2
    });

    $("#filtro_cliente").focusout(function(){
        var user = $('#filtro_cliente').val();
        if(!user || user == ''){
            $('#filtro_cliente_id').val('all');
        }
    });


    $('#cliente').typeahead({
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
            //limparForm();
            $('#cliente_id').val(map[item]);
            $.getJSON('/clientes/' + map[item], function(data) {
                $('#cidade').val(data['cidade']['nome'] + '-' + data['cidade']['estado']['sigla'])
                $('#telefone').val(data['telefone']);
                $('#telefone2').val(data['telefone2']);
                if(data['telefone_preferencial']){
                    $('input[id="telefone_preferencial1"]').prop('checked', true);
                }
                if(data['telefone2_preferencial']){
                    $('input[id="telefone_preferencial2"]').prop('checked', true);
                }
                if(data['telefone_enviado_whats']){
                    $('input[id="telefone_whats1"]').prop('checked', true);
                }
                if(data['telefone2_enviado_whats']){
                    $('input[id="telefone_whats2"]').prop('checked', true);
                }
                if(data['contatos'].length > 0){
                    $('#responsavel').val(data['contatos'][0]['nome']);
                }
                if(data['contatos'].length > 1) {
                    $('#responsavel').val(data['contatos'][1]['nome']);
                }
            });
            return item;
        },
        minLength: 2
    });

    $("#cliente").focusout(function(){
        var cliente = $('#cliente').val();
        if(!cliente || cliente == ''){
            $('#cliente_id').val('');
        }
    });

    $('#form_agendamento').validate({
        rules: {
            'cliente': {
                required: true
            },
            'telefone': {
                required: true
            },
            'responsavel': {
                required: true
            },
            'tipo_agendamento_id':{
                required: true
            },
            'data_inicio': {
                required: true,
                brazilianDate : true,
                date_start_smaller_date_end: true
            },
            'data_fim': {
                required: true,
                brazilianDate : true,
                date_end_bigger_date_start: true
            }
            // },
            // 'telbox[]':{
            //     required: true,
            //     minlength: 1
            // }
        },
        submitHandler: function (form) {
            event.preventDefault()
            $("#form_agendamento").validate()
            var checkBox1;
            var checkBox2;
            checkBox1 = document.getElementById('telefone_preferencial1');
            
            checkBox2 = document.getElementById('telefone_preferencial2');
            

            console.log(checkBox1.checked)

            if(checkBox1.checked || checkBox2.checked){

            $.ajax({
                url: '/agendamentos/salvar/',
                data: getFormAgendamento(),
                processData: false,
                contentType: false,
                type: 'POST',
                success: function (data) {
                    $('#calendar').fullCalendar('refetchEvents');
                    $('#agendamento').modal('toggle');
                    if($('#form_agendamento #comentario').val() != ''){
                          salvarComentario($('#form_agendamento #comentario').val(), data['id']);
                    }
                    exibirMsg("Agenda salva com sucesso.");
                },error: function(data) {
                    if (data['responseJSON'] == 'CONFLITO_HORARIO') {
                        exibirErro('Horário do agendamento em conflito com outro agendamento do atendente.');
                    } else if (data['responseJSON'] != null) {
                        exibirErro(data['responseJSON']);
                    } else {
                        exibirErro('Ocorreu algum erro.');
                    }
                }
            });
            }else{
                exibirErro('Informe um telefone preferencial para salvar o agendamento');
            }
            return false;
        }
    });

    get_users_agenda();
    get_legenda();

    $('#btnNovoEvento').click(function () {
        limparForm();

        $('#agendamento').modal('show');
    });

    $('#btnReagendar').click(function () {
        $('#form_agendamento #data_inicio').val('');
        $('#form_agendamento #data_fim').val('');
        $('#form_agendamento #id').val('');
        $('#form_agendamento #infoEmpresa').hide();
        $('#form_agendamento #form_confirmacao').hide();
        $('#form_agendamento #confirmado_agendamento').val(false);
        $('#form_agendamento #btnReagendar').hide();
        $('#form_agendamento #btnSalvarReagendamento').show();
        $('#form_agendamento #btnSalvarAgendamento').hide();
        $('#form_agendamento #btnExcluirEvento').hide();
        $('#form_agendamento #form_comentario').show();
        $('#form_agendamento #comentario_label').text('Motivo');

        return false;
    });

    $('#btnSalvarReagendamento').click(function () {

        if($('#form_agendamento #comentario').val().length < 1){
            exibirErro('Informe um motivo.')
            return false;
        }

        if($('#form_agendamento').valid()){
            $.ajax({
                url: '/agendamentos/' + $('#form_agendamento #id_reagendado').val() + '/reagendar/',
                data: getFormAgendamento(),
                processData: false,
                contentType: false,
                type: 'POST',
                success: function (data) {
                    $('#calendar').fullCalendar('refetchEvents');
                    $('#agendamento').modal('toggle');
                    exibirMsg("Reagendado com sucesso.");
                },error: function(data){
                    if(data['responseJSON'] == 'CONFLITO_HORARIO'){
                        exibirErro('Horário do agendamento em conflito com outro agendamento do atendente.');
                    }else{
                        exibirErro('Ocorreu algum erro.');
                    }
                }
            });
        }

        return false;
    });

    $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        defaultView: 'agendaDay',
        timezone:'local',
        height: 730,
        defaultDate: Date(),
        navLinks: true, // can click day/week names to navigate views
        eventLimit: true, // allow "more" link when too many events
        allDaySlot: false,
        minTime: "07:00:00",
        maxTime: "23:30:00",
        selectable: true,
        selectHelper: true,
        select: function(start, end){
            limparForm();
            $('#form_agendamento #data_inicio').text(moment(start).format("DD/MM/YYYY HH:mm"));
            $('#form_agendamento #data_inicio').val(moment(start).format("DD/MM/YYYY HH:mm"));
            $('#form_agendamento #data_fim').text(moment(end).format("DD/MM/YYYY HH:mm"));
            $('#form_agendamento #data_fim').val(moment(end).format("DD/MM/YYYY HH:mm"));

            $('#agendamento').modal('show');
        },
        eventClick: function(calEvent, jsEvent, view) {
            $.getJSON('/agendamentos/' + calEvent.id, function(data) {
                showAgendamento(data);
            });
        },
        events: function(start, end, timezone, callback) {
            $.getJSON('/agendamentos/get_agenda?start=' + start.unix() + "&end=" + end.unix() + "&status=" + $('#filtro_status').val()
            + "&confirmacao=" + $('#filtro_confirmado').val() + "&sem_tecnico=" + $("#somente_sem_tecnico").is(':checked'), function(data) {
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
                        user_id: (agendamento['user_id'] == null ? null : agendamento['user_id'].toString()),
                        user: agendamento['user_name'],
                        tipo_id: (agendamento['tipo_agendamento_id'] == null ? null : agendamento['tipo_agendamento_id'].toString()),
                        tipo: agendamento['tipo_agendamento'],
                        cliente: agendamento['cliente_razao_social'],
                        cliente_id: (agendamento['cliente_id'] == null ? null : agendamento['cliente_id'].toString()),
                        empresa: agendamento['empresa'],
                        empresa_id: agendamento['empresa_id'].toString(),
                        solicitante: agendamento['user_registro'],
                        telefone: agendamento['telefone'],
                        responsavel: agendamento['responsavel'],
                        telefone2: agendamento['telefone2'],
                        resposavel2: agendamento['responsavel2'],
                        implantacao_id: agendamento['implantacao_id'],
                        sistema: agendamento['sistema'],
                        vendedor: agendamento['vendedor'],
                        vendedor_id: (agendamento['vendedor_id'] == null ? null : agendamento['vendedor_id'].toString()),
                        negociador_id: (agendamento['negociador_id'] == null ? null : agendamento['negociador_id']),
                        tipo_fechamento: agendamento['tipo_fechamento'],
                        data_fechamento: agendamento['data_fechamento'],
                        status: agendamento['ativo'],
                        motivo: agendamento['motivo'],
                        data_cancelamento: agendamento['data_cancelamento'],
                        user_cancelamento: agendamento['user_cancelamento'],
                        confirmado: agendamento['confirmado'],
                        usuario_confirmacao: agendamento['usuario_confirmacao'],
                        data_confirmacao: agendamento['data_confirmacao'],
                        cidade: agendamento['cidade']
                    });
                });
                callback(events);
            });
        },
        eventRender: function eventRender( event, element, view ) {
            var content = '<h3>'+event.cliente + '</h3>' +
                '<h5>' + event.cidade + '</h5>'
                '<p><b>Tipo:</b> '+event.tipo+'<br />' +
                '<p><b>Atendente:</b> '+event.user+'</p>';
            if(event.sistema != null)
                content = content + '<p><b>Sistema:</b> '+event.sistema+'</p>';
            if(event.vendedor != null)
                content = content + '<p><b>Vendedor:</b> '+event.vendedor+'</p>';
            if(event.solicitante != null)
                content = content + '<p><b>Solicitante:</b> '+event.solicitante+'</p>';
            if(event.user != null)
                content = content + '<p><b>Técnico:</b> '+event.user+'</p>';
            else
                content = content + '<p><b>Técnico:</b> </p>';

            content = content + '<p><b>Empresa:</b> '+event.empresa+'</p>';
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
                return ['all', event.user_id].indexOf($('#user_id_selector').val()) >= 0 &&
                    ['all', event.tipo_id].indexOf($('#tipo_id_selector').val()) >= 0 &&
                    ['all', event.cliente_id].indexOf($('#filtro_cliente_id').val()) >= 0 &&
                    ['all', event.vendedor_id].indexOf($('#filtro_vendedor_id').val() == '' ? 'all' : $('#filtro_vendedor_id').val()) >= 0 &&
                    ['all', event.empresa_id].indexOf($('#filtro_empresa_id').val() == '' ? 'all' : $('#filtro_empresa_id').val()) >= 0
        },
        eventAfterAllRender: function (view) {
            var quantity = $('.fc-event').length;
            $("#quantity").text('(' + quantity + ' agendamentos)');
        },
    });

    function get_users_agenda(){
        $.getJSON('/agendamentos/get_users_agenda', function(data) {
            $.each(data,function (i,user){
                $("#external-events").append('<div class="external-event navy-bg userAgenda" value="' + user['id'] + '" style="background-color: '+ user['color'] + '">' + user['name'] +' </div>');
            });
            $('.userAgenda').on('click', function () {
                $(".userAgenda").each(function( index ) {
                    $(this).css({"color": "",
                        "border-width":"",
                        "border-style":""});
                });
                if($('#user_id_selector').val() == $(this)["0"].attributes[1].value){
                    $('#user_id_selector').val("all");
                }else{
                    $('#user_id_selector').val($(this)["0"].attributes[1].value)
                    $(this).css({"color": "yellow",
                        "border-width":"2px",
                        "border-style":"solid"});
                }
                $('#calendar').fullCalendar('rerenderEvents');
            })
        });
    }

    function salvarComentario(comentario, id) {
        $.ajax({
            url: '/comentarios/',
            data: {'comentario[agendamento_id]': id, 'comentario[comentario]': comentario},
            type: 'POST',
            success: function (data) {
                exibirMsg('Comentário registrado');
                return false;
            },error: function(data){
                exibirErro('Ocorreu um erro.');
                return false;
            }
        });
        return false;
    }

    function salvarComentarioImplantacao(comentario, implantacao_id, negociacao_id, data_retorno, usuario_id) {
        $.ajax({
            url: '/comentarios/',
            data: getFormComentarioImplantacao(comentario, implantacao_id, negociacao_id, data_retorno, usuario_id),
            processData: false,
            contentType: false,
            type: 'POST',
            success: function (data) {
                exibirMsg('Comentário registrado');
                return false;
            },error: function(data){
                exibirErro('Ocorreu um erro.');
                return false;
            }
        });
        return false;
    }

    function getFormComentarioImplantacao(comentario, implantacao_id, negociacao_id, data_retorno, usuario_id){
        form = new FormData();
        form.append('comentario[comentario]', comentario);
        form.append('comentario[implantacao_id]', implantacao_id);
        form.append('comentario[negociacao_id]', negociacao_id);
        if(moment(data_retorno,"DD/MM/YYYY HH:mm").isValid()){
            form.append('data_retorno', data_retorno);
        }
        if(usuario_id != null )
            form.append('usuario_id', usuario_id);
        return form;
    }

    function showAgendamento(calEvent){
        limparForm();
        console.log(calEvent);

        if(calEvent['telefone_preferencial']){
            $('#form_agendamento #telefone_preferencial1').prop('checked', true);
        }
        if(calEvent['telefone_preferencial2']){
            $('#form_agendamento #telefone_preferencial2').prop('checked', true);
        }
        if(calEvent['telefone_whats']){
            $('#form_agendamento #telefone_whats1').prop('checked', true);
        }
        if(calEvent['telefone_whats2']){
            $('#form_agendamento #telefone_whats2').prop('checked', true);
        }

        $('#form_agendamento #id').val(calEvent['id']);
        $('#form_agendamento #id_reagendado').val(calEvent['id']);
        $('#form_agendamento #data_inicio').val(moment(calEvent['data_inicio']).format("DD/MM/YYYY HH:mm"));
        $('#form_agendamento #data_fim').val(moment(calEvent['data_fim']).format("DD/MM/YYYY HH:mm"));
        $('#form_agendamento #observacao').val(calEvent['observacao']);
        if(calEvent['user_id'] != null)
            $('#form_agendamento #user_id').val(calEvent['user_id']).trigger("chosen:updated");
        $('#form_agendamento #tipo_agendamento_id').val(calEvent['tipo_agendamento_id']).trigger("chosen:updated");
        $('#form_agendamento #cliente_id').val(calEvent['cliente_id']);
        $('#form_agendamento #cliente').val(calEvent['cliente_razao_social']);
        $('#form_agendamento #empresa').val(calEvent['empresa']);
        $('#form_agendamento #user_registro').val(calEvent['user_registro']);
        $('#form_agendamento #telefone').val(calEvent['telefone']);
        $('#form_agendamento #responsavel').val(calEvent['responsavel']);
        $('#form_agendamento #responsavel2').val(calEvent['responsavel2']);
        $('#form_agendamento #telefone2').val(calEvent['telefone2']);
        $('#form_agendamento #fechamento_vendedor').val(calEvent['vendedor']);
        $('#form_agendamento #negociador_id').val(calEvent['negociador_id']);
        $('#form_agendamento #fechamento_sistema').val(calEvent['sistema']);
        $('#form_agendamento #fechamento_data').val(calEvent['data_fechamento']);
        $('#form_agendamento #negociacao_id').val(calEvent['negociacao_id']);
        $('#form_agendamento #agendamento_user_cancelamento').val(calEvent['user_cancelamento']);
        $('#form_agendamento #agendamento_data_cancelamento').val(calEvent['data_cancelamento']);
        $('#form_agendamento #agendamento_motivo').val(calEvent['motivo']);
        $('#form_agendamento #cidade').val(calEvent['cidade']);

        $('#form_agendamento #form_confirmacao').show();
        $('#form_agendamento #confirmado_agendamento').val(calEvent['confirmado']);
        if(calEvent['confirmado'] == true){
            $('#form_agendamento #confirmado_agendamento').prop( "checked", true );
            $('#text-confirmacao').text('- Confirmado');
            $('#form_agendamento #confirmacao_confirmado').show();
            $('#form_agendamento #usuario_confirmacao').val(calEvent['usuario_confirmacao']);
            $('#form_agendamento #data_confirmacao').val(calEvent['data_confirmacao']);
        }else{
            $('#form_agendamento #confirmado_agendamento').prop( "checked", false );
            $('#text-confirmacao').text('- Não Confirmado');
            $('#form_agendamento #confirmacao_confirmado').hide();
            $('#form_agendamento #usuario_confirmacao').val('');
            $('#form_agendamento #data_confirmacao').val('');
        }

        $('#form_agendamento #novo_comentario').show();
        $('#form_agendamento #form_comentario').hide();
        $('#form_agendamento #comentario_label').text('Comentário');

        $('#form_agendamento #btnReagendar').show();
        $('#form_agendamento #btnExcluirEvento').show();
        $('#form_agendamento #btnSalvarReagendamento').hide();

        $('#infoEmpresa').show();

        if(calEvent['ativo'] == false){
            $('#form_agendamento #btnExcluirEvento').hide();
            $('#form_agendamento #tabCancelamento').show();
            $('#form_agendamento #btnSalvarAgendamento').hide();
        }else{
            $('#form_agendamento #tabCancelamento').hide();
            $('#form_agendamento #btnExcluirEvento').show();
            $('#form_agendamento #btnSalvarAgendamento').show();
        }

        if(calEvent['vendedor'] == null ) {
            $('#form_agendamento #tabFechamento').hide();
        }else {
            $('#form_agendamento #tabFechamento').show();
        }

        if(calEvent['implantacao_id'] != null){
            $('#form_agendamento #implantacao_id').val(calEvent['implantacao_id']);
            $('#form_agendamento #btnAbrirImplantacao').show();
        }else{
            $('#form_agendamento #btnAbrirImplantacao').hide();
        }
        $('#tabAgendamento a[href="#tab-1"]').click();

        buscarAtividades(calEvent['id']);

        $('#agendamento').modal('show');
    }

    function buscarAtividades(id) {
        $.ajax({
            url: '/agendamentos/activities',
            data: {id: id},
            type: 'GET',
            success: function (data) {
                $("#activities_agendamento").html(data);
            },error: function(data){
                exibirErro(data);
            }
        });
    }


    function get_legenda(){
        $.getJSON('/agendamentos/get_legenda', function(data) {
            $.each(data,function (i,tipo){
                $("#external-events-legenda").append('<div class="external-event navy-bg tipoAgenda" value="' + tipo['id'] + '" style="background-color: '+ tipo['cor'] + '">' + tipo['descricao'] +' </div>');
            });
            $('.tipoAgenda').on('click', function () {
                $(".tipoAgenda").each(function( index ) {
                    $(this).css({"color": "",
                        "border-width":"",
                        "border-style":""});
                });
                if($('#tipo_id_selector').val() == $(this)["0"].attributes[1].value){
                    $('#tipo_id_selector').val("all");
                }else{
                    $('#tipo_id_selector').val($(this)["0"].attributes[1].value)
                    $(this).css({"border-color": "yellow",
                        "border-width":"2px",
                        "border-style":"solid"});
                }
                $('#calendar').fullCalendar('rerenderEvents');
            })
        });
    }

    function limparForm(){

        $('#form_agendamento #telefone_preferencial1').prop('checked', false);
        $('#form_agendamento #telefone_preferencial2').prop('checked', false);
        $('#form_agendamento #telefone_whats1').prop('checked', false);
        $('#form_agendamento #telefone_whats2').prop('checked', false);

        $('#form_agendamento #id').val('');
        $('#form_agendamento #data_inicio').val('');
        $('#form_agendamento #data_fim').val('');
        $('#form_agendamento #cliente').val('');
        $('#form_agendamento #cliente_id').val('');
        $('#form_agendamento #implantacao_id').val('');
        $('#form_agendamento #telefone').val('');
        $('#form_agendamento #responsavel').val('');
        $('#form_agendamento #telefone2').val('');
        $('#form_agendamento #responsavel2').val('');
        $('#form_agendamento #user_id').val('').trigger('chosen:updated')
        $('#form_agendamento #tipo_agendamento_id').val('').trigger('chosen:updated')
        $('#form_agendamento #empresa').val('');
        $('#form_agendamento #user_registro').val('');

        $('#form_agendamento #comentario').val('');

        $('#form_agendamento #form_confirmacao').hide();
        $('#form_agendamento #form_comentario').hide();
        $('#form_agendamento #comentario_label').text('Comentário');

        $('#form_agendamento #fechamento_vendedor').val('');
        $('#form_agendamento #fechamento_sistema').val('');
        $('#form_agendamento #fechamento_data').val('');

        $('#form_agendamento #btnExcluirEvento').hide();
        $('#form_agendamento #formgroup_empresa').hide();
        $('#form_agendamento #formgroup_solicitante').hide();
        $('#form_agendamento #btnAbrirImplantacao').hide();

        $('#form_agendamento #confirmacao_confirmado').hide();
        $('#form_agendamento #usuario_confirmacao').val('');
        $('#form_agendamento #data_confirmacao').val('');
        $('#form_agendamento #form_confirmacao').hide();
        $('#form_agendamento #form_comentario').show();
        $('#form_agendamento #novo_comentario').hide();
        $('#form_agendamento #tabFechamento').hide();
        $('#form_agendamento #tabCancelamento').hide();

        $('#form_agendamento #btnReagendar').hide();
        $('#form_agendamento #btnExcluirEvento').hide();
        $('#form_agendamento #btnSalvarAgendamento').show();

        $('#infoEmpresa').hide();

        $('#modal_comentario_agendamento #text_comentario').val('');
        $('#modal_comentario_agendamento #novo_comentario_agendamento_id').val('');
        $('#modal_comentario_agendamento #error_comentario').hide();
        $('#modal_comentario_agendamento #comentario_data_retorno').hide();
    }

    function getFormAgendamento(){
        var checkBox;
        form = new FormData();
        form.append('id', $("#id").val());
        form.append('data_inicio', $("#data_inicio").val());
        form.append('data_fim', $("#data_fim").val());
        form.append('observacao', $("#observacao").val());
        form.append('user_id', $("#user_id").val());
        form.append('cliente_id', $("#cliente_id").val());
        form.append('tipo_agendamento_id', $("#tipo_agendamento_id").val());
        form.append('telefone', $("#telefone").val());
        form.append('contato', $("#responsavel").val());
        form.append('telefone2', $("#telefone2").val());
        form.append('contato2', $("#responsavel2").val());
        form.append('confirmacao', $("#confirmado_agendamento").val());
        checkBox = document.getElementById('telefone_preferencial1');
        form.append('telefone_preferencial',checkBox.checked);
        checkBox = document.getElementById('telefone_preferencial2');
        form.append('telefone_preferencial2',checkBox.checked);
        checkBox = document.getElementById('telefone_whats1');
        form.append('telefone_whats',checkBox.checked);
        checkBox = document.getElementById('telefone_whats2');
        form.append('telefone_whats2',checkBox.checked);

        form.append('motivo_reagendamento', $("#comentario").val());
        return form;
    }
});


