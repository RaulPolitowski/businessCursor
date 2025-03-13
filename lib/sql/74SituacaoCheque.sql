-- CHEQUES EMITIDOS
INSERT INTO situacaocheque (id, cor, descricao, statuschequeemitido, statuschequerecebido, tipocheque, ativo, todasempresas, padrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) 
VALUES(1, 'BLUE', 'Lançado', 'LANCADO', null, 'CHEQUE_EMITIDO', true, true, true, null, null, null, null, 1);

INSERT INTO situacaocheque (id, cor, descricao, statuschequeemitido, statuschequerecebido, tipocheque, ativo, todasempresas, padrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) 
VALUES (2, 'GREEN', 'A Compensar', 'A_COMPENSAR', null, 'CHEQUE_EMITIDO', true, true, true, null, null, null, null, 1);

INSERT INTO situacaocheque (id, cor, descricao, statuschequeemitido, statuschequerecebido, tipocheque, ativo, todasempresas, padrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) 
VALUES (3, 'YELLOW', 'Compensado', 'COMPENSADO', null, 'CHEQUE_EMITIDO', true, true, true, null, null, null, null, 1);

INSERT INTO situacaocheque (id, cor, descricao, statuschequeemitido, statuschequerecebido, tipocheque, ativo, todasempresas, padrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) 
VALUES (4, 'BLACK', 'Devolvido', 'DEVOLVIDO', null, 'CHEQUE_EMITIDO', true, true, true, null, null, null, null, 1);

INSERT INTO situacaocheque (id, cor, descricao, statuschequeemitido, statuschequerecebido, tipocheque, ativo, todasempresas, padrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) 
VALUES (5, 'RED', 'Cancelado', 'CANCELADO', null, 'CHEQUE_EMITIDO', true, true, true, null, null, null, null, 1);

--CHEQUES RECEBIDOS
INSERT INTO situacaocheque (id, cor, descricao, statuschequeemitido, statuschequerecebido, tipocheque, ativo, todasempresas, padrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) 
VALUES (6, 'BLUE', 'Lançado', null, 'LANCADO', 'CHEQUE_RECEBIDO', true, true, true, null, null, null, null, 1);

INSERT INTO situacaocheque (id, cor, descricao, statuschequeemitido, statuschequerecebido, tipocheque, ativo, todasempresas, padrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) 
VALUES (7, 'GREEN', 'A Compensar', null, 'A_COMPENSAR', 'CHEQUE_RECEBIDO', true, true, true, null, null, null, null, 1);

INSERT INTO situacaocheque (id, cor, descricao, statuschequeemitido, statuschequerecebido, tipocheque, ativo, todasempresas, padrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) 
VALUES (8, 'PURPLE', 'Repassado', null, 'REPASSADO', 'CHEQUE_RECEBIDO', true, true, true, null, null, null, null, 1);

INSERT INTO situacaocheque (id, cor, descricao, statuschequeemitido, statuschequerecebido, tipocheque, ativo, todasempresas, padrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) 
VALUES (9, 'YELLOW', 'Compensado', null, 'COMPENSADO', 'CHEQUE_RECEBIDO', true, true, true, null, null, null, null, 1);

INSERT INTO situacaocheque (id, cor, descricao, statuschequeemitido, statuschequerecebido, tipocheque, ativo, todasempresas, padrao, dataalteracao, datacadastro, usuarioalteracao_id, usuariocadastro_id, empresa_id) 
VALUES (10, 'RED', 'Cancelado', null, 'CANCELADO', 'CHEQUE_RECEBIDO', true, true, true, null, null, null, null, 1);


-- Atualizar o sequence do id
SELECT setval('situacaocheque_id_seq', (SELECT max(id) + 1 FROM situacaocheque));
