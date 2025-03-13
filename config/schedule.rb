# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
# Example:
#
#set :output, "/home/alison/Documents/cron_log.log"
set :output, "/var/www/business.gtech.site/shared/log/cron_log.log"

every 1.day, :at => '0:00 am' do
  rake "processar_limbo"
end

every 1.day, :at => '0:15 am' do
  rake "importar_ba", :output => {:error => '/var/www/business.gtech.site/shared/log/error_ba.log', :standard => '/var/www/business.gtech.site/shared/log/cron_ba.log'}
end

# every 1.day, :at => '1:00 am' do
#   rake "importar_pb", :output => {:error => '/var/www/business.gtech.site/shared/log/error_pb.log', :standard => '/var/www/business.gtech.site/shared/log/cron_pb.log'}
# end

every 1.day, :at => '1:30 am' do
  rake "importar_ma", :output => {:error => '/var/www/business.gtech.site/shared/log/error_ma.log', :standard => '/var/www/business.gtech.site/shared/log/cron_ma.log'}
end

# every 1.day, :at => '2:00 am' do
#   rake "importar_rj", :output => {:error => '/var/www/business.gtech.site/shared/log/error_rj.log', :standard => '/var/www/business.gtech.site/shared/log/cron_rj.log'}
# end

# every 1.day, :at => '2:30 am' do
#   rake "importar_mg", :output => {:error => '/var/www/business.gtech.site/shared/log/error_mg.log', :standard => '/var/www/business.gtech.site/shared/log/cron_mg.log'}
# end

every 1.day, :at => '3:00 am' do
  rake "importar_pe", :output => {:error => '/var/www/business.gtech.site/shared/log/error_pe.log', :standard => '/var/www/business.gtech.site/shared/log/cron_pe.log'}
end

# every 1.day, :at => '3:30 am' do
#   rake "importar_ce", :output => {:error => '/var/www/business.gtech.site/shared/log/error_ce.log', :standard => '/var/www/business.gtech.site/shared/log/cron_ce.log'}
# end

every 1.day, :at => '4:00 am' do
  rake "importar_es", :output => {:error => '/var/www/business.gtech.site/shared/log/error_es.log', :standard => '/var/www/business.gtech.site/shared/log/cron_es.log'}
end

every 1.day, :at => '5:00 am' do
  rake "importar_go", :output => {:error => '/var/www/business.gtech.site/shared/log/error_go.log', :standard => '/var/www/business.gtech.site/shared/log/cron_go.log'}
end

every 1.day, :at => '6:00 am' do
  rake "importar_pr", :output => {:error => '/var/www/business.gtech.site/shared/log/error_pr.log', :standard => '/var/www/business.gtech.site/shared/log/cron_pr.log'}
end

every 1.day, :at => '7:00 am' do
  rake "importar_rs", :output => {:error => '/var/www/business.gtech.site/shared/log/error_rs.log', :standard => '/var/www/business.gtech.site/shared/log/cron_rs.log'}
end

every 1.day, :at => '7:45 am' do
  rake "importar_ms", :output => {:error => '/var/www/business.gtech.site/shared/log/error_ms.log', :standard => '/var/www/business.gtech.site/shared/log/cron_ms.log'}
end

# every 1.day, :at => '21:15 pm' do
#   rake "importar_sp"
# end

every 1.day, :at => '21:30 pm' do
  rake "registrar_fim_controle"
end

every 1.day, :at => '00:10 pm' do
  rake "reajustar_filas"
end

every 1.day, :at => '06:30 am' do
  rake "gerar_fila"
end

#
# every 12.hours do
#   rake "registrar_empresas_inertes"
# end
#
# every 12.hours do
#   rake "registrar_pesquisas"
# end

every 1.month, :at => '01:00 am' do
  rake "finalizar_notificacoes"
end

every 4.hours do
  rake "verificar_contas_receita_ws"
end

every 30.minute do
  rake 'atualizar_campanhas'
end

every 5.minute do
  rake 'atualizar_numeros_ocultos'
end

every 1.day, :at => ['04:30 am', '18:30 pm', '23:30 pm'] do
  rake "reconsultar_empresas_recentes"
end

every '0 17 * * 0', if: -> { Date.today.day <= 7 } do
  rake 'reconsultar_cliente_da_fila_empresa'
end

every 1.day, :at => '19:00 pm' do
  rake "gerar_importacao_massa"
end