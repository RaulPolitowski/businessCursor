//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require iCheck/icheck.min.js
//= require chosen/chosen.jquery.js

$(function() {
    $('.chosen-select').chosen({width: "100%"});

    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green'
    });


});