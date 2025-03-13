//= require chosen/chosen.jquery.js
//= require typehead/bootstrap3-typeahead.min.js
//= require mask_plugin/jquery.mask.js
//= require validate/jquery.validate.min.js
//= require jquery-ui/jquery-ui.min.js
//= require datapicker/bootstrap-datepicker.js
//= require ligacoes_typeahead.js
//= require qtip/jquery.qtip.min.js
//= require fullcalendar/fullcalendar.min.js
//= require fullcalendar/fullcalendar-rightclick.js
//= require tagify/jQuery.tagify.min.js

var TAGS;
$(document).ready(function(){

    $.getJSON('/perguntas/get_tags', function(data) {
        TAGS = data;
    });

    //--------------QDO CARREGA A TELA----------------//
    // Verifica se tem um parametro de cnpj na url
    const urlParams = new URLSearchParams(window.location.search);
    const valorCNPJ = urlParams.get('cnpj_contatos_realizados');
    if (valorCNPJ){
        const inputElement = document.getElementById('cliente_cnpj');
        inputElement.value = valorCNPJ
        setTimeout(() => {
            $('#btnBuscarCliente').click();
        }, 500);
    }

    verificarAtendimento();
    buscar_perguntas();
    atualizarSaldo();
    atualizarCnaes();
    $('.chosen-select').chosen({width: "100%"});
    $('#agenda_data_fim').mask('00/00/0000 00:00');
    $('#agenda_data_inicio').mask('00/00/0000 00:00');

    $('#groupLigacaoAtendida').hide();
    $('#groupLigacaoIniciada').hide();
    $('#retorno_data_agendamento_retorno').mask('00/00/0000 00:00');
    $('#form_modal_ligacao #ligacao_data_fim').mask('00/00/0000 00:00');
    $('#form_modal_ligacao #ligacao_data_inicio').mask('00/00/0000 00:00');
    $('#sistema_terceiro_mensalidade').maskMoney({thousands:'.', decimal:','});

    if($('#cliente_retorno_id').val() != "" && $('#cliente_retorno_id').val() != undefined){
        getClienteRetorno($('#cliente_retorno_id').val(), function(retorno){
            window.history.pushState({}, document.title, "/" + "ligacoes/ligacao");
        });
    }

    $('#data_fim_q #data_inicio_lteq').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });

    $('#data_inicio_q #data_inicio_gteq').datetimepicker({
        format: 'dd/mm/yyyy hh:ii',
        language: 'pt-BR',
        autoclose: true,
        todayBtn: true,
        pickerPosition: "bottom-left"
    });
    
    $('#cliente_cnpj, #cliente_telefone, #cliente_telefone2, #cliente_email').on('change', function(){
        if($('#cliente_id').val() == "") {
            $('#btnBuscarCliente').show();
        }else {
            $('#btnBuscarCliente').hide();
        }
    });

   $('#cliente_cnpj, #cliente_razao_social, #cliente_contato, #cliente_contato1, #cliente_telefone, #cliente_email').keypress(function(){
        if($('#cliente_id').val() == "") {
            $('#btnSalvarClienteManual').show();;
        }else {
            $('#btnSalvarClienteManual').hide();
        }
    });

    $('#datetimepicker2').datetimepicker({
        format: 'dd/mm/yyyy hh:ii',
        language: 'pt-BR',
        autoclose: true,
        todayBtn: true,
        pickerPosition: "bottom-left"
    });

    $('#btnBuscarCliente').on('click', function () {
        var parametros = '';
        var primeiroParametro = true;
        if($('#cliente_cnpj').val() != ''){
            parametros = '?cnpj=' + $('#cliente_cnpj').val();
            primeiroParametro = false
        }
        if($('#cliente_telefone').val() != ''){
            if(primeiroParametro) {
                parametros = '?telefone=' + $('#cliente_telefone').val();
                primeiroParametro = false
            }else parametros = parametros + '&telefone=' + $('#cliente_telefone').val();
        }
        if($('#cliente_telefone2').val() != ''){
            if(primeiroParametro) {
                parametros = '?telefone=' + $('#cliente_telefone2').val();
                primeiroParametro = false
            }else parametros = parametros + '&telefone=' + $('#cliente_telefone2').val();
        }
        if($('#cliente_email').val() != ''){
            if(primeiroParametro) {
                parametros = '?email=' + $('#cliente_email').val();
            }else parametros = parametros +  '&email=' + $('#cliente_email').val();
        }
        $.getJSON('/clientes/find_cliente_params' + parametros, function(data) {
            limparTela();
            $('#btnSalvarClienteManual').hide();
            $('#btnBuscarCliente').hide();
            getDadosCliente(data);
            setClienteEmAtendimento(data['id']);
        });
    });

    $('#setObstelefone2').popover({
        placement: 'left',
        title: 'Observação',
        html:true,
        content:  getHtml('telefone2'),
        container: 'body'
    }).on('click', function(data){
        var telefone = $('#cliente_telefone2').val();
        $('.btnRegistrar').click(function(){
            var ligacao_obs = $('#ligacao_observacoes');
            if(ligacao_obs.val() == '')
                ligacao_obs.val(telefone + ' - ' + $("#text-area-obstelefone2").val());
            else ligacao_obs.val(ligacao_obs.val() + ' / ' + telefone + ' - ' + $("#text-area-obstelefone2").val());

            $('#setObstelefone2').popover('hide')
        })
    });

    $('#setObstelefone').popover({
        placement: 'left',
        title: 'Observação',
        html:true,
        content:  getHtml('telefone'),
        container: 'body'
    }).on('click', function(data){
        var telefone = $('#cliente_telefone').val();
        $('.btnRegistrar').click(function(){
            var ligacao_obs = $('#ligacao_observacoes');
            if(ligacao_obs.val() == '')
                ligacao_obs.val(telefone + ' - ' + $("#text-area-obstelefone").val());
            else ligacao_obs.val(ligacao_obs.val() + ' / ' + telefone + ' - ' + $("#text-area-obstelefone").val());

            $('#setObstelefone').popover('hide')
        })
    });

    var regex = new RegExp('[^ 0-9a-zA-Zàèìòùáéíóúâêîôûãõ\b-]', 'g');
    // repare a flag "g" de global, para substituir todas as ocorrências
    $('#escritorio_nome_fantasia').bind('input', function () {
        $(this).val($(this).val().replace(regex, ''));
    });

    if($('#escritorio_id').val() != ''){
        $("#novoTelefone").show();
    }else{
        $("#novoTelefone").hide();
    }

    $('#proposta_valor_mensalidade').maskMoney({thousands:'.', decimal:','});
    $('#proposta_valor_implantacao').maskMoney({thousands:'.', decimal:','});
    $('#proposta_valor_parcelas').maskMoney({thousands:'.', decimal:','});
    $('#parcelas').hide();
    $('#meses_fidelidade').hide(); //campo oculto inicialmente

    //------------------------ON CLICK-----------------------------------//
    $("#cliente_status_id").change(function() {
        $.getJSON("/status/" + $(this).val(), function(data) {
            $('#status_fechamento').val(data['fechamento']);
        });
    });

    $('#btnFinalizarModalTipoFechamento').on('click', function () {

        var bool = false;
        $('#perguntas').find('textarea').each(function (key, value) {
           if($(value).val() == '' || $(value).val().length < 10){
               bool = true;
           }
        });

        if(bool){
            exibirErro('É obrigatório responder todas as perguntas com no minímo 10 caracteres.');
            return;
        }

        if(($("#cliente_tipo_fechamento_id").val() == null || $("#cliente_tipo_fechamento_id").val() == '')){
            exibirErro('É obrigatório informar o tipo fechamento.');
            return;
        }

        $('#modalFechamento').modal('toggle');
        abrirModalAgenda('fechamento');        
    });

    $('#btnSalvarAgendamento').on('click', function(){ finalizarAgenda();})

    $('#formCaptacaoAutomatizada').on('submit', function() {
        const botao = $('#btnEnviarCaptacaoAutomatizada');
        botao.prop('disabled', true);
        botao.html('<span id="loading_captacao_automatizada" class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Enviando...');

        return true;
    });

    $('#btnIniciarLigacao').on('click', function () {
        $('#btnIniciarLigacao').hide();
        $('#groupLigacaoIniciada').show();
        $('#btnCancelarLigacao').hide();
        $('#lblLigacaoEmAndamento').show();

        if($('#ligacao_id').val() == "" || $('#ligacao_id').val() == undefined)
            novaLigacao();
    });

    $('#btnSalvarClienteManual').on('click', function(){ salvarClienteManual(); })

    $('#btLigacaoAtendida').on('click', function(){ setStatusLigacao(5);})

    $('#btNumeroOcupado').on('click', function(){ setStatusLigacao(3); })

    $('#btNumeroErrado').on('click', function(){ setStatusLigacao(2); })

    $('#btnAgendarLigacao').on('click', function(){ agendarRetorno() })

    $('#btnSalvarDataRetorno').on('click', function(){ salvarDataRetorno(); return false; })

    $('#btFinalizarLigacao').on('click', function(){ finalizarLigacao(); })

    $('#btnCancelarLigacao').on('click', function(){ cancelarAtendimento(); })

    $('#btnInserirCnaeBlackList').on('click', function(){ incluirCnaeBlackList($("#cliente_cnae_id").val()); return false;})
    $('#btnVerCnaes').on('click', function(){ $('#cnaes_cliente').modal('show'); return false;})

    $('#btnVerTodosContatos').on('click', function(){ $('#contatos_cliente').modal('show'); return false;})

    $('#btnPossuiSistema').on('click', function(){
        $('#sistema_terceiro_cliente_id').val($('#cliente_id').val());
        $('#sistema_terceiro_cliente').val($('#cliente_razao_social').val());
        $('#sistema_terceiros').modal('show');
    });

    $('#btnSalvarSistemaTerceiros').on('click', function(){ salvarSistemaTerceiro(); })

    $('#btnProxLigacao').on('click', function(){
        buscarProximoCliente()
    })

    $('.editarLigacao').on('click', function(){
        editarLigacao($(this)["0"].attributes[3].value)
    });

    $('#btnSalvarLigacaoModal').on('click', function(){
        salvarModalLigacao();
    });

    $('#btnSalvarNovoEscritorio').on('click', function(){ salvarEscritorioContabil(); })

    $('#btnEscritorioContabil').on('click', function(){
        $('#escritorio').modal('show');
        if($('#escritorio_id').val() == ''){
            $("#escritorio_telefone").val($('#cliente_telefone').val())
        }
    });

    $('#btnAdicionarNovoTelefone').on('click', function () {
        if($('#escritorio_novo_telefone').val() == ''){
            exibirErro('Informe o telefone.');
        }else{
            $.getJSON('/escritorios/add_novo_telefone?telefone=' + $('#escritorio_novo_telefone').val() + '&escritorio_id=' + $("#escritorio_id").val(), function(data) {
                exibirMsg('Contato adicionado.');
                $('#escritorio_novo_telefone').val('')
            });
        }
        return false;
    });    

    if($('#obrigacao').val() != "" && $('#obrigacao').val() != undefined){
        window.history.pushState({}, document.title, "/" + "ligacoes/ligacao");

        swal({
            title: "Atenção",
            text: 'Você possui um cliente em atendimento.',
            type: "warning",
            customClass: 'swal-width'
        }).then(function(result) {

        })
    }

    $('#modalConfimarSolicitacaoBanco #btnSolicitarBanco').on('click', function () {
        if($('input[name="solicitou_banco"]:checked').val() == 'true'){            
            $('#modalConfimarSolicitacaoBanco').modal('hide');
            $.getJSON('/solicitacao_bancos/get_dados_modal?cliente_id=' + $("#cliente_id").val() + '&solicitou=true', function(data) {
                console.log(data);
                //inserir values
                $('#modalSolicitarBancoFechamento #solicitar_banco_cliente').val(data['razao_social']);
                $('#modalSolicitarBancoFechamento #solicitar_banco_cidade').val(data['cidade']['nome']);
                $('#modalSolicitarBancoFechamento #solicitar_banco_sistema').val(data['fechamento']['proposta']['sistema']);
                $('#modalSolicitarBancoFechamento #solicitar_banco_status').val(data['fechamento']['status']['descricao']);
                $('#modalSolicitarBancoFechamento #solicitar_banco_socio').val(data['socio_admin']);

                $('#modalSolicitarBancoFechamento').modal('show'); 
            });
             
        }else {
            $.getJSON('/solicitacao_bancos/get_dados_modal?cliente_id=' + $("#cliente_id").val(), function(data) {
            });

            $('#modalConfimarSolicitacaoBanco').modal('hide');
            window.location.href = "/ligacoes/ligacao";            
        }       
        
    });

    $('#modalSolicitarBancoFechamento #cancelarBanco').on('click', function () {
        $.getJSON('/solicitacao_bancos/get_dados_modal?cliente_id=' + $("#cliente_id").val(), function(data) {
        });

        $('#modalSolicitarBancoFechamento').modal('hide');
        window.location.href = "/ligacoes/ligacao";
    });

    $('#modalSolicitarBancoFechamento #btnSalvarBanco').on('click', function () {
        if  ($("#modalSolicitarBancoFechamento #solicitar_banco_socio").val() == null || $("#modalSolicitarBancoFechamento #solicitar_banco_socio").val() == '')
        {
            exibirErro('Sócio administrador deve ser informado.');
            return
        }
        $.ajax({
            url: '/solicitacao_bancos/create_banco',
            data: {cliente_id: $("#cliente_id").val(), tipo: $('#modalSolicitarBancoFechamento #solicitar_banco_tipo').val(),
                    responsavel: $("#modalSolicitarBancoFechamento #responsavel").val(),
                    socio_admin: $("#modalSolicitarBancoFechamento #solicitar_banco_socio").val(),
                    local_banco: $("#modalSolicitarBancoFechamento #solicitar_banco_tipo_banco").val()},
            type: 'GET',
            success: function (data) {
                window.location.href = "/ligacoes/ligacao";   
                exibirMsg('Banco solicitado');
            },error: function(data){
                exibirErro(data);
            }
        });
    });

    $('#adicionarCnpj').on('click', function() {
        // Abre uma nova aba
        const cliente_cnpj = $('#cliente_cnpj').val();
        let inputTest = document.createElement("textarea");
        inputTest.value = cliente_cnpj;
        //Anexa o elemento ao body
        document.body.appendChild(inputTest);
        //seleciona todo o texto do elemento
        inputTest.select();
        //executa o comando copy
        document.execCommand('copy');
        //remove o elemento
        document.body.removeChild(inputTest);
        window.open('https://consopt.www8.receita.fazenda.gov.br/consultaoptantes', '_blank');
    });

    $('#captacao_job, #captacao_empresa').on('change', atualizarSaldo);
    $('#captacao_empresa').on('change', onChangeEmpresa);
});

$(document).on('ajax:success', '#formCaptacaoAutomatizada', function(event, data) {
    exibirMsg(data.message);
    const botao = $('#btnEnviarCaptacaoAutomatizada');
    botao.prop('disabled', false);
    const loading = $('#loading_captacao_automatizada');
    loading.remove();
    botao.html('<i class="fa fa-play"></i> captações')
});

$(document).on('ajax:error', '#formCaptacaoAutomatizada', function(event, xhr) {
    exibirErro(xhr.responseJSON.message);
    const botao = $('#btnEnviarCaptacaoAutomatizada');
    botao.prop('disabled', false);
    const loading = $('#loading_captacao_automatizada');
    loading.remove();
    botao.html('<i class="fa fa-play"></i> captações')
});

function atualizarCnaes() {
    addLoadingCnaes();
    buscarCnaesMaisVendidos().then((cnaes) => {
        if (cnaes.length > 0)
            mostrarCnaes(cnaes);
        removingLoadingCnaes();
    });
}

function mostrarCnaes(cnaes) {
    $('#captacao_cnae').empty();
    $.each(cnaes, function(index, cnae) {
        $('#captacao_cnae').append(new Option(`${index + 1} | ${cnae.descricao}`, cnae.id));
    });
    $('#captacao_cnae').trigger('chosen:updated');
}

function atualizarSaldo() {
    buscarSaldoAtualPorJob().then((saldo) => {
        mostrarSaldo(saldo);
    });
}

function mostrarSaldo(saldo) {
    $('label[for="captacao_saldo_job"]').text(`(Saldo: ${saldo})`)
}

function buscarCidadesPorEstado(estado_sigla = '') {
    $.ajax({
        url: '/ligacoes/buscar_cidades_por_estado',
        data: { estado_sigla: estado_sigla },
        processData: false,
        contentType: false,
        type: 'GET',
    });
}

function buscarSaldoAtualPorJob() {
    const job = $('#captacao_job').val();
    const empresa = $('#captacao_empresa').val();

    return new Promise((resolve) => {
        $.getJSON(`/importacoes/saldo_atual_por_job?empresa_id=${empresa}&job=${job}`, function (data) {
            if (data == null)
                data = 0;

            resolve(data);
        });
    })
}

function onChangeEmpresa() {
    buscarCidadesPorEstado();
    atualizarCnaes();
}

function buscarCnaesMaisVendidos() {
    const empresa = $('#captacao_empresa').val();

    return new Promise((resolve) => {
        $.getJSON(`/cnaes/top_vendidos?empresa_id=${empresa}`, function (data) {
            resolve(data);
        });
    });
}

function addLoadingCnaes() {
    const input = $('#captacao_cnae');
    $('label[for="captacao_cnae"]').html('Cnaes <span id="loading_captacao_cnae" class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>');
    input.prop('disabled', true).trigger("chosen:updated");
}

function removingLoadingCnaes() {
    const input = $('#captacao_cnae');
    $('label[for="captacao_cnae"]').html('Cnaes')
    input.prop('disabled', false).trigger("chosen:updated");
}


function alterarProposta(funcao, ativa) {
    if ($("#proposta_fidelidade").val() == 'true' && $("#proposta_meses_fidelidade").val() == ''){
        $('#error_meses_fidelidade').show();
        return false;
    }

    if ($("#proposta_data_pri_men").val() == ''){
        $('#error_pri_mensalidade').show();
        return false;
    }
    $.ajax({
        url: '/propostas/',
        data: getFormProposta(funcao, ativa),
        processData: false,
        contentType: false,
        type: 'POST',
        success: function (data) {
            recarregarPropostas(data);
            limparModalProposta();
            if(funcao == 'cadastro')
                $('#proposta').modal('toggle');
            exibirMsg('Proposta registrada.');
        },error: function(data){
            exibirErro(data);
        }
    });
}

function recarregarPropostas(data) {
    $("#body_table_proposta tr").remove();
    $.getJSON('/propostas/find_propostas?cliente_id=' + data['cliente_id'], function (data) {
        $.each(data, function( key, value ) {
            addRowPropostas(value);
        });
    });
}

function salvarSistemaTerceiro() {
    $('#form_sistema_terceiros').validate({
        rules: {
            'sistema_terceiro_cliente_id': {
                required: true
            },
            'sistema_terceiro_empresa': {
                required: true
            },
            'sistema_terceiro_sistema': {
                required: true
            },
            'sistema_terceiro_mensalidade': {
                required: true
            }
        },
        submitHandler: function (form) {
            event.preventDefault();
            $("#form_sistema_terceiros").validate();
            $.ajax({
                url: '/ligacoes/cadastrar_sistema_terceiro',
                data: getFormSistemaTerceiro(),
                dataType: 'json',
                processData: false,
                contentType: false,
                type: 'POST',
                success: function(data) {
                    $('#sistema_terceiros').modal('toggle');
                    $('#sistema_terceiro_id').val(data['id']);

                    exibirMsg('Registrado informações.');
                },
                error: function(data) {
                    exibirErro(data['responseText']);
                }
            });
            return false;
        }
    });
}



function incluirCnaeBlackList(cnae_id) {
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
            $.ajax({
                url: "/cnaes/" + cnae_id,
                data: { "cnae[blacklist]": "true"},
                dataType: 'json',
                type: 'PUT',
                success: function(data) {
                    exibirMsg('Cnae adicionado a blacklist.');
                },
                error: function(data) {
                    exibirErro(data);
                }
            });
        }
    });
}

function cancelarAtendimento() {
    $.ajax({
        url: "/clientes/" + $('#cliente_id').val() + "/cancelar_atendimento",
        dataType: 'json',
        processData: false,
        contentType: false,
        type: 'PUT',
        success: function(data) {
            window.location.href = "/ligacoes/ligacao";
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

function agendarRetorno() {
    var array = ['28', '7'];
    if(jQuery.inArray( $("#cliente_status_id").val(), array ) != -1 ) {
        $('#agendar_retorno #ObsLigacaoGroup').show();
        $("#agendar_retorno #retorno_obs_ligacao_retorno").val($('#ligacao_observacoes').val());
    }
    else 
        $('#agendar_retorno #ObsLigacaoGroup').hide();
    
    //se não for estatus demonstrou interesse ou ag. confirmação faz a validação normal
    if(jQuery.inArray( $("#cliente_status_id").val(), array ) == -1 ) {
        if(validarFinalizarLigacao())
            return;
    }

    $('#agendar_retorno').modal({backdrop: true, keyboard: true});

    var array = ['7', '1', '28'];
    var empresas = ['1', '3', '5'];
    //if(jQuery.inArray( $("#cliente_status_id").val(), array) != -1 &&  jQuery.inArray( $('#empresa_id').val(), empresas) == -1)
    if(jQuery.inArray( $("#cliente_status_id").val(), array) != -1)
        $('#agendar_retorno #negociadorGroup').show();
    else $('#agendar_retorno #negociadorGroup').hide();

    $('#agendar_retorno').modal('show');
}

$.validator.addMethod("brazilianDate", function(value, element) {
    return moment(value,"DD/MM/YYYY HH:mm").isValid()
}, "Data inválida");

function salvarDataRetorno() {
    atualizarCliente();

    if ($('#agendar_retorno #retorno_data_agendamento_retorno').val() == '' || !moment($('#agendar_retorno #retorno_data_agendamento_retorno').val(),"DD/MM/YYYY HH:mm").isValid()){
        exibirErro("Informe uma data válida.");
        return false;
    }

    if($("#cliente_status_id").val() == 28 && $('#agendar_retorno #retorno_obs_ligacao_retorno').val().length < 4){
        exibirErro('É obrigatório informar uma observação de pelo menos 3 caracteres na ligação.');
        return false;
    }

    if($("#cliente_status_id").val() == 7 && $('#agendar_retorno #retorno_obs_ligacao_retorno').val().length < 15){
        exibirErro('É obrigatório informar uma observação de pelo menos 15 caracteres na ligação.');
        return false;
    }

    /*var array = ['7', '1', '28'];
    if (jQuery.inArray( $("#cliente_status_id").val(), array) != -1 &&
        ($('#empresa_id').val() == 2 || $('#empresa_id').val() == 4) &&
        ($('#agendar_retorno #negociador_id').val() == '' || $('#agendar_retorno #negociador_id').val() == null)){

        exibirErro("Informe um negociador.");
        return false;
    }*/

    if(moment($('#agendar_retorno #retorno_data_agendamento_retorno').val(),"DD/MM/YYYY HH:mm") > moment().add(3, 'days')){
        $('#agendar_retorno').modal('toggle');
        swal({
            title: 'INFORME A SENHA',
            input: 'password',
            inputAttributes: {
                id: 'senha_master',
                autocapitalize: 'off'
            },
            allowOutsideClick: true,
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
                salvarRetorno(false);
            }else{
                exibirWarning('Retorno não foi salvo, tente novamente.');
            }
        });
    }else{
        salvarRetorno(true);
    }
}

function salvarRetorno(closeDialog) {
    $.ajax({
        url: '/agendamento_retornos/',
        data: getFormAgendarRetorno(),
        dataType: 'json',
        processData: false,
        contentType: false,
        type: 'POST',
        success: function(data) {
            finalizarLigacaoJson($("#agendar_retorno #status_ligacao").val());
            if(closeDialog)
                $('#agendar_retorno').modal('toggle');
        },
        error: function(data) {
            if(data['responseText'] == "\"FORA_HORARIO\"")
                exibirErro("O selecione um horário entre 8:00 e 21:00.")
            else exibirErro('Ocorreu um erro.');
        }
    });
}


function getFormAgendarRetorno(){
    form = new FormData();
    form.append('retorno[data_agendamento_retorno]', $("#retorno_data_agendamento_retorno").val());
    if($('#agendar_retorno #negociador_id').val() != '')
        form.append('retorno[user_id]', $("#agendar_retorno #negociador_id").val());
    if($('#agendar_retorno #retorno_obs_ligacao_retorno').val() != '')
        form.append('retorno[obs_ligacao]', $("#agendar_retorno #retorno_obs_ligacao_retorno").val());
    form.append('retorno[ligacao_id]', $("#ligacao_id").val());
    form.append('retorno[cliente_id]', $("#cliente_id").val());
    return form;
}

function validarFinalizarLigacao(){
    if(($("#cliente_status_id").val() == null || $("#cliente_status_id").val() == '')){
        exibirErro('É obrigatório informar Status do cliente.');
        return true;
    }

    if((($('#status_fechamento').val() == 'true'))
            // || ($("#cliente_status_id").val() == 7 && $('#empresa_id').val() == 1))
        && $("#body_table_proposta tr").length == 0){
        exibirErro('Para Status de Fechado e Negociando, é obrigatório ter no minimo uma proposta cadastrada.');
        return true;
    }

    var array = ['3', '4', '19', '6', '9', '7'];
    if(jQuery.inArray( $("#cliente_status_id").val(), array ) != -1 && $("#ligacao_observacoes").val().length == 0){
        exibirErro('É obrigatório informar observação da ligação.');
        return true;
    }

    var array = ['28', '7'];
    if(jQuery.inArray( $("#cliente_status_id").val(), array ) != -1 && $("#ligacao_observacoes").val().length < 15){
        exibirErro('É obrigatório informar uma observação de pelo menos 15 caracteres na ligação.');
        return true;
    }

    if(!validarTelefonePreferencial())
        return true;

    return false;
}

function finalizarLigacao(){

    array2 = ['28', '7'];
    if(jQuery.inArray( $("#cliente_status_id").val(), array2 ) != -1){
        agendarRetorno();
        return true;
    }
    if(jQuery.inArray( $("#cliente_status_id").val(), array2 ) == -1){
        if (validarFinalizarLigacao()) 
            return;
    }

    array = ['6','29','30'];
    if(jQuery.inArray( $("#cliente_status_id").val(), array ) != -1){
        exibirErro('Para o status selecionado é obrigatório finalizar a ligação com agendar retorno.');
        return true;
    }    

    if(validarTelefoneWhats()){
        finalizar();
    }else{
        swal({
            title: "Enviou whatsapp?",
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
                swal.close();
                exibirWarning('Marque o telefone para qual fez o envio.');
                return false;
            } else {
               finalizar();
            }
        });
    }
}

function finalizar() {
    atualizarCliente();

    if($('#cliente_fechado').val() == 'false' && $('#status_fechamento').val() == 'true' ){
        $('#modalFechamento').modal('show');
    }else{
        finalizarLigacaoJson();
    }
}

function getFormFinalizarLigacao(status){
    form = new FormData();
    form.append('tipo_fechamento_id', $("#cliente_tipo_fechamento_id").val());
    if($('#agendar_retorno #retorno_obs_ligacao_retorno').val() != '')
        form.append('ligacao_observacoes', $("#agendar_retorno #retorno_obs_ligacao_retorno").val());
    else
        form.append('ligacao_observacoes', $("#ligacao_observacoes").val());

    form.append('status_cliente_id', $("#cliente_status_id").val());
    form.append('negociador_id', $("#agendar_retorno #negociador_id").val());
    if(status != null)
        form.append('status_id', status);

    return form;
}

function finalizarLigacaoJson(status) {
    $.ajax({
        url: '/ligacoes/' + $("#ligacao_id").val() + '/finalizar_ligacao',
        data: getFormFinalizarLigacao(status),
        dataType: 'json',
        processData: false,
        contentType: false,
        type: 'PUT',
        success: function(data) {
            $('body').lmask('hide');
            $('#agenda').modal('hide');
            if ($("#cliente_status_id").val() == 2)
                $('#modalConfimarSolicitacaoBanco').modal('show');
            else
                window.location.href = "/ligacoes/ligacao";
        },
        error: function(data) {
            exibirErro(data);
            $('body').lmask('hide');
        }
    });
}

function salvarPerguntasCliente(){
    form = new FormData();
    form.append('cliente_id', $('#cliente_id').val());
    form.append('tipo', 1);
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
}

function verificarAtendimento(){
    if($('#retorno_id').val() != '')
        return false;

    $.getJSON('/ligacoes/user_em_atendimento', function(data) {
        if(data == null)
            return false;

        getDadosCliente(data);
        $('#btnProxLigacao').hide();

        if($('#cliente_fechado').val() == "true"){
            $('#btnIniciarLigacao').hide();
        }else{
            $('#btnIniciarLigacao').show();
        }
        $('#btnCancelarLigacao').show();

        verificarLigacao(data)
    });
}

function verificarLigacao(data){
    $.getJSON('/ligacoes/ligacao_em_andamento?' +
        "cliente_id="+data['id'], function(data) {
        if(data == null)
            return;

        $('#ligacao_id').val(data['id']);
        $('#retorno_id').val(data['agendamento_retorno_id']);

        $('#ligacao_observacoes').val(data['observacao']);

        $('#btnIniciarLigacao').hide();
        $('#btnCancelarLigacao').hide();
        $('#lblLigacaoEmAndamento').show();
        $('#btnNovaProposta').show();

        if(data['status_ligacao_id'] == 5){
            $('#groupLigacaoAtendida').show();
            $("#cliente_status_id.chosen-select").attr('disabled', false).trigger("chosen:updated");
        }else{
            $('#groupLigacaoIniciada').show();
        }
    });
}

function novaLigacao(retornoId){
    $.ajax({
        url: '/ligacoes/',
        data: { 'ligacao[cliente_id]': $('#cliente_id').val(), 'ligacao[agendamento_retorno_id]': retornoId},
        dataType: 'json',
        type: 'POST',
        success: function(data) {
            $('#ligacao_id').val(data['id']);
            if(data['agendamento_retorno_id'] != null){
                $('#retorno_id').val(data['agendamento_retorno_id'])
            }
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

function setStatusLigacao(status){
    if($("#ligacao_id").val() == null || $("#ligacao_id").val() == '') {
        exibirErro("Não há ligação em andamento, verifique!")
        return false;
    }
    if($('#retorno_id').val() != null && $('#retorno_id').val() != '' && status != 5 && status != 1 && status != 2){
        setStatusRetornoLigacao(status);
    }else{
        atualizarCliente();
        $.ajax({
            url: '/ligacoes/' + $("#ligacao_id").val() + '/set_status_ligacao',
            data: getFormSetStatusLigacao(status),
            dataType: 'json',
            processData: false,
            contentType: false,
            type: 'PUT',
            success: function(data) {
                if(status < 5){
                    window.location.href = "/ligacoes/ligacao";
                }else{
                    $("#cliente_status_id.chosen-select").attr('disabled', false).trigger("chosen:updated");
                    $('#groupLigacaoAtendida').show();
                    $('#groupLigacaoIniciada').hide();
                    $('#btnNovaProposta').show();
                }
            },
            error: function(data) {
                exibirErro(data);
            }
        });
    }
}

function getFormSetStatusLigacao(status){
    form = new FormData();
    form.append('status', status);
    form.append('ligacao_observacoes', $("#ligacao_observacoes").val());
    form.append('status_cliente_id', $("#cliente_status_id").val());
    return form;
}

function setStatusRetornoLigacao(status){
    var array = ['7', '1', '28'];
    if(jQuery.inArray( $("#cliente_status_id").val(), array) != -1 && ($('#empresa_id').val() == 2 || $('#empresa_id').val() == 4)) {
        $('#agendar_retorno #negociadorGroup').show();        
    }else $('#agendar_retorno #negociadorGroup').hide();

    $("#agendar_retorno #retorno_obs_ligacao_retorno").val($('#ligacao_observacoes').val());
    $('#agendar_retorno').modal({backdrop: 'static', keyboard: false});
    $('#agendar_retorno #status_ligacao').val(status);
    $('#agendar_retorno').modal('show');
}

function limparTela(){
    $("#cliente_id").val("");
    $("#ligacao_id").val("");
    $("#cliente_retorno_id").val("");
    $("#retorno_id").val("");

    $("#cliente_razao_social").val("");
    $("#cliente_cnpj").val("");
    $("#cliente_data_licensa").val("");
    $("#cliente_cnae").val("");
    $("#cliente_cnae_id").val("");

    $("#cliente_cidade").val("");
    $("#cliente_contato").val("");
    $("#cliente_contato1").val("");
    $("#cliente_contato1_id").val("");
    $("#cliente_contato_id").val("");
    $("#cliente_telefone").val("");
    $("#cliente_telefone2").val("");
    $("#cliente_email").val("");

    $('#cliente_status_id').find('option').remove();
    $('#cliente_status_id').trigger("chosen:updated");

    $('#cliente_status_id').val('').trigger('chosen:updated');
    $('#cliente_tipo_fechamento_id').val('').trigger('chosen:updated');

    $("#ligacao_observacoes").val("");

    limparModalDataRetorno();
    limparModalProposta();
    limparModalPossuiSistema();
    limparModalEscritorio();

    $("#body_table_proposta tr").remove();
    $("#body_table_ligacoes tr").remove();
    $("#body-table-cnaes-cliente tr").remove();
    $('#body-table-contatos-cliente-celular tr').remove();
    $('#body-table-contatos-cliente-telefone tr').remove();
    $('#body-table-contatos-whats tr').remove();


    $('#lblLigacaoEmAndamento').hide();
    $('#btnIniciarLigacao').hide();
    $('#btnCancelarLigacao').hide();
    $('#groupLigacaoIniciada').hide();
    $('#btnProxLigacao').show();
    $('#groupLigacaoAtendida').hide();
    $('#btnNovaProposta').hide();
    $('#cliente_razao_social').prop( "disabled", false );
    $('#cliente_cnpj').prop( "disabled", false );

    $("#cliente_status_id.chosen-select").attr('disabled', true).trigger("chosen:updated");
    $('#empresa_id').val('');
}

function limparModalPossuiSistema() {
    $("#sistema_terceiro_cliente").val("");
    $("#sistema_terceiro_cliente_id").val("");
    $("#sistema_terceiro_empresa").val("");
    $("#sistema_terceiro_sistema").val("");
    $("#sistema_terceiro_mensalidade").val("");
    $("#sistema_terceiro_observacao").val("");
    $("#sistema_terceiro_id").val("");
}

function limparModalDataRetorno() {
    $("#cliente_data_retorno").val("");
}

function salvarClienteManual(){
    if($('#cliente_cnpj').val() == ""){
        $('#cliente_cnpj').focus();
        return false;
    }
    $.ajax({
        url: '/clientes/',
        data: getFormCliente(),
        dataType: 'json',
        processData: false,
        contentType: false,
        type: 'POST',
        success: function(data) {
            setClienteEmAtendimento(data['id']);
            $('#btnSalvarClienteManual').hide();
            exibirMsg('Cliente cadastrado com sucesso.')
        },
        error: function(data) {
            exibirErro(data['responseText']);
        }
    });
}

function atualizarCliente(){
    $.ajax({
        url: '/clientes/' +  $("#cliente_id").val(),
        data: getFormCliente(),
        dataType: 'json',
        processData: false,
        contentType: false,
        type: 'PUT',
        success: function(data) {},
        error: function(data) {
            exibirErro(data);
        }
    });
}

function setClienteEmAtendimento(id){
    $.ajax({
        url: '/clientes/' + id,
        data: getFormSetAtendimento(),
        processData: false,
        dataType: 'json',
        contentType: false,
        type: 'PUT',
        success: function(data) {},
        error: function(data) {
            exibirErro(data);
        }
    });
}

function getFormCliente(){
    form = new FormData();
    form.append('cliente[telefone]', $("#cliente_telefone").val());
    form.append('cliente[telefone2]', $("#cliente_telefone2").val());
    form.append('cliente[email]', $("#cliente_email").val());
    if($("#cliente_status_id").val() != null && $("#cliente_status_id").val() != 'undefined')
        form.append('cliente[status_id]', $("#cliente_status_id").val());
    form.append('contato', $("#cliente_contato").val());
    form.append('contato1', $("#cliente_contato1").val());
    form.append('contato_id', $("#cliente_contato_id").val());
    form.append('contato1_id', $("#cliente_contato1_id").val());
    return form;
}

function getFormSetAtendimento(){
    form = new FormData();
    form.append('cliente[em_atendimento]', true);
    return form;
}

function getClienteRetorno(clienteRetornoId, funcao){
    if($("#cliente_id").val() == 'undefined'){
        exibirErro("Ocorreu um erro ao buscar cliente. Verificar Suporte!")
        return;
    }

    $.getJSON('/clientes/'+ clienteRetornoId, function(data) {
        getDadosCliente(data);
        setClienteEmAtendimento(data['id']);
        funcao('ok');
    });
}

function buscarProximoCliente(){
    $.getJSON('/ligacoes/get_proximo_cliente', function(data) {
        if(data['status'] != 204){
            getDadosCliente(data);
            validarEmpresa();
        }else{
            exibirWarning('Não há nenhum cliente na fila.');
        }
    });
}

function validarEmpresa(){
    $.getJSON('/empresas/empresa_logada', function(data) {
        $('#empresaNome').text(data['razao_social']);
        $('#trocar_empresa_id').val(data['id']);
    });
}

function getDadosCliente(data){
    setDadosCliente(data);
    $.each(data['propostas'], function( key, value ) {
        addRowPropostas(value);
    });

    if(data['sistema_terceiros'] != null)
        setDadosSistemaTerceiros(data['sistema_terceiros']);

    if(data['status'] != null)
        $('#status_fechamento').val(data['status']['fechamento']);

    carregarTodosCnaes(data['cnae'], data['cnae_clientes']);

    setDadosEscritorio(data['escritorio']);

    $.getJSON('/ligacoes?q[cliente_id_eq]=' + data['id'], function(data) {
        $.each(data, function(k, v) {
            addRowLigacoes(v);
        });
    });

    $.getJSON('/status/get_status_cliente?cliente_id=' + data['id'], function (value) {
        $.each(value, function (k, v) {
            $('#cliente_status_id').append('<option value="' + v['id'] + '">'+ v['descricao'] +'</option>');
        });

        if(data['status'] != null)
            $('#cliente_status_id').val(data['status']['id']);
        $('#cliente_status_id').trigger("chosen:updated");

    });

    if(data['telefone_enviado_whats'])
        addRowWhatsTelefone(data, 'telefone');

    if(data['telefone2_enviado_whats'])
        addRowWhatsTelefone(data, 'telefone2');

    carregarTodosContatos(data['contatos']);

    controleBotoesLigacao();
    if(data['negociacao'] != null){
        $.ajax({
            url: '/negociacoes/activities',
            data: {id: data['negociacao']['id'], ligacao: true},
            type: 'GET',
            success: function (data) {
                $("#content_activities").html(data);
            },error: function(data){
                exibirErro(data);
            }
        });
    }
    if(data['hist_impl_id'] != null){
        $.ajax({
            url: '/implantacoes/activities',
            data: {historico: data['hist_impl_id'], ligacao: true},
            type: 'GET',
            success: function (data) {
                $("#content_activities_implantacao").html(data);
                $('#show_hist_anterior').show();
            },error: function(data){
                exibirErro(data);
            }
        });
    }
    if(data['hist_acomp_id'] != null){
        $.ajax({
            url: '/acompanhamentos/activities',
            data: {historico: data['hist_acomp_id'], ligacao: true},
            type: 'GET',
            success: function (data) {
                $("#content_activities_acompanhamento").html(data);
                $('#show_hist_anterior').show();
            },error: function(data){
                exibirErro(data);
            }
        });
    }

    //pegar ligações_old
    $.getJSON('/ligacoes/ligacoes_old?cliente=' + data['id'], function(data) {
        $.each(data, function(k, v) {
            addRowLigacoesOld(v);
        });
    });

    if(data['hist_acomp_id'] == null && data['hist_impl_id'] == null)
        $('#show_hist_anterior').hide();
        
}

function controleBotoesLigacao(){
    $('#btnProxLigacao').hide();
    if($('#cliente_fechado').val() == "true"){
        $('#btnIniciarLigacao').hide();
    }else{
        $('#btnIniciarLigacao').show();
    }
    $('#btnCancelarLigacao').show();
    $('#cliente_razao_social').prop( "disabled", true );
    $('#cliente_cnpj').prop( "disabled", true );
}

function addRowLigacoes(data){
    var newRow = $("<tr>");
    var cols = "";
    cols += '<td>' + data['data_inicio_formatada'] + '</td>';
    cols += '<td>' + data['usuario'] + '</td>';
    cols += '<td>' + ( data['status_ligacao'] != null ? data['status_ligacao'] : "")  + '</td>';
    cols += '<td>' + ( data['status_cliente'] != null ? data['status_cliente'] : "") + '</td>';
    cols += '<td>' + ( data['observacao'] != null ? data['observacao'] : "") + '</td>';

    newRow.append(cols);
    $("#table-ligacoes").append(newRow);
}

function addRowLigacoesOld(data){
    var newRow = $("<tr>");
    var cols = "";
    cols += '<td>' + data['data_inicio_formatada'] + '</td>';
    cols += '<td>' + data['usuario'] + '</td>';
    cols += '<td>' + ( data['status_ligacao'] != null ? data['status_ligacao'] : "")  + '</td>';
    cols += '<td>' + ( data['status_cliente'] != null ? data['status_cliente'] : "") + '</td>';
    cols += '<td>' + ( data['observacao'] != null ? data['observacao'] : "") + '</td>';

    newRow.append(cols);
    $("#table-ligacoes-old").append(newRow);
}

function setDadosCliente(data){
    $("#cliente_id").val(data['id']);
    $("#cliente_email").val(data['email']);
    $("#cliente_job").val(data['job']);
    $("#cliente_telefone2").val(data['telefone2']);
    $("#cliente_telefone").val(data['telefone']);
    $("#cliente_telefone_preferencial").prop('checked', data['telefone_preferencial']);
    $("#cliente_telefone_enviado_whats").prop('checked', data['telefone_enviado_whats']);
    $("#cliente_telefone2_preferencial").prop('checked', data['telefone2_preferencial']);
    $("#cliente_telefone2_enviado_whats").prop('checked', data['telefone2_enviado_whats']);
    if(data['contatos'][0] != null){
        $("#cliente_contato").val(data['contatos'][0]['nome']);
        $("#cliente_contato_id").val(data['contatos'][0]['id']);
    }
    if(data['contatos'][1] != null){
        $("#cliente_contato1").val(data['contatos'][1]['nome']);
        $("#cliente_contato1_id").val(data['contatos'][1]['id'])
    }
    if(data['cidade'] != null)
        $("#cliente_cidade").val(data['cidade']['nome'] + '-' + data['cidade']['estado']['sigla']);
    if(data['cnae'] != null){
        $("#cliente_cnae").val(data['cnae']['descricao']);
        $("#cliente_cnae_id").val(data['cnae']['id']);
    }
    $("#cliente_data_licensa").val(data['data_licenca']);
    $("#cliente_data_importacao").val(data['data_importacao']);
    $("#cliente_razao_social").val(data['razao_social']);
    $("#cliente_cnpj").val(data['cnpj']);
    $("#cliente_porte").val(data['porte']);
    if(data['status'] != null)
        $('#cliente_status_id').val(data['status']['id']).trigger('chosen:updated');
    $('#cliente_triagem').val(data['triagem']);

    $('#empresa_id').val(data['empresa_id']);
    $('#cliente_fechado').val(data['cliente']);
}

function setDadosSistemaTerceiros(data) {
    $("#sistema_terceiro_cliente").val(data['cliente']);
    $("#sistema_terceiro_cliente_id").val(data['cliente_id']);
    $("#sistema_terceiro_empresa").val(data['empresa']);
    $("#sistema_terceiro_sistema").val(data['nome']);
    $("#sistema_terceiro_mensalidade").val(data['mensalidade']);
    $("#sistema_terceiro_observacao").val(data['observacao']);
    $("#sistema_terceiro_id").val(data['id']);
}

function carregarTodosCnaes(cnae_princ, cnaes) {
    $("#body-table-cnaes-cliente tr").remove();

    if(cnae_princ != null){
        var newRow = $("<tr id='" + cnae_princ['id'] +"'>");
        var cols = '<td>' + cnae_princ['codigo'] + '</td>';
        cols += '<td>' + cnae_princ['descricao'] + '</td>';
        cols += '<td>' + cnae_princ['blacklist'] + '</td>';
        cols += '<td>' + '<button class="btn btn-sm btn-danger btn-table incluirBlacklist" title="Incluir CNAE na blacklist" value="' + cnae_princ['id'] +'"  data-toggle="tooltip" data-placement="right">' +
            '<i class="fa fa-ban" aria-hidden="true"></i>' +
            '</button>' + '</td>';
        newRow.append(cols);

        $("#table-cnae-cliente").append(newRow);
    }

    $.each(cnaes, function( key, value ) {
        var newRow = $("<tr id='" + value['cnae']['id'] +"'>");
        var cols = '<td>' + value['cnae']['codigo'] + '</td>';
        cols += '<td>' + value['cnae']['descricao'] + '</td>';
        cols += '<td>' + value['blacklist'] + '</td>';
        cols += '<td>' + '<button class="btn btn-sm btn-danger btn-table incluirBlacklist" title="Incluir CNAE na blacklist" value="' + value['cnae']['id'] +'"  data-toggle="tooltip" data-placement="right">' +
            '<i class="fa fa-ban" aria-hidden="true"></i>' +
            '</button>' + '</td>';
        newRow.append(cols);

        $("#table-cnae-cliente").append(newRow);
    });

    $('.incluirBlacklist').on('click', function () {
        $('#cnaes_cliente').modal('toggle');
        var retorno = $(this)["0"].attributes[2].value;
        incluirCnaeBlackList(retorno);
    });
}

function carregarTodosContatos(contatos) {
    $("#body-table-contatos-cliente-telefone tr").remove();
    $("#body-table-contatos-cliente-celular tr").remove();

    $.each(contatos, function( key, contato ) {
        $.each(contato['telefones'], function( key, telefone ) {
            var newRow = $("<tr id='tr-contatos" + telefone['id'] + "' style='height: 10px'>");
            var cols = "";
            cols += '<td style="width: 45%">' + contato['nome'].substring(0, 20) + '</td>';
            cols += '<td id="td-'+ telefone['id'] +'" style="width: 20%">' + telefone['telefone'] + '</td>';
            cols += '<td style="width: 5%; padding-top: 0px"><input class="pref pref-celular" onclick="setPref('+ telefone['id'] +')" id="pref'+ telefone['id'] + '" type="checkbox" title="Preferencial?" ' + (telefone['preferencial'] == true ? 'checked' : '') +'></td>';
            cols += '<td style="width: 5%; padding-top: 0px"><div class="message-obs" id="setObs'+ telefone['id'] +'" value="'+ telefone['id'] +'"></td>';
            cols += '<td style="width: 5%; padding-top: 0px"><input class="desativar desativar-celular" onclick="desativarContato('+ telefone['id'] +')" type="checkbox" title="Desativar contato?"></td>';
            newRow.append(cols);

            $("#table-contatos-cliente-telefone").append(newRow);
            var btnTeste = "#setObs"+ telefone['id'];
            $(btnTeste).popover({
                placement: 'left',
                title: 'Observação',
                html:true,
                content:  getHtml(telefone['id']),
                container: 'body'
            }).on('click', function(data){
                var id = '#td-' + data['delegateTarget']['attributes'][2]['nodeValue']
                var text = "#text-area-obs"+ data['delegateTarget']['attributes'][2]['nodeValue']
                var telefone = $(id).text();
                $('.btnRegistrar').click(function(){
                    var ligacao_obs = $('#ligacao_observacoes');
                    if(ligacao_obs.val() == '')
                        ligacao_obs.val(telefone + ' - ' + $(text).val());
                    else ligacao_obs.val(ligacao_obs.val() + ' / (Telefone)' + telefone + ' - ' + $(text).val());

                    $(btnTeste).popover('hide')
                })
            });
        });
        $.each(contato['celulares'], function( key, celular ) {
            var newRow = $("<tr id='tr-contatos" + celular['id'] + "'  style='height: 10px'>");
            var cols = "";
            cols += '<td style="width: 55%">' + contato['nome'].substring(0, 20) + '</td>';
            cols += '<td id="td-'+ celular['id'] +'" style="width: 20%">' + celular['telefone'] + '</td>';
            cols += '<td style="width: 7%; padding-top: 0px"><input class="pref pref-celular" onclick="setPref('+ celular['id'] +')" id="pref'+ celular['id'] + '" type="checkbox" title="Preferencial?"' + (celular['preferencial'] == true ? 'checked' : '') +'></td>';
            cols += '<td style="width: 5%; padding-top: 0px"><input class="whats whats-celular" onclick="setWhats('+ celular['id'] +')" id="whats'+ celular['id'] + '" type="checkbox" title="Enviou whatsapp?"' + (celular['enviado_whats'] == true ? 'checked' : '') +'></td>';
            cols += '<td style="width: 5%; padding-top: 0px"><div class="message-obs" id="setObs'+ celular['id'] +'" value="'+ celular['id'] +'"></td>';
            cols += '<td style="width: 5%; padding-top: 0px"><input class="desativar desativar-celular" onclick="desativarContato('+ celular['id'] +')" type="checkbox" title="Desativar contato?"></td>';

            newRow.append(cols);

            $("#table-contatos-cliente-celular").append(newRow);

            var btnTeste = "#setObs"+ celular['id'];
            $(btnTeste).popover({
                placement: 'left',
                title: 'Observação',
                html:true,
                content:  getHtml(celular['id']),
                container: 'body'
            }).on('click', function(data){
                var id = '#td-' + data['delegateTarget']['attributes'][2]['nodeValue']
                var text = "#text-area-obs"+ data['delegateTarget']['attributes'][2]['nodeValue']
                var telefone = $(id).text();
                $('.btnRegistrar').click(function(){
                    var ligacao_obs = $('#ligacao_observacoes');
                    if(ligacao_obs.val() == '')
                        ligacao_obs.val(telefone + ' - ' + $(text).val());
                    else ligacao_obs.val(ligacao_obs.val() + ' / (Celular)' + telefone + ' - ' + $(text).val());

                    $(btnTeste).popover('hide')
                })
            });
        });

        $.each(contato['enviado_whats'], function( key, whats ) {
            var newRow = $("<tr id='tr-whats" + whats['id'] + " style='height: 10px'>");
            var cols = "";
            cols += '<td style="width: 65%">' + contato['nome'].substring(0, 20) + '</td>';
            cols += '<td style="width: 30%">' + whats['telefone'] + '</td>';
            cols += '<td style="width: 15%; padding-top: 0px"><input class="resp-whats resp-whats-celular" onclick="setRespondeuWhats('+ whats['id'] +')" id="respondeuWhats'+ whats['id'] + '" type="checkbox" title="Respondeu whatsapp?"' + (whats['respondeu_whats'] == true ? 'checked' : '') +'></td>';

            newRow.append(cols);

            $("#table-contatos-cliente-whats").append(newRow);
        });
    });
}

function desativarContato(id) {
    swal({
        title: "Deseja desativar o contato?",
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
            $.getJSON("/clientes/desativar_telefone?id=" +id, function (data) {
                var teste = '#tr-contatos'+id;
                $(teste).closest('tr').remove();
                swal.close();
                exibirMsg('Contato desativado.');
            });
        }
    });
}

function getHtml(id){
    return '<div id="obs_form">' +
           '<textarea rows="3" id="text-area-obs'+ id + '" class="form-control input-md contato_obs_ligacao" style="resize: none; margin-bottom: 5px"></textarea>' +
           '<button type="button" class="btn btn-primary btnRegistrar"><em class="icon-ok"></em> Salvar</button>' +
           '</div>';
}

function setPref(id) {
    var checkBox;
    if(id == 'telefone') {
        checkBox = document.getElementById('cliente_telefone_preferencial');
    }else if(id == 'telefone2'){
        checkBox = document.getElementById('cliente_telefone2_preferencial');
    }else{
        checkBox = document.getElementById("pref"+ id);
    }

    $.getJSON("/clientes/set_telefone_preferencial?id=" +id
        +'&preferencial=' + checkBox.checked + '&cliente_id=' + $('#cliente_id').val(), function (data) {
    });
}

function setWhats(id) {
    var checkBox;
    if(id == 'telefone') {
        checkBox = document.getElementById('cliente_telefone_enviado_whats');
    }else if(id == 'telefone2'){
        checkBox = document.getElementById('cliente_telefone2_enviado_whats');
    }else{
        checkBox = document.getElementById("whats"+ id);
    }

    $.getJSON("/clientes/set_telefone_whatsapp?id=" +id
        +'&enviado_whats=' + checkBox.checked + '&cliente_id=' + $('#cliente_id').val(), function (data) {
        if(checkBox.checked){
            if(id == 'telefone' || id == 'telefone2') {
                addRowWhatsTelefone(data, id)

                window.open('https://api.whatsapp.com/send?phone=55' + (id == 'telefone' ? apenasNumeros(data['telefone']) : apenasNumeros(data['telefone2'])) + '&text=' + data['msg_whats'] , '_blank');
            }else{
                addRowWhatsContato(data, id)

                window.open('https://api.whatsapp.com/send?phone=55' + apenasNumeros(data['telefone']) + '&text=' + data['msg_whats'], '_blank');
            }
        }else{
            var teste = '#tr-whats'+id;
            $(teste).closest('tr').remove();
        }
    });
}
function addRowWhatsContato(data, id) {
    var newRow = $("<tr id='tr-whats" + id +"' style='height: 10px'>");
    var cols = "";
    cols += '<td style="width: 45%">' + data['contato']['nome'].substring(0, 20) + '</td>';
    cols += '<td style="width: 20%">' + data['telefone'] + '</td>';
    cols += '<td style="width: 10%; padding-top: 0px"><input class="resp-whats resp-whats-celular" onclick="setRespondeuWhats('+ data['id'] +')" id="respondeuWhats'+ data['id'] + '" type="checkbox" title="Respondeu whatsapp?"' + (data['respondeu_whats'] == true ? 'checked' : '') +'></td>';

    newRow.append(cols);

    $("#table-contatos-cliente-whats").append(newRow);
}

function addRowWhatsTelefone(data, id) {
    var newRow = $("<tr id='tr-whats" + id +"' style='height: 10px'>");
    var cols = "";
    cols += '<td style="width: 45%">' + (id == 'telefone' ? 'Telefone' : 'Celular') +'</td>';
    cols += '<td style="width: 20%">' + (id == 'telefone' ? data['telefone'] : data['telefone2']) + '</td>';
    cols += '<td style="width: 10%; padding-top: 0px"><input class="resp-whats resp-whats-celular" onclick="' + 'setRespondeuWhats(\'' + id + '\')' + '" id="respondeuWhats'+ id + '" type="checkbox" title="Respondeu whatsapp?"' + ((id == 'telefone' ? (data['telefone_respondeu_whats'] == true ? 'checked' : '') : (data['telefone2_respondeu_whats'] == true ? 'checked' : '')) ) +'></td>';

    newRow.append(cols);

    $("#table-contatos-cliente-whats").append(newRow);
}

function setRespondeuWhats(id) {
    var checkBox = document.getElementById("respondeuWhats"+ id);

    $.getJSON("/clientes/set_respondeu_whats?id=" +id
        +'&respondeu_whats=' + checkBox.checked + '&cliente_id=' + $('#cliente_id').val(), function (data) {
    });
}

function editarLigacao(ligacao){
    $.getJSON("/ligacoes/" + ligacao, function( data ) {
        setLigacao(data);
    });
    $('#modal_ligacao').modal('show');
}

function setLigacao(data){
    $('#form_modal_ligacao #ligacao_id').val(data['id']);
    $('#form_modal_ligacao #ligacao_data_inicio').val(data['data_inicio_formatada']);
    $('#form_modal_ligacao #ligacao_data_fim').val(data['data_fim_formatada']);
    $("#form_modal_ligacao #ligacao_user_id").val(data['user_id']);
    $("#form_modal_ligacao #ligacao_usuario").val(data['usuario']);
    $("#form_modal_ligacao #ligacao_cliente_id").val(data['cliente_id']);
    $("#form_modal_ligacao #ligacao_cliente").val(data['cliente']);
    $("#form_modal_ligacao #ligacao_observacao").val(data['observacao']);
    $("#form_modal_ligacao #ligacao_status_cliente_id").val(data['status_cliente_id']).trigger('chosen:updated');
    $("#form_modal_ligacao #ligacao_status_ligacao_id").val(data['status_ligacao_id']).trigger('chosen:updated');
}

function salvarModalLigacao(){
    $('#form_modal_ligacao').validate({
        rules: {
            'ligacao_data_inicio': {
                required: true,
                brazilianDate : true
            },
            'ligacao_data_fim': {
                required: true,
                brazilianDate : true
            },
            'ligacao_status_ligacao_id':{
                required: true
            }
        },
        submitHandler: function (form) {
            event.preventDefault()
            $("#form_modal_ligacao").validate();
            $.ajax({
                url: '/ligacoes/' + $('#form_modal_ligacao #ligacao_id').val(),
                data: getFormModalLigacao(),
                processData: false,
                contentType: false,
                type: 'PUT',
                success: function(data) {
                    exibirMsg("Ligação alterada com sucesso.")
                },
                error: function(data) {
                    exibirErro(data);
                }
            });
            return false;
        }
    });
}

function getFormModalLigacao(){
    form = new FormData();
    form.append('ligacao[observacao]', $('#form_modal_ligacao #ligacao_observacao').val());
    form.append('ligacao[data_inicio]', $('#form_modal_ligacao #ligacao_data_inicio').val());
    form.append('ligacao[data_fim]', $('#form_modal_ligacao #ligacao_data_fim').val());
    form.append('ligacao[status_cliente_id]', $('#form_modal_ligacao #ligacao_status_cliente_id').val());
    form.append('ligacao[status_ligacao_id]', $('#form_modal_ligacao #ligacao_status_ligacao_id').val());
    return form;
}

function setDadosModalAgenda(){
    $('#agenda_cliente_id').val($('#cliente_id').val());
    $('#agenda_cliente').val($('#cliente_razao_social').val());
    $('#agenda_responsavel').val($('#cliente_contato').val());
    $('#agenda_responsavel2').val($('#cliente_contato1').val());
    $('#agenda_telefone').val($('#cliente_telefone').val());
    $('#agenda_telefone2').val($('#cliente_telefone2').val());
    checkBox = document.getElementById('cliente_telefone_preferencial');
    if(checkBox.checked){
        $('input[id="telefone_preferencial1"]').prop('checked', true);
    }
    checkBox = document.getElementById('cliente_telefone2_preferencial');
    if(checkBox.checked){
        $('input[id="telefone_preferencial2"]').prop('checked', true);
    }
    checkBox = document.getElementById('cliente_telefone_enviado_whats');
    if(checkBox.checked){
        $('input[id="telefone_whats1"]').prop('checked', true);
    }
    checkBox = document.getElementById('cliente_telefone2_enviado_whats');
    if(checkBox.checked){
        $('input[id="telefone_whats2"]').prop('checked', true);
    }

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

function validarTelefonePreferencial(){
    var validou = false;
    $('.pref').each(function(){
        if(this.checked == true)
            validou = true;
    });

    if(validou) {
        return true;
    }else{
        exibirErro('Pelo menos um telefone deve ser marcado como preferencial.');
        return false;
    }
}

function validarTelefoneWhats(){
    var validou = false;
    $('.whats').each(function(){
        if(this.checked == true)
            validou = true;
    });

    if(validou)
        return true;

    return false;
}


function salvarEscritorioContabil() {
    $('#form_escritorio').validate({
        rules: {
            'escritorio_nome_fantasia': {
                required: true
            },
            'escritorio_telefone': {
                required: true
            },
            'escritorio_cidade_id': {
                required : true
            }
        },
        submitHandler: function (form) {
            event.preventDefault()

            $("#form_escritorio").validate();
            atualizarCliente();

            $.ajax({
                url: '/escritorios/salvar_atualizar_cadastro',
                data: getFormEscritorio(),
                dataType: 'json',
                processData: false,
                contentType: false,
                type: 'POST',
                success: function(data) {
                    $('#escritorio').modal('toggle');
                    $("#escritorio_id").val(data['id']);

                    swal({
                        title: "Escritório passou número do cliente?",
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
                            //MANTER CLIENTE NA TELA
                            var cliente_id = $('#cliente_id').val()
                            finalizarLigacaoEscritorio();
                            $.getJSON('/clientes/' + cliente_id, function(data) {
                                limparTela();
                                getDadosCliente(data);
                            });
                            swal.close();
                            exibirMsg('Escritório contábil registrado e ligação encerrada.');
                        } else {
                            finalizarLigacaoEscritorio();
                            window.location.href = "/ligacoes/ligacao";
                        }

                    });
                },
                error: function(data) {
                    exibirErro(data);
                }
            });
            return false;
        }
    });
}

function getFormEscritorio(){
    form = new FormData();
    form.append('id', $("#escritorio_id").val());
    form.append('escritorio[nome_fantasia]', $("#escritorio_nome_fantasia").val());
    form.append('escritorio[responsavel]', $("#escritorio_responsavel").val());
    form.append('escritorio[telefone]', $("#escritorio_telefone").val());
    form.append('escritorio[observacao]', $("#escritorio_observacao").val());
    form.append('escritorio[empresa_id]', $("#escritorio_empresa_id").val());
    form.append('escritorio[cidade_id]', $("#escritorio_cidade_id").val());
    form.append('escritorio[empresa_id]', $("#escritorio_empresa_id").val());
    form.append('cliente_id', $("#cliente_id").val());
    return form;
}

function limparModalEscritorio(){
    $("#escritorio_busca").val("");
    $("#escritorio_id").val("");
    $("#escritorio_razao_social").val("");
    $("#escritorio_responsavel").val("");
    $("#escritorio_nome_fantasia").val("");
    $("#escritorio_telefone").val("");
    $("#escritorio_observacao").val("");
    $("#escritorio_cidade_id").val("");
    $("#escritorio_cidade").val("");
    $.getJSON("/users/get_current_empresa_id", function(data) {
        $('#escritorio_empresa_id').val(data).trigger('chosen:updated');
    });
}

function setDadosEscritorio(data){
    if(data == null)
        return;
    $("#escritorio_nome_fantasia").val(data['nome_fantasia']);
    $("#escritorio_responsavel").val(data['responsavel']);
    $("#escritorio_telefone").val(data['telefone']);
    $("#escritorio_observacao").val(data['observacao']);
    $("#escritorio_id").val(data['id']);
    if(data['cidade'] != null){
        $('#escritorio_cidade_id').val(data['cidade']['id']);
        $('#escritorio_cidade').val(data['cidade']['nome'] + '-' + data['cidade']['estado']['sigla']);
    }
    $('#escritorio_empresa_id').val(data['empresa_id'] + '').trigger('chosen:updated');
    $("#novoTelefone").show();
}

function finalizarLigacaoEscritorio(){
    $.ajax({
        url: '/ligacoes/' + $("#ligacao_id").val() + '/finalizar_ligacao_escritorio/',
        data: { 'ligacao[observacoes]': $("#ligacao_observacoes").val()},
        dataType: 'json',
        type: 'PUT',
        success: function (data) {}
        ,error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}
function addRowPropostas(data){
    $("#table-proposta").append(gerarRowProposta(data));
}

function getFormSistemaTerceiro() {
    form = new FormData();
    form.append('sistema_terceiro[cliente_id]',$("#sistema_terceiro_cliente_id").val());
    form.append('sistema_terceiro[empresa]',$("#sistema_terceiro_empresa").val());
    form.append('sistema_terceiro[nome]',$("#sistema_terceiro_sistema").val());
    form.append('sistema_terceiro[mensalidade]', parseValorRails($("#sistema_terceiro_mensalidade").val()));
    form.append('sistema_terceiro[observacao]',$("#sistema_terceiro_observacao").val());
    form.append('sistema_id', $("#sistema_terceiro_id").val());
    return form;
}

function mostrarLigacoes() {
    $('#modal_captacoes').modal('show');
    const empresa = $("#captacao_empresa").val()
    const job = $("#captacao_job").val()
    const quantidade = $("#captacao_quantidade").val()
    const cnae = $("#captacao_cnae").val()
    $.ajax({
        url: `/ligacoes/mostrar_ligacoes_filtradas?captacao[empresa]=${empresa}&captacao[job]=${job}&captacao[quantidade]=${quantidade}&captacao[cnae]=${cnae}`,
        type: 'GET',
        success: function (data) {
            $('#table_captacao').html('');
            $('#table_captacao').append(data)
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}

function parseValorRails(valor){
    return valor.replace(".", "").replace(",", ".");
}

function sistemaEspecifico(){
    $.ajax({
        url: '/ligacoes/sistema_especifico/',
        data: { cliente_id: $('#cliente_id').val(), obs: $('#ligacao_observacoes').val() },
        type: 'POST',
        success: function (data) {
            window.location.href = "/ligacoes/ligacao";
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}

function enviadoWhatsapp(){
    if(!validarTelefonePreferencial())
        return true;
    if(!validarTelefoneWhats()){
        exibirWarning('Marque o telefone para qual fez o envio.');
        return true;
    }

    $.ajax({
        url: '/ligacoes/enviado_whats/',
        data: { cliente_id: $('#cliente_id').val(), obs: $('#ligacao_observacoes').val() },
        type: 'POST',
        success: function (data) {
            window.location.href = "/ligacoes/ligacao";
        },error: function(data){
            exibirErro('Ocorreu um erro.');
        }
    });
}

function buscar_perguntas() {
    $.getJSON('/perguntas/perguntas_fechamento', function (value) {
        preencherPerguntas(value);
    });
}