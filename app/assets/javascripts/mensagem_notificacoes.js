
//= require chosen/chosen.jquery.js


$(document).ready(function(){
	recreateTableMensagemNotificacao('.table-notificacao-whatsapps-desativados')
	recreateTableMensagemNotificacao('.table-notificacao-whatsapps-ativos')
	
	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
		var target = $(e.target).attr("href");
		if (target === "#tabAtivos-1") {
			recreateTableMensagemNotificacao('.table-notificacao-whatsapps-ativos');
		} else if (target === "#tabDesativados-2") {
			recreateTableMensagemNotificacao('.table-notificacao-whatsapps-desativados');
		}
	});

	$("#tooltip-notificacao").tooltip();
});

function recreateTableMensagemNotificacao(selector) {
	if ($.fn.DataTable.isDataTable(selector)) {
		$(selector).DataTable().destroy();
	}

	$(selector).DataTable({
		pageLength: 10,
		rowReorder: {
			selector: 'td:nth-child(2)'
		},
		responsive: true,
		dom: '<"html5buttons"B>lTfgitp',
		"order": [[1, 'DESC']],
		buttons: [
			{extend: 'excel', title: 'MensagemNotificacao'},
			{extend: 'pdf', title: 'MensagemNotificacao'}
		],
		"language": {
			"url": "//cdn.datatables.net/plug-ins/1.10.16/i18n/Portuguese-Brasil.json"
		},
		"columnDefs": [
			{ "width": "8%", "targets": 0 },
			{ "width": "12%", "targets": 1 },
			{ "width": "12%", "targets": 2 },
			{ "width": "12%", "targets": 3 },
			{ "width": "48%", "targets": 4 },
			{ "width": "5%", "targets": 5 }
		],
	});
}