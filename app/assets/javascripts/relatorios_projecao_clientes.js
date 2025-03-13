//= require typehead/bootstrap3-typeahead.min.js
//= require jquery-ui/jquery-ui.min.js
//= require datapicker/bootstrap-datepicker.js

$(document).ready(function(){

    var date = new Date();
    $('#data_inicio_projecao').datepicker({
        format: "mm/yyyy",
        viewMode: "months",
        minViewMode: "months",
        keyboardNavigation: false,
        autoclose: true
    });
    $("#data_inicio_projecao").datepicker("setDate", new Date(date.getFullYear(), date.getMonth()+1, 1));

    $('#data_fim_projecao').datepicker({
        format: "mm/yyyy",
        viewMode: "months",
        minViewMode: "months",
        keyboardNavigation: false,
        autoclose: true
    });
    $("#data_fim_projecao").datepicker("setDate", new Date(date.getFullYear(), date.getMonth()+1, 1));

})
