//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require mask_plugin/jquery.mask.js
//= require typehead/bootstrap3-typeahead.min.js
//= require iCheck/icheck.min.js

$('#lembrete_data').mask('00/00/0000 00:00');

jQuery.validator.addMethod("brazilianDate", function(value, element) {
    return moment(value,"DD/MM/YYYY  HH:mm").isValid()
}, "Data inválida");

$(document).ready(function () {

    if($('#lembrete_index_id').val() != ""){
        window.history.pushState({}, document.title, "/lembretes");
        editarLembrete($('#lembrete_index_id').val());
        $('#lembrete').modal('show');
    }

    $('#btnNovoLembrete').on('click', function(){
        limparFormLembrete();
        $('#lembrete').modal('show');
    });

    $('.editarLembrete').on('click', function(){
        limparFormLembrete()
        editarLembrete($(this)["0"].attributes[3].value)
    });

    $('#lembrete_user_lembrete').typeahead({
        source: function (query, process) {
            return $.ajax({
                url: '/users/find_usuarios/',
                dataType: "json",
                data: {
                    term: query
                },
                success: function(data) {
                    var options = [];
                    map = {}; //replace any existing map attr with an empty object
                    $.each(data,function (i,val){
                        options.push(val.name);
                        map[val.name] = val.id; //keep reference from name -> id
                    });
                    return process(options);
                }
            });
        },
        updater: function (item) {
            $('#lembrete_user_lembrete_id').val(map[item]);
            return item;
        },
        minLength: 2
    });

    $("#lembrete_user_lembrete").focusout(function(){
        var user = $('#lembrete_user_lembrete').val();
        if(!user || user == ''){
            $('#lembrete_user_lembrete_id').val('');
        }
    });

    $('#form_lembrete').validate({
        rules: {
            'lembrete_data': {
                required: true,
                brazilianDate : true
            },
            'lembrete_user_lembrete_id': {
                required: true
            },
            'lembrete_observacao': {
                required: true
            }
        },
        submitHandler: function (form) {
            event.preventDefault()
            $("#form_lembrete").validate()
            $.ajax({
                url: '/lembretes/salvar/',
                data: getFormLembrete(),
                processData: false,
                contentType: false,
                type: 'POST',
                success: function (data) {
                    limparFormLembrete();
                    location.reload();
                },error: function(){
                    exibirErro('Ocorreu algum erro.');
                }
            });
            return false;
        }
    });
});

function editarLembrete(lembrete){
    $.getJSON("/lembretes/find_lembrete?id=" + lembrete, function( data ) {
        setLembrete(data);
    });
    $('#lembrete').modal('show');
}

function limparFormLembrete(){
    $('#form_lembrete #lembrete_id').val('');
    $('#form_lembrete #lembrete_data').val('');
    $('#form_lembrete #lembrete_observacao').val('');
    $("#form_lembrete #lembrete_user_lembrete_id").val('');
    $("#form_lembrete #lembrete_user_lembrete").val('');
    $("#form_lembrete #lembrete_privado").val("true");
}

function setLembrete(data){
    $('#form_lembrete #lembrete_id').val(data['id']);
    $('#form_lembrete #lembrete_data').val(data['data_formatada']);
    $('#form_lembrete #lembrete_observacao').val(data['observacao']);
    $("#form_lembrete #lembrete_user_lembrete_id").val(data['user_lembrete_id']);
    $("#form_lembrete #lembrete_user_lembrete").val(data['user_lembrete']);
    $("#form_lembrete #lembrete_privado").val(data['privado'] + '');
}

function getFormLembrete(){
    form = new FormData();
    form.append('id', $("#lembrete_id").val());
    form.append('data', $("#lembrete_data").val());
    form.append('user_lembrete_id', $("#lembrete_user_lembrete_id").val());
    form.append('observacao', $("#lembrete_observacao").val());
    form.append('privado', $("#lembrete_privado").val());
    return form;
}
