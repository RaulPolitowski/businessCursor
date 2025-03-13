INSERT INTO situacao (id, cor, descricao, status, tipoarquivo, situacaopadrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) VALUES (1, 'RED', 'Cancelado', 'CANCELADO', 'TODOS', true, '2016-12-01', '2016-10-19', NULL, NULL, 1);
INSERT INTO situacao (id, cor, descricao, status, tipoarquivo, situacaopadrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) VALUES (3, 'PURPLE', 'Concluido Parcialmente', 'PARCIAL_CONCLUIDO', 'TODOS', true, '2016-12-01', '2016-11-07', NULL, NULL, 1);
INSERT INTO situacao (id, cor, descricao, status, tipoarquivo, situacaopadrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) VALUES (2, 'WHITE', 'Aberto', 'ABERTO', 'TODOS', true, '2016-12-01', '2016-10-20', NULL, NULL, 1);
INSERT INTO situacao (id, cor, descricao, status, tipoarquivo, situacaopadrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) VALUES (4, 'GREEN', 'Concluído', 'CONCLUIDO', 'TODOS', true, '2016-12-01', '2016-12-01', NULL, NULL, 1);

-- Atualizar o sequence do id
SELECT setval('situacao_id_seq', (SELECT max(id) + 1 FROM situacao));
