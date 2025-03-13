//= require dataTables/datatables.min.js
//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require typehead/bootstrap3-typeahead.min.js
//= require datapicker/bootstrap-datepicker.js
//= require mask_plugin/jquery.mask.js
//= require iCheck/icheck.min.js
//= require chosen/chosen.jquery.js
//= require jquery_nested_form

const CAMPANHA = {
    ModalPrimeiraCampanha: '#modal_primeira_campanha',
    ModalNovaCampanha: '#modal_nova_campanha',
    ModalCampanhaMassa: '#modal_campanha_massa',
    BodyPrimeiraCampanha: '#body_table_campanha_primeira_campanha',
    BodyNovaCampanha: '#body_table_campanha_nova_campanha',
    BodyCampanhaMassa: '#body_table_campanha_massa',
};
var current_campanha = {
    modal: "",
    table: ""
};
var total_disparos = 0;
var total_enviado = 0;
var total_erro = 0;
var optionSelect;
var now;
var before;
var difference;
var drawDataEstado = [];
var drawDataUsuario = [];
var drawDataUsuarioAtivo = [];
var tableUsuarios;
var tableNumerosAtivos;
var tableEstados;
var tableDemonstracaoSolicitante;
var tableSimplesNacional;
var tableDemonstracaoEstado;
var tableNumeros;
var tooltipData = '';
var campanhasAndamento = [];
var rowColor ='';
var qtdNumerosAutenticados = 0;

$(document).ready(function() {
    // Checkbox css
    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green'
    });

    //Carregar as tabelas do google no sistema
    google.charts.load('current', {'packages':['corechart','table'], 'callback': atualizarTabelas});

    //Script para manter o tooltip aberto enquanto estiver em cima do tooltip criado
    (function($) {
        var uiTooltipTmp = {
            options: {
                hoverTimeout: 200,
                tooltipHover: false // to have a regular behaviour by default. Use true to keep the tooltip while hovering it 
            },
            // This function will check every "hoverTimeout" if the original object or it's tooltip is hovered. If not, it will continue the standard tooltip closure procedure.
            timeoutHover: function (event,target,tooltipData,obj){
                var TO;
                var hov=false, hov2=false;
                if(target !== undefined) {
                    if(target.is(":hover")){
                    hov=true;}
                }
                if(tooltipData !== undefined) {
                    if(tooltipData && $(tooltipData.tooltip).is(":hover")){
                    hov=true;}
                }
                if(target !== undefined || tooltipData !== undefined) {hov2=true;}
                if(hov) {
                    TO = setTimeout(obj.timeoutHover,obj.options.hoverTimeout,event,target,tooltipData,obj);
                }else{
                    target.data('hoverFinished',1);
                    clearTimeout(TO);
                    if(hov2){
                        obj.closing = false;
                        obj.close(event,true);}
                }
            },
            // Changed standard procedure
            close: function(event) {
                var tooltip,
                    that = this,
                    target = $( event ? event.currentTarget : this.element ),
                    tooltipData = this._find( target );
                if(that.options.tooltipHover && (target.data('hoverFinished')===undefined || target.data('hoverFinished') === 0)){
                target.data('hoverFinished',0);
                setTimeout(that.timeoutHover, that.options.hoverTimeout,event, target, tooltipData, that);
                }
                else
                {
                if(that.options.tooltipHover){
                    target.data('hoverFinished',0);}
        
                // The rest part of standard code is unchanged
        
                if ( !tooltipData ) {
                    target.removeData( "ui-tooltip-open" );
                    return;
                }
        
                tooltip = tooltipData.tooltip;
                if ( tooltipData.closing ) {
                    return;
                }
        
                clearInterval( this.delayedShow );
        
                if ( target.data( "ui-tooltip-title" ) && !target.attr( "title" ) ) {
                    target.attr( "title", target.data( "ui-tooltip-title" ) );
                }
        
                this._removeDescribedBy( target );
        
                tooltipData.hiding = true;
                tooltip.stop( true );
                this._hide( tooltip, this.options.hide, function() {
                    that._removeTooltip( $( this ) );
                } );
        
                target.removeData( "ui-tooltip-open" );
                this._off( target, "mouseleave focusout keyup" );
        
                if ( target[ 0 ] !== this.element[ 0 ] ) {
                this._off( target, "remove" );
                }
                this._off( this.document, "mousemove" );
        
                if ( event && event.type === "mouseleave" ) {
                $.each( this.parents, function( id, parent ) {
                    $( parent.element ).attr( "title", parent.title );
                    delete that.parents[ id ];
                } );
                }
        
                tooltipData.closing = true;
                this._trigger( "close", event, { tooltip: tooltip } );
                if ( !tooltipData.hiding ) {
                    tooltipData.closing = false;
                }
                }
                }
            };
        
        // Extending ui.tooltip. Changing "close" function and adding two new parameters.
        $.widget( "ui.tooltip", $.ui.tooltip, uiTooltipTmp);
        
    })(jQuery);
    var date = new Date();

    $(`${current_campanha.modal} #data_disparo`).datetimepicker({    
        mask: true,
        altFormat: "dd/mm/yyyy hh:ii",
        dateFormat: "dd/mm/yyyy hh:ii",
        minDate: moment(Date.now()),
        language: 'pt-BR',
        todayBtn: true,
        autoclose: true,
        format: 'dd/mm/yyyy hh:ii',
        pickerPosition: "top-left",
    }).mask("99/99/9999 99:99");

    $('#data_inicio').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
    $("#data_inicio").datepicker("setDate", date);

    $('#data_fim').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
    $("#data_fim").datepicker("setDate",  date);

    $(`${current_campanha.modal} #data_inicio_modal`).datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
    $(`${current_campanha.modal} #data_inicio_modal`).datepicker("setDate", date);

    $(`${current_campanha.modal} #data_fim_modal`).datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
    $(`${current_campanha.modal} #data_fim_modal`).datepicker("setDate", date);

    $(`${CAMPANHA.ModalCampanhaMassa} #user_id`).on('change', function() {
        let options = $(this).find('option:selected').map(function() {
            return $(this).val();
        }).get();
    
        if (options.includes("TODOS")) {
            options = $(this).find('option').map(function() {
                return $(this).val();
            }).get();
    
            options = options.filter(function(value) {
                return value !== "TODOS";
            });
    
            $(this).val(options);
            $(this).trigger('chosen:updated');
        }
    
        $.getJSON(`/users/qtd_numeros_autenticados?ids=${options.join(',')}`, function(data) {
            qtdNumerosAutenticados = data;
            const qtdDisparos = $(`${CAMPANHA.ModalCampanhaMassa} #quantidade`).val();
            const qtdDisparoPorNumero = Math.floor(qtdDisparos / (qtdNumerosAutenticados || 1));
            const qtdDisparoAdicionais = (qtdDisparos % (qtdNumerosAutenticados || 1));

            $(`${CAMPANHA.ModalCampanhaMassa} #media_qtd_disparo`).text(`${qtdDisparoPorNumero} | Disp. último número ${qtdDisparoPorNumero + qtdDisparoAdicionais}`);
            $(`${CAMPANHA.ModalCampanhaMassa} #qtd_numeros`).text(qtdNumerosAutenticados);
        });
    });
    

    $(`${current_campanha.modal} #whatsapp_numero_id`).on('change', function() {
        optionSelect = $(this).find('option:selected')
        buscarHistoricoNumero();
    });

    $(`${current_campanha.modal} #pesquisar_historico`).on('click', function () {
        optionSelect = $(`${current_campanha.modal} #whatsapp_numero_id`).find('option:selected');
        buscarHistoricoNumero();
    })

    function atualizarSaldo() {
        buscarSaldoAtualPorJob().then((saldo) => {
            mostrarSaldo(saldo);
        });
    }

    function buscarSaldoAtualPorJob() {
        const job = $(`${current_campanha.modal} #numero_job`).val();
        const empresa = $(`${current_campanha.modal} #empresa_id`).val();
        return new Promise((resolve) => {
            $.getJSON(`/importacoes/saldo_atual_por_job?empresa_id=${empresa}&job=${job}`, function (data) {
                if (data == null)
                    data = 0;

                resolve(data);
            });
        })
    }

    function mostrarSaldo(saldo) {
        $(`${current_campanha.modal} label[for="saldo_job"]`).text(`(Saldo: ${saldo || 0})`)
    }

    $('#btnDia').on('click', function () {
        $("#data_inicio").datepicker("setDate",  new Date());
        $("#data_fim").datepicker("setDate",  new Date());

        atualizarTabelas();
        return false;
    });

    $('#btnOntem').on('click', function () {
        $("#data_inicio").datepicker("setDate",  addDays(new Date(), -1));
        $("#data_fim").datepicker("setDate",  addDays(new Date(), -1));

        atualizarTabelas();
        return false;
    });

    $('#btnSemana').on('click', function () {
        $("#data_inicio").datepicker("setDate",  addDays(new Date(), -7));
        $("#data_fim").datepicker("setDate",  new Date());

        atualizarTabelas();
        return false;
    });

    $('#btnMes').on('click', function () {
        $("#data_inicio").datepicker("setDate",  new Date(date.getFullYear(), date.getMonth(), 1));
        $("#data_fim").datepicker("setDate",  new Date(date.getFullYear(), date.getMonth() + 1, 0));

        atualizarTabelas();
        return false;
    });

    $('#btnTodas').on('click', function () {
        $("#data_inicio").datepicker("setDate",  null);
        $("#data_fim").datepicker("setDate",  null);

        atualizarTabelas();
        return false;
    });

    $('.chosen-select').chosen({width: "100%", allow_single_deselect: true, search_contains: true});

    $(`${current_campanha.modal} #empresa_id`).change(() => atualizarSaldo());
    $(`${current_campanha.modal} #numero_job`).on('input', () => atualizarSaldo());

    $('#openModalCampanha').on('click', function () {
        $.getJSON("/campanhas/get_saldo_chat_pro", function(data) {
            $('#saldo_chat_pro').text(`${data.saldo}`)
        });
        atualizarSaldo();
        current_campanha.modal = CAMPANHA.ModalNovaCampanha;
        current_campanha.table = CAMPANHA.BodyNovaCampanha;
        optionSelect = $(`${current_campanha.modal} #whatsapp_numero_id`).find('option:selected');
        $(current_campanha.table).attr('id', 'body_table_campanha_nova_campanha');
        $(current_campanha.modal).modal('show');
        buscarHistoricoNumero();
    });

    $('#openModalPrimeiraCampanha').on('click', function () {
        current_campanha.modal = CAMPANHA.ModalPrimeiraCampanha;
        current_campanha.table = CAMPANHA.BodyPrimeiraCampanha;
        optionSelect = $(`${current_campanha.modal} #whatsapp_numero_id`).find('option:selected');
        atualizarSaldo();
        $(current_campanha.table).attr('id', 'body_table_campanha_primeira_campanha');
        $(current_campanha.modal).modal('show');
        buscarHistoricoNumero();
    });

    $('#openModalDisparoMassa').on('click', function () {
        current_campanha.modal = CAMPANHA.ModalCampanhaMassa;
        current_campanha.table = CAMPANHA.BodyCampanhaMassa;
        optionSelect = $(`${current_campanha.modal} #whatsapp_numero_id`).find('option:selected');
        atualizarSaldo();
        $(current_campanha.table).attr('id', 'body_table_campanha_massa');
        $(current_campanha.modal).modal('show');
    });

    $('#openModalTransferirCampanha').on('click', function () {
        $('#modal_transferir_campanha').modal('show');
    });

    $('#modal_nova_campanha #tipo').on('change', function() {
        if($('#modal_nova_campanha #tipo').val() === 'CAPTACAO'){
            $('#modal_nova_campanha #headerTabAbordagemNovaCampanha').show();
        }else{
            $('#modal_nova_campanha #headerTabAbordagemNovaCampanha').hide();
        }
    });

    $('#modal_primeira_campanha #tipo').on('change', function() {
        if($('#modal_primeira_campanha #tipo').val() === 'CAPTACAO'){
            $('#modal_primeira_campanha #headerTabAbordagemPrimeiraCampanha').show();
        }else{
            $('#modal_primeira_campanha #headerTabAbordagemPrimeiraCampanha').hide();
        }
    });

    $('#modal_nova_campanha #btnGerarCampanha').on('click', function (){
        if($("#modal_nova_campanha #numero_job").val() === "" || $("#modal_nova_campanha #quantidade").val() === ""){
            exibirErro("Informe o job e a quantidade");
            return false;
        }
        if($("#modal_nova_campanha #whatsapp_numero_id").val() == undefined){
            exibirErro("Informe o número");
            return false;
        }
        if($("#modal_nova_campanha #tempo_espera").val() === "" && $("#modal_nova_campanha #tipo_disparo").val() === "1" ){
            exibirErro("Informe o tempo de espera");
            return false;
        }
        if($("#modal_nova_campanha #tempo_total").val() === "" && $("#modal_nova_campanha #tipo_disparo").val() === "2"){
            exibirErro("Informe o tempo total");
            return false;
        }
        if($("#modal_nova_campanha #tempo_espera").val() !== "" && $("#modal_nova_campanha #tempo_total").val() !== ""){
            exibirErro("Preencha apenas um dos campos: tempo de espera ou tempo total");
            return false;
        }
        if($("#modal_nova_campanha #tipo").val() === "PERSONALIZADO" && $("#modal_nova_campanha #texto_abordagem").val() === ""){
            exibirErro("Informe o texto que será enviado");
            return false;
        }
        if(moment($("#modal_nova_campanha #data_disparo").val()) < moment(moment(Date().now).format('DD/MM/YYYY HH:mm'))) {
            exibirErro("O agendamento não pode ser menor que a data atual")
            return false;
        }
        if((!$("#modal_nova_campanha #is_edit_abordagem_especifica").is(":checked")) && $("#modal_nova_campanha #texto_abordagem_padrao_especifica").val() === '') {
            exibirErro("Informe o texto da abordagem inicial que será enviada, ou altere para a abordagem padrão")
            return false;
        }   
        if((!$("#modal_nova_campanha #is_edit_resposta_especifica").is(':checked')) && $("#modal_nova_campanha #texto_abordagem_resposta_especifica").val() === '') {
            exibirErro("Informe o texto da resposta automatica que será enviada, ou altere para a abordagem padrão")
            return false;
        }
        $('body').lmask('show');
        $.ajax({
            url: '/campanhas',
            data: getFormCampanha(),
            processData: false,
            contentType: false,
            type: 'POST',
            success: function (data) {
                $('#modal_nova_campanha').modal('toggle');
                $('body').lmask('hide');
                exibirMsg("Campanha cadastrada");
                window.location.reload();
            },error: function(data){
                exibirErro(data);
            }
        });
        return false;
    });

    $('#modal_primeira_campanha #btnGerarCampanha').on('click', function (){
        if($("#modal_primeira_campanha #numero_job").val() === "" || $("#modal_primeira_campanha #quantidade").val() === ""){
            exibirErro("Informe o job e a quantidade");
            return false;
        }
        if($("#modal_primeira_campanha #whatsapp_numero_id").val() == undefined){
            exibirErro("Informe o número");
            return false;
        }
        if($("#modal_primeira_campanha #tempo_espera").val() === "" && $("#modal_primeira_campanha #tipo_disparo").val() === "1" ){
            exibirErro("Informe o tempo de espera");
            return false;
        }
        if($("#modal_primeira_campanha #tempo_total").val() === "" && $("#modal_primeira_campanha #tipo_disparo").val() === "2"){
            exibirErro("Informe o tempo total");
            return false;
        }
        if($("#modal_primeira_campanha #tempo_espera").val() !== "" && $("#modal_primeira_campanha #tempo_total").val() !== ""){
            exibirErro("Preencha apenas um dos campos: tempo de espera ou tempo total");
            return false;
        }
        if($("#modal_primeira_campanha #tipo").val() === "PERSONALIZADO" && $("#modal_primeira_campanha #texto_abordagem").val() === ""){
            exibirErro("Informe o texto que será enviado");
            return false;
        }
        if(moment($("#modal_primeira_campanha #data_disparo").val()) < moment(moment(Date().now).format('DD/MM/YYYY HH:mm'))) {
            exibirErro("O agendamento não pode ser menor que a data atual")
            return false;
        }
        if((!$("#modal_primeira_campanha #is_edit_abordagem_especifica").is(":checked")) && $("#modal_primeira_campanha #texto_abordagem_padrao_especifica").val() === '') {
            exibirErro("Informe o texto da abordagem inicial que será enviada, ou altere para padrão")
            return false;
        }   
        if((!$("#modal_primeira_campanha #is_edit_resposta_especifica").is(':checked')) && $("#modal_primeira_campanha #texto_abordagem_resposta_especifica").val() === '') {
            exibirErro("Informe o texto da resposta automatica que será enviada, ou altere para padrão")
            return false;
        }
        $('body').lmask('show');
        $.ajax({
            url: '/campanhas',
            data: getFormPrimeiraCampanha(),
            processData: false,
            contentType: false,
            type: 'POST',
            success: function (data) {
                $('#modal_primeira_campanha').modal('toggle');
                $('body').lmask('hide');
                exibirMsg("Campanha cadastrada");
                window.location.reload();
            },error: function(data){
                exibirErro(data);
            }
        });
        return false;
    });

    $(`${CAMPANHA.ModalCampanhaMassa} #btnGerarCampanha`).on('click', function (){
        if($(`${CAMPANHA.ModalCampanhaMassa} #numero_job`).val() === "" || $(`${CAMPANHA.ModalCampanhaMassa} #quantidade`).val() === ""){
            exibirErro("Informe o job e a quantidade");
            return false;
        }
        if($(`${CAMPANHA.ModalCampanhaMassa} #tempo_espera`).val() === "" && $(`${CAMPANHA.ModalCampanhaMassa} #tipo_disparo`).val() === "1" ){
            exibirErro("Informe o tempo de espera");
            return false;
        }
        if($(`${CAMPANHA.ModalCampanhaMassa} #tempo_total`).val() === "" && $(`${CAMPANHA.ModalCampanhaMassa} #tipo_disparo`).val() === "2"){
            exibirErro("Informe o tempo total");
            return false;
        }
        if($(`${CAMPANHA.ModalCampanhaMassa} #tempo_espera`).val() !== "" && $(`${CAMPANHA.ModalCampanhaMassa} #tempo_total`).val() !== ""){
            exibirErro("Preencha apenas um dos campos: tempo de espera ou tempo total");
            return false;
        }
        if($(`${CAMPANHA.ModalCampanhaMassa} #tipo`).val() === "PERSONALIZADO" && $(`${CAMPANHA.ModalCampanhaMassa} #texto_abordagem`).val() === ""){
            exibirErro("Informe o texto que será enviado");
            return false;
        }
        if(moment($(`${CAMPANHA.ModalCampanhaMassa} #data_disparo`).val()) < moment(moment(Date().now).format('DD/MM/YYYY HH:mm'))) {
            exibirErro("O agendamento não pode ser menor que a data atual")
            return false;
        }
        if((!$(`${CAMPANHA.ModalCampanhaMassa} #is_edit_abordagem_especifica`).is(":checked")) && $(`${CAMPANHA.ModalCampanhaMassa} #texto_abordagem_padrao_especifica`).val() === '') {
            exibirErro("Informe o texto da abordagem inicial que será enviada, ou altere para padrão")
            return false;
        }   
        if((!$(`${CAMPANHA.ModalCampanhaMassa} #is_edit_resposta_especifica`).is(':checked')) && $(`${CAMPANHA.ModalCampanhaMassa} #texto_abordagem_resposta_especifica`).val() === '') {
            exibirErro("Informe o texto da resposta automatica que será enviada, ou altere para padrão")
            return false;
        }
        $('body').lmask('show');
        $.ajax({
            url: '/campanhas',
            data: getFormCampanhaMassa(),
            processData: false,
            contentType: false,
            type: 'POST',
            success: function (data) {
                $(CAMPANHA.ModalCampanhaMassa).modal('toggle');
                $('body').lmask('hide');
                exibirMsg("Campanha cadastrada");
                window.location.reload();
            },error: function(data){
                exibirErro(data);
            }
        });
        return false;
    });

    $('#modal_transferir_campanha #btnTransferirCampanha').on('click', function (){
        if($("#modal_transferir_campanha #campanha_id").val() == undefined){
            exibirErro("Informe a campanha");
            return false;
        }
        if($("#modal_transferir_campanha #whatsapp_numero_id").val() == undefined){
            exibirErro("Informe o número");
            return false;
        }
        $('body').lmask('show');
        $.ajax({
            url: '/campanhas/transferir_campanha',
            data: { id: $("#modal_transferir_campanha #campanha_id").val(), numero_whatsapp_id: $("#modal_transferir_campanha #whatsapp_numero_id").val()},
            type: 'POST',
            success: function (data) {
                $('#modal_transferir_campanha').modal('toggle');
                $('body').lmask('hide');
                exibirMsg("Campanha transferida");
                window.location.reload();
            },error: function(data){
                $('body').lmask('hide');
                exibirErro(data);
            }
        });
        return false;
    });

    //Redesenha os gráficos
    $(".nav-tabs a").click(function(){
        setTimeout(() => {
            if($('#pie_chart_estados').is(':visible') && $("#tab-content").tabs({ active: 9 })){
                drawPieChartEstado(drawDataEstado[0], drawDataEstado[1]);
                drawPieChartUsuario(drawDataUsuario[0], drawDataUsuario[1]);
                drawPieChartNumerosAtivos(drawDataUsuarioAtivo[0], drawDataUsuarioAtivo[1]);
            }
        }, 100);
    });

    $('#tooltip-1').on({
        'mouseover': function () {
            var tooltipContent = `<table class="table table-fixed" style="font-size: 12px;"> <thead class="table-fixed"> <tr class="table-fixed"> <th>Qtd Total</th> <th>Data de Criação</th> <th>Data Fim / Previsão</th> <th>Status</th> </tr> </thead><tbody class="table-fixed table-tbody-scroll" id='body_table_tooltip'">${tooltipData}</tbody></table>`
            $('#tooltip-1').tooltip({
                hoverTimeout: 250,
                tooltipHover: true,
                content: tooltipContent,
                tooltipClass: 'tooltip-box',
                hide: false,
                close: function () {
                    $("#body_table_tooltip tr").remove();
                    $(this).tooltip('close');
                }
            }).tooltip('open');
        }
    })

    $('#modal_nova_campanha #tipo_disparo').on('change', function() {
        //tipo 1 = Intervalo de tempo de disparos fixo
        //tipo 2 = Intervalo de tempo de disparos aleatórios
        if($('#modal_nova_campanha #tipo_disparo').val() === '1'){
            $('#modal_nova_campanha #tempo_total').val('');
            $('#modal_nova_campanha #campo_espera').show();
            $('#modal_nova_campanha #campo_tempo_total').hide();
        } else if ($('#modal_nova_campanha #tipo_disparo').val() === '2') {
            $('#modal_nova_campanha #tempo_total').val('');
            $('#modal_nova_campanha #tempo_espera').val('');
            $('#modal_nova_campanha #campo_espera').hide();
            $('#modal_nova_campanha #campo_tempo_total').show();
        }
    });

    $('#modal_primeira_campanha #tipo_disparo').on('change', function() {
        //tipo 1 = Intervalo de tempo de disparos fixo
        //tipo 2 = Intervalo de tempo de disparos aleatórios
        if($('#modal_primeira_campanha #tipo_disparo').val() === '1'){
            $('#modal_primeira_campanha #tempo_total').val('');
            $('#modal_primeira_campanha #campo_espera').show();
            $('#modal_primeira_campanha #campo_tempo_total').hide();
        } else if ($('#modal_primeira_campanha #tipo_disparo').val() === '2') {
            $('#modal_primeira_campanha #tempo_total').val('');
            $('#modal_primeira_campanha #tempo_espera').val('');
            $('#modal_primeira_campanha #campo_espera').hide();
            $('#modal_primeira_campanha #campo_tempo_total').show();
        }
    });

    $(`${CAMPANHA.ModalCampanhaMassa} #tipo_disparo`).on('change', function() {
        //tipo 1 = Intervalo de tempo de disparos fixo
        //tipo 2 = Intervalo de tempo de disparos aleatórios
        if($(`${CAMPANHA.ModalCampanhaMassa} #tipo_disparo`).val() === '1'){
            $(`${CAMPANHA.ModalCampanhaMassa} #tempo_total`).val('');
            $(`${CAMPANHA.ModalCampanhaMassa} #campo_espera`).show();
            $(`${CAMPANHA.ModalCampanhaMassa} #campo_tempo_total`).hide();
        } else if ($(`${CAMPANHA.ModalCampanhaMassa} #tipo_disparo`).val() === '2') {
            $(`${CAMPANHA.ModalCampanhaMassa} #tempo_total`).val('');
            $(`${CAMPANHA.ModalCampanhaMassa} #tempo_espera`).val('');
            $(`${CAMPANHA.ModalCampanhaMassa} #campo_espera`).hide();
            $(`${CAMPANHA.ModalCampanhaMassa} #campo_tempo_total`).show();
        }
    });

    $('#btnAtualizarCampanhas').on('click', function (){
        drawDataEstado=[]
        drawDataUsuario=[]
        drawDataUsuarioAtivo=[]
        atualizarTabelas();
        return false;
    });

    // Campanha tem resposta automatica?
    $('#modal_primeira_campanha #is_resposta_automatica').change(function() {
        if (this.checked) {
            $('#modal_primeira_campanha #campo_resposta_automatica').show()
            $('#modal_primeira_campanha #campo_abordagem_resposta_especifica').removeAttr('hidden');
            $(this).val($(this).data('on_value'));
        } else {
            $('#modal_primeira_campanha #campo_resposta_automatica').hide()
            $('#modal_primeira_campanha #campo_abordagem_resposta_especifica').attr('hidden', true);
            $(this).val($(this).data('off_value'));
        }
    });

    $('#modal_nova_campanha #is_resposta_automatica').change(function() {
        if (this.checked) {
            $('#modal_nova_campanha #campo_resposta_automatica').show();
            $('#modal_nova_campanha #campo_abordagem_resposta_especifica').removeAttr('hidden');
            $(this).val($(this).data('on_value'));
        } else {
            $('#modal_nova_campanha #campo_resposta_automatica').hide();
            $('#modal_nova_campanha #campo_abordagem_resposta_especifica').attr('hidden', true);
            $(this).val($(this).data('off_value'));
        }
    });

    $(`${CAMPANHA.ModalCampanhaMassa} #is_resposta_automatica`).change(function() {
        if (this.checked) {
            $(`${CAMPANHA.ModalCampanhaMassa} #campo_resposta_automatica`).show();
            $(`${CAMPANHA.ModalCampanhaMassa} #campo_abordagem_resposta_especifica`).removeAttr('hidden');
            $(this).val($(this).data('on_value'));
        } else {
            $(`${CAMPANHA.ModalCampanhaMassa} #campo_resposta_automatica`).hide();
            $(`${CAMPANHA.ModalCampanhaMassa} #campo_abordagem_resposta_especifica`).attr('hidden', true);
            $(this).val($(this).data('off_value'));
        }
    });

    // Checkbox editar Abordagem inicial Padrão
    $('#modal_nova_campanha #is_edit_abordagem_especifica').change(function() {
        if (this.checked) {
            $('#modal_nova_campanha #texto_abordagem_padrao_especifica').attr('disabled', true);
            $('#modal_nova_campanha #texto_abordagem_padrao_especifica').val('');
            $(this).val($(this).data('on_value'));
        } else {
            $('#modal_nova_campanha #texto_abordagem_padrao_especifica').attr('disabled', false);
            $(this).val($(this).data('off_value'));
        }
    })

    $('#modal_primeira_campanha #is_edit_abordagem_especifica').change(function() {
        if (this.checked) {
            $('#modal_primeira_campanha #texto_abordagem_padrao_especifica').attr('disabled', true)
            $('#modal_primeira_campanha #texto_abordagem_padrao_especifica').val('')

            $(this).val($(this).data('on_value'));
        } else {
            $('#modal_primeira_campanha #texto_abordagem_padrao_especifica').attr('disabled', false)
            $(this).val($(this).data('off_value'));
        }
    })

    $(`${CAMPANHA.ModalCampanhaMassa} #is_edit_abordagem_especifica`).change(function() {
        if (this.checked) {
            $(`${CAMPANHA.ModalCampanhaMassa} #texto_abordagem_padrao_especifica`).attr('disabled', true)
            $(`${CAMPANHA.ModalCampanhaMassa} #texto_abordagem_padrao_especifica`).val('')

            $(this).val($(this).data('on_value'));
        } else {
            $(`${CAMPANHA.ModalCampanhaMassa} #texto_abordagem_padrao_especifica`).attr('disabled', false)
            $(this).val($(this).data('off_value'));
        }
    })

    // Checkbox editar Abordagem resposta automatica
    $('#modal_nova_campanha #is_edit_resposta_especifica').change(function() {
        if (this.checked) {
            $('#modal_nova_campanha #texto_abordagem_resposta_especifica').attr('disabled', true);
            $('#modal_nova_campanha #texto_abordagem_resposta_especifica').val('');

            $('#modal_nova_campanha #texto_palavra_chave').attr('disabled', true);
            $('#modal_nova_campanha #texto_palavra_chave').val('');
            $(this).val($(this).data('on_value'));
        } else {
            $('#modal_nova_campanha #texto_abordagem_resposta_especifica').attr('disabled', false)
            $('#modal_nova_campanha #texto_palavra_chave').attr('disabled', false)
            $(this).val($(this).data('off_value'));
        }
    })

    $('#modal_primeira_campanha #is_edit_resposta_especifica').change(function() {
        if (this.checked) {
            $('#modal_primeira_campanha #texto_abordagem_resposta_especifica').attr('disabled', true);
            $('#modal_primeira_campanha #texto_abordagem_resposta_especifica').val('');

            $('#modal_primeira_campanha #texto_palavra_chave').attr('disabled', true);
            $('#modal_primeira_campanha #texto_palavra_chave').val('');
            $(this).val($(this).data('on_value'));
        } else {
            $('#modal_primeira_campanha #texto_abordagem_resposta_especifica').attr('disabled', false)
            $('#modal_primeira_campanha #texto_palavra_chave').attr('disabled', false)
            $(this).val($(this).data('off_value'));
        }
    })

    $(`${CAMPANHA.ModalCampanhaMassa} #is_edit_resposta_especifica`).change(function() {
        if (this.checked) {
            $(`${CAMPANHA.ModalCampanhaMassa} #texto_abordagem_resposta_especifica`).attr('disabled', true);
            $(`${CAMPANHA.ModalCampanhaMassa} #texto_abordagem_resposta_especifica`).val('');

            $(`${CAMPANHA.ModalCampanhaMassa} #texto_palavra_chave`).attr('disabled', true);
            $(`${CAMPANHA.ModalCampanhaMassa} #texto_palavra_chave`).val('');
            $(this).val($(this).data('on_value'));
        } else {
            $(`${CAMPANHA.ModalCampanhaMassa} #texto_abordagem_resposta_especifica`).attr('disabled', false)
            $(`${CAMPANHA.ModalCampanhaMassa} #texto_palavra_chave`).attr('disabled', false)
            $(this).val($(this).data('off_value'));
        }
    })

    $(`${CAMPANHA.ModalCampanhaMassa} #quantidade`).on('input', function() {
        const qtdDisparos = $(`${CAMPANHA.ModalCampanhaMassa} #quantidade`).val();
        const qtdDisparoPorNumero = Math.floor(qtdDisparos/(qtdNumerosAutenticados || 1));
        const qtdDisparoAdicionais = qtdDisparos%(qtdNumerosAutenticados || 1);

        $(`${CAMPANHA.ModalCampanhaMassa} #media_qtd_disparo`).text(`${qtdDisparoPorNumero} | Disp. último número ${qtdDisparoPorNumero + qtdDisparoAdicionais}`);
    });

    atualizarTabelas();

    setInterval(function() {
        buscarCampanhasAndamento();
        buscarCampanhasAguardando();
    }, 180000);
});

function atualizarTabelas(){
    buscarCampanhasAndamento();
    buscarCampanhasAguardando();
    buscarCampanhasFinalizadas();
    buscarCampanhasTotalizadoresEstado();
    buscarCampanhasTotalizadoresUsuario();
    buscarCampanhasNumerosAtivos();
    buscarInfoNumeros();
    buscarDemonstracaoEstado();
    buscarDemonstracaoSolicitante();
    buscarEmpresasSimplesNacional();
}

function buscarCampanhasAndamento(){
    $.getJSON("/campanhas/by_status?tipo=ANDAMENTO"
        + "&estado_id=" + $('#estado_id').val()
        + "&usuario_id=" + $('#usuario_id').val()
        + "&telefone_id=" + $('#telefone_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val(), function(data) {
        $("#body_table_campanha_andamento tr").remove();
        $('#tab1').text('Em Andamento (' + data.length + ')')
        let total_geral = 0;
        let total_aguardando = 0;
        let total_enviado = 0;
        let total_erro = 0;
        $.each(data,function (i,val){
            total_geral += parseInt(val['qtd_total']);
            total_aguardando += parseInt(val['qtd_aguardando']);    
            total_enviado += parseInt(val['qtd_enviado']);
            total_erro += parseInt(val['qtd_erro']);
            const diasMaturado = moment().diff(moment(val['numero_created_at']), 'days');
            addLineTabelaAndamento(
                val['numero'], val['nome'], val['job'], val['sigla'], (val['tempo_total'] && val['tempo_total'] > 0 ? (val['tempo_total']/60) + " min" : val['tempo_espera']), val['qtd_total'],
                val['qtd_aguardando'], val['qtd_enviado'], val['qtd_erro'], val['status'], val['created_at'], val['previsao'],
                val['numero_status'], val['banido'], diasMaturado, val['agendado_at'], val["is_pausada"] === "t" ? true : false, val['id'], false
            );
        });

        addLineTabelaAndamento('Total', '', '', '', '', total_geral,
            total_aguardando, total_enviado, total_erro, '', '', '', '', '', '', '', false, '', true);

    });
}

function addLineTabelaAndamento(numero, nome, job, sigla, tempoespesa, qtd_total, qtd_aguardando, qtd_enviado, qtd_erro, status, created_at, previsao, numero_status, banido, diasMaturado, agendado_at, is_pausada, id, istotal){
    $('#playPauseStopButton').show();
    const retomarButton = `<button id="retomar-button-${id}" class="btn btn-sm btn-primary" onClick=(retomarCampanha(${id})) title="Resumir Campanha"><span class="fa fa-play"></span></button>`;
    const pausarButton = `<button id="pause-button-${id}" class="btn btn-sm btn-primary" onClick=(pausarCampanha(${id})) title="Pausar Campanha"><span class="fa fa-pause"></span></button>`;
    const pararButton = `<button class="btn btn-sm btn-primary" onClick=(pararCampanha(${id})) title="Parar Campanha"><span class="fa fa-stop"></span></button>`;

    $('#body_table_campanha_andamento').append('<tr class="' + (istotal ? 'totalTabelaCampanha' : '') + '"style="background-color:'+ definirCorLinha(numero_status, banido) +'"><td class="tableHeadCampanha">' + numero + '</td>' +
        '<td>' + nome + '</td>' +
        '<td class="tableHeadCampanha">' + (istotal ? '' : ("<label class=" + ((numero_status.includes('DESCONECTADO')) ? 'disconnected_number' : 'connected_number') +">" + numero_status + "</label>" + "\n<label>" + " á " + diasMaturado + " dias" + "</label>")) + '</td>' +
        '<td class="tableHeadCampanha">' + job + '</td>' +
        '<td class="tableHeadCampanha">' + sigla + '</td>' +
        '<td class="tableHeadCampanha">' + tempoespesa + '</td>' +
        '<td class="tableHeadCampanha">' + qtd_total + '</td>' +
        '<td class="tableHeadCampanha">' + qtd_aguardando + '</td>' +
        '<td class="tableHeadCampanha">' + qtd_enviado + '</td>' +
        '<td class="tableHeadCampanha">' + qtd_erro + '</td>' +
        '<td class="tableHeadCampanha">' + status + (istotal ? '' : ' %') + '</td>' +
        '<td class="tableHeadCampanha">' + (agendado_at ? moment(agendado_at).format('DD/MM/YYYY HH:mm') : created_at) + '</td>' +
        '<td class="tableHeadCampanha" id="previsao-'+id+'">' + previsao + '</td>' +
        '<td class="tableHeadCampanha">' + "<div class='button-group'>" + (
            !istotal
                ? is_pausada
                    ? retomarButton + pararButton
                    : pausarButton + pararButton
                : ""
            +
            "</div>" +
        '</td>' +
        '</tr>'));
}

function buscarCampanhasAguardando(){
        $.getJSON("/campanhas/by_status?tipo=AGUARDANDO"
        + "&estado_id=" + $('#estado_id').val()
        + "&usuario_id=" + $('#usuario_id').val()
        + "&telefone_id=" + $('#telefone_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val(), function(data) {
        $("#body_table_campanha_aguardando tr").remove();
        $('#tab2').text('Aguardando (' + data.length + ')')
        $.each(data,function (i,val){
            const diasMaturado = moment().diff(moment(val['numero_created_at']), 'days');
            $('#body_table_campanha_aguardando').append(
          '<tr style="background-color:'+ definirCorLinha(val['numero_status'], val['banido']) + '">' +
            '<td class="tableHeadCampanha">' + val['numero'] + '</td>' +
            '<td>' + val['nome'] + '</td>' +
            '<td class="tableHeadCampanha">' + ("<label class=" + ((val['numero_status'].includes('DESCONECTADO')) ? 'disconnected_number' : 'connected_number') +">" + val['numero_status'] + "</label>" + "\n<label>" + " á " + diasMaturado + " dias" + "</label>")+ '</td>' +
            '<td class="tableHeadCampanha">' + val['job'] + '</td>' +
            '<td class="tableHeadCampanha">' + val['sigla'] + '</td>' +
            '<td class="tableHeadCampanha">' + (val['tempo_total'] ? (val['tempo_total']/60) + " min" : val['tempo_espera']) + '</td>' +
            '<td class="tableHeadCampanha">' + val['qtd_total'] + '</td>' +
            '<td class="tableHeadCampanha">' + (val['agendado_at'] ? moment(val['agendado_at']).format('DD/MM/YYYY HH:mm') : val['created_at']) + '</td>' +
            '<td>' + ((['ENVIADA', 'NAO ENVIADA', 'AGUARDANDO'].includes(val['status']) && val['numero_status'] === 'CONECTADO') ? (`<button class="btn btn-sm btn-primary" onClick=(reenviarCampanha(${val['id']})) title="Reenviar Campanha"><span class="fa fa-paper-plane"></span></button>`)  : ('')) + '</td>' +
          '</tr>');
        });
    });
}

function buscarCampanhasTotalizadoresEstado(){
    $.getJSON("/campanhas/analise_dados?tipo=TOTALIZADOR_ESTADO"
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val(), function(data) {
        let total_enviado = 0;
        drawDataEstado = []
        var tableLayoutEstados = new google.visualization.DataTable();
        tableLayoutEstados.addColumn('string', 'Id');
        tableLayoutEstados.addColumn('string', 'UF');
        tableLayoutEstados.addColumn('string', 'Qtd. Disparo');
        tableEstados = new google.visualization.Table(document.getElementById('tableEstados'));
        $.each(data,function (i,val){
            total_enviado += parseInt(val['qtd'])
            tableLayoutEstados.addRow([(i + 1).toString(), val['sigla'], parseInt(val['qtd']).toLocaleString()]);
        });

        drawDataEstado.push(data)
        drawDataEstado.push(tableLayoutEstados)
        tableLayoutEstados.addRow(['Total', '', parseInt(total_enviado).toLocaleString()]);
        drawPieChartEstado(drawDataEstado[0], drawDataEstado[1]);
    });
}

function drawPieChartEstado(data, tableData){
    var dataArray = [
        ['UF', 'Qtd. Disparo'],
    ];
    if(data){
        for (var i = 0; i < data.length; i++) {
            var row = [data[i].sigla, parseInt(data[i].qtd)];
            dataArray.push(row);
        }
    }
    var options = {
        width: 390,
        height: 400,
        'chartArea': {'width': '70%', 'height': '70%'},
    };

    var chart = new google.visualization.PieChart(document.getElementById('pie_chart_estados'));
    var data = google.visualization.arrayToDataTable(dataArray);
    chart.draw(data, options);
    if(tableEstados) tableEstados.draw(tableData, {allowHtml: true, width: '100%', height: '100%', sort: 'disable'});
}

function buscarCampanhasTotalizadoresUsuario(){
    $.getJSON("/campanhas/analise_dados?tipo=TOTALIZADOR_USUARIO"
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val(), function(data) {
        drawDataUsuario = []
        var tableLayoutUsuarios = new google.visualization.DataTable();
        tableLayoutUsuarios.addColumn('string', 'Id');
        tableLayoutUsuarios.addColumn('string', 'Usuario');
        tableLayoutUsuarios.addColumn('string', 'Qtd. Disparo');
        tableUsuarios = new google.visualization.Table(document.getElementById('tableUsuarios'));

        let total_enviado = 0;
        $.each(data,function (i,val){
            total_enviado += parseInt(val['qtd']);
            tableLayoutUsuarios.addRow([(i + 1).toString(), val['name'], parseInt(val['qtd']).toLocaleString()]);
        });
        drawDataUsuario.push(data);
        drawDataUsuario.push(tableLayoutUsuarios);
        tableLayoutUsuarios.addRow(['Total', '', parseInt(total_enviado).toLocaleString()]);
        drawPieChartUsuario(drawDataUsuario[0], drawDataUsuario[1]);
    });
}

function buscarCampanhasNumerosAtivos(){
    $.getJSON("/campanhas/numeros_ativos_usuario", function(data) {
        drawDataUsuarioAtivo = []
        var tableLayoutNumerosAtivos = new google.visualization.DataTable();
        tableLayoutNumerosAtivos.addColumn('string', 'Id');
        tableLayoutNumerosAtivos.addColumn('string', 'Usuario');
        tableLayoutNumerosAtivos.addColumn('string', 'Qtd. Numeros');
        tableNumerosAtivos = new google.visualization.Table(document.getElementById('tableNumerosAtivos'));

        let total_numeros = 0;
        $.each(data,function (i,val){
            total_numeros += parseInt(val['total']);
            tableLayoutNumerosAtivos.addRow([(i + 1).toString(), val['name'], parseInt(val['total']).toLocaleString()]);
        });
        drawDataUsuarioAtivo.push(data);
        drawDataUsuarioAtivo.push(tableLayoutNumerosAtivos);
        tableLayoutNumerosAtivos.addRow(['Total', '', parseInt(total_numeros).toLocaleString()]);
        drawPieChartNumerosAtivos(drawDataUsuarioAtivo[0], drawDataUsuarioAtivo[1]);
    });
}

function drawPieChartUsuario(data, tableData){
    var dataArray = [
        ['Usuarios', 'Qtd. Disparo'],
    ];
    if(data) {
        for (var i = 0; i < data.length; i++) {
            var row = [data[i].name, parseInt(data[i].qtd)];
            dataArray.push(row);
        }
    }
    var options = {
        width: 390,
        height: 400,
        'chartArea': {'width': '70%', 'height': '70%'},
    };

    var chart = new google.visualization.PieChart(document.getElementById('pie_chart_usuarios'));
    var data = google.visualization.arrayToDataTable(dataArray);
    
    chart.draw(data, options);
    if(tableUsuarios) tableUsuarios.draw(tableData, {allowHtml: true, width: '100%', height: '100%', sort: 'disable'});
}

function drawPieChartNumerosAtivos(data, tableData){
    var dataArray = [
        ['Usuarios', 'Qtd. Numeros'],
    ];
    if(data) {
        for (var i = 0; i < data.length; i++) {
            var row = [data[i].name, parseInt(data[i].total)];
            dataArray.push(row);
        }
    }
    var options = {
        width: 390,
        height: 400,
        'chartArea': {'width': '70%', 'height': '70%'},
    };

    var chart = new google.visualization.PieChart(document.getElementById('pie_chart_numeros_ativos'));
    var data = google.visualization.arrayToDataTable(dataArray);
    
    chart.draw(data, options);
    if(tableNumerosAtivos) tableNumerosAtivos.draw(tableData, {allowHtml: true, width: '100%', height: '100%', sort: 'disable'});
}

function buscarDemonstracaoEstado(){
    $.getJSON("/campanhas/analise_dados?tipo=DEMONSTRACAO_ESTADO" +
      "&data_inicio=" + $('#data_inicio').val() +
      "&data_fim=" + $('#data_fim').val(), function(data) {
        let qtd_total = 0;
        var tableLayoutDemonstracaoEstado = new google.visualization.DataTable();
        tableLayoutDemonstracaoEstado.addColumn('string', 'Estados');
        tableLayoutDemonstracaoEstado.addColumn('string', 'Totais');
        tableDemonstracaoEstado = new google.visualization.Table(document.getElementById('tableDemonstracaoEstado'));
        
        $.each(data, function(i, val) {
            tableLayoutDemonstracaoEstado.addRow([val['sigla'].toLocaleString(), val['qtd_total']]);
            qtd_total += parseInt(val['qtd_total']);
        });
        tableLayoutDemonstracaoEstado.addRow(['Total', qtd_total.toLocaleString()]);

        if(tableDemonstracaoEstado && tableLayoutDemonstracaoEstado) tableDemonstracaoEstado.draw(tableLayoutDemonstracaoEstado, {allowHtml: true, width: '100%', height: '100%', sort: 'disable'});
    });
}

function buscarDemonstracaoSolicitante() {
    $.getJSON("/campanhas/analise_dados?tipo=DEMONSTRACAO_SOLICITANTE" +
      "&data_inicio=" + $('#data_inicio').val() +
      "&data_fim=" + $('#data_fim').val(), function(data) {
        var tableLayoutDemonstracaoSolicitante = new google.visualization.DataTable();
        tableLayoutDemonstracaoSolicitante.addColumn('string', 'Solicitantes');
        tableLayoutDemonstracaoSolicitante.addColumn('string', 'Quantidades');
        tableLayoutDemonstracaoSolicitante.addColumn('string', 'Estados');
        tableDemonstracaoSolicitante = new google.visualization.Table(document.getElementById('tableDemonstracaoSolicitante'));
        let rowsSolicitante = [];
        let name;
        let qtdTotalUsuario = 0;
        let sigla = '';
        $.each(data, function(i, val) {
            if (!name) name = val['name'];
            if (name === val['name']) {
                qtdTotalUsuario += parseInt(val['qtd_total']);
                sigla += `${val['sigla']}: ${val['qtd_total']}${(i + 1 < data.length && name === data[i + 1]['name']) ? ', ' : ''}`;
                if (i + 1 === data.length || name !== data[i + 1]['name']) {
                    //Verifica se o row atual é o último desse mesmo usuário
                    rowsSolicitante.push([name, qtdTotalUsuario.toLocaleString(), sigla]);
                }
            } else {
                name = val['name'];
                qtdTotalUsuario = parseInt(val['qtd_total']);
                sigla = `${val['sigla']}: ${val['qtd_total']}${(i + 1 < data.length && name === data[i + 1]['name']) ? ', ' : ''}`;
                if (i + 1 === data.length || name !== data[i + 1]['name']) {
                    rowsSolicitante.push([name, qtdTotalUsuario.toLocaleString(), sigla]);
                }
            }
        });
        rowsSolicitante.sort(function(a, b) {
            return parseInt(b[1].replace(/\D/g, '')) - parseInt(a[1].replace(/\D/g, ''));
        });
  
        $.each(rowsSolicitante, function(i, row) {
            tableLayoutDemonstracaoSolicitante.addRow(row);
        });
  
        if (tableDemonstracaoSolicitante && tableLayoutDemonstracaoSolicitante) {
            tableDemonstracaoSolicitante.draw(tableLayoutDemonstracaoSolicitante, {allowHtml: true, width: '100%', height: '100%', sort: 'disable'});
        }
  
        rowsSolicitante = [];
        name = null;
        qtdTotalUsuario = null;
        sigla = null;
    });
}

function buscarEmpresasSimplesNacional() {
    $.getJSON("/campanhas/simples_nacional?tipo=JOB0" +
      "&data_inicio=" + $('#data_inicio').val(), function(data) {
        var tableLayoutEmpresaSimples= new google.visualization.DataTable();
        tableLayoutEmpresaSimples.addColumn('string', 'Total de empresas');
        tableLayoutEmpresaSimples.addColumn('string', 'Disparos feitos no dia');
        tableLayoutEmpresaSimples.addColumn('string', 'Saldo restante');
        tableSimplesNacional = new google.visualization.Table(document.getElementById('tableSimplesNacional'));
        tableLayoutEmpresaSimples.addRow([data[0].total, data[0].ligados, data[0].restantes])
        if(tableSimplesNacional) tableSimplesNacional.draw(tableLayoutEmpresaSimples, {allowHtml: true, width: '100%', height: '100%', sort: 'disable'});
    });
}

function buscarInfoNumeros(){
    $.getJSON("/campanhas/analise_dados?tipo=INFO_NUMEROS"
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val(), function(data) {
        var tableLayoutNumeros = new google.visualization.DataTable();
        tableLayoutNumeros.addColumn('string', 'Num. iniciados no dia');
        tableLayoutNumeros.addColumn('string', 'Novos num. cadastrados');
        tableLayoutNumeros.addColumn('string', 'Num. banidos');
        tableLayoutNumeros.addColumn('string', 'Saldo');
        tableNumeros = new google.visualization.Table(document.getElementById('tableNumeros'));
        const inicio = parseInt(data[0].qtd_numero_inicial);
        const cadastrado = parseInt(data[0].qtd_numeros_cadastrados);
        const banido = parseInt(data[0].qtd_numero_banido);
        const qtd_numero_final = ((inicio + cadastrado) - banido).toString();
        tableLayoutNumeros.addRow([data[0].qtd_numero_inicial, data[0].qtd_numeros_cadastrados, data[0].qtd_numero_banido, qtd_numero_final]);
        drawTabelaNumeros(tableLayoutNumeros)
    });
}

function drawTabelaNumeros(tableData){
    if(tableNumeros) tableNumeros.draw(tableData, {allowHtml: true, width: '100%', height: '100%', sort: 'disable'});
}

function buscarCampanhasFinalizadas(){
    $.getJSON("/campanhas/by_status?tipo=FINALIZADAS"
        + "&estado_id=" + $('#estado_id').val()
        + "&usuario_id=" + $('#usuario_id').val()
        + "&telefone_id=" + $('#telefone_id').val()
        + "&data_inicio=" + $('#data_inicio').val()
        + "&data_fim=" + $('#data_fim').val(), function(data) {
        $("#body_table_campanha_finalizadas tr").remove();
        $('#tab3').text('Finalizadas (' + data.length + ')')
        let total_geral = 0;
        let total_enviado = 0;
        let total_erro = 0;
        let total_ignorado = 0;
        $.each(data,function (i,val){
            total_geral += parseInt(val['qtd_total']);
            total_enviado += parseInt(val['qtd_enviado']);
            total_erro += parseInt(val['qtd_erros']);
            total_ignorado += parseInt(val['qtd_ignorado']);
            addLineTabelaFinalizadas(val['numero'], val['nome'], val['job'], val['sigla'], (val['tempo_total'] && val['tempo_total'] > 0 ? (val['tempo_total']/60) + " min" : val['tempo_espera'] )
            , val['qtd_total'], val['qtd_enviado'], val['qtd_erros'], val['updated_at'], val['numero_status'], val['banido'],false)
        });
        addLineTabelaFinalizadas('Total', '', '', '', '', total_geral,
            total_enviado, total_erro, total_ignorado, '','', '', true);
    });
}

function trocaEmpresaUltimaCampanha(ultimaCampanhaHistorico){
    const dataAtual = moment().format("DD/MM/YYYY");
    const dataParametro = moment(Date(ultimaCampanhaHistorico.updated_at)).format("DD/MM/YYYY");
    let diaAtual = dataAtual === dataParametro;

    if (!diaAtual)
        return;

    $(`${current_campanha.modal} #empresa_id`).val(ultimaCampanhaHistorico.empresa_id).prop('selected', true).trigger('chosen:updated');
}

var table;
function buscarHistoricoNumero(){
    $.getJSON("/campanhas/by_status?tipo=FINALIZADAS_ANDAMENTO"
    + "&data_inicio=" + $(`${current_campanha.modal} #data_inicio_modal`).val()
    + "&data_fim=" + $(`${current_campanha.modal} #data_fim_modal`).val()
    + "&numero_id=" + optionSelect.val(), function(data) {
        $(`${current_campanha.modal} ${current_campanha.table} tr`).remove();
        total_disparos = 0;
        total_enviado = 0;
        total_erro = 0;
        if (table) table.clear().destroy();
        table = $(`${current_campanha.modal} ${current_campanha.table}`).closest('table').DataTable({
            "order": [[6, 'desc']],
            "language": {
                "url": "//cdn.datatables.net/plug-ins/1.10.16/i18n/Portuguese-Brasil.json"
            }
        });
        numeroCreatedAt = data.pop();
        ultimaCampanhaHistorico = data[0];
        if(ultimaCampanhaHistorico)
            trocaEmpresaUltimaCampanha(ultimaCampanhaHistorico);

        now = moment(Date.now());
        before = moment(numeroCreatedAt.created_at);
        difference = now.diff(before, 'days');
        $((current_campanha.modal) + ' #selected_value').text(`Ativo a ${difference} dias`);
        $.each(data,function (i,val){
            if (val['qtd_total']) total_disparos += parseInt(val['qtd_total']);
            if (val['qtd_enviado']) total_enviado += parseInt(val['qtd_enviado']);
            if (val['qtd_erros']) total_erro += parseInt(val['qtd_erros']);
            table.row.add([
                val['job'],
                val['sigla'],
                val['tempo_total'] ? (val['tempo_total']/60) + " min" : val['tempo_espera'],
                val['qtd_enviado'] ? val['qtd_enviado'] - val['qtd_erros'] : '0',
                val['qtd_erros'] ? val['qtd_erros'] : '0',
                val['qtd_total'] ? val['qtd_total'] : '0',
                val['previsao'] ? "ANDAMENTO" : val['updated_at'],
            ]).draw( false );
        });
        $(`${current_campanha.modal} #qtd_disparo_enviado`).val(total_enviado - total_erro);
        $(`${current_campanha.modal} #qtd_disparo_erro`).val(total_erro);
        $(`${current_campanha.modal} #qtd_disparo_total`).val(total_disparos);
        buscarCampanhasExistente()
    });
}

function buscarCampanhasExistente(){
    $.getJSON("/campanhas/by_status?tipo=ANDAMENTO_AGUARDANDO" + 
    "&numero_id=" + optionSelect.val(),
    function(data) {
        campanhasAndamento = [];
        $.each(data,function (i,val){
            if(val['previsao'] || val['agendado_at'] || val['created_at']) {
                campanhasAndamento.push({
                    qtd_total: val['qtd_total'],
                    data_inicio: val['created_at'],
                    data_fim: ( val['previsao'] ? val['previsao'] : (
                        val['agendado_at'] ? moment(val['agendado_at']).format('DD/MM/YYYY HH:mm') : val['created_at']
                    )),
                    status: val['previsao'] ? 'ANDAMENTO' : 'AGUARDANDO'
                })
            } 
        });
        if(campanhasAndamento.length > 0) {
            tooltipData = '';
            $('#qtd_total_campanha').text(`(${data.length})`);
            $("#tooltip-1").css("visibility","visible")
            campanhasAndamento.forEach(campanha => {
                tooltipData += `<tr class="table-fixed">`
                tooltipData += `<td> ${campanha.qtd_total} </td>`;
                tooltipData += `<td> ${campanha.data_inicio} </td>`;
                tooltipData += `<td> ${campanha.data_fim} </td>`;
                tooltipData += `<td> ${campanha.status} </td>`;
                tooltipData += `</tr>`
            })
        }
    });
}

function reenviarCampanha(id){
    $.ajax({
        url: '/campanhas/reenviar_campanha/',
        data: getFormReenviarCampanha(id),
        processData: false,
        contentType: false,
        type: 'POST',
        success: function (data) {
            console.log({data})
            if(data && data.error){
                exibirMsg(data.error);
            } else if (data && data.success){
                exibirMsg(data.success);
                window.location.reload();
            }
        },error: function(data){
            console.log({data})
            exibirErro(`Erro ao reenviar campanha: ${data.status + data.statusText}`);
        }
    });
}
function addLineTabelaFinalizadas(numero, nome, job, sigla, tempoespesa, qtd_total, qtd_enviado, qtd_erros, updated_at, numero_status, banido, istotal){
    $('#body_table_campanha_finalizadas').append(
        '<tr class="' + (istotal ? 'totalTabelaCampanha' : '') + '"style=" background-color:' + definirCorLinha(numero_status, banido)+ '">' +
        '<td class="tableHeadCampanha">' + numero + '</td>' +
        '<td>' + nome + '</td>' +
        '<td class="tableHeadCampanha">' + job + '</td>' +
        '<td class="tableHeadCampanha">' + sigla + '</td>' +
        '<td class="tableHeadCampanha">' + tempoespesa + '</td>' +
        '<td class="tableHeadCampanha">' + qtd_total + '</td>' +
        '<td class="tableHeadCampanha">' + (qtd_enviado - qtd_erros) + '</td>' +
        '<td class="tableHeadCampanha">' + qtd_erros + '</td>' +
        '<td class="tableHeadCampanha">' + updated_at + '</td>' +
        '</tr>');
}

function getFormCampanha(){
    var form = new FormData();
    const tempo_total = $("#modal_nova_campanha #tempo_total").val()
    if(tempo_total) segundos = Number(tempo_total) * 60
    else segundos = '';
    form.append('empresa_id', $("#modal_nova_campanha #empresa_id").val());
    form.append('whatsapp_numero_id', $("#modal_nova_campanha #whatsapp_numero_id").val());
    form.append('tipo', $("#modal_nova_campanha #tipo").val());
    form.append('is_resposta_automatica', $("#modal_nova_campanha #is_resposta_automatica").is(':checked') ? $("#modal_nova_campanha #is_resposta_automatica").val() : false);
    form.append('numero_job', $("#modal_nova_campanha #numero_job").val());
    form.append('quantidade', $("#modal_nova_campanha #quantidade").val());
    form.append('tempo_total', (segundos));
    form.append('tipo_disparo', $("#modal_nova_campanha #tipo_disparo").val());
    form.append('tempo_espera', $("#modal_nova_campanha #tempo_espera").val());     
    form.append('abordagem_inicial_especifica', $("#modal_nova_campanha #is_edit_abordagem_especifica").prop('checked', true) ? $("#modal_nova_campanha #texto_abordagem_padrao_especifica").val() : '');
    form.append('abordagem_resposta_especifica', $("#modal_nova_campanha #is_edit_resposta_especifica").prop('checked', true) ? $("#modal_nova_campanha #texto_abordagem_resposta_especifica").val() : '');
    form.append('palavra_chave_especifica', $("#modal_nova_campanha #is_edit_resposta_especifica").prop('checked', true) ? $("#modal_nova_campanha #texto_palavra_chave").val() : '');
    form.append('agendado_at', $("#modal_nova_campanha #data_disparo").val());
    form.append('tempo_ocultacao', $("#modal_nova_campanha #tempo_ocultacao").val());
    return form;
}

function getFormPrimeiraCampanha(){
    var form = new FormData();
    const tempo_total = $("#modal_primeira_campanha #tempo_total").val()
    if(tempo_total) segundos = Number(tempo_total) * 60
    else segundos = '';
    form.append('empresa_id', $("#modal_primeira_campanha #empresa_id").val());
    form.append('whatsapp_numero_id', $("#modal_primeira_campanha #whatsapp_numero_id").val());
    form.append('tipo', $("#modal_primeira_campanha #tipo").val());
    form.append('is_resposta_automatica', $("#modal_primeira_campanha #is_resposta_automatica").is(':checked') ? $("#modal_primeira_campanha #is_resposta_automatica").val() : false);
    form.append('numero_job', $("#modal_primeira_campanha #numero_job").val());
    form.append('quantidade', $("#modal_primeira_campanha #quantidade").val());
    form.append('tempo_total', (segundos));
    form.append('tipo_disparo', $("#modal_primeira_campanha #tipo_disparo").val());
    form.append('tempo_espera', $("#modal_primeira_campanha #tempo_espera").val());
    form.append('abordagem_inicial_especifica', $("#modal_primeira_campanha #is_edit_abordagem_especifica").prop('checked', true) ? $("#modal_primeira_campanha #texto_abordagem_padrao_especifica").val() : '');
    form.append('abordagem_resposta_especifica', $("#modal_primeira_campanha #is_edit_resposta_especifica").prop('checked', true) ? $("#modal_primeira_campanha #texto_abordagem_resposta_especifica").val() : '');
    form.append('palavra_chave_especifica', $("#modal_primeira_campanha #is_edit_resposta_especifica").prop('checked', true) ? $("#modal_primeira_campanha #texto_palavra_chave").val() : '');
    form.append('agendado_at', $("#modal_primeira_campanha #data_disparo").val());
    form.append('tempo_ocultacao', $("#modal_primeira_campanha #tempo_ocultacao").val());
    return form;
}

function getFormCampanhaMassa(){
    var form = new FormData();
    const usersSelected = $(`${current_campanha.modal} #user_id`).find('option:selected').map(function() {
        return $(this).val();
    }).get();

    const tempo_total = $(`${CAMPANHA.ModalCampanhaMassa} #tempo_total`).val()
    if(tempo_total) segundos = Number(tempo_total) * 60
    else segundos = '';
    form.append('empresa_id', $(`${CAMPANHA.ModalCampanhaMassa} #empresa_id`).val());
    form.append('user_ids', usersSelected);
    form.append('tipo', 'CAPTACAO_MASSA');
    form.append('is_resposta_automatica', $(`${CAMPANHA.ModalCampanhaMassa} #is_resposta_automatica`).is(':checked') ? $(`${CAMPANHA.ModalCampanhaMassa} #is_resposta_automatica`).val() : false);
    form.append('numero_job', $(`${CAMPANHA.ModalCampanhaMassa} #numero_job`).val());
    form.append('quantidade', $(`${CAMPANHA.ModalCampanhaMassa} #quantidade`).val());
    form.append('tempo_total', (segundos));
    form.append('tipo_disparo', $(`${CAMPANHA.ModalCampanhaMassa} #tipo_disparo`).val());
    form.append('tempo_espera', $(`${CAMPANHA.ModalCampanhaMassa} #tempo_espera`).val());
    form.append('abordagem_inicial_especifica', $(`${CAMPANHA.ModalCampanhaMassa} #is_edit_abordagem_especifica`).prop('checked', true) ? $(`${CAMPANHA.ModalCampanhaMassa} #texto_abordagem_padrao_especifica`).val() : '');
    form.append('abordagem_resposta_especifica', $(`${CAMPANHA.ModalCampanhaMassa} #is_edit_resposta_especifica`).prop('checked', true) ? $(`${CAMPANHA.ModalCampanhaMassa} #texto_abordagem_resposta_especifica`).val() : '');
    form.append('palavra_chave_especifica', $(`${CAMPANHA.ModalCampanhaMassa} #is_edit_resposta_especifica`).prop('checked', true) ? $(`${CAMPANHA.ModalCampanhaMassa} #texto_palavra_chave`).val() : '');
    form.append('agendado_at', $(`${CAMPANHA.ModalCampanhaMassa} #data_disparo`).val());
    form.append('tempo_ocultacao', $(`${CAMPANHA.ModalCampanhaMassa} #tempo_ocultacao`).val());
    return form;
}

function getFormReenviarCampanha(id){
    var form = new FormData();
    form.append('campanha_id', id);
    return form;
}

function getFormPausarCampanha(id, pause) {
    var form = new FormData();
    form.append("id", id);
    form.append("pause", pause);
    return form;
}

function getFormPararCampanha(id) {
    var form = new FormData();
    form.append("id", id);
    return form;
}

function definirCorLinha(numero_status, banido) {
    if (banido == "true" || banido == 't') {
      if (numero_status.includes('DESCONECTADO')) {
        return '#ef27277d';
      } else {
        return '';
      }
    } else {
      if (numero_status.includes('DESCONECTADO')) {
        return '#fbc98d';
      } else {
        return '';
      }
    }
}

function pausarCampanha(id) {
  $.ajax({
    url: "/campanhas/pausar/",
    data: getFormPausarCampanha(id, true),
    processData: false,
    contentType: false,
    type: "POST",
    success: function (data) {
        if (data)
            $(`#pause-button-${id}`).replaceWith(`<button id="retomar-button-${id}" class="btn btn-sm btn-primary" onClick="retomarCampanha(${id})" title="Resumir Campanha"><span class="fa fa-play"></span></button>`).trigger('chosen:updated');
        else
            console.error(data)
    },
    error: function (data) {
      console.log({ data });
      exibirErro(`Erro ao pausar campanha: ${data.status + data.statusText}`);
    },
  });
}

function retomarCampanha(id) {
    $.getJSON(`/campanhas/${id}/previsao_termino/`, function (data_previsao) {
        $.ajax({
            url: "/campanhas/pausar/",
            data: getFormPausarCampanha(id, false),
            processData: false,
            contentType: false,
            type: "POST",
            success: function (data) {
                if (data){
                    $(`#retomar-button-${id}`).replaceWith(`<button id="pause-button-${id}" class="btn btn-sm btn-primary" onClick="pausarCampanha(${id})" title="Pausar Campanha"><span class="fa fa-pause"></span></button>`).trigger('chosen:updated');
                    $(`#previsao-${id}`).replaceWith(`<td class="tableHeadCampanha" id="previsao-${id}">${data_previsao[0].previsao}</td>`).trigger('chosen:updated');                    
                } else {
                    console.error({data});
                }},
                error: function (data) {
                    exibirErro(`Erro ao retomar campanha: ${data.status + data.statusText}`);
                },
        });
    });
}

function pararCampanha(id) {
    swal({
        title: "Deseja encerrar essa campanha?",
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
                url: "/campanhas/parar/",
                data: getFormPararCampanha(id, false),
                processData: false,
                contentType: false,
                type: "POST",
                success: function (data) {
                    if (data)
                        window.location.reload();
                    else
                        console.error({data});
                }, error: function (data) {
                    exibirErro(`Erro ao parar campanha: ${data.status + data.statusText}`);
                },
            });
        }
    });
}

function pausarCampanhas(pause) {
    swal({
        title: `Deseja ${pause ? 'pausar' : 'iniciar'} todas as campanhas?`,
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
                url: "/campanhas/pausar_todas/",
                data: { pause: pause },
                type: "POST",
                success: function (data) {
                    if (data)
                        window.location.reload();
                    else
                        console.error({data});
                }, error: function (data) {
                    exibirErro(`Erro ao parar campanha: ${data.status + data.statusText}`);
                },
            });
        }
    });
}

function pararCampanhas() {
    swal({
        title: `Deseja parar todas as campanhas?`,
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
                url: "/campanhas/parar_todas/",
                type: "POST",
                success: function (data) {
                    if (data)
                        window.location.reload();
                    else
                        console.error({data});
                }, error: function (data) {
                    exibirErro(`Erro ao parar campanha: ${data.status + data.statusText}`);
                },
            });
        }
    });
}