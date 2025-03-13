# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Cidade.create(codigo: '79278', nome: 'TOLEDO', estado_id: 1)
Empresa.create(razao_social: 'GERMAN TECH SISTEMAS', nome_fantasia: 'GERMAN TECH SISTEMAS', cnpj: '211586637000128', cidade_id: 1)
User.create(email: 'alisonluisk@gmail.com', password: '123456', password_confirmation: '123456', name: 'Alison Luis', admin: true, color: 'rgb(0,0,0)', empresa_ids: '1')
User.create(email: 'giovane.negocios@gmail.com', password: '123456', password_confirmation: '123456', name: 'Giovane Timm', admin: true, color: 'rgb(0,0,0)', empresa_ids: '1')
StatusLigacao.create(descricao: 'Número não existente')
StatusLigacao.create(descricao: 'Número errado')
StatusLigacao.create(descricao: 'Número ocupado')
StatusLigacao.create(descricao: 'Ninguém atende')
StatusLigacao.create(descricao: 'Ligação atendida')
StatusLigacao.create(descricao: 'Ligação atendida')
StatusLigacao.create(descricao: 'Em retorno')

Status.create(descricao: 'AGENDADO DEMONSTRAÇÃO', empresa_id: 1);
Status.create(descricao: 'FECHADO - AGENDADO IMPLANTAÇÃO', empresa_id: 1);
Status.create(descricao: 'FECHADO - AGUARDANDO TERCEIROS', empresa_id: 1);
Status.create(descricao: 'SEM INTERESSE', empresa_id: 1);
Status.create(descricao: 'SEM CONTATO LIGAR MAIS UMA VEZ ( CAIXA POSTAL, OCUPADO, NÃO ATENDE)', empresa_id: 1);
Status.create(descricao: 'RETORNO INICIAL', empresa_id: 1);
Status.create(descricao: 'RETORNO NEGOCIAÇÃO', empresa_id: 1);
Parametro.create(cidades_preferenciais: true, cnaes_preferenciais: true, data_habilitacao_preferencial: true, telefone_preferencial: true, empresa_id: 1)
