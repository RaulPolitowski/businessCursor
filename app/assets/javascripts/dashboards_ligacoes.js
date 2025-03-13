$(document).ready(function() {
    $('#data_value').val(moment().format('DD/MM/YYYY'));
    $('#data_value').text('Ligações por usuário (' + moment().format('DD/MM/YYYY') + ')');
    $('#data_value_status').val(moment().format('DD/MM/YYYY'));
    $('#data_value_status').text('Ligações por status cliente (' + moment().format('DD/MM/YYYY') + ')');
    $('#data_value_status_ligacao').val(moment().format('DD/MM/YYYY'));
    $('#data_value_status_ligacao').text('Ligações por status (' + moment().format('DD/MM/YYYY') + ')');

    $('#btnCliente').on('click', function () {
        $('#todas_lig').val("false");
        console.log($('#todas_lig').val());
        //atualizarPaineis();
        return false;
    });

    $('#btnLigacoes').on('click', function () {
        $('#todas_lig').val("true");
        console.log($('#todas_lig').val());
        //atualizarPaineis();
        return false;
    });

    $(function() {
        createTableCliente();

        $('#bloco_clientes').hide();
        var donut = Morris.Donut({
            element: 'ultimosdiausuario',
            data:[ {value: 0} ],
            resize: true,
            colors: ['#87d6c6',  '#1ab394', 'red', 'blue'],
        }).on('click', function (i, row) {
            $.getJSON("/users/find_usuario_by_id?id="+row['id'], function(data) {
                $('#bloco_clientes').hide();
                var table = $('.table-clientes').DataTable();                
                table.clear().draw();
                if($('#usuario_id').val() == data['id']){
                    $('#usuario_id').val('');
                    $('#usuario_name_status').text('');
                    $('#usuario_name_status_ligacao').text('');
                }else{
                    $('#usuario_id').val(data['id']);
                    $('#usuario_name_status').text(data['name']);
                    $('#usuario_name_status_ligacao').text(data['name']);

                    $.getJSON("/dashboards/get_clientes_by_status?dia=" + $('#data_value').val()+'&usuario_id=' + data['id'] +
                        "&empresa_id=" + $('#empresa_id').val()+"&estado_id="+$('#estado_financeiro_id').val(), function(data) {
                        $('#bloco_clientes').show();
                        var t = $('.table-clientes').DataTable();
                        $.each(data,function (i,val){
                            t.row.add( [
                                `<a onclick='novaLigacaoCNPJ("${val["cnpj"]}","${val["estado"]}")'>${val["cnpj"]}</a>`,
                                val['razao_social'],
                                val['cidade'],
                                val['data_inicio_formatada'],
                                val['status_cliente'],
                                val['usuario'],
                                val['observacao']
                            ] ).draw( false );
                        });

                    });
                }
                $('#status_ligacao_id').val('');

                atualizarLigacoesStatus();
                atualizarLigacoesStatusLigacao();
            });
        });

        var donut_status_ligacao = Morris.Donut({
            element: 'ligacoes_por_status_ligacao',
            data:[ {value: 0} ],
            resize: true,
            colors: ['#87d6c6',  '#1ab394', 'red', 'blue', 'yellow', 'green', 'gray'],
        }).on('click', function (i, row) {
            $.getJSON("/dashboards/get_clientes_by_status_ligacao?status="+row['id']+'&dia=' + $('#data_value').val()+'&usuario_id=' + $('#usuario_id').val() +
                "&empresa_id=" + $('#empresa_id').val()+"&estado_id="+$('#estado_financeiro_id').val(), function(data) {

                var table = $('.table-clientes').DataTable();
                table.clear().draw();
                if($('#status_ligacao_id').val() == row['id']){
                    $('#status_ligacao_id').val('');
                    $('#bloco_clientes').hide();
                }else{
                    $('#status_ligacao_id').val(row['id']);
                    $('#tabela_clientes_msg').text('Tabela de Ligações (Status: ' + row['label'] + ')');
                    $('#bloco_clientes').show();
                    var t = $('.table-clientes').DataTable();
                    $.each(data,function (i,val){
                        t.row.add( [
                            val['cnpj'],
                            val['razao_social'],
                            val['cidade'],
                            val['data_inicio_formatada'],
                            val['status_cliente'],
                            val['usuario'],
                            val['observacao']
                        ] ).draw( false );
                    });
                }
                atualizarLigacoesStatus();

            });
        });

        var donut_status = Morris.Donut({
            element: 'ligacoesstatus',
            data:[ {value: 0} ],
            resize: true,
            colors: ['#87d6c6',  '#1ab394', 'red', 'blue', 'yellow', 'green', 'gray', 'lightblue'],
        }).on('click', function (i, row) {
            $.getJSON("/dashboards/get_clientes_by_status?status="+row['id']+'&dia=' + $('#data_value').val()+'&usuario_id=' + $('#usuario_id').val() + '&status_ligacao_id=' + $('#status_ligacao_id').val() +
            "&empresa_id=" + $('#empresa_id').val()+"&estado_id="+$('#estado_financeiro_id').val(), function(data) {
                var table = $('.table-clientes').DataTable();
                table.clear().draw();
                $('#tabela_clientes_msg').text('Tabela de Ligações (Status: ' + row['label'] + ')');
                $('#bloco_clientes').show();
                var t = $('.table-clientes').DataTable();
                $.each(data,function (i,val){
                    t.row.add( [
                        val['cnpj'],
                        val['razao_social'],
                        val['cidade'],
                        val['data_inicio_formatada'],
                        val['status_cliente'],
                        val['usuario'],
                        val['observacao']
                    ] ).draw( false );
                });

            });
        });



        var bar = Morris.Bar({
            element: 'ultimos10dias',
            data:[ {value: 0} ],
            xkey: 'dia',
            ykeys: ['qtd'],
            labels: ['Quantidade'],
            hideHover: 'auto',
            resize: true,
            barColors: ['#1ab394', '#cacaca'],
        }).on('click', function (i, row) {
            var thisDataHtml = $(".morris-hover-point").html().split(":");
            var qtd = thisDataHtml[1].trim();
            $('#usuario_id').val('');
            $('#usuario_name_status').text('');
            $('#usuario_name_status_ligacao').text('');
            $('#status_ligacao_id').val('');
            $('#bloco_clientes').hide();
            var table = $('.table-clientes').DataTable();
            table.clear().draw();

            if(qtd == 0){
                return false;
            }

            $('#data_value').val(moment($(".morris-hover-row-label").html(),"DD/MM/YYYY").format("DD/MM/YYYY"));
            $('#data_value').text('Ligações por usuário (' + moment($(".morris-hover-row-label").html(),"DD/MM/YYYY").format("DD/MM/YYYY") + ')');
            atualizarLigacoesDia();

            $('#data_value_status').val(moment($(".morris-hover-row-label").html(),"DD/MM/YYYY").format("DD/MM/YYYY"));
            $('#data_value_status').text('Ligações por status cliente (' + moment($(".morris-hover-row-label").html(),"DD/MM/YYYY").format("DD/MM/YYYY") + ')');
            atualizarLigacoesStatus();

            $('#data_value_status_ligacao').val(moment($(".morris-hover-row-label").html(),"DD/MM/YYYY").format("DD/MM/YYYY"));
            $('#data_value_status_ligacao').text('Ligações por status (' + moment($(".morris-hover-row-label").html(),"DD/MM/YYYY").format("DD/MM/YYYY") + ')');
            atualizarLigacoesStatusLigacao();
        });


        atualizarLigacoesDia();
        ligacoes10Dias();
        atualizarLigacoesStatus();
        atualizarLigacoesStatusLigacao();

        setInterval(atualizarLigacoesDia, 320000);
        setInterval(atualizarLigacoesStatus, 320000);
        setInterval(atualizarLigacoesStatusLigacao, 320000);
        setInterval(ligacoes10Dias, 320000);

        $('#btnAtualizarPainelVendas').on('click', function () {
            if($('#empresa_id').val() == ''){
                exibirWarning("Selecione uma empresa!");
                return false;
            }
            atualizarPaineis();
            return false;
        });

        function atualizarPaineis(){
            atualizarLigacoesDia();
            ligacoes10Dias();
            atualizarLigacoesStatus();
            atualizarLigacoesStatusLigacao();
        }

        function atualizarLigacoesDia(){
            $.getJSON("/dashboards/get_ligacoes_dia?data="+$('#data_value').val()+"&empresa_id=" + $('#empresa_id').val()+"&estado_id="+$('#estado_financeiro_id').val()+"&flag="+$('#todas_lig').val(), function(data) {
                donut.setData(data);
            });
        }

        function atualizarLigacoesStatus(){
            $.getJSON("/dashboards/get_ligacoes_status?data="+$('#data_value').val() + '&user_id=' + $('#usuario_id').val() + '&status_ligacao_id=' + $('#status_ligacao_id').val() +
                "&empresa_id=" + $('#empresa_id').val()+"&estado_id="+$('#estado_financeiro_id').val(), function(data) {
                donut_status.setData(data);
            });
        }

        function atualizarLigacoesStatusLigacao(){
            $.getJSON("/dashboards/get_ligacoes_status_ligacao?data="+$('#data_value').val() + '&user_id=' + $('#usuario_id').val() +
                "&empresa_id=" + $('#empresa_id').val()+"&estado_id="+$('#estado_financeiro_id').val(), function(data) {
                donut_status_ligacao.setData(data);
            });
        }

        function ligacoes10Dias() {
            $.getJSON("/dashboards/get_ligacoes_dias?empresa_id=" + $('#empresa_id').val()+"&estado_id="+$('#estado_financeiro_id').val()+"&flag="+$('#todas_lig').val(), function(data) {
                bar.setData(data);
            });
        }

        function createTableCliente(){
            if ($("#DataTables_Table_0_wrapper").length == 0){
                $('.table-clientes').DataTable({
                    pageLength: 10,
                    responsive: true,
                    dom: '<"html5buttons"B>lTfgitp',
                    buttons: [
                        {
                            extend: 'excel',
                            title: 'Clientes'
                        },
                        {extend: 'pdf', title: 'Clientes'}

                    ],
                    "ordering": false,
                    "language": {
                        "url": "//cdn.datatables.net/plug-ins/1.10.16/i18n/Portuguese-Brasil.json"
                    }
                });
            }
        }


    });
    
});
function novaLigacaoCNPJ(cnpj, estado) {
    $.ajax({
        url: '/empresas/get_empresa_by_sigla_estado',
        data: {sigla: estado},
        type: 'GET',
        success: function (data) {
            const empresa = data.id
            get_current_empresa()
                .then((current_empresa) => {
                if (estado !== current_empresa.estado) {
                    alterar_empresa(empresa);
                } else {
                    window.open(`/ligacoes/ligacao?cnpj_contatos_realizados=${cnpj}`, '_blank')
                }
                })
                .catch((error) => {
                    console.error(error);
                });
        },error: function(){
            alert('Ocorreu algum erro!')
        }
    });

    const get_current_empresa = () => {
        return new Promise((resolve, reject) => {
            $.ajax({
                url: '/users/get_current_empresa/',
                data: {},
                type: 'GET',
                success: function(data) {
                    current_empresas = data;
                    resolve(data);
                },
                error: function() {
                    reject('Ocorreu algum erro!');
                }
            });
        });
    }

    const alterar_empresa = (empresa) =>{
        $.ajax({
            url: '/users/alterar_empresa/',
            data: {empresa_id: empresa},
            type: 'POST',
            success: function (data) {
                window.open(`/ligacoes/ligacao?cnpj_contatos_realizados=${cnpj}`, '_blank');
            },error: function(){
                alert('Ocorreu algum erro!')
            }
        });
    }
}



