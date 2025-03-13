//= require iCheck/icheck.min.js
//= require jquery-ui/jquery-ui.min.js
//= require validate/jquery.validate.min.js
//= require colorpicker/bootstrap-colorselector.min
//= require chosen/chosen.jquery.js
//= require qrcode/qrious.min.js


$(document).ready(function(){
    $('.chosen-select').chosen({width: "100%"});

    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green'
    });

})

function connectWhatsapp(id){
    $('body').lmask('show');
    $.ajax({
        url: `/whatsapp_numeros/${id}/conectar_numero`,
        type: 'POST',
        success: function (data) {
            $('body').lmask('hide');
            createIntervalQrCode(id);
        }, error: function(data){
            $('body').lmask('hide');
            if(data.responseJSON){
                exibirErro(data.responseJSON['error']);
            }else {
                exibirErro(data);
            }
        }
    });
}

function setConnectedNumber(id){
    $.ajax({
        url: `/whatsapp_numeros/${id}/set_numero_conectado`,
        type: 'POST',
        success: function (data) {
        },error: function(data){
            exibirErro(data);
        }
    });
}

function disconnectNumber(id){
    $.ajax({
        url: `/whatsapp_numeros/${id}/desconectar_numero_manualmente`,
        type: 'POST',
        success: function (data) {
            exibirMsg(data.msg);
        },error: function(data){
            exibirErro(data);
        }
    });
}

function criarBlobBase64(base64Data, contentType='', sliceSize=512){
    const byteCharacters = atob(base64Data);
    const byteArrays = [];
  
    for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
      const slice = byteCharacters.slice(offset, offset + sliceSize);
  
      const byteNumbers = new Array(slice.length);
      for (let i = 0; i < slice.length; i++) {
        byteNumbers[i] = slice.charCodeAt(i);
      }
  
      const byteArray = new Uint8Array(byteNumbers);
      byteArrays.push(byteArray);
    }
  
    const blob = new Blob(byteArrays, {type: contentType});
    const blobUrl = URL.createObjectURL(blob);
    return blobUrl;
}


var qr;
function createIntervalQrCode(numero){
    $('#qrCodeModal').modal('show');
    setInterval(function () {
        $.getJSON(`whatsapp_numeros/${numero}/qrcode`, function(data) {
            if(data['qrCode'] || data['qrCodeChatPro']){
                console.log({data})
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
