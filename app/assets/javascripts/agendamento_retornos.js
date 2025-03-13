//= require typehead/bootstrap3-typeahead.min.js
//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require chosen/chosen.jquery.js
//= require datapicker/bootstrap-datepicker.js
//= require sweetalert/sweetalert2.all.js


$(document).ready(function(){

    $('.chosen-select').chosen({width: "100%", allow_single_deselect: true});
    $('#filtro_cliente').typeahead({
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
            $('#filtro_cliente_id').val(map[item]);
            return item;
        },
        minLength: 2
    });

    $("#filtro_cliente").focusout(function(){
        var cliente = $('#filtro_cliente').val();
        if(!cliente || cliente == ''){
            $('#filtro_cliente_id').val('');
        }
    });

});

function cancelarRetorno(id) {
    swal({
        title: 'INFORME A MOTIVO',
        html: '<form class="form-horizontal" id="form_motivo_cancelamento">\n' +
        '        <div class="modal-body">\n' +
        '          <div class="form-group">\n' +
        '            <div class="field">\n' +
        '              <label class="col-sm-3 control-label padding">Motivo</label>\n' +
        '              <div class="col-sm-9 padding">\n' +
        '                <textarea autocomplete="off" class="form-control" placeholder="Informe a motivo" name="motivo_cancelamento" id="motivo_cancelamento"></textarea>\n' +
        '              </div>\n' +
        '            </div>\n' +
        '          </div>\n' +
        '        </div>\n' +
        '      </form>',
        showConfirmButton: true,
        allowOutsideClick: true,
        showLoaderOnConfirm: true,
        preConfirm: function() {
            return new Promise(function(resolve) {
                if($('#motivo_cancelamento').val() == null || $('#motivo_cancelamento').val() == ''){
                    swal.showValidationError(
                        'Informe o motivo.'
                    )
                }
                resolve();
            })
        }
    }).then(function(result) {
        if(result['value'] == true){
            var motivo = $('#motivo_cancelamento').val();

            $.getJSON("/agendamento_retornos/cancelar_retorno?id=" + id + "&motivo=" + motivo, function( data ) {
                var table = $('.table-retorno').DataTable();
                table.row('#' + data['id']).remove().draw( false );

                exibirMsg('Retorno cancelado!');
            });
        }
    });
}


function criarLinhaTabela(val) {
    var cols = "";
    cols += '<td style="width: 8%; padding: 2px; text-align: center">' + moment(val['created_at']).format("DD/MM/YYYY")  + '</td>';
    cols += '<td style="width: 9%; padding: 2px; text-align: center">' + val['name'] + '</td>';
    cols += '<td style="width: 8%; padding: 2px; text-align: center">' + moment(val['data_agendamento_retorno']).format("DD/MM/YYYY HH:mm") + '</td>';
    cols += '<td style="width: 20%; padding: 2px;">' + getStringTamanho(val['razao_social']) + '</td>';
    cols += '<td style="width: 5%; padding: 2px; text-align: center">' + (val['whatsapp'] == 't' ? 'Sim' : 'Não') + '</td>';
    cols += '<td style="width: 5%; padding: 2px; text-align: center">' + val['qtd_ligacoes'] + '</td>';
    cols += '<td style="width: 40%; padding: 2px;">' + val['observacao'] + '</td>';
    cols += '<td style="padding: 2px;"><a id="btn-' + val['id'] + '" href="/ligacoes/ligacao?cliente_retorno_id=' + val['cliente_id'] + '&retorno_id=' + val['id'] + '" class="btn btn-success retornoLigacao" value="' + val['id'] + '" target="_blank" style="padding: 2px 6px"><i class="fa fa-phone"></i></button> </a></td>';
    cols += '<td style="padding: 2px;"><button id="btn-cancelar-' + val['id'] + '"  onclick="cancelarRetorno(' + val['id'] + ')" class="btn btn-warning cancelarRetorno" value="' + val['id'] + '" title="Cancelar Retorno" style="padding: 2px 6px"><i class="fa fa-trash"></i></button></td>';
    cols += '<td style="padding: 2px;"><button id="btn-activities-' + val['id'] + '"  onclick="atividades_retorno(' + val['cliente_id'] + ')" class="btn btn-info activitiesRetorno" value="' + val['id'] + '" title="Atividades" style="padding: 2px 6px"><i class="fa fa-search"></i></button></td>';
    return cols;
}

function getStringTamanho(txt) {
    if(txt.length > 40)
        return txt.substring(0,38) + '..'

    return txt
}

function atividades_retorno(id) {
    $.getJSON('/ligacoes?q[cliente_id_eq]=' + id, function(data) {
        $("#body_retorno_table_ligacoes tr").remove();
        $.each(data, function(k, v) {
            addRowLigacoesRetornoInicial(v);
        });
        $("#modal_activities_ligacoes").modal('show')
    });
}

function addRowLigacoesRetornoInicial(data){
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

