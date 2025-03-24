//= require dataTables/datatables.min.js
//= require chosen/chosen.jquery.js
//= require qtip/jquery.qtip.min.js
//= require jquery-ui/jquery-ui.min.js


$(document).ready(function() {
  google.charts.load('current', {'packages':['corechart','table'], 'callback': carregarGraficos});
  
  $('#btnAtualizarGraficoDesistencia').on('click', function (){
    carregarGraficos();
    return false;
  });

  $('#btnAtualizarComparativoMensal').on('click', function (){
    exibirComparativoMensal();
    return false;
  });
});

function validarEmpresas() {
  const empresas = $('#select_empresas_financeiro').val();
  if(empresas.length == 0) {
    exibirErro('Selecione ao menos uma empresa');
    return false;
  } else {
    return true;
  }
}

function carregarGraficos() {
  $('#bloco_clientes_bloqueados').hide();
  $('#bloco_clientes_bloqueados_atualmente').hide();
  buscarQtdDesistentesPorTags();
  buscarDesistentesBloqueados();
}

function buscarDesistentesBloqueados() {
  $.getJSON(`/dashboards/clientes_bloqueados?empresas=${$('#select_empresas_financeiro').val()}&datainicial=${$('#data_inicio').val()}&datafinal=${$('#data_fim').val()}`, function(data) {
    if (!data) return;

    const bloqueados = data[0];
    const bloqueadosAtualmente = data[1];

    $('#clientes_ativos_bloqueados').text(`Total ${bloqueados.qtd}`);
    $('#valor_clientes_ativos_bloqueados').text(`${mascaraValor(bloqueados.valor)}`);
    $('#media_clientes_ativos_bloqueados').text(`Média ${mascaraValor(bloqueados.media)}`);

    $('#clientes_ativos_bloqueados_atualmente').text(`Total ${bloqueadosAtualmente.qtd}`);
    $('#valor_clientes_ativos_bloqueados_atualmente').text(`${mascaraValor(bloqueadosAtualmente.valor)}`);
    $('#media_clientes_ativos_bloqueados_atualmente').text(`Média ${mascaraValor(bloqueadosAtualmente.media)}`);
  });
}

function buscarQtdDesistentesPorTags(){
  $.getJSON(`/dashboards/desistentes_por_tags?datainicial=${$('#data_inicio').val()}&datafinal=${$('#data_fim').val()}`, function(data) {
    if (!data) return;

    drawPieChartTagsDesistencia(data);
  });
}

function drawPieChartTagsDesistencia(data) {
  let dataArray = [
    ['Descricao', 'Qtd. Disparo', { role: 'tooltip', type: 'string' }, 'Id'],
  ];

  if (data) {
    for (let i = 0; i < data.length; i++) {
      let tooltip = `${data[i].descricao}\n${data[i].info_completa}`;
      
      let descricaoFormatada = `${data[i].descricao} (${data[i].info_completa})`;
      
      let row = [descricaoFormatada, parseInt(data[i].qtd), tooltip, data[i].id];
      dataArray.push(row);
    }
  }

  let options = {
    width: 500,
    height: 400,
    'chartArea': {'width': '100%', 'height': '70%'},
    legend: {
      position: 'right',
      textStyle: { fontSize: 12 }
    },
    tooltip: { 
      text: 'both' 
    },
    pieSliceText: 'percentage'
  };

  let chart = new google.visualization.PieChart(document.getElementById('pie_chart_tags_desistencia'));
  let googleData = google.visualization.arrayToDataTable(dataArray);
  chart.draw(googleData, options);

  let allTags = data.map(item => item.id).join(',');

  exibirDetalhesDesistentes(allTags, true);

  google.visualization.events.addListener(chart, 'select', function() {
    const selectedItem = chart.getSelection()[0];

    if (selectedItem) {
      const tags = googleData.getValue(selectedItem.row, 3);
      exibirDetalhesDesistentes(tags, false);
    }
  });
}

function carregarInfoClientesBloqueadosAtualmente() {
  if (!validarEmpresas()) return;
  $('#bloco_clientes_bloqueados').hide();
  if($('#bloco_clientes_bloqueados_atualmente').is(':visible')){
    $('#bloco_clientes_bloqueados_atualmente').hide();
  }else{
    $('body').lmask('show');

    $.getJSON(`/dashboards/table_clientes_bloqueados_atualmente?empresa=${$('#select_empresas_financeiro').val()}&data=${$('#data_inicio').val()}`, function(data) {
      $('#bloco_clientes_bloqueados_atualmente').show();
      $('#bloco_clientes_bloqueados_atualmente').css('float', 'none');
      $('#bloco_clientes_bloqueados_atualmente').css('padding-bottom', '50px');

      let table = $('.table-clientes-bloqueados-atualmente').DataTable();
      table.clear().draw();
      $.each(data,function (i,val){
        table.row.add( [
          moment(val['databloqueio']).format("DD/MM/YYYY"),
          val['dias_bloq'],
          val['dias_sem_uso'],
          val['dias_cliente'],
          val['razaosocial'],
          val['cidade'],
          val['sistema'],
          mascaraValor(val['valor']),
          val['hist_ligacoes']
        ] ).draw( false );
      });

      $('body').lmask('hide');
    });
  }
}

function carregarInfoClienteBloqueados() {
  if (!validarEmpresas()) return;
  $('#bloco_clientes_ativos').hide();
  $('#bloco_clientes_bloqueados_atualmente').hide();
  if($('#bloco_clientes_bloqueados').is(':visible')){
    $('#bloco_clientes_bloqueados').hide();
  }else{
    $('body').lmask('show');

    $.getJSON(`/dashboards/table_clientes_ativos_bloqueados?empresa=${$('#select_empresas_financeiro').val()}&data=${$('#data_inicio').val()}&tipo='BLOQUEADO'`, function(data) {
      $('#bloco_clientes_bloqueados').show();
      $('#bloco_clientes_bloqueados').css('float', 'none');
      $('#bloco_clientes_bloqueados').css('padding-bottom', '50px');

      let table = $('.table-clientes-bloqueados').DataTable();
      table.clear().draw();
      $.each(data,function (i,val){
        table.row.add( [
          moment(val['databloqueio']).format("DD/MM/YYYY"),
          val['dias_bloq'],
          val['dias_sem_uso'],
          val['dias_cliente'],
          val['razaosocial'],
          val['cidade'],
          val['sistema'],
          mascaraValor(val['valor']),
          val['hist_ligacoes']
        ]).draw( false );
      });

      $('body').lmask('hide');
    });
  }
}

function exibirDetalhesDesistentes(tags, mostrarTodos) {
  $.getJSON(`/dashboards/buscar_info_desistentes_por_tag?datainicial=${$('#data_inicio').val()}&datafinal=${$('#data_fim').val()}&tags=${tags}`, function(data) {
    let dataTable = new google.visualization.DataTable();
    let totalTable = new google.visualization.DataTable();

    dataTable.addColumn('string', 'Porcentagem');
    dataTable.addColumn('string', 'Qtd.');
    dataTable.addColumn('string', 'Valor');
    dataTable.addColumn('string', 'Sistema');
    if (mostrarTodos)
      dataTable.addColumn('string', 'Tags');

    totalTable.addColumn('string', '');
    totalTable.addColumn('string', '');
    totalTable.addColumn('string', '');
    totalTable.addColumn('string', '');
    if (mostrarTodos)
      totalTable.addColumn('string', '');

    let valorTotal = 0;
    let qtdTotal = 0;

    $.each(data, function (i, val) {
      const row = [
        `${val['porcentagem']}%`,
        val['qtd'],
        `${mascaraValor(val['valor'])}`,
        val['sistema'],
      ];

      valorTotal += parseInt(val['valor']);
      qtdTotal += parseInt(val['qtd']);

      if (mostrarTodos)
        row.push(val['tag']);

      dataTable.addRow(row);
    });

    const rowData = [
      '<span style="font-weight: bolder;">Total</span>',
      `<span style="font-weight: bolder;">Qtd: ${qtdTotal}</span>`,
      `<span style="font-weight: bolder;">Valor: ${mascaraValor(parseFloat(valorTotal).toFixed(2))}</span>`,
      ''
    ];

    if (mostrarTodos)
      rowData.push('');

    totalTable.addRow(rowData);

    if (mostrarTodos)
      $('#titulo_tag_desistencia').text(`Clientes desistentes - Todos`);
    else
      $('#titulo_tag_desistencia').text(`Clientes desistentes - ${data[0]['tag']}`);

    const table = new google.visualization.Table(document.getElementById('table_infos_bloqueados'));
    table.draw(dataTable, {
      allowHtml: true,
      width: '100%',
      height: '100%'
    });

    const totalRowTable = new google.visualization.Table(document.getElementById('total_row_div'));
    totalRowTable.draw(totalTable, {
      allowHtml: true,
      width: '100%',
      height: '45px',
      allowHtml: true,
      cssClassNames: {
        headerRow: 'hidden-header',
      }
    });
  });
}


function exibirComparativoMensal() {
  const tags = $('#select_tags_desistencia').val();

  $.getJSON(`/dashboards/comparacao_tags_mensal?primeiro_mes=${$('#primeiro_mes').val()}&segundo_mes=${$('#segundo_mes').val()}&tags=${tags}`, function(data) {
    let dataTable = new google.visualization.DataTable();

    adicionarColunasTabelaComparativoMensal(dataTable);
    const totais = inicializarTotaisComparativoMensal();

    $.each(data, function(i, val) {
      const {
        tag,
        qtd_primeiro_mes: qtdPrimeiroMes,
        qtd_segundo_mes: qtdSegundoMes,
        valor_primeiro_mes: valorPrimeiroMes,
        valor_segundo_mes: valorSegundoMes,
        diferenca_qtd: diferencaQtd,
        diferenca_valor: diferencaValor
      } = val;

      const row = [
        tag,
        formatarCentroTexto(qtdPrimeiroMes),
        formatarCentroTexto(qtdSegundoMes),
        formatarCentroTexto(mascaraValor(valorPrimeiroMes)),
        formatarCentroTexto(mascaraValor(valorSegundoMes)),
        formatarCentroTexto(diferencaQtd),
        formatarCentroTexto(mascaraValor(diferencaValor))
      ];

      dataTable.addRow(row);

      atualizarTotaisComparativoMensal(totais, {
        qtdPrimeiroMes,
        qtdSegundoMes,
        valorPrimeiroMes,
        valorSegundoMes,
        diferencaQtd,
        diferencaValor
      });
    });

    adicionarLinhaTotais(dataTable, totais);

    const table = new google.visualization.Table(document.getElementById('table_comparativo_desistentes_mensal'));
    table.draw(dataTable, {allowHtml: true, width: '100%', height: '100%'});
  });
}

function formatarCentroTexto(valor, outraClass = '') {
  return `<div class="center-text ${outraClass}">${valor}</div>`
}

function atualizarTotaisComparativoMensal(totais, valores) {
  totais.qtdPrimeiroMes += parseInt(valores.qtdPrimeiroMes, 10);
  totais.qtdSegundoMes += parseInt(valores.qtdSegundoMes, 10);
  totais.valorPrimeiroMes += parseFloat(valores.valorPrimeiroMes);
  totais.valorSegundoMes += parseFloat(valores.valorSegundoMes);
  totais.diferencaQtd += parseInt(valores.diferencaQtd, 10);
  totais.diferencaValor += parseFloat(valores.diferencaValor);
}

function inicializarTotaisComparativoMensal() {
  return {
    qtdPrimeiroMes: 0,
    qtdSegundoMes: 0,
    valorPrimeiroMes: 0.0,
    valorSegundoMes: 0.0,
    diferencaQtd: 0,
    diferencaValor: 0.0
  };
}

function adicionarColunasTabelaComparativoMensal(dataTable) {
  dataTable.addColumn('string', 'Tags');
  dataTable.addColumn('string', '1º mês qtd.');
  dataTable.addColumn('string', '2º mês qtd.');
  dataTable.addColumn('string', '1º mês valor');
  dataTable.addColumn('string', '2º mês valor');
  dataTable.addColumn('string', 'Diferença qtd.');
  dataTable.addColumn('string', 'Diferença valor');
}

function adicionarLinhaTotais(dataTable, totais) {
  const totalRow = [
    '<div class="font-weight-bold">Total</div',
    formatarCentroTexto(`${totais.qtdPrimeiroMes}`, 'font-weight-bold'),
    formatarCentroTexto(`${totais.qtdSegundoMes}`, 'font-weight-bold'),
    formatarCentroTexto(`${mascaraValor(totais.valorPrimeiroMes.toFixed(2))}`, 'font-weight-bold'),
    formatarCentroTexto(`${mascaraValor(totais.valorSegundoMes.toFixed(2))}`, 'font-weight-bold'),
    formatarCentroTexto(`${totais.diferencaQtd}`, 'font-weight-bold'),
    formatarCentroTexto(`${mascaraValor(totais.diferencaValor.toFixed(2))}`, 'font-weight-bold')
  ];

  dataTable.addRow(totalRow);
}

function selecionarTodos() {
  const select = $('#select_tags_desistencia');
  select.find('option').prop('selected', true);
  select.trigger('chosen:updated');
}

function deselecionarTodos() {
  const select = $('#select_tags_desistencia');
  select.find('option').prop('selected', false);
  select.trigger('chosen:updated');
}