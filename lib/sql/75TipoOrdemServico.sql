-- OS TIPOS PADRAO PARA A ORDEM DE SERVICO
INSERT INTO tipo (id, descricao, numero, dataalteracao, datacadastro, ativo, todasempresas, usuarioalteracao_id, usuariocadastro_id, empresa_id) 
VALUES (1, 'Interno', 1, null, null, true, true, null, null, 1);

INSERT INTO tipo  (id, descricao, numero, dataalteracao, datacadastro, ativo, todasempresas, usuarioalteracao_id, usuariocadastro_id, empresa_id) 
VALUES (2, 'Externo', 2, null, null, true, true, null, null, 1);

-- Atualizar o sequence do id
SELECT setval('tipo_id_seq', (SELECT max(id) + 1 FROM tipo));
