//= require typehead/bootstrap3-typeahead.min.js
//= require jquery-ui/jquery-ui.min.js
//= require datapicker/bootstrap-datepicker.js

$(document).ready(function(){

    $('#valor_local').maskMoney({thousands:'.', decimal:','});
    $('#valor_regional').maskMoney({thousands:'.', decimal:','});
    $('#percentual_escritorios').maskMoney({thousands:'.', decimal:','});

    var date = new Date();
    $('#data_inicio').datepicker({
        format: "mm/yyyy",
        viewMode: "months",
        minViewMode: "months",
        keyboardNavigation: false,
        autoclose: true
    });
    $("#data_inicio").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), 1));

    $('#data_fim').datepicker({
        format: "mm/yyyy",
        viewMode: "months",
        minViewMode: "months",
        keyboardNavigation: false,
        autoclose: true
    });
    $("#data_fim").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), date.getDate()));

    $('#tipo').change(function(data){
        if(this.value == '2'){
            $('#local').hide();
            $('#regional').hide();
            $('#vendedor_div').hide();
            $("#vendedor").prop('required',false);
            $("#responsavel_div").hide();
            $("#responsavel").prop('required',false);
            $('#vendedor_meta_div').hide();
            $("#vendedor_meta").prop('required',false);
            $('#implantacao_div').hide();
            $("#implantador").prop('required',false);
            $('#implantador_meta_div').hide();
            $("#implantador_meta").prop('required',false);
            $('#vendedor_acompanhamento_div').hide();
            $("#colaborador_tipo_10").prop('required',false);
            $('#acompanhamento_div').hide();
            $("#acompanhador").prop('required',false); 
            $('#adm_div').hide();
            $("#colaborador").prop('required',false); 
            $('#estagio_div').hide();
            $("#estagio").prop('required',false); 
            $("#btnComissoes").hide();
            $('#tableAcompanhador').hide();
            $('#tableConsultor').hide();
            $('#tableImplantador').hide();
        }else if(this.value == '1'){
            $('#local').show();
            $('#regional').show();
            $('#vendedor_div').hide();
            $("#vendedor").prop('required',false);
            $("#responsavel_div").hide();
            $("#responsavel").prop('required',false);
            $('#vendedor_meta_div').hide();
            $("#vendedor_meta").prop('required',false);
            $('#implantacao_div').hide();
            $("#implantador").prop('required',false);
            $('#implantador_meta_div').hide();
            $("#implantador_meta").prop('required',false);
            $('#acompanhamento_div').hide();
            $("#acompanhador").prop('required',false);
            $('#vendedor_acompanhamento_div').hide();
            $("#colaborador_tipo_10").prop('required',false);
            $('#adm_div').hide();
            $("#colaborador").prop('required',false); 
            $('#estagio_div').hide();
            $("#estagio").prop('required',false); 
            $("#btnComissoes").hide();
            $('#tableAcompanhador').hide();
            $('#tableConsultor').hide();
            $('#tableImplantador').hide();
        }else if(this.value == '3'){
            $('#local').hide();
            $('#regional').hide();
            $('#implantacao_div').hide();
            $("#implantador").prop('required',false);
            $('#implantador_meta_div').hide();
            $("#implantador_meta").prop('required',false);
            $('#acompanhamento_div').hide();
            $("#acompanhador").prop('required',false);
            $('#vendedor_acompanhamento_div').hide();
            $("#colaborador_tipo_10").prop('required',false);
            $('#vendedor_meta_div').hide();
            $("#vendedor_meta").prop('required',false);
            $('#estagio_div').hide();
            $("#estagio").prop('required',false);  
            $('#adm_div').hide();
            $("#colaborador").prop('required',false); 
            $('#vendedor_div').show();
            $("#vendedor").prop('required',true);
            $("#responsavel_div").hide();
            $("#responsavel").prop('required',false);
            $("#btnComissoes").hide();
            $('#tableAcompanhador').hide();
            $('#tableConsultor').hide();
            $('#tableImplantador').hide();
        }else if(this.value == '4'){
            $('#local').hide();
            $('#regional').hide();
            $('#vendedor_div').hide();
            $("#vendedor").prop('required',false);
            $("#responsavel_div").hide();
            $("#responsavel").prop('required',false);
            $('#vendedor_meta_div').hide();
            $("#vendedor_meta").prop('required',false);
            $('#acompanhamento_div').hide();
            $("#acompanhador").prop('required',false);
            $('#estagio_div').hide();
            $("#estagio").prop('required',false);
            $('#vendedor_acompanhamento_div').hide();
            $("#colaborador_tipo_10").prop('required',false);
            $('#implantador_meta_div').hide();
            $("#implantador_meta").prop('required',false); 
            $('#adm_div').hide();
            $("#colaborador").prop('required',false); 
            $('#implantacao_div').show();
            $("#implantador").prop('required',true);
            $("#btnComissoes").hide();
            $('#tableAcompanhador').hide();
            $('#tableConsultor').hide();
            $('#tableImplantador').hide();
        }else if(this.value == '5'){
            $('#local').hide();
            $('#regional').hide();
            $('#vendedor_div').hide();
            $("#vendedor").prop('required',false);
            $("#responsavel_div").hide();
            $("#responsavel").prop('required',false);
            $('#vendedor_meta_div').hide();
            $("#vendedor_meta").prop('required',false);           
            $('#implantacao_div').hide();
            $("#implantador").prop('required',false);
            $('#implantador_meta_div').hide();
            $("#implantador_meta").prop('required',false);
            $('#estagio_div').hide();
            $("#estagio").prop('required',false);
            $('#vendedor_acompanhamento_div').hide();
            $("#colaborador_tipo_10").prop('required',false);
            $('#adm_div').hide();
            $("#colaborador").prop('required',false); 
            $('#acompanhamento_div').show();
            $("#acompanhador").prop('required',true);
            $('#acompanhamento_com').show();
            $("#btnComissoes").show();
            $('#tableAcompanhador').hide();
            $('#tableConsultor').hide();
            $('#tableImplantador').hide();
        }else if(this.value == '6'){
            $('#local').hide();
            $('#regional').hide();
            $('#vendedor_div').hide();
            $("#vendedor").prop('required',false);          
            $("#responsavel_div").hide();
            $("#responsavel").prop('required',false);
            $('#implantacao_div').hide();
            $("#implantador").prop('required',false);
            $('#implantador_meta_div').hide();
            $("#implantador_meta").prop('required',false);
            $('#acompanhamento_div').hide();
            $("#acompanhador").prop('required',false);
            $('#estagio_div').hide();
            $("#estagio").prop('required',false);  
            $('#adm_div').hide();
            $("#colaborador").prop('required',false);
            $('#vendedor_acompanhamento_div').hide();
            $("#colaborador_tipo_10").prop('required',false);
            $('#vendedor_meta_div').show();
            $("#vendedor_meta").prop('required',true); 
            $("#btnComissoes").show();
            $('#tableAcompanhador').hide();
            $('#tableConsultor').hide();
            $('#tableImplantador').hide();
        }else if(this.value == '7'){
            $('#local').hide();
            $('#regional').hide();
            $('#vendedor_div').hide();
            $("#vendedor").prop('required',false);          
            $("#responsavel_div").hide();
            $("#responsavel").prop('required',false);
            $('#implantacao_div').hide();
            $("#implantador").prop('required',false);
            $('#acompanhamento_div').hide();
            $("#acompanhador").prop('required',false);
            $('#vendedor_meta_div').hide();
            $("#vendedor_meta").prop('required',false);
            $('#implantador_meta_div').hide();
            $("#implantador_meta").prop('required',false); 
            $('#adm_div').hide();
            $("#colaborador").prop('required',false);
            $('#vendedor_acompanhamento_div').hide();
            $("#colaborador_tipo_10").prop('required',false);
            $('#estagio_div').show();
            $("#estagio").prop('required',true); 
            $("#btnComissoes").hide();
            $('#tableAcompanhador').hide();
            $('#tableConsultor').hide();
            $('#tableImplantador').hide();
        }else if(this.value == '8'){
            $('#local').hide();
            $('#regional').hide();
            $('#vendedor_div').hide();
            $("#vendedor").prop('required',false);          
            $("#responsavel_div").hide();
            $("#responsavel").prop('required',false);
            $('#implantacao_div').hide();
            $("#implantador").prop('required',false);
            $('#acompanhamento_div').hide();
            $("#acompanhador").prop('required',false);
            $('#vendedor_meta_div').hide();
            $("#vendedor_meta").prop('required',false);            
            $('#estagio_div').hide();
            $("#estagio").prop('required',false); 
            $('#adm_div').hide();
            $("#colaborador").prop('required',false);
            $('#vendedor_acompanhamento_div').hide();
            $("#colaborador_tipo_10").prop('required',false);
            $('#implantador_meta_div').show();
            $("#implantador_meta").prop('required',true);
            $("#btnComissoes").show();
            $('#tableAcompanhador').hide();
            $('#tableConsultor').hide();
            $('#tableImplantador').hide();
        }else if(this.value == '9'){
            $('#local').hide();
            $('#regional').hide();
            $('#vendedor_div').hide();
            $("#vendedor").prop('required',false);          
            $("#responsavel_div").hide();
            $("#responsavel").prop('required',false);
            $('#implantacao_div').hide();
            $("#implantador").prop('required',false);
            $('#acompanhamento_div').hide();
            $("#acompanhador").prop('required',false);
            $('#vendedor_meta_div').hide();
            $("#vendedor_meta").prop('required',false);
            $('#implantador_meta_div').hide();
            $("#implantador_meta").prop('required',false);
            $('#estagio_div').hide();
            $("#estagio").prop('required',false);
            $('#vendedor_acompanhamento_div').hide();
            $("#colaborador_tipo_10").prop('required',false);
            $('#adm_div').show();
            $("#colaborador").prop('required',true); 
            $("#btnComissoes").hide();
            $('#tableAcompanhador').hide();
            $('#tableConsultor').hide();
            $('#tableImplantador').hide();
        }else if(this.value == '10'){
            $('#local').hide();
            $('#regional').hide();
            $('#implantacao_div').hide();
            $("#implantador").prop('required',false);
            $('#implantador_meta_div').hide();
            $("#implantador_meta").prop('required',false);
            $('#acompanhamento_div').hide();
            $("#acompanhador").prop('required',false);
            $('#vendedor_meta_div').hide();
            $("#vendedor_meta").prop('required',false);
            $('#estagio_div').hide();
            $("#estagio").prop('required',false);
            $('#adm_div').hide();
            $("#colaborador").prop('required',false);
            $('#vendedor_div').hide();
            $("#vendedor").prop('required',false);
            $("#responsavel_div").hide();
            $("#responsavel").prop('required',false);
            $('#vendedor_acompanhamento_div').show();
            $("#colaborador_tipo_10").prop('required',true);
            $("#btnComissoes").hide();
            $('#tableAcompanhador').hide();
            $('#tableConsultor').hide();
            $('#tableImplantador').hide();
        }else if(this.value == '11') {
            $('#local').hide();
            $('#regional').hide();
            $('#implantacao_div').hide();
            $("#implantador").prop('required',false);
            $('#implantador_meta_div').hide();
            $("#implantador_meta").prop('required',false);
            $('#acompanhamento_div').hide();
            $("#acompanhador").prop('required',false);
            $('#vendedor_acompanhamento_div').hide();
            $("#colaborador_tipo_10").prop('required',false);
            $('#vendedor_meta_div').hide();
            $("#vendedor_meta").prop('required',false);
            $('#estagio_div').hide();
            $("#estagio").prop('required',false);  
            $('#adm_div').hide();
            $("#colaborador").prop('required',false); 
            $('#vendedor_div').hide();
            $("#vendedor").prop('required',false);
            $("#responsavel_div").show();
            $("#responsavel").prop('required',true);
            $("#btnComissoes").hide();
            $('#tableAcompanhador').hide();
            $('#tableConsultor').hide();
            $('#tableImplantador').hide();
        }
        
    })

    $('#filtro_cliente').typeahead({        
        source: function (query, process) {
            return $.ajax({
                url: '/clientes/find_cliente_all_empresa/',
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
            if ($('#filtro_cliente_id').val() == ''){
                $('#filtro_cliente_id').val(map[item]);
                $('#clientes_add').append(item);
            }else{
                var valor = $('#filtro_cliente_id').val();
                valor += ',' + map[item];
                $('#filtro_cliente_id').val(valor);
                $('#clientes_add').append('\n' + item);
            }
            return item;
        },
        minLength: 7
    });

    $("#filtro_cliente").focusout(function(){
        var user = $('#filtro_cliente').val();
        /*if(!user || user == ''){
            $('#filtro_cliente_id').val('');
        }*/
    });

})

function downloadExcel(){
    if($("#tipo").val() == '3' && $("#vendedor").val() == ''){
        exibirErro("Selecione um vendedor");
        return;
    }

    if(($("#tipo").val() == '4' && $("#implantador").val() == '') || ($("#tipo").val() == '8') && $("#implantador_meta").val() == ''){
        exibirErro("Selecione um implantador");
        return;
    }

    if($("#tipo").val() == '5' && $("#acompanhador").val() == ''){
        exibirErro("Selecione um acompanhante");
        return;
    }

    if($("#tipo").val() == '6' && $("#vendedor_meta").val() == ''){
        exibirErro("Selecione um vendedor");
        return;
    }

    if($("#tipo").val() == '7' && $("#estagio").val() == ''){
        exibirErro("Selecione um colaborador");
        return;
    }

    if($("#tipo").val() == '9' && $("#colaborador").val() == ''){
        exibirErro("Selecione um colaborador");
        return;
    }

    if($("#tipo").val() == '10' && $("#colaborador_tipo_10").val() == ''){
        exibirErro("Selecione um colaborador");
        return;
    }

    var url = '/relatorios/comissionamento_mensalidades_json';
    url += '?tipo=' + $("#tipo").val();
    url += '&data_inicial=' + moment($("#data_inicio").val(),"MM/YYYY").startOf('month').format("YYYY-MM-DD");
    url += '&data_final=' +  moment($("#data_inicio").val(),"MM/YYYY").endOf('month').format("YYYY-MM-DD");
    url += '&valor_local=' +  $("#valor_local").val();
    url += '&valor_regional=' +  $("#valor_regional").val();
    if($("#tipo").val() == '3')
        url += '&vendedor=' +  $("#vendedor").val();
    else if($("#tipo").val() == '7')
        url += '&vendedor=' +  $("#estagio").val();
    else
        url += '&vendedor=' +  $("#vendedor_meta").val();
    
    if ($("#tipo").val() == '8')
        url += '&implantador=' +  $("#implantador_meta").val();
    else
        url += '&implantador=' +  $("#implantador").val();

    url += '&acompanhador=' +  $("#acompanhador").val();
    url += '&colaborador=' +  $("#colaborador").val();
    url += '&colaborador_tipo10=' +  $("#colaborador_tipo_10").val();
    url += '&percentual_escritorios=0';
    url += '&format=' +  'xlsx';
    window.open(url, '_blank');
}
function mostrarComissao() {
    if ($("#tipo").val() == '5') {
        $('#tableConsultor').hide();
        $('#tableImplantador').hide();
        if ($('#tableAcompanhador').is(':visible')) {
            $('#tableAcompanhador').hide();
        } else {
            $('#tableAcompanhador').show();
        }
    }

    if ($("#tipo").val() == '6') {
        $('#tableAcompanhador').hide();
        $('#tableImplantador').hide();
        if($('#tableConsultor').is(':visible')){
            $('#tableConsultor').hide();
        }else{
        $('#tableConsultor').show();
        }
    }

    if ($("#tipo").val() == '8'){
            $('#tableAcompanhador').hide();
            $('#tableConsultor').hide();
        if ($('#tableImplantador').is(':visible')){
            $('#tableImplantador').hide();
        }else {
            $('#tableImplantador').show();
        }
    }


}


function addCliente(){    
    if ($('#filtro_cliente_id').val() == '')
        $('#filtro_cliente_id').val($('#filtro_cliente2').val());
    else{
        var cnpjs = $('#filtro_cliente_id').val();
        cnpjs += ',' + $('#filtro_cliente2').val();
        $('#filtro_cliente_id').val(cnpjs);
    }
    
    $.ajax({
        url: '/clientes/find_cliente_cnpj?cnpj=' + $('#filtro_cliente2').val(),
        type: 'GET',
        success: function(data) {
            $('#clientes_add').append(data.razao_social + ' - ' + data.cnpj + '\n');
            $('#filtro_cliente2').val("");
        },error: function(data){
            exibirErro(data);
        }
    });    
 }

