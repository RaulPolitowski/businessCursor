//= require dataTables/datatables.min.js
//= require jquery-ui/jquery-ui.min.js
//= require datapicker/bootstrap-datepicker.js
//= require sweetalert/sweetalert2.all.js
//= require jasny/jasny-bootstrap.min.js
//= require iCheck/icheck.min.js
//= require jeditable/jquery.jeditable.js
//= require footable/footable.all.min.js
//= require chosen/chosen.jquery.js

$(document).ready(function(){
    $('.chosen-select').chosen({width: "100%"});

    $('#btnReprocessarImportacao').on('click', function () {
        $('#modal_reprocessar_importacao').modal('show');
    });

    $('#form_reprocessar_importacao').on('submit', function( event ) {
        event.preventDefault();
        $('body').lmask('show');

        $.ajax({
            url: '/importacoes/reprocessar_importacao',
            data: { "importacao_id": $('#modal_reprocessar_importacao #importacao_id').val()},
            dataType: 'json',
            type: 'POST',
            success: function (data) {
                $('body').lmask('hide');
                exibirMsg('Reprocessado com sucesso.');
                return false;
            }, error: function (data) {
                $('body').lmask('hide');
                exibirErro('Ocorreu um erro.' + data);
                return false;
            }
        });
        return false;
    });

    $('#btnImportacaoEmMassa').on('click', function () {
        $.getJSON('/importacoes/ultima_data_importacao', function(data) {
            $('#modal_importacao_em_massa #data').val(data['data_licenca_desc']);
            $('#modal_importacao_em_massa #qtd_dia').val(data['count']);
            $('#modal_importacao_em_massa').modal('show');
        });
    });

    $('#btnReajustarFilas').on('click', function () {
        swal({
            title: 'Deseja reajustar todas as filas?',
            text: '',
            type: "warning",
            showCancelButton: true,
            cancelButtonColor: '#d33',
            confirmButtonColor: '#3085d6',
            confirmButtonText: 'Sim!',
            cancelButtonText: "Não!",
            allowOutsideClick: true
        }).then((result) => {
            if (result.value) {
                $.ajax({
                    url: '/importacoes/reajustar_filas',
                    processData: false,
                    contentType: false,
                    type: 'POST',
                    success: function (data) {
                        toastr.options = {
                            closeButton: true,
                            progressBar: true,
                            timeOut: 30000,
                            showMethod: 'slideDown'
                        };
                        console.log({data})
                        toastr.info('As filas foram reajustadas com sucesso!');
                    },error: function(data){
                        exibirErro('Ocorreu um erro ao reajustar as filas!');
                    }
                });
            }
        });
    });

    $('#form_importacao_em_massa').on('submit', function( event ) {
        event.preventDefault();
        $('body').lmask('show');

        $.ajax({
            url: '/importacoes/importacao_em_massa',
            data: { "qtd": $('#modal_importacao_em_massa #qtd').val() },
            dataType: 'json',
            type: 'POST',
            success: function (data) {
                $('body').lmask('hide');
                exibirMsg('Importação iniciada com sucesso.');
                $('#modal_importacao_em_massa').modal('toggle');
                return false;
            }, error: function (data) {
                $('body').lmask('hide');
                exibirErro('Ocorreu um erro.' + data);
                return false;
            }
        });
        return false;
    });

    $('#modal_reconsultar_empresas #btnRecalcular').on('click', function () {
        $.getJSON('/importacoes/quantidade_empresas_reconsultar?data_inicio='+moment($('#modal_reconsultar_empresas #data_inicio').val(),"DD/MM/YYYY").format("YYYY-MM-DD")+"&data_final="+moment($('#modal_reconsultar_empresas #data_final').val(), "DD/MM/YYYY").format("YYYY-MM-DD"), function(data) {
            $('#modal_reconsultar_empresas #qtd_dia').val(data['count']);
        });
    })
        
    $('#btnReconsultar').on('click', function () {

        $('#data_final').mask('00/00/0000 00:00');
        $('#data_inicio').mask('00/00/0000 00:00');

        var date = new Date();
        $('#modal_reconsultar_empresas #data_inicio').datepicker({
            todayBtn: "linked",
            keyboardNavigation: false,
            forceParse: false,
            calendarWeeks: true,
            autoclose: true,
            format: 'dd/mm/yyyy'
        });
        $("#modal_reconsultar_empresas #data_inicio").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), 1));

        $('#modal_reconsultar_empresas #data_final').datepicker({
            todayBtn: "linked",
            keyboardNavigation: false,
            forceParse: false,
            calendarWeeks: true,
            autoclose: true,
            format: 'dd/mm/yyyy'
        });
        $("#modal_reconsultar_empresas #data_final").datepicker("setDate",  new Date(date.getFullYear(), date.getMonth() + 1, 0));
        
        $.getJSON('/importacoes/quantidade_empresas_reconsultar?data_inicio='+moment($('#modal_reconsultar_empresas #data_inicio').val(),"DD/MM/YYYY").format("YYYY-MM-DD")+"&data_final="+moment($('#modal_reconsultar_empresas #data_final').val(), "DD/MM/YYYY").format("YYYY-MM-DD"), function(data) {
            $('#modal_reconsultar_empresas #qtd_dia').val(data['count']);
            $('#modal_reconsultar_empresas').modal('show');
        });
    });

    $('#form_reconsultar_empresas').on('submit', function( event ) {
        event.preventDefault();
        $('body').lmask('show');

        $.ajax({
            url: '/importacoes/reconsultar_empresas',
            data: { "qtd": $('#modal_reconsultar_empresas #qtd').val(), "data_inicio": moment($('#modal_reconsultar_empresas #data_inicio').val(),"DD/MM/YYYY").format("YYYY-MM-DD"), "data_final": moment($('#modal_reconsultar_empresas #data_final').val(),"DD/MM/YYYY").format("YYYY-MM-DD") },
            dataType: 'json',
            type: 'POST',
            success: function (data) {
                console.log(data)
                $('body').lmask('hide');
                exibirMsg(`Reconsultar iniciado com sucesso. ${data.total} CNPJs mandados para reconsulta`);
                $('#modal_reconsultar_empresas').modal('toggle');
                return false;
            }, error: function (data) {
                $('body').lmask('hide');
                exibirErro('Ocorreu um erro.' + data);
                return false;
            }
        });
        return false;
    });


});