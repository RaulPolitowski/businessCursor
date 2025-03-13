//= require datapicker/bootstrap-datepicker.js
//= require chosen/chosen.jquery.js
//= require iCheck/icheck.min.js
$(document).ready(function() {
    $('.chosen-select').chosen({width: "100%", allow_single_deselect: true});
    //--------------QDO CARREGA A TELA----------------//
    // var date = new Date();
    // $('#data_inicio').datepicker({
    //     todayBtn: "linked",
    //     keyboardNavigation: false,
    //     forceParse: false,
    //     calendarWeeks: true,
    //     autoclose: true,
    //     format: 'dd/mm/yyyy'
    // });
    // $("#data_inicio").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), date.getDate() - 1));
    //
    // $('#data_fim').datepicker({
    //     todayBtn: "linked",
    //     keyboardNavigation: false,
    //     forceParse: false,
    //     calendarWeeks: true,
    //     autoclose: true,
    //     format: 'dd/mm/yyyy'
    // });
    // $("#data_fim").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), date.getDate() - 1));

    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green'
    });

});