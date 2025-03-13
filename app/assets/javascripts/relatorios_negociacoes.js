//= require typehead/bootstrap3-typeahead.min.js
//= require jquery-ui/jquery-ui.min.js
//= require datapicker/bootstrap-datepicker.js

$(document).ready(function(){

    var date = new Date();
    $('#data_inicio').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: true,
        autoclose: true,
        format: 'dd/mm/yyyy'
    });
    $("#data_inicio").datepicker("setDate", new Date(date.getFullYear(), date.getMonth(), date.getDate()));

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
