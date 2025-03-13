//= require typehead/bootstrap3-typeahead.min.js
//= require jquery-ui/jquery-ui.min.js
//= require datapicker/bootstrap-datepicker.js

$(document).ready(function(){

    //--------------QDO CARREGA A TELA----------------//

    var date = new Date();
    $('#data_inicio').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
    $("#data_inicio").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), date.getDate() - 1));

    $('#data_fim').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
    $("#data_fim").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), date.getDate() - 1));

    $('#btnGerarRelatorio').on('click', function(){
        event.preventDefault();
        
        if(($("#data_inicio").val() == null || $("#data_fim").val() == '')){
            exibirErro('É obrigatório informar o período.');
            return;
        }

        var url = "/relatorios/resumo_comercial_relatorio.pdf?data_inicio="+$("#data_inicio").val()+"&data_fim="+$("#data_fim").val();
        if($("#vendedor_id").val() != null && $("#vendedor_id").val() != "")
            url = url.concat("&vendedor_id="+$("#vendedor_id").val());

        if($("#implantador_id").val() != null && $("#implantador_id").val() != "")
            url = url.concat("&implantador_id="+$("#implantador_id").val());

        if($("#sistema_id").val() != null && $("#sistema_id").val() != "")
            url = url.concat("&sistema_id="+$("#sistema_id").val());

        if($("#cidade_id").val() != null && $("#cidade_id").val() != "")
            url = url.concat("&cidade_id="+$("#cidade_id").val());

        if($("#estado_financeiro_id").val() != null && $("#estado_financeiro_id").val() != "")
            url = url.concat("&estado_financeiro_id="+$("#estado_financeiro_id").val());

        if($("#empresa_id").val() != null && $("#empresa_id").val() != "")
            url = url.concat("&empresa_id="+$("#empresa_id").val());

        window.open(url);

        if($('#gerar_ligacoes').val() == 'true'){
            var url = "/relatorios/ligacoes_relatorio.pdf?data_inicio="+$("#data_inicio").val()+"&data_fim="+$("#data_fim").val();

            window.open(url);
        }

        return false;
    })

})
