//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require typehead/bootstrap3-typeahead.min.js
//= require datapicker/bootstrap-datepicker.js
//= require mask_plugin/jquery.mask.js
//= require chosen/chosen.jquery.js
//= require jquery_nested_form


$(document).ready(function() {
    $('#receitaws_conta_dia_renovacao').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });

})