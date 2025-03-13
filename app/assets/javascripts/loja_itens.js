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

var tableLojaNumeros;
var selectedItemsIds = [];

$(document).ready(function(){
    google.charts.load('current', {'packages':['corechart','table']});

    $('.item-checkbox').on('change', function(e) {
        if(!selectedItemsIds.includes($(this).val()) && $(this).prop('checked')){
            selectedItemsIds.push($(this).val());
        } else {
            let index = selectedItemsIds.indexOf($(this).val());
            if (index !== -1) {
                selectedItemsIds.splice(index, 1);
            }
        }
    });

    $('.chosen-select').chosen({width: "100%"});

    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green'
    });

    $('#select-all').change(function() {
        $('.item-checkbox').prop('checked', $(this).prop('checked'));
    });
  
    $('#comprar-selecionados').click(function() {
        var selectedItems = [];
        $('.item-checkbox:checked').each(function() {
            selectedItems.push($(this).val());
        });

        $.ajax({
            url: '/loja_itens/comprar_itens_selecionados',
            type: 'post',
            dataType: 'json',
            data: { selected_items: selectedItems },
            success: function(response) {
            },
            error: function(xhr, status, error) {
            }
        });
    });

    $('#btnMin7DiasMaturacao').on('click', function () {
        $("#maturacao").val('7+');
        getLojaItensFiltered();
    });


    $('.item-checkbox').on('change', function () {});

    createTables()
});

function comprarNumero(idNumero) {
    swal({
        title: `Comprar Número`,
        description: selectedItemsIds,
        type: 'warning',
        showCancelButton: true,
        cancelButtonColor: '#d33',
        confirmButtonColor: '#3085d6',
        showLoaderOnConfirm: true,
        confirmButtonText: 'Sim!',
        cancelButtonText: 'Não!',
        allowOutsideClick: true,
    }).then(function(result) {
        if (result.value) {
            const numeroIds = selectedItemsIds.length > 0 ? selectedItemsIds : [idNumero];
            $.ajax({
                url: `/loja_itens/comprar_numero`,
                type: 'POST',
                data: {numeroIds},
                success: function(data) {
                    window.location.href = "/loja_itens/";
                },
                error: function(data) {
                    exibirErro(data);
                }
            });
            
        }
    });    
}

function openQrCode(idNumero){
    $.ajax({
        url: `/loja_itens/${idNumero}/conectar_qrcode`,
        type: 'POST',
        success: function(data) {
            createIntervalQrCode(data.numero);
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

function removerNumero(idNumero) {
    swal({
        title: `Remover esse número da loja`,
        text: '',
        type: 'warning',
        showCancelButton: true,
        cancelButtonColor: '#d33',
        confirmButtonColor: '#3085d6',
        confirmButtonText: 'Sim!',
        cancelButtonText: 'Não!',
        allowOutsideClick: true
    }).then(function(result) {
        if (result.value) {
            $.ajax({
                url: `/loja_itens/${idNumero}`,
                processData: false,
                contentType: false,
                type: 'DELETE',
                success: function (data) {
                    window.location.href = "/loja_itens/";
                },error: function(data){
                    exibirErro('Ocorreu um erro ao remover um número da loja');
                }
            });
            return false;
        }
    });
};


function getLojaItensFiltered(){
    const usuario_id = $("#usuario_id").val();
    const maturacao = $("#maturacao").val();
    const isMinValue = $("#maturacao").val().match(/\+/) ? true : false
    $.ajax({
        url: `/loja_itens/get_loja_itens?usuario_id=${usuario_id}&maturacao=${maturacao}&isMinValue=${isMinValue}`,
        processData: false,
        contentType: false,
        type: 'GET',
        success: function (data) {
            reloadLojaItens(data);
            return false;
        },error: function(data){
            exibirErro('Ocorreu um erro ao ataulizaros números da loja');
        }
    });
    return false;
}

function reloadLojaItens(data){
    tableLojaNumeros.clear().draw();
    $.each(data, function(i, val) {
        const now = moment(Date.now());
        const before = moment(moment(val['created_at']).startOf('day'));
        var diasDesdeCriacao = now.diff(before, 'days');
        var statusBtn = val['status'] === "DISPONIVEL" ?
            `<a class="btn btn-sm btn-warning" title="Comprar" data-toggle="tooltip" data-placement="right" onclick="comprarNumero(${val['id']})">
                <i class="fa fa-cart-plus" aria-hidden="true"></i>
            </a>` :
            `<a class="btn btn-sm btn-info" title="QrCode" data-toggle="tooltip" data-placement="right" onclick="openQrCode(${val['id']})">
                <i class="fa fa-whatsapp" aria-hidden="true"></i>
            </a>`;

        var editBtn = `<a class="btn btn-sm btn-success" title="Editar" data-toggle="tooltip" data-placement="right" href="/loja_itens/${val['id']}/edit">
                        <i class="fa fa-pencil" aria-hidden="true"></i>
                    </a>`;

        var deleteBtn = `<a class="btn btn-sm btn-danger" title="Remover" data-toggle="tooltip" data-placement="right" onclick="removerNumero(${val['id']})">
                            <i class="fa fa-trash" aria-hidden="true"></i>
                        </a>`;

        var rowData = [
            (val['status'] === "DISPONIVEL") ? "<input type='checkbox' class='item-checkbox' value='" + val['id'] + "'>" : "",
            moment(val['created_at']).format('DD/MM/YYYY'),
            diasDesdeCriacao + " dias",
            val['numero'],
            val['user']['name'],
            val['apelido'] ? val['apelido'] : '',
            val['status'] === "DISPONIVEL" ? '✅' : '❌',
            editBtn + deleteBtn + statusBtn
        ];

        tableLojaNumeros.row.add(rowData);
    });

    tableLojaNumeros.draw();
};


function totalizadorPorVendedor() {
    $.ajax({
        url: '/loja_itens/vendas_pendentes_vendedor',
        type: 'get',
        dataType: 'json',
        success: function(data) {
            var totalLayoutPorVendedor = new google.visualization.DataTable();
            totalLayoutPorVendedor.addColumn('string', 'Vendedor')
            totalLayoutPorVendedor.addColumn('string', 'Qtd')
            var totalPorVendedor = new google.visualization.Table(document.getElementById('tableTotalizadorNumeroPorVendedor'));
            let total = 0;
            $.each(data, function(i, val) {
                totalLayoutPorVendedor.addRow([val['vendedor'].toLocaleString(), val['qtd'].toLocaleString()]);
                total += parseInt(val['qtd']);
            });
            totalLayoutPorVendedor.addRow(['Total', parseInt(total).toLocaleString()]);
            if(totalPorVendedor && totalLayoutPorVendedor) totalPorVendedor.draw(totalLayoutPorVendedor, 
                {allowHtml: true, width: '100%', height: '70%', sort: 'disable'}
            );
        },
        error: function(xhr, status, error) {
        }
    });
}

function createTableLojaNumeros() {
    tableLojaNumeros = $('.table-loja-numeros').DataTable({
        pageLength: 10,
        rowReorder: {
            selector: 'td:nth-child(2)'
        },
        responsive: true,
        dom: '<"html5buttons"B>lTfgitp',
        "order": [[1, 'DESC']],
        buttons: [
            {extend: 'excel', title: 'Loja Itens'},
            {extend: 'pdf', title: 'Loja Itens'}
        ],
        "language": {
            "url": "//cdn.datatables.net/plug-ins/1.10.16/i18n/Portuguese-Brasil.json"
        },
        "columnDefs": [
            { "width": "2%", "targets": 0 },
            { "width": "4%", "targets": 1 },
            { "width": "5%", "targets": 2 },
            { "width": "20%", "targets": 3 },
            { "width": "18%", "targets": 4 },
            { "width": "22%", "targets": 5 },
            { "width": "1%", "targets": 6 },
            { "width": "18%", "targets": 7 },
        ],
    });
};

function createTables() {
    createTableLojaNumeros()
    totalizadorPorVendedor()
}
