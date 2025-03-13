INSERT INTO conta (id, descricao, empresa_id, ativo, numeroconta, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, contacaixa) 
VALUES (1, 'Caixa', 1, true, NULL, NULL, NULL, NULL, NULL, TRUE);

-- Atualizar o sequence do id
SELECT setval('conta_id_seq', (SELECT max(id) + 1 FROM conta));