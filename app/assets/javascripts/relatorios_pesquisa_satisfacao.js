//= require typehead/bootstrap3-typeahead.min.js
//= require jquery-ui/jquery-ui.min.js
//= require datapicker/bootstrap-datepicker.js

$(document).ready(function(){

    $('#estado_id').on('change', function(){
        $('#cidade_id').html('');
        if($('#estado_id').val() != null){
            $.ajax({
                url: '/cidades/find_by_estado?q[estado_id_eq]=' + $('#estado_id').val(),
                type: 'GET',
                success: function (data) {
                    $('#cidade_id').append('<option value=""></option>');
                    $.each(data, function (k, v) {
                        $('#cidade_id').append('<option value="' + v['id'] + '">'+ v['nome'] + '-' + v['estado']['sigla'] +'</option>');
                    });
                    $('#cidade_id').trigger("chosen:updated");
                },error: function(data){
                    exibirErro(data);
                }
            });
        }
    });

    var date = new Date();
    $('#data_inicio').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
    $("#data_inicio").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), 1));

    $('#data_fim').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
    $("#data_fim").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), date.getDate()));

})
