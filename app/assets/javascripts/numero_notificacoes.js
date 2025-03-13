//= require iCheck/icheck.min.js
//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require colorpicker/bootstrap-colorselector.min
//= require chosen/chosen.jquery.js
//= require qrcode/qrious.min.js
//= require dataTables/datatables.min.js
//= require typehead/bootstrap3-typeahead.min.js
//= require datapicker/bootstrap-datepicker.js
//= require jquery_nested_form

$(document).ready(function(){

    $('.chosen-select').chosen({width: "100%"});

    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green'
    });
  
    createTables()
});


function openQrCode(numero){
    $.ajax({
        url: `/whatsapp_numeros/${numero}/conectar_numero`,
        data: {isNotificacao: true},
        type: 'POST',
        success: function(data) {
            createIntervalQrCode(numero);
        },
        error: function(data) {
            exibirErro(data);
        }
    });
}

function createIntervalQrCode(numero){
    $('#qrCodeModal').modal('show');
    setInterval(function () {
        $.getJSON(`whatsapp_numeros/${numero}/qrcode`, function(data) {
            if(data['qrCode'] || data['qrCodeChatPro']){
                if($("#tab-content").tabs({ active: 2 }) && data['isChatPro'] && data['qrCodeChatPro']){
                    let cookieQrCode = localStorage.getItem("whatsQrCode");
                    if (cookieQrCode !== data['qrCodeChatPro']){
                        localStorage.setItem("whatsQrCode", data["qrCodeChatPro"]);
                        const qr_chat_pro = document.getElementById('qr_chat_pro')
                        qr_chat_pro.src = data["qrCodeChatPro"]
                    }
                }

                qr = new QRious({
                    element: document.getElementById('qr'),
                    value: data['qrCode'],
                    padding: 15,
                    size: 350,
                });
            }
        })
    }, 1000);
}

function disconnectNumber(numero){
    $.ajax({
        url: `/numero_notificacoes/${numero}/desconectar_numero`,
        type: 'POST',
        success: function (data) {
            exibirMsg(data.msg);
            window.location.reload();
        },error: function(data){
            exibirErro(data.responseText);
        }
    });
}

function createTableNumeroNotificacao() {
    $('.table-numeros-notificacao').DataTable({
        pageLength: 10,
        rowReorder: {
            selector: 'td:nth-child(2)'
        },
        responsive: true,
        dom: '<"html5buttons"B>lTfgitp',
        "order": [[1, 'DESC']],
        buttons: [
            {extend: 'excel', title: 'NumeroNotificacao'},
            {extend: 'pdf', title: 'NumeroNotificacao'}
        ],
        "language": {
            "url": "//cdn.datatables.net/plug-ins/1.10.16/i18n/Portuguese-Brasil.json"
        },
        "columnDefs": [
            { "width": "25%", "targets": 0 },
            { "width": "25%", "targets": 1 },
            { "width": "25%", "targets": 2 },
            { "width": "25%", "targets": 3 },
 
        ],
    });
};

function createTables() {
    createTableNumeroNotificacao()
}
