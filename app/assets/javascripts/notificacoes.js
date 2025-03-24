$(document).ready(function()
{
    novas_notificacoes();
    contador_notificacao('FECHAMENTO');
    contador_notificacao('EFETIVACAO');
    contador_notificacao('DESATIVACAO');
    contador_notificacao('SOLICITACAO_DESATIVACAO');
    contador_notificacao('IMPLANTACAO');
    contador_notificacao('ARQUIVO_RETORNO');
    contador_notificacao('CENTRO_DISTRIBUICAO');
    contador_notificacao();
    $("#notificacoes").click(function(){
        carregarNotificacoes();
    });
    $("#notificacoes_fechamento").click(function(){
        carregarNotificacoes('FECHAMENTO');
    });
    $("#notificacoes_efetivacoes").click(function(){
        carregarNotificacoes('EFETIVACAO');
    });
    $("#notificacoes_desativacoes").click(function(){
        carregarNotificacoes('DESATIVACAO');
    });
    $("#notificacoes_solicitacoes_desativacoes").click(function(){
        carregarNotificacoes('SOLICITACAO_DESATIVACAO');
    });
    $("#notificacoes_implantacoes").click(function(){
        carregarNotificacoes('IMPLANTACAO');
    });
    $("#notificacoes_arquivo_retorno").click(function(){
        carregarNotificacoes('ARQUIVO_RETORNO');
    });
    $("#notificacoes_centro_distribuicao").click(function(){
        carregarNotificacoes('CENTRO_DISTRIBUICAO');
    });
    $("#notificacoes_numeros_desconectados").click(function(){
        carregarNotificacoes('NUMERO_DESCONECTADO');
    });

    setInterval(function() {
        novas_notificacoes();
        contador_notificacao('FECHAMENTO');
        contador_notificacao('EFETIVACAO');
        contador_notificacao('DESATIVACAO');
        contador_notificacao('IMPLANTACAO');
        contador_notificacao('ARQUIVO_RETORNO');
        contador_notificacao('SOLICITACAO_DESATIVACAO');
        contador_notificacao('CENTRO_DISTRIBUICAO');
        contador_notificacao('NUMERO_DESCONECTADO');
        contador_notificacao();
    }, 300000);

});

function carregarNotificacoes(tipo){
    contador_notificacao(tipo);
    $.ajax({
        url: '/notificacoes/get_notificacoes?tipo=' + (tipo != null ? tipo : ''),
        dataType: "json",
        success: function (data) {
            $("#alerts").empty();
            $("#alerts_fechamento").empty();
            $("#alerts_efetivacoes").empty();
            $("#alerts_desativacoes").empty();
            $("#alerts_notificacao_desativacoes").empty();
            $("#alerts_implantacoes").empty();
            $("#alerts_arquivo_retorno").empty();
            $("#alerts_centro_distribuicao").empty();
            $("#alerts_numeros_desconectados").empty();
            
            var targetAlerts;
            switch(tipo) {
                case 'FECHAMENTO':
                    targetAlerts = '#alerts_fechamento';
                    break;
                case 'EFETIVACAO':
                    targetAlerts = '#alerts_efetivacoes';
                    break;
                case 'DESATIVACAO':
                    targetAlerts = '#alerts_desativacoes';
                    break;
                case 'SOLICITACAO_DESATIVACAO':
                    targetAlerts = '#alerts_notificacao_desativacoes';
                    break;
                case 'IMPLANTACAO':
                    targetAlerts = '#alerts_implantacoes';
                    break;
                case 'ARQUIVO_RETORNO':
                    targetAlerts = '#alerts_arquivo_retorno';
                    break;
                case 'CENTRO_DISTRIBUICAO':
                    targetAlerts = '#alerts_centro_distribuicao';
                    break;
                case 'NUMERO_DESCONECTADO':
                    targetAlerts = '#alerts_numeros_desconectados';
                    break;
                default:
                    targetAlerts = '#alerts';
            }
            
            // Adicionar o botão "Marcar todas como lidas" somente se houver notificações
            if(data.length > 0){
                // Adicionar botão para marcar todas como lidas no topo do dropdown
                // Garantir que o tipo seja passado corretamente
                var tipoBtn = tipo || '';
                
                // Exibir no console para debug
                console.log('Adicionando botão "Marcar todas como lidas" para o tipo:', tipoBtn);
                
                $('<li class="no-padding-left-right">')
                    .prepend('<div style="text-align: center; background-color: #f8f8f8; padding: 8px; cursor: pointer; font-weight: bold; color: #1c84c6;" class="marcar-todas-lidas" data-tipo="' + tipoBtn + '">' +
                            'Marcar todas como lidas <i class="fa fa-check-circle"></i>' +
                            '</div>' +
                            '<li class="divider"></li>')
                    .appendTo(targetAlerts);
                
                // Adicionar as notificações individuais
                $.map(data, function (item) {
                    if(item.tipo == 'FECHAMENTO'){
                        $('<li id="'+ item.id +'" class="no-padding-left-right">')
                            .prepend('<a href="#" class="notificacao" OnClick="marcar_lido(' + item.id + ', true)">' +
                                '<div class="col-lg-12 no-padding-left-right">' +
                                '<div class="col-lg-7 no-padding-left-right"><i class="fa fa-bell fa-fw"></i> <b>' + item.tipo + '</b></div>' +
                                '<div class="col-lg-5 no-padding-left-right"> <span>'+ item.data_hora_formatada +'</span></div>' +
                                '<span>' + processarMsgLinha1(item) + '</span><br>' +
                                '<span>' + processarMsgLinha2(item) + '</span>' +
                                 processarMsgLinha3(item)  +
                                 processarMsgLinha4(item)  + '<span class="pull-right text-muted small"> ' + humanDate(item.data_hora) + '</span>' +
                                '</div>'+
                                '</a>' +
                                '<div style="text-align: center; cursor: pointer;" OnClick="marcar_lido(' + item.id + ', false)">Marcar lido <i class="fa fa-check-circle"></i></div>' +
                                '</li>' +
                                '<li class="divider"></li>')
                            .appendTo(targetAlerts);
                    }else if(item.tipo == 'AGENDA_CANCELADA') {
                        $('<li id="' + item.id + '" class="no-padding-left-right">')
                            .prepend('<a href="#" class="notificacao" OnClick="marcar_lido(' + item.id + ', true)">' +
                            '<div class="col-lg-12 no-padding-left-right">' +
                            '<div class="col-lg-7 no-padding-left-right"><i class="fa fa-bell fa-fw"></i> <b>' + item.tipo + '</b></div>' +
                            '<div class="col-lg-5 no-padding-left-right"> <span>' + item.data_hora_formatada + '</span></div>' +
                            '<span>' + processarMsgLinha1(item) + '</span><br>' +
                            '<span>' + processarMsgLinha2(item) + '</span>' +
                            processarMsgLinha3(item) +
                            processarMsgLinha4(item) + '<span class="pull-right text-muted small"> ' + humanDate(item.data_hora) + '</span>' +
                            '</div>' +
                            '</a>' +
                            '<div style="text-align: center; cursor: pointer;" OnClick="marcar_lido(' + item.id + ', false)">Marcar lido <i class="fa fa-check-circle"></i></div>' +
                            '</li>' +
                            '<li class="divider"></li>')
                            .appendTo(targetAlerts);
                    } else if(item.tipo == 'EFETIVACAO'){
                            $('<li id="'+ item.id +'" class="no-padding-left-right">')
                                .prepend('<a href="#" class="notificacao" OnClick="marcar_lido(' + item.id + ', true)">' +
                                '<div class="col-lg-12 no-padding-left-right">' +
                                '<div class="col-lg-7 no-padding-left-right"><i class="fa fa-bell fa-fw"></i> <b>' + item.tipo + '</b></div>' +
                                '<div class="col-lg-5 no-padding-left-right"> <span>'+ item.data_hora_formatada +'</span></div>' +
                                '<span>' + processarMsgLinha1(item) + '</span><br>' +
                                '<span>' + processarMsgLinha2(item) + '</span>' +
                                processarMsgLinha3(item)  +
                                processarMsgLinha4(item)  + '<span class="pull-right text-muted small"> ' + humanDate(item.data_hora) + '</span>' +
                                '</div>'+
                                '</a>' +
                                '<div style="text-align: center; cursor: pointer;" OnClick="marcar_lido(' + item.id + ', false)">Marcar lido <i class="fa fa-check-circle"></i></div>' +
                                '</li>' +
                                '<li class="divider"></li>')
                                .appendTo(targetAlerts);
                    }else if(item.tipo == 'DESATIVACAO'){
                        $('<li id="'+ item.id +'" class="no-padding-left-right">')
                            .prepend('<a href="#" class="notificacao" OnClick="marcar_lido(' + item.id + ', true)">' +
                            '<div class="col-lg-12 no-padding-left-right" style="font-size: 11px;">' +
                            '<div class="col-lg-7 no-padding-left-right"><i class="fa fa-bell fa-fw"></i> <b>' + item.tipo + '</b></div>' +
                            '<div class="col-lg-5 no-padding-left-right"> <span>'+ item.data_hora_formatada +'</span></div>' +
                            '<span>' + processarMsgLinha1(item) + '</span><br>' +
                            '<span>' + processarMsgLinha2(item) + '</span>' +
                            processarMsgLinha3(item)  +
                            processarMsgLinha4(item)  + '<span class="pull-right text-muted small"> ' + humanDate(item.data_hora) + '</span>' +
                            '</div>'+
                            '</a>' +
                            '<div style="text-align: center; cursor: pointer;" OnClick="marcar_lido(' + item.id + ', false)">Marcar lido <i class="fa fa-check-circle"></i></div>' +
                            '</li>' +
                            '<li class="divider"></li>')
                            .appendTo(targetAlerts);
                    }else if(item.tipo == 'SOLICITACAO_DESATIVACAO') {
                        $('<li id="' + item.id + '" class="no-padding-left-right">')
                            .prepend('<a href="#" class="notificacao" OnClick="marcar_lido(' + item.id + ', true)">' +
                                '<div class="col-lg-12 no-padding-left-right" style="font-size: 11px;">' +
                                '<div class="col-lg-7 no-padding-left-right"><i class="fa fa-bell fa-fw"></i> <b>' + 'DESATIVACAO' + '</b></div>' +
                                '<div class="col-lg-5 no-padding-left-right"> <span>' + item.data_hora_formatada + '</span></div>' +
                                '<span>' + processarMsgLinha1(item) + '</span><br>' +
                                '<span>' + processarMsgLinha2(item) + '</span>' +
                                processarMsgLinha3(item) +
                                processarMsgLinha4(item) + '<span class="pull-right text-muted small"> ' + humanDate(item.data_hora) + '</span>' +
                                '</div>' +
                                '</a>' +
                                '<div style="text-align: center; cursor: pointer;" OnClick="marcar_lido(' + item.id + ', false)">Marcar lido <i class="fa fa-check-circle"></i></div>' +
                                '</li>' +
                                '<li class="divider"></li>')
                            .appendTo(targetAlerts);
                    }else if(item.tipo == 'IMPLANTACAO'){
                            $('<li id="'+ item.id +'" class="no-padding-left-right">')
                                .prepend('<a href="#" class="notificacao" OnClick="marcar_lido(' + item.id + ', true)">' +
                                '<div class="col-lg-12 no-padding-left-right">' +
                                '<div class="col-lg-7 no-padding-left-right"><i class="fa fa-bell fa-fw"></i> <b>' + item.tipo + '</b></div>' +
                                '<div class="col-lg-5 no-padding-left-right"> <span>'+ item.data_hora_formatada +'</span></div>' +
                                '<span>' + processarMsgLinha1(item) + '</span><br>' +
                                '<span>' + processarMsgLinha2(item) + '</span>' +
                                processarMsgLinha3(item)  +
                                processarMsgLinha4(item)  + '<span class="pull-right text-muted small"> ' + humanDate(item.data_hora) + '</span>' +
                                '</div>'+
                                '</a>' +
                                '<div style="text-align: center; cursor: pointer;" OnClick="marcar_lido(' + item.id + ', false)">Marcar lido <i class="fa fa-check-circle"></i></div>' +
                                '</li>' +
                                '<li class="divider"></li>')
                                .appendTo(targetAlerts);
                    }else if(item.tipo == 'CENTRO_DISTRIBUICAO'){
                            $('<li id="'+ item.id +'" class="no-padding-left-right">')
                            .prepend('<a href="#" class="notificacao" OnClick="marcar_lido(' + item.id + ', true)">' +
                            '<div class="col-lg-12 no-padding-left-right">' +
                            '<div class="col-lg-7 no-padding-left-right"><i class="fa fa-bell fa-fw"></i> <b>' + item.title + '</b></div>' +
                            '<div class="col-lg-5 no-padding-left-right"> <span>'+ item.data_hora_formatada +'</span></div>' +
                            '<span>' + processarMsgLinha1(item) + '</span><br>' +
                            '<span>' + processarMsgLinha2(item) + '</span>' +
                            '<span>' + processarMsgLinha3(item) + '</span>' +
                            '<span>' + processarMsgLinha4(item) + '</span>' +
                            '<span class="pull-right text-muted small"> ' + humanDate(item.data_hora) + '</span>' +
                            '</div>'+
                            '</a>' +
                            '<div style="text-align: center; cursor: pointer;" OnClick="marcar_lido(' + item.id + ', false)">Marcar lido <i class="fa fa-check-circle"></i></div>' +
                            '</li>' +
                            '<li class="divider"></li>')
                            .appendTo(targetAlerts);
                    }
                });
            }else{
                $('<li class="no-padding-left-right">')
                    .prepend('<div class="col-lg-12 no-padding-left-right">' +
                        '<span>Você não possui notificações pendentes!</span>' +
                        '</div>'+
                        '</li>')
                    .appendTo(targetAlerts);
            }
            
            // Adicionar evento de clique para o botão "Marcar todas como lidas"
            $('.marcar-todas-lidas').on('click', function(e) {
                // Evitar a propagação do evento e o comportamento padrão
                e.preventDefault();
                e.stopPropagation();
                
                var tipoNotificacao = $(this).data('tipo');
                console.log('Botão "Marcar todas como lidas" clicado. Tipo:', tipoNotificacao);
                marcarTodasLidas(tipoNotificacao);
                return false; // Garantia adicional para evitar a propagação
            });
        }
    });
}

function humanDate(data){
    var dataNotificacao = new Date(data);
    var dataAtual = new Date().getTime();
    //segundos
    var horas = ((dataAtual - dataNotificacao.getTime()) / 1000);
    //minutos
    horas = (horas /60);
    if(horas < 0){
        return 'Em ' + horas.toFixed() * -1 + ' minutos'
    }
    if(horas<60){
        return 'Há ' + horas.toFixed() + ' min. atrás';
    }
    //horas
    horas = horas/60
    if(horas<24){
        return 'Há ' + horas.toFixed() + ' hrs atrás';
    }
    //Dias
    horas = horas/24
    return 'Há ' + horas.toFixed() + ' dias atrás';
}

function processarMsgLinha1(item){
    switch(item.tipo) {
        case 'LEMBRETE':
            return item.observacao.substring(0, 40);
        case 'AGENDA':
            aux = item.observacao.split("//");
            if(aux[0].length > 40){
                return aux[0].substring(0, 40) + '...';
            }else{
                return aux[0].substring(0, 40);
            }
        case 'RETORNO':
            return item.observacao.substring(0, 40);
        case 'FECHAMENTO':
            aux = item.observacao.split(",");
            if(aux[0].length > 40){
                return aux[0].substring(0, 40) + '...';
            }else{
                return aux[0].substring(0, 40);
            }
        case 'EFETIVACAO':
            aux = item.observacao.split(",");
            if(aux[0].length > 40){
                return aux[0].substring(0, 40) + '...';
            }else{
                return aux[0].substring(0, 40);
            }
        case 'DESATIVACAO':
            aux = item.observacao.split(",");
            if(aux[0].length > 40){
                return aux[0].substring(0, 40) + '...';
            }else{
                return aux[0].substring(0, 40);
            }
        case 'SOLICITACAO_DESATIVACAO':
            aux = item.observacao.split(",");
            if(aux[0].length > 20){
                txt = aux[0].substring(0, 20) + '...';
            }else{
                txt = aux[0].substring(0, 20);
            }
            return txt + '<span class="pull-right">' + aux[4].substring(0, 20) + '</span>';
        case 'IMPLANTACAO':
            aux = item.observacao.split(",");
            if(aux[0].length > 40){
                return aux[0].substring(0, 40) + '...';
            }else{
                return aux[0].substring(0, 40);
            }
        case 'AGENDA_CANCELADA':
            aux = item.observacao.split(",");
            if(aux[0].length > 40){
                return aux[0].substring(0, 40) + '...';
            }else{
                return aux[0].substring(0, 40);
            }
        case 'ARQUIVO_RETORNO':
            aux = item.observacao.split(",");
            if(aux[0].length > 40){
                return aux[0].substring(0, 40) + '...';
            }else{
                return aux[0].substring(0, 40);
            }
        case 'CENTRO_DISTRIBUICAO':
            aux = item.observacao.split(",");
            if(aux[0].length > 40){
                return aux[0].substring(0, 40) + '...';
            }else{
                return aux[0].substring(0, 40);
            }
        case 'NUMERO_DESCONECTADO':
            aux = item.observacao.split(",");
            if(aux[0].length > 40){
                return aux[0].substring(0, 40) + '...';
            }else{
                return aux[0].substring(0, 40);
            }
        default:
            return '';
    }
}

function processarMsgLinha2(item){
    switch(item.tipo) {
        case 'LEMBRETE':
            return item.observacao.substring(40, 65) + '...';
        case 'AGENDA':
            aux = item.observacao.split("//");
            if(aux[1].length > 25){
                return aux[1].substring(0, 25) + '...';
            }else{
                return aux[1].substring(0, 25);
            }
        case 'RETORNO':
            return '';
        case 'FECHAMENTO':
            aux = item.observacao.split(",");
            var txt = '';
            /*if(aux[1].length > 40){//cliente
                txt = aux[1].substring(0, 40) + '...';
            }else{
                txt = aux[1].substring(0, 40);
            }*/
            if (item.tipo_fechamento != null)
                txt = item.tipo_fechamento;
            else
                txt = 'FECHAMENTO';

            if(aux[3] == null) //vendedor
                return txt;
            if(aux[3].length > 40){
                txt =  txt + '<span class="pull-right">' + 'Sistema ' + aux[3].substring(0, 40) + '...' + '</span>';
            }else{
                txt =  txt + '<span class="pull-right">' + 'Sistema ' + aux[3].substring(0, 40) + '</span>';
            }
            return txt;
        case 'FECHAMENTO':
            aux = item.observacao.split(",");
            var txt = '';
            if(aux[1].length > 40){
                txt = aux[1].substring(0, 40) + '...';
            }else{
                txt = aux[1].substring(0, 40);
            }
            if(aux[3] == null)
                return txt;
            if(aux[3].length > 40){
                txt =  txt + '<span class="pull-right">' + 'Sistema ' + aux[3].substring(0, 40) + '...' + '</span>';
            }else{
                txt =  txt + '<span class="pull-right">' + 'Sistema ' + aux[3].substring(0, 40) + '</span>';
            }
            return txt;
        case 'EFETIVACAO':
            aux = item.observacao.split(",");
            var txt = '';
            if (item.tipo_fechamento != null)
                txt = item.tipo_fechamento;
            else {                
                if(aux[1].length > 40){
                    txt = aux[1].substring(0, 40) + '...';
                }else{
                    txt = aux[1].substring(0, 40);
                }
            }   
            if(aux[3] == null)
                return txt;
            if(aux[3].length > 40){
                txt =  txt + '<span class="pull-right">' + 'Sistema ' + aux[4].substring(0, 40) + '...' + '</span>';
            }else{
                txt =  txt + '<span class="pull-right">' + 'Sistema ' + aux[4].substring(0, 40) + '</span>';
            }
            return txt;
        case 'DESATIVACAO':
            aux = item.observacao.split(",");
            var txt = '';
            if (item.tipo_fechamento != null)
                txt = item.tipo_fechamento;
            else
            {
                if(aux[1].length > 40){
                    txt = aux[1].substring(0, 40) + '...';
                }else{
                    txt = aux[1].substring(0, 40);
                }
            }
            if(aux[3] == null)
                return txt;
            if(aux[3].length > 40){
                txt =  txt + '<span class="pull-right">' + 'Sistema ' + aux[4].substring(0, 40) + '...' + '</span>';
            }else{
                txt =  txt + '<span class="pull-right">' + 'Sistema ' + aux[4].substring(0, 40) + '</span>';
            }
            
            return txt;
        case 'SOLICITACAO_DESATIVACAO':
            aux = item.observacao.split(",");
            var txt = item['cidade']

            if(txt.length > 20){
                    txt = txt.substring(0, 20) + '...';
                }else{
                    txt = txt.substring(0, 20);
                }

            if(aux[3] == null){
                return txt;
            }else{
                txt =  txt + '<span class="pull-right">' + 'Sistema ' + aux[3].substring(0, 40) + '</span>';
            }
            return txt;
        case 'IMPLANTACAO':
            aux = item.observacao.split(",");
            var txt = '';
            if (item.tipo_fechamento != null)
                txt = item.tipo_fechamento;
            else
            {
                if(aux[1].length > 40){
                    txt = aux[1].substring(0, 40) + '...';
                }else{
                    txt = aux[1].substring(0, 40);
                }
            }
            if(aux[3] == null)
                return txt;
            if(aux[3].length > 40){
                txt =  txt + '<span class="pull-right">' + 'Sistema ' + aux[4].substring(0, 40) + '...' + '</span>';
            }else{
                txt =  txt + '<span class="pull-right">' + 'Sistema ' + aux[4].substring(0, 40) + '</span>';
            }
            
            return txt;
        case 'AGENDA_CANCELADA':
            aux = item.observacao.split(",");
            var txt = '';
            if(aux[1].length > 40){
                txt = 'Horário ' + aux[1].substring(0, 40) + '...';
            }else{
                txt = 'Horário ' +  aux[1].substring(0, 40);
            }
            if(aux[3] == null)
                return txt;
            if(aux[3].length > 40){
                txt =  txt + '<span class="pull-right">' + 'Sistema ' + aux[3].substring(0, 40) + '...' + '</span>';
            }else{
                txt =  txt + '<span class="pull-right">' + 'Sistema ' + aux[3].substring(0, 40) + '</span>';
            }
            return txt;
        case 'ARQUIVO_RETORNO':
            aux = item.observacao.split(",");
            if(aux[1].length > 40){
                return aux[1].substring(0, 40) + '...';
            }else{
                return aux[1].substring(0, 40);
            }
        case 'CENTRO_DISTRIBUICAO':
            aux = item.observacao.split(",");
            if(aux[1].length > 40){
                return aux[1].substring(0, 40) + '...';
            }else{
                return aux[1].substring(0, 40);
            }
        case 'NUMERO_DESCONECTADO':
            aux = item.observacao.split(",");
            if(aux[1].length > 40){
                return aux[1].substring(0, 40) + '...';
            }else{
                return aux[1].substring(0, 40);
            }
        default:
            return '';
    }
}

function processarMsgLinha3(item){
    switch(item.tipo) {
        case 'FECHAMENTO':
            aux = item.observacao.split(",");
            if(aux[2] == null)
                return '';
            if(aux[2].length > 40){
                return '<br><span>' + 'Vendedor ' + aux[2].substring(0, 40) + '...' + '</span>' + '<span class="pull-right"> ' + item['cidade']  + '</span>';
            }else{
                return '<br><span>' + 'Vendedor ' + aux[2].substring(0, 40) + '</span>' + '<span class="pull-right"> ' + item['cidade']  + '</span>';
            }
        case 'EFETIVACAO':
            aux = item.observacao.split(",");
            if(aux[2] == null)
                return '';

            return '<br><span>' + aux[2] + ',' + aux[3] + '</span>' + '<span class="pull-right"> ' + item['cidade']  + '</span>';
        case 'DESATIVACAO':
                aux = item.observacao.split(",");
                if(aux[2] == null)
                    return '';
    
                return '<br><span>' + aux[2] + ',' + aux[3] + '</span>' + '<span class="pull-right"> ' + item['cidade']  + '</span>';
        case 'SOLICITACAO_DESATIVACAO':
            aux = item.observacao.split(",");
            if(aux[2] == null)
                return '';

            return '<br><span>' + aux[2] + '</span>' + '<span class="pull-right"> ' + aux[6] + '</span>';

        case 'IMPLANTACAO':
                aux = item.observacao.split(",");
                if(aux[2] == null)
                    return '';
    
                return '<br><span>' + aux[2] + ',' + aux[3] + '</span>' + '<span class="pull-right"> ' + item['cidade']  + '</span>';
        case 'AGENDA_CANCELADA':
            aux = item.observacao.split(",");
            if(aux[2] == null)
                return '';
            if(aux[2].length > 40){
                return '<br><span>' + 'Responsável ' + aux[2].substring(0, 40) + '...' + '</span>' + '<span class="pull-right"> ' + item['cidade']  + '</span>';
            }else{
                return '<br><span>' + 'Responsável ' + aux[2].substring(0, 40) + '</span>' + '<span class="pull-right"> ' + item['cidade']  + '</span>';
            }
        case 'CENTRO_DISTRIBUICAO':
            aux = item.observacao.split(",");
            if(aux[2] == null)
                return '';
            if(aux[2].length > 40){
                return '<br><span>' +  aux[2].substring(0, 40) + '...' + '</span>' + '<span class="pull-right"> ' + '</span>';
            }else{
                return '<br><span>' +  aux[2].substring(0, 40) + '</span>' + '<span class="pull-right"> ' + '</span>';
            }
        case 'NUMERO_DESCONECTADO':
            aux = item.observacao.split(",");
            if(aux[2] == null)
                return '';
            if(aux[2].length > 40){
                return '<br><span>' +  aux[2].substring(0, 40) + '...' + '</span>' + '<span class="pull-right"> ' + '</span>';
            }else{
                return '<br><span>' +  aux[2].substring(0, 40) + '</span>' + '<span class="pull-right"> ' + '</span>';
            }
        default:
            return '';
    }
}

function processarMsgLinha4(item){
    switch(item.tipo) {
        case 'FECHAMENTO':
            return '<br><span>' + item['empresa']['razao_social'] + '</span>';
        case 'EFETIVACAO':
            return '<br><span>' + item['empresa']['razao_social'] + '</span>';
        case 'DESATIVACAO':
            return '<br><span>' + item['empresa']['razao_social'] + '</span>';
        case 'SOLICITACAO_DESATIVACAO':
            return '<br><span>' + item['empresa']['razao_social'] + '</span>';
        case 'IMPLANTACAO':
            return '<br><span>' + item['empresa']['razao_social'] + '</span>';
        case 'AGENDA_CANCELADA':
            return '<br><span>' + item['empresa']['razao_social'] + '</span>';
        case 'CENTRO_DISTRIBUICAO':
            aux = item.observacao.split(",");
            if(aux[3] == null)
                return '';
            if(aux[3].length > 40){
                return '<br><span>' + aux[3].substring(0, 40) + '</span> ';
            }else{
                return '<br><span>' + aux[3].substring(0, 40) + '</span> ';
            }
        default:
            return '';
    }
}


function contador_notificacao(tipo){
    $.ajax({
        url: '/notificacoes/contador?tipo=' + (tipo != null ? tipo : ''),
        dataType: "json",
        success: function(data){
            if(tipo == 'FECHAMENTO') {
                if (data > 0) {
                    $('#qtd_notificacoes_fechamento').text(data);
                } else {
                    $('#qtd_notificacoes_fechamento').text('');
                }
            } else if(tipo == 'EFETIVACAO'){
                if (data > 0) {
                    $('#qtd_notificacoes_efetivacoes').text(data);
                } else {
                    $('#qtd_notificacoes_efetivacoes').text('');
                }
            }else if(tipo == 'DESATIVACAO'){
                if (data > 0) {
                    $('#qtd_notificacoes_desativacoes').text(data);
                } else {
                    $('#qtd_notificacoes_desativacoes').text('');
                }
            }else if(tipo == 'SOLICITACAO_DESATIVACAO'){
                if(data > 0){
                    $('#qtd_notificacoes_solicitacoes_desativacoes').text(data);
                }else {
                    $('#qtd_notificacoes_solicitacoes_desativacoes').text('');
                }
            }else if(tipo == 'IMPLANTACAO'){
                if (data > 0) {
                    $('#qtd_notificacoes_implantacoes').text(data);
                } else {
                    $('#qtd_notificacoes_implantacoes').text('');
                }
            }else if(tipo == 'ARQUIVO_RETORNO'){
                if (data > 0) {
                    $('#qtd_notificacoes_arquivo_retorno').text(data);
                } else {
                    $('#qtd_notificacoes_arquivo_retorno').text('');
                }
            }else if(tipo == 'CENTRO_DISTRIBUICAO'){
                if (data > 0) {
                    $('#qtd_notificacoes_centro_distribuicao').text(data);
                } else {
                    $('#qtd_notificacoes_centro_distribuicao').text('');
                }
            }else if(tipo == 'NUMERO_DESCONECTADO'){
                if (data > 0) {
                    $('#qtd_notificacoes_numeros_desconectados').text(data);
                } else {
                    $('#qtd_notificacoes_numeros_desconectados').text('');
                }
            }else{
                if(data > 0){
                    $('#qtd_notificacoes').text(data);
                }else{
                    $('#qtd_notificacoes').text('');
                }
            }

        }
    });
}

function novas_notificacoes(){
    $.ajax({
        url: '/notificacoes/novas_notificacoes/',
        dataType: "json",
        success: function(data){
            if(data.length > 0){
                toastr.options = {
                    closeButton: true,
                    progressBar: true,
                    timeOut: 30000,
                    showMethod: 'slideDown'
                };
                toastr.info('Você possui novas notificações!');
            }
        }
    });
}

function marcar_lido(id, redirect){
    $.getJSON('/notificacoes/marcar_lido?notificacao_id='+ id, function(data) {        
        if(data['tipo'] == 'LEMBRETE') {
            location.href = "../lembretes?lembrete_index_id=" + data['modelo_id'];
        }
        if(data['tipo'] == 'AGENDA') {
            location.href = "../agenda?agenda_index_id=" + data['modelo_id'];
        }
        if(data['tipo'] == 'RETORNO') {
            location.href = "../agendamento_retornos";
        }
        if(data['tipo'] == 'FECHAMENTO') {
            if(redirect)
                location.href = "../agenda?cliente_index_id=" + data['modelo_id'];
            else{
                carregarNotificacoes('FECHAMENTO');
                $('#notificacoes_fechamento').click();
            }
        }
        if(data['tipo'] == 'AGENDA_CANCELADA') {
            if(redirect)
                location.href = "../agenda?agenda_index_id=" + data['modelo_id'];
            else {
                carregarNotificacoes('AGENDA_CANCELADA');
                $('#notificacoes').click();
            }
        }
        if(data['tipo'] == 'EFETIVACAO') {
            if (redirect)
                location.href = "../acompanhamentos/" + data['modelo_id'];
            else {
                carregarNotificacoes('EFETIVACAO');
                $('#notificacoes_efetivacoes').click();
            }
        }
        if(data['tipo'] == 'DESATIVACAO') {
            if(redirect)
                location.href = "../acompanhamentos/" + data['modelo_id'];
            else{
                carregarNotificacoes('DESATIVACAO');
                $('#notificacoes_desativacoes').click();
            }
        }
        if(data['tipo'] == 'SOLICITACAO_DESATIVACAO') {
            if(redirect)
                location.href = "../acompanhamentos/" + data['modelo_id'];
            else{
                carregarNotificacoes('SOLICITACAO_DESATIVACAO');
                $('#notificacoes_solicitacoes_desativacoes').click();
            }
        }
        if(data['tipo'] == 'IMPLANTACAO') {
            if(redirect)
                location.href = "../implantacoes/" + data['modelo_id'];
            else {
                carregarNotificacoes('IMPLANTACAO');
                $('#notificacoes_implantacoes').click();
            }
        }
        if(data['tipo'] == 'ARQUIVO_RETORNO') {
            if(redirect)
                location.href = "../dashboards/resultados";
            else {
                carregarNotificacoes('ARQUIVO_RETORNO');
                $('#notificacoes_arquivo_retorno').click();
            }
        }
        if(data['tipo'] == 'CENTRO_DISTRIBUICAO') {
            if(redirect)
                location.href = "../importacoes";
            else {
                carregarNotificacoes('CENTRO_DISTRIBUICAO');
                $('#notificacoes_centro_distribuicao').click();
            }
        }
        if(data['tipo'] == 'NUMERO_DESCONECTADO') {
            if(redirect)
                location.href = "../whatsapp_numeros";
            else {
                carregarNotificacoes('NUMERO_DESCONECTADO');
                $('#notificacoes_numeros_desconectados').click();
            }
        }
    });
}

// Função para marcar todas as notificações como lidas
function marcarTodasLidas(tipo) {
    console.log('Enviando requisição para marcar todas as notificações como lidas. Tipo:', tipo);
    
    // Mostrar indicador de loading
    var loadingToast = toastr.info('Processando...');
    
    $.ajax({
        url: '/notificacoes/marcar_todas_lidas',
        method: 'POST',
        data: { 
            tipo: tipo,
            authenticity_token: $('meta[name="csrf-token"]').attr('content')
        },
        dataType: 'json',
        success: function(response) {
            console.log('Resposta do servidor:', response);
            
            // Fechar toast de loading
            toastr.clear(loadingToast);
            
            if (response.success) {
                // Atualizar os contadores
                contador_notificacao(tipo);
                if (!tipo) {
                    contador_notificacao();
                }
                
                // Fechar o dropdown e mostrar mensagem de sucesso
                $('.dropdown.open .dropdown-toggle').dropdown('toggle');
                
                var mensagem = response.count + ' notificação(ões) marcada(s) como lida(s).';
                console.log(mensagem);
                toastr.success(mensagem);
                
                // Recarregar as notificações após um breve período
                setTimeout(function() {
                    carregarNotificacoes(tipo);
                }, 1000);
            }
        },
        error: function(xhr, status, error) {
            console.error('Erro ao marcar notificações como lidas:', xhr.responseText);
            console.error('Status:', status);
            console.error('Erro:', error);
            toastr.error('Erro ao marcar notificações como lidas.');
        }
    });
}