INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '00', 'Tributada integralmente', 'ICMS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '20', 'Com redução de base de cálculo', 'ICMS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '10', 'Tributada e com cobrança do ICMS por substituição tributária', 'ICMS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '30', 'Isenta ou não tributada e com cobrança do ICMS por substituição tributária', 'ICMS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '40', 'Isenta', 'ICMS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '41', 'Não tributada', 'ICMS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '50', 'Suspensão', 'ICMS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '51', 'Diferimento', 'ICMS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '60', 'ICMS cobrado anteriormente por substituição tributária', 'ICMS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '70', 'Com redução de base de cálculo e cobrança do ICMS por substituição tributária', 'ICMS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '90', 'Outros', 'ICMS', 'CST');
--
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '00', 'Entrada com recuperação de crédito', 'IPI', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '01', 'Entrada tributada com alíquota zero', 'IPI', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '02', 'Entrada isenta', 'IPI', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '03', 'Entrada não-tributada', 'IPI', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '04', 'Entrada imune', 'IPI', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '05', 'Entrada com suspensão', 'IPI', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '49', 'Outras entradas', 'IPI', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '50', 'Saída tributada', 'IPI', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '51', 'Saída tributada com alíquota zero', 'IPI', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '52', 'Saída isenta', 'IPI', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '53', 'Saída não-tributada', 'IPI', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '54', 'Saída imune', 'IPI', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '55', 'Saída com suspensão', 'IPI', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '99', 'Outras Saídas', 'IPI', 'CST');
--
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '01', 'Operação Tributável (base de cálculo = valor da operação (alíquota normal (cumulativo/não cumulativo))).', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '02', 'Operação Tributável (base de cálculo = valor da operação (alíquota diferenciada))', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '03', 'Operação Tributável (base de cálculo = quantidade vendida (alíquota por unidade de produto))', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '04', 'Operação Tributável (tributação monofásica (alíquota zero))', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '06', 'Operação Tributável (alíquota zero)', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '07', 'Operação Isenta da Contribuição.', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '08', 'Operação Sem Incidência da Contribuição.', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '09', 'Operação com Suspensão da Contribuição.', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '49', 'Outras Operações de Saída', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '50', 'Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '51', 'Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '52', 'Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '53', 'Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '54', 'Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '55', 'Operação com Direito a Crédito - Vinculada a Receitas Não Tributadas no Mercado Interno e de Exportação', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '56', 'Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno e de Exportação', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '60', 'Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '61', 'Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '62', 'Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '63', 'Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '64', 'Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '65', 'Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '66', 'Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno e de Exportação', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '67', 'Crédito Presumido - Outras Operações', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '70', 'Operação de Aquisição sem Direito a Crédito', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '71', 'Operação de Aquisição com Isenção', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '72', 'Operação de Aquisição com Suspensão', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '73', 'Operação de Aquisição a Alíquota Zero', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '74', 'Operação de Aquisição sem Incidência da Contribuição', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '75', 'Operação de Aquisição por Substituição Tributária', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '98', 'Outras Operações de Entrada', 'PIS', 'CST');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '99', 'Outras Operações', 'PIS', 'CST');
--
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '101', 'Tributada pelo Simples Nacional com permissão de crédito', 'ICMS', 'CSOSN');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '102', 'Tributada pelo Simples Nacional sem permissão de crédito', 'ICMS', 'CSOSN');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '103', 'Isenção do ICMS no Simples Nacional pela faixa de receita bruta', 'ICMS', 'CSOSN');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '300', 'Imune', 'ICMS', 'CSOSN');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '400', 'Não tributada pelo Simples Nacional', 'ICMS', 'CSOSN');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '201', 'Tributada pelo Simples Nacional com permissão de crédito e com cobrança do ICMS por Substituição Tributária', 'ICMS', 'CSOSN');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '202', 'Tributada pelo Simples Nacional sem permissão de crédito e com cobrança do ICMS por Substituição Tributária', 'ICMS', 'CSOSN');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '203', 'Isenção do ICMS nos Simples Nacional para faixa de receita bruta e com cobrança do ICMS por Substituição 	Tributária', 'ICMS', 'CSOSN');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '500', 'Isenção do ICMS nos Simples Nacional para faixa de receita bruta e com cobrança do ICMS por Substituição 	Tributária', 'ICMS', 'CSOSN');
INSERT INTO cst ( codigo, descricao, imposto, tipo) VALUES ( '900', 'Outros', 'ICMS', 'CSOSN');
