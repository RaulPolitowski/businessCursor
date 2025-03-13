//= require morris/raphael-2.1.0.min.js
//= require morris/morris.js
//= require d3/d3.min.js
//= require c3/c3.min.js
//= require datapicker/bootstrap-datepicker.js
//= require typehead/bootstrap3-typeahead.min.js
//= require chosen/chosen.jquery.js
//= require iCheck/icheck.min.js
//= require canvas/jquery.canvasjs.min.js

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
$("#data_fim").datepicker("setDate",  new Date(date.getFullYear(), date.getMonth() + 1, 0));

$('#nono_digito').change(function() {
    if (this.checked) {
        $(this).val($(this).data('on_value'));
    } else {
        $(this).val($(this).data('off_value'));
    }
});

$('.i-checks').iCheck({
    checkboxClass: 'icheckbox_square-green'
});

$('.chosen-select').chosen({width: "100%", allow_single_deselect: true});