CREATE SCHEMA cte;
CREATE SCHEMA ecf;
CREATE SCHEMA manifesto;
CREATE SCHEMA notafiscal;
CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;
CREATE TABLE cte.cartacorrecaocte (
                                      id serial,
                                      condicaouso text,
                                      datacarta timestamp without time zone,
                                      descricaoevento character varying(255),
                                      xmlenvio text,
                                      xmlretorno text,
                                      dataalteracao date,
                                      datacadastro date,
                                      usuarioalteracao_id bigint,
                                      usuariocadastro_id bigint,
                                      cte_id bigint
);


CREATE TABLE cte.cte (
                         id serial,
                         aliquotaicms numeric(6,2),
                         ambiente character varying(1),
                         chaveacesso character varying(255),
                         chaveacessoanulacao character varying(44),
                         chaveacessoanulado character varying(44),
                         chaveacessoctetomador character varying(44),
                         chaveacessonfetomador character varying(44),
                         chaveacessosubstituicao character varying(44),
                         chavectereferenciada character varying(44),
                         cnpjemitentedoc character varying(14),
                         codigoretorno character varying(10),
                         conteudoxml text,
                         csticms character varying(2) NOT NULL,
                         dataautorizacao timestamp without time zone,
                         datacontingencia timestamp without time zone,
                         datadeclaracaotomador date,
                         dataemissao timestamp without time zone NOT NULL,
                         dataemissaodoc date,
                         detalheretira character varying(160),
                         formaemissao integer NOT NULL,
                         identprocesso integer NOT NULL,
                         infoadicionalfisco character varying(2000),
                         infoadicionalservico character varying(30),
                         infoadicionaltransporte character varying(15),
                         mensagemretorno text,
                         modal character varying(2) NOT NULL,
                         modelo character varying,
                         modelodoc integer,
                         motivocancelamento character varying(255),
                         motivocontingencia character varying(255),
                         motivoinutilizacao character varying(255),
                         natureza character varying(60) NOT NULL,
                         numero bigint NOT NULL,
                         numerodoc integer,
                         numeroprotocolo character varying(15),
                         observacoesgerais text,
                         opcaoentrega integer,
                         outrasinfcarga character varying(30),
                         percredbcicms numeric(6,2),
                         produtopredominante character varying(60),
                         protocolocte text,
                         retirada integer NOT NULL,
                         retornocanccte text,
                         serie integer NOT NULL,
                         seriedoc integer,
                         subseriedoc integer,
                         tipocte integer NOT NULL,
                         tipodocumento integer NOT NULL,
                         tiposervico integer NOT NULL,
                         tipotomador integer NOT NULL,
                         tomadorcontribuinteicms boolean,
                         valorbcicms numeric(13,2),
                         valorcarga numeric(13,2),
                         valorcreditoicms numeric(13,2),
                         valordoc numeric(13,2),
                         valoricms numeric(13,2),
                         valorprestacaoservico numeric(13,2),
                         valorrecebido numeric(13,2),
                         versaomodal character varying(255) NOT NULL,
                         xmlmodal text,
                         dataalteracao date,
                         datacadastro date,
                         usuarioalteracao_id bigint,
                         usuariocadastro_id bigint,
                         cfop_id bigint,
                         destinatario_id bigint,
                         emitente_id bigint,
                         empresa_id bigint,
                         expeditor_id bigint,
                         lote_id bigint,
                         modalrodoviario_id bigint,
                         municipioenvio_id bigint,
                         municipioinicio_id bigint,
                         municipiotermino_id bigint,
                         recebedor_id bigint,
                         remetente_id bigint,
                         tomador_id bigint,
                         usuario_id bigint,
                         chaveacessoctecomplementado character varying(44),
                         opcaocoleta integer,
                         razaosocialdestinatario character varying(255),
                         documentoanterior_id bigint,
                         localcoleta_id bigint,
                         aliquotaufinter numeric(6,2),
                         aliquotaufinterpart numeric(6,2),
                         aliquotauffim numeric(6,2),
                         valorbcicmsuffin numeric(13,2),
                         valoricmsuffimpart numeric(13,2),
                         valoricmsufinicpart numeric(13,2),
                         percfcpuffim numeric(6,4),
                         valorfcpfim numeric(13,2),
                         csticmscte character varying(255) NOT NULL,
                         globalizado boolean DEFAULT false,
                         observacoesglobalizado character varying(255),
                         cnpjdestinatario character varying(255),
                         cnpjremetente character varying(255),
                         razaosocialremetente character varying(255),
                         enderecodestinatario_id bigint,
                         enderecoexpedidor_id bigint,
                         enderecorecebedor_id bigint,
                         enderecoremetente_id bigint,
                         enderecotomador_id bigint,
                         provisionado boolean DEFAULT false,
                         valortotalpago numeric(13,2),
                         valortroco numeric(13,2),
                         vendedorfuncionario_id bigint,
                         datacancelamento timestamp without time zone,
                         qrcode character varying(255),
                         tipodocumentoctesubstituto character varying(255),
                         tomado_alterado_ctesubstituto boolean DEFAULT false,
                         caixaaberto_id bigint
);


CREATE TABLE cte.ctecomplementado (
                                      id serial,
                                      chaveacesso character varying(44),
                                      empresa_id bigint
);

CREATE TABLE cte.documentoanterior (
                                       id serial,
                                       cte_id bigint
);

CREATE TABLE cte.documentoanterioreletronico (
                                                 id serial,
                                                 chaveacesso character varying(44) NOT NULL,
                                                 identificacaodocanterior_id bigint
);

CREATE TABLE cte.documentoanteriorpapel (
                                            id serial,
                                            dataemissao date NOT NULL,
                                            numerodocumento character varying(20) NOT NULL,
                                            serie character varying(3) NOT NULL,
                                            subserie character varying(2),
                                            tipodocumento character varying(2) NOT NULL,
                                            identificacaodocanterior_id bigint
);

CREATE TABLE cte.emissordocumentoanterior (
                                              id serial,
                                              clientefornecedor_id bigint NOT NULL,
                                              documentoanterior_id bigint
);

CREATE TABLE cte.fiscalicmsinterestadual (
                                             id serial,
                                             origem character varying(2) NOT NULL,
                                             destino character varying(2) NOT NULL,
                                             icms numeric(10,2) NOT NULL
);

CREATE TABLE cte.formapagamentocte (
                                       id serial,
                                       acrescimo numeric(13,2),
                                       bandeiracartao character varying(255),
                                       cnpjcredenciadora character varying(14),
                                       desconto numeric(13,2),
                                       forma character varying(255),
                                       movimentacaogerada boolean DEFAULT false,
                                       numerotransacao character varying(255),
                                       observacao character varying(255),
                                       observacaopedido text,
                                       tipo character varying(255),
                                       troco numeric(13,2),
                                       valor numeric(13,2),
                                       valorcotacaomoedaestrangeira numeric(13,2),
                                       valormoedaestrangeira numeric(13,2),
                                       valorpago numeric(13,2),
                                       cte_id bigint,
                                       maquinacartao_id bigint,
                                       moedaestrangeira_id bigint,
                                       movimentacaocreditosaida_id bigint,
                                       vale_id bigint
);

CREATE TABLE cte.historico_veiculo (
                                       id serial,
                                       data date,
                                       quilometragem bigint NOT NULL,
                                       tipo character varying(255),
                                       valor numeric(13,2),
                                       dataalteracao date,
                                       datacadastro date,
                                       usuarioalteracao_id bigint,
                                       usuariocadastro_id bigint,
                                       empresa_id bigint,
                                       veiculo_id bigint
);

CREATE TABLE cte.identificacaodocanterior (
                                              id serial,
                                              emissordocumentoanterior_id bigint
);

CREATE TABLE cte.informacaocorrecao (
                                        id serial,
                                        campoalterado character varying(20) NOT NULL,
                                        grupoalterado character varying(20) NOT NULL,
                                        numeroitemalterado integer,
                                        valoralterado character varying(500) NOT NULL,
                                        cartacorrecao_id bigint
);

CREATE TABLE cte.itemservico (
                                 id serial,
                                 nomeservico character varying(15),
                                 valor numeric(13,2),
                                 cte_id bigint
);

CREATE TABLE cte.itemservicolist (
                                     id serial,
                                     nomeservico character varying(15),
                                     empresa_id bigint
);

CREATE TABLE cte.lacre (
                           id serial,
                           numerolacre character varying(20) NOT NULL,
                           modalrodo_id bigint
);

CREATE TABLE cte.lotecte (
                             id serial,
                             ambiente character varying(1) NOT NULL,
                             codigoretorno character varying(10),
                             codigouf character varying(255),
                             dataenvio timestamp without time zone NOT NULL,
                             datarecebimento timestamp without time zone,
                             mensagemretorno text,
                             numerorecibo character varying(15),
                             tempomedio character varying(255)
);

CREATE TABLE cte.modalrodoviario (
                                     id serial,
                                     contafrete bigint,
                                     dataprevistaentrega date NOT NULL,
                                     lotacao integer NOT NULL,
                                     rntrc character varying(20) NOT NULL
);

CREATE TABLE cte.motorista (
                               id serial,
                               ativo boolean DEFAULT true,
                               bairro character varying(100),
                               categoriacnh character varying(2) DEFAULT 'AC'::character varying,
                               cep character varying(10),
                               cnh character varying(11),
                               complemento text,
                               cpf character varying(11),
                               dataadmissao date,
                               datadenascimento character varying(50),
                               datavencimentocnh date,
                               email character varying(100),
                               endereco text,
                               nome character varying(100),
                               numero character varying(255),
                               observacao character varying(255),
                               pontuacao character varying(50),
                               rg character varying(13),
                               telefone character varying(50),
                               todasempresas boolean DEFAULT false,
                               dataalteracao date,
                               datacadastro date,
                               usuarioalteracao_id bigint,
                               usuariocadastro_id bigint,
                               empresa_id bigint,
                               municipio_id bigint
);

CREATE TABLE cte.notafiscalcte (
                                   id serial,
                                   chaveacesso character varying(44) NOT NULL,
                                   pinsuframa bigint,
                                   cte_id bigint
);

CREATE TABLE cte.notaprodutorcte (
                                     id serial,
                                     dataemissao date,
                                     modelo character varying(255),
                                     numero bigint NOT NULL,
                                     pesototalkg numeric(15,3),
                                     pinsuframa bigint,
                                     serie character varying(3) NOT NULL,
                                     valorbasecalculoicms numeric(15,2),
                                     valorbcicmsst numeric(15,2),
                                     valoricms numeric(15,2),
                                     valoricmsst numeric(15,2),
                                     valorprodutos numeric(15,2),
                                     valortotalnf numeric(15,2),
                                     cfop_id bigint,
                                     cte_id bigint,
                                     empresa_id bigint
);

CREATE TABLE cte.obscontribuintecte (
                                        id serial,
                                        campo character varying(20) NOT NULL,
                                        texto character varying(160) NOT NULL,
                                        cte_id bigint
);

CREATE TABLE cte.obsfiscocte (
                                 id serial,
                                 campo character varying(20) NOT NULL,
                                 texto character varying(160) NOT NULL,
                                 cte_id bigint
);

CREATE TABLE cte.ordemcoleta (
                                 id serial,
                                 contatodestinatario character varying(255),
                                 contatoremetente character varying(255),
                                 datacoleta date,
                                 dataemissao timestamp without time zone,
                                 emaildestinatario character varying(255),
                                 emailremetente character varying(255),
                                 numero bigint,
                                 observacao text,
                                 pesobrutototal numeric(17,3),
                                 pesoliquidototal numeric(17,3),
                                 produtopredominante character varying(255),
                                 rntrc character varying(255),
                                 situacao character varying(255),
                                 telefonedestinatario character varying(255),
                                 telefoneremetente character varying(255),
                                 totalvolumes integer,
                                 dataalteracao date,
                                 datacadastro date,
                                 usuarioalteracao_id bigint,
                                 usuariocadastro_id bigint,
                                 destinatario_id bigint,
                                 empresa_id bigint,
                                 enderecodestinatario_id bigint,
                                 enderecoremetente_id bigint,
                                 motorista_id bigint,
                                 remetente_id bigint,
                                 veiculo_id bigint,
                                 proprietario_id bigint
);

CREATE TABLE cte.ordemcoletacte (
                                    id serial,
                                    cnpj character varying(14) NOT NULL,
                                    codigointerno bigint,
                                    dataemissao date NOT NULL,
                                    inscricaoestadual character varying(14) NOT NULL,
                                    numero integer NOT NULL,
                                    serie integer,
                                    telefone character varying(255),
                                    modalrodo_id bigint,
                                    uf_id bigint
);

CREATE TABLE cte.outrodocumento (
                                    id serial,
                                    dataemissao date,
                                    dataprevistaentrega date,
                                    descricaooutros character varying(100),
                                    numero bigint,
                                    tipodocumento character varying(2) NOT NULL,
                                    tipodocumentoorigem character varying(255),
                                    valor numeric(13,2),
                                    cte_id bigint
);

CREATE TABLE cte.quantidadecarga (
                                     id serial,
                                     codigomedida character varying(2) NOT NULL,
                                     quantidade numeric(15,4),
                                     tipomedida character varying(20) NOT NULL,
                                     cte_id bigint
);

CREATE TABLE cte.seguro (
                            id serial,
                            nomeseguradora character varying(30),
                            numeroapolice character varying(20),
                            numeroaverbacao character varying(20),
                            reponsavelseguro integer NOT NULL,
                            valorcarga numeric(13,2),
                            cte_id bigint
);

CREATE TABLE cte.terceiro (
                              id serial,
                              ativo boolean,
                              bairro character varying(100),
                              cep character varying(10),
                              complemento text,
                              cpfcnpj character varying(14),
                              email character varying(100),
                              endereco text,
                              inscricaoestadual character varying(30),
                              isento boolean,
                              nome character varying(100),
                              numero character varying(255),
                              razaosocial character varying(100),
                              rntrc character varying(20) NOT NULL,
                              telefone character varying(50),
                              tipoproprietario integer NOT NULL,
                              tiporegistro character varying(2) NOT NULL,
                              empresa_id bigint,
                              municipio_id bigint,
                              todasempresas boolean DEFAULT false,
                              dataalteracao date,
                              datacadastro date,
                              usuarioalteracao_id bigint,
                              usuariocadastro_id bigint
);

CREATE TABLE cte.tipomedidacte (
                                   id serial,
                                   descricao character varying(20),
                                   empresa_id bigint
);

CREATE TABLE cte.veiculo (
                             id serial,
                             capacidadekg character varying(6),
                             capacidadem3 character varying(3),
                             placa character varying(8) NOT NULL,
                             renavam character varying(12) NOT NULL,
                             tara character varying(6),
                             tipocarroceria character varying(2) NOT NULL,
                             tipopropriedade character varying(255) NOT NULL,
                             tiporodado character varying(2) NOT NULL,
                             tipoveiculo integer NOT NULL,
                             empresa_id bigint,
                             municipio_id bigint,
                             proprietario_id bigint,
                             combinado boolean,
                             dataaquisicao date,
                             numeronf bigint,
                             proprietarioanterior character varying(150),
                             tipoaquisicao character varying(1),
                             valoraquisicao numeric(13,2),
                             veiculocombinado_id bigint,
                             anofabricacao character varying(4),
                             anomodelo character varying(4),
                             chassi character varying(17),
                             cor character varying(50),
                             modelo character varying(100),
                             observacao text,
                             quilometragem bigint,
                             fabricante_id bigint,
                             combustivel character varying,
                             ativo boolean DEFAULT true,
                             camarafria boolean,
                             todasempresas boolean,
                             dataalteracao date,
                             datacadastro date,
                             usuarioalteracao_id bigint,
                             usuariocadastro_id bigint,
                             controleviagem_id bigint,
                             motorista_id bigint
);

CREATE TABLE cte.volumeordemcoleta (
                                       id serial,
                                       dataemissaonotafiscal date,
                                       descricao character varying(255),
                                       numeronotafiscal bigint,
                                       numeropedido bigint,
                                       pesobruto numeric(14,3),
                                       pesoliquido numeric(14,3),
                                       quantidade integer,
                                       serienotafiscal integer,
                                       unidademedida character varying(255),
                                       valornotafiscal numeric(15,2),
                                       ordemcoleta_id bigint
);

CREATE TABLE ecf.auxiliarvenda (
                                   id serial,
                                   acrescimo numeric(14,2),
                                   cancelada boolean DEFAULT false,
                                   cpfcliente character varying(14),
                                   datavenda timestamp without time zone,
                                   desconto numeric(14,2),
                                   nomecliente character varying(100),
                                   numeronotafiscal character varying(20),
                                   troco numeric(14,2),
                                   valor numeric(14,2),
                                   valorentrada numeric(14,2),
                                   valorrecebido numeric(14,2),
                                   dataalteracao date,
                                   datacadastro date,
                                   usuarioalteracao_id bigint,
                                   usuariocadastro_id bigint,
                                   clientefornecedor_id bigint,
                                   consignacaodevolucao_id bigint,
                                   dependente_id bigint,
                                   empresa_id bigint,
                                   vendedor_id bigint,
                                   dadosadicionais text,
                                   juros numeric(14,2),
                                   observacoes text,
                                   taxaservico numeric(5,2) DEFAULT 0.00,
                                   valortaxaentrega numeric(14,2) DEFAULT 0.00,
                                   valortaxaservico numeric(14,2),
                                   caixaaberto_id bigint,
                                   delivery_id bigint,
                                   enderecocliente_id bigint,
                                   tabelapreco_id bigint,
                                   valetroco_id bigint
);

CREATE TABLE ecf.consignacao (
                                 id serial,
                                 dataprevistadevolucao date,
                                 dateconsignacao date,
                                 cliente_id bigint,
                                 usuario_id bigint,
                                 cancelada boolean,
                                 dataemissao timestamp without time zone,
                                 observacao text,
                                 dataalteracao date,
                                 datacadastro date,
                                 usuarioalteracao_id bigint,
                                 usuariocadastro_id bigint,
                                 empresa_id bigint,
                                 tabelapreco_id bigint,
                                 vendedor_id bigint
);

CREATE TABLE ecf.consignacaodevolucao (
                                          id serial,
                                          dataentrega date,
                                          consignacao_id bigint,
                                          usuario_id bigint,
                                          dataalteracao date,
                                          datacadastro date,
                                          usuarioalteracao_id bigint,
                                          usuariocadastro_id bigint
);

CREATE TABLE ecf.cupomfiscal (
                                 id serial,
                                 ambiente character varying(255),
                                 assinaturacancelamentoqrcode text,
                                 assinaturaqrcode text,
                                 chaveacesso character varying(44),
                                 chaveacessocancelamento character varying(44),
                                 codigoespecificadorretorno character varying(4),
                                 codigoretorno character varying(6),
                                 codigoretornosat character varying(6),
                                 contabil boolean DEFAULT false,
                                 conteudoxml text,
                                 cpfdestinatario character varying(255),
                                 datacancelamento timestamp without time zone,
                                 dataemissao timestamp without time zone NOT NULL,
                                 informacoescomplementares text,
                                 informacoesfisco text,
                                 mensagemretorno text,
                                 mensagemretornosat text,
                                 modelo character varying(8),
                                 nomedestinatario character varying(255),
                                 numero bigint,
                                 numerocaixa integer NOT NULL,
                                 numeroseriesat character varying(255) NOT NULL,
                                 valoracrescimosubtotal numeric(15,2),
                                 valorcofins numeric(15,2),
                                 valorcofinsst numeric(15,2),
                                 valordesconto numeric(15,2),
                                 valordescontosubtotal numeric(15,2),
                                 valoricms numeric(15,2),
                                 valoroutrasdespesas numeric(10,2),
                                 valorpis numeric(15,2),
                                 valorpisst numeric(15,2),
                                 valortotalcupom numeric(10,2),
                                 valortotalprodutos numeric(15,2),
                                 valortotaltributacao numeric(15,2),
                                 valortroco numeric(15,2),
                                 dataalteracao date,
                                 datacadastro date,
                                 usuarioalteracao_id bigint,
                                 usuariocadastro_id bigint,
                                 destinatario_id bigint,
                                 emitente_id bigint,
                                 empresa_id bigint NOT NULL,
                                 vendedor_id bigint,
                                 adicionais numeric(14,2),
                                 taxaservico numeric(5,2) DEFAULT 0.00,
                                 valorfrete numeric(10,2),
                                 versao_sat character varying DEFAULT 'VERSAO_007'::character varying,
                                 caixaaberto_id bigint,
                                 delivery_id bigint,
                                 enderecocliente_id bigint,
                                 tabelapreco_id bigint
);

CREATE TABLE ecf.duplicata (
                               id serial,
                               datavencimento date,
                               numeroduplicata bigint,
                               numeroparcela integer,
                               pago boolean,
                               valor numeric(10,2)
);

CREATE TABLE ecf.duplicatarecebida (
                                       id serial,
                                       troco numeric(10,2),
                                       datapagamento date,
                                       valordesconto numeric(10,2),
                                       valorjuros numeric(10,2),
                                       valorrecebido numeric(10,2),
                                       duplicata_id bigint
);

CREATE TABLE ecf.formapagamentoauxiliarvenda (
                                                 id serial,
                                                 acrescimo numeric(13,2),
                                                 bandeiracartao character varying(255),
                                                 cnpjcredenciadora character varying(14),
                                                 desconto numeric(13,2),
                                                 forma character varying(255),
                                                 numerotransacao character varying(255),
                                                 observacao character varying(255),
                                                 observacaopedido text,
                                                 tipo character varying(255),
                                                 troco numeric(13,2),
                                                 valor numeric(13,2),
                                                 valorcotacaomoedaestrangeira numeric(13,2),
                                                 valormoedaestrangeira numeric(13,2),
                                                 valorpago numeric(13,2),
                                                 auxiliarvenda_id bigint,
                                                 maquinacartao_id bigint,
                                                 moedaestrangeira_id bigint,
                                                 movimentacaocreditosaida_id bigint,
                                                 vale_id bigint
);

CREATE TABLE ecf.formapagamentocreditocliente (
                                                  id serial,
                                                  bandeira character varying(255),
                                                  bandeiracartao character varying(255),
                                                  cnpjcredenciadora character varying(14),
                                                  forma character varying(255),
                                                  numerotransacao character varying(255),
                                                  valor numeric(12,2),
                                                  maquinacartao_id bigint,
                                                  movcredito_id bigint
);

CREATE TABLE ecf.formapagamentocupomfiscal (
                                               id serial,
                                               acrescimo numeric(13,2),
                                               bandeiracartao character varying(255),
                                               cnpjcredenciadora character varying(14),
                                               codigocredenciadoracartao integer,
                                               desconto numeric(13,2),
                                               forma character varying(255),
                                               movimentacaogerada boolean DEFAULT false,
                                               numerotransacao character varying(255),
                                               observacao character varying(255),
                                               observacaopedido text,
                                               tipo character varying(255),
                                               troco numeric(13,2),
                                               valor numeric(13,2),
                                               valorcotacaomoedaestrangeira numeric(13,2),
                                               valormoedaestrangeira numeric(13,2),
                                               valorpago numeric(13,2),
                                               cupomfiscal_id bigint,
                                               maquinacartao_id bigint,
                                               moedaestrangeira_id bigint,
                                               movimentacaocreditosaida_id bigint,
                                               vale_id bigint
);

CREATE TABLE ecf.itemconsignacao (
                                     id serial,
                                     quantidade numeric(10,4),
                                     consignacao_id bigint,
                                     produto_id bigint,
                                     descricaoproduto character varying,
                                     desconto numeric(14,2) DEFAULT 0.00,
                                     valoritem numeric(14,2) DEFAULT 0.00,
                                     kitproduto_id bigint
);

CREATE TABLE ecf.itemconsignacaodevolucao (
                                              id serial,
                                              desconto numeric(12,2),
                                              quantidade numeric(12,4),
                                              consignacaodevolucao_id bigint,
                                              item_id bigint,
                                              descricaoproduto character varying(255),
                                              quantidadelevada numeric(12,4),
                                              valoritem numeric(14,2) DEFAULT 0.00
);

CREATE TABLE ecf.itemcupomfiscal (
                                     id serial,
                                     aliquotacofins numeric(6,4) NOT NULL,
                                     aliquotaicms numeric(5,2) NOT NULL,
                                     aliquotapis numeric(6,4) NOT NULL,
                                     descricaoproduto character varying(255) NOT NULL,
                                     estoquegerado boolean DEFAULT false,
                                     infadicional character varying(500),
                                     posicaoitem integer NOT NULL,
                                     quantidade numeric(15,4) NOT NULL,
                                     regracalculo character varying(255),
                                     valorcofins numeric(10,2) NOT NULL,
                                     valordesconto numeric(15,2) NOT NULL,
                                     valoricms numeric(15,2) NOT NULL,
                                     valoroutros numeric(15,2) NOT NULL,
                                     valorpis numeric(10,2) NOT NULL,
                                     valorrateioacrescimo numeric(15,2),
                                     valorrateiodesconto numeric(15,2),
                                     valortotal numeric(15,2),
                                     valortotalliquido numeric(15,2),
                                     valortotaltributacao numeric(15,2),
                                     valorunitario numeric(15,2) NOT NULL,
                                     cfop_id bigint NOT NULL,
                                     csticms_id bigint NOT NULL,
                                     cstpiscofins_id bigint NOT NULL,
                                     cupomfiscal_id bigint,
                                     produto_id bigint NOT NULL,
                                     tipoitem_id bigint,
                                     valorfrete numeric(10,2),
                                     valortaxaservico numeric(10,2),
                                     kitproduto_id bigint,
                                     promocaoproduto_id bigint
);

CREATE TABLE ecf.itemusoconsumo (
                                    id serial,
                                    quantidade numeric(10,4),
                                    ordemservico_id bigint,
                                    produto_id bigint
);

CREATE TABLE ecf.numeroduplicata (
                                     id serial,
                                     numero bigint
);

CREATE TABLE ecf.produtoauxiliarvenda (
                                          id serial,
                                          datahorasaida timestamp without time zone,
                                          desconto numeric(14,2),
                                          descontovenda numeric(14,2),
                                          descricaoproduto character varying(255),
                                          quantidade numeric(14,4),
                                          valor numeric(14,2),
                                          valortotal numeric(14,4),
                                          auxiliarvenda_id bigint,
                                          produto_id bigint,
                                          posicaoitem integer,
                                          acrescimo numeric(14,2),
                                          codigobeneficiofiscal character varying(255),
                                          juros numeric(14,2),
                                          valorprazo numeric(14,2) DEFAULT 0.00,
                                          valortaxaentrega numeric(14,2),
                                          valortaxaservico numeric(14,2),
                                          kitproduto_id bigint,
                                          promocaoproduto_id bigint
);

CREATE TABLE ecf.satfiscal (
                               id serial,
                               ativo boolean,
                               codigoativacao character varying(32) NOT NULL,
                               diretoriodll character varying(255),
                               fabricante character varying(255),
                               modelo character varying(255) NOT NULL,
                               numeroserie character varying(255) NOT NULL,
                               tipocertificado character varying(255),
                               dataalteracao date,
                               datacadastro date,
                               usuarioalteracao_id bigint,
                               usuariocadastro_id bigint,
                               empresa_id bigint NOT NULL,
                               cnpjcontribuinteteste character varying(14),
                               incricaoestadualcontribuinteteste character varying(12),
                               cnpjsoftwarehouseteste character varying(14),
                               assinaturaac character varying(344),
                               caminhodll character varying(255),
                               modelosat character varying(255),
                               modosat character varying DEFAULT 'PRODUCAO'::character varying,
                               tipoequipamento character varying DEFAULT 'NORMAL'::character varying,
                               utilizar_dll_sistema boolean DEFAULT true,
                               dnsprimario character varying(255),
                               dnssecundario character varying(255),
                               gateway character varying(255),
                               interfacerede character varying(255),
                               ip character varying(255),
                               ipproxy character varying(255),
                               mascararede character varying(255),
                               portaproxy character varying(255),
                               proxysat character varying(255),
                               senhaproxy character varying(255),
                               tiporede character varying(255),
                               usuarioproxy character varying(255)
);

CREATE TABLE manifesto.autorizacaoxml (
                                          id serial,
                                          cnpj character varying(255),
                                          cpf character varying(255),
                                          manifesto_id bigint NOT NULL
);

CREATE TABLE manifesto.averbacaoseguromdfe (
                                               id serial,
                                               numeroaverbacao character varying(40),
                                               seguromdfe_id bigint NOT NULL
);

CREATE TABLE manifesto.documentofiscalmanifesto (
                                                    id serial,
                                                    chaveacesso character varying(255) NOT NULL,
                                                    segundocodigobarra character varying(255),
                                                    tipodocumento character varying(255) NOT NULL,
                                                    municipiodescarregamento_id bigint NOT NULL
);

CREATE TABLE manifesto.documentosfiscais (
                                             id serial,
                                             manifesto_id bigint NOT NULL
);

CREATE TABLE manifesto.embarcacaocomboio (
                                             id serial,
                                             codigoembarcacaocomboio character varying(255) NOT NULL,
                                             modalaquaviario_id bigint NOT NULL
);

CREATE TABLE manifesto.informacoesciotmdfe (
                                               id serial,
                                               ciot character varying(255),
                                               cpfcnpj character varying(14),
                                               modalrodoviariomdfe_id bigint NOT NULL
);

CREATE TABLE manifesto.informacoescontratantemdfe (
                                                      id serial,
                                                      cpfcnpj character varying(14),
                                                      identificacaoestrangeiro character varying(20),
                                                      nome character varying(255),
                                                      modalrodoviariomdfe_id bigint NOT NULL
);

CREATE TABLE manifesto.informacoesseguradoramdfe (
                                                     id serial,
                                                     seguromdfe_id bigint NOT NULL,
                                                     seguradora_id bigint NOT NULL
);

CREATE TABLE manifesto.lacresmdfe (
                                      id serial,
                                      numerolacre character varying(255) NOT NULL,
                                      manifesto_id bigint NOT NULL
);

CREATE TABLE manifesto.lacresunidadecarga (
                                              id serial,
                                              numerolacre character varying(255) NOT NULL,
                                              unidadecarga_id bigint NOT NULL
);

CREATE TABLE manifesto.lacresunidadetransporte (
                                                   id serial,
                                                   numerolacre character varying(255) NOT NULL,
                                                   unidadetransporte_id bigint NOT NULL
);

CREATE TABLE manifesto.manifesto (
                                     id serial,
                                     ambiente character varying(255) NOT NULL,
                                     codigomdfe character varying(255) NOT NULL,
                                     codigoretorno character varying(255),
                                     conteudoxml text,
                                     dataautorizacao timestamp without time zone,
                                     dataemissao timestamp without time zone NOT NULL,
                                     datainicioviagem timestamp without time zone NOT NULL,
                                     digitoverificadorchave character varying(255) NOT NULL,
                                     identificacaoprocessoemissao character varying(255) NOT NULL,
                                     informacaoadicionalfisco text,
                                     informacaocomplementarcontribuinte text,
                                     mensagemretorno text,
                                     modalidadetransporte character varying(255) NOT NULL,
                                     modelo character varying DEFAULT '1'::character varying,
                                     numero bigint NOT NULL,
                                     numerochaveacesso character varying(255) NOT NULL,
                                     numeroprotocolo character varying(255),
                                     numerorecibo character varying(255),
                                     protocolomdfe text,
                                     qrcodemdfe character varying(255),
                                     quantidadecte numeric(4,0),
                                     quantidadecarga numeric(15,4),
                                     quantidademdfe numeric(4,0),
                                     quantidadenfe numeric(4,0),
                                     retornocancelamentomdfe text,
                                     retornoencerramentomdfe text,
                                     retornoevento text,
                                     serie integer NOT NULL,
                                     tipoemissao character varying(255) NOT NULL,
                                     tipoemissor character varying(255) NOT NULL,
                                     unidademedida character varying(255) NOT NULL,
                                     valorcarga numeric(15,2),
                                     versaoprocessamento character varying(255) NOT NULL,
                                     ceplocalcarregamento character varying(10),
                                     ceplocaldescarregamento character varying(10),
                                     enderecocarregamento character varying(255),
                                     enderecodescarregamento character varying(255),
                                     latitudelocalcarregamento character varying(6),
                                     latitudelocaldescarregamento character varying(6),
                                     longitudelocalcarregamento character varying(6),
                                     longitudelocaldescarregamento character varying(6),
                                     dataalteracao date,
                                     datacadastro date,
                                     usuarioalteracao_id bigint,
                                     usuariocadastro_id bigint,
                                     descricao_produto_predominante character varying(255),
                                     ean_produto_predominante character varying(255),
                                     ncm_produto_predominante character varying(255),
                                     tipocarga character varying(255),
                                     emitente_id bigint NOT NULL,
                                     empresa_id bigint NOT NULL,
                                     ufcarregamento_id bigint NOT NULL,
                                     ufdescarregamento_id bigint NOT NULL
);

CREATE TABLE manifesto.modalaereo (
                                      id serial,
                                      aerodromodestino character varying(255) NOT NULL,
                                      aerodromoembarque character varying(255) NOT NULL,
                                      datavoo date NOT NULL,
                                      marcamatriculaaeronave character varying(255) NOT NULL,
                                      marcanacionalidadeaeronave character varying(255) NOT NULL,
                                      numerovoo character varying(255) NOT NULL,
                                      manifesto_id bigint NOT NULL
);

CREATE TABLE manifesto.modalaquaviario (
                                           id serial,
                                           cnpjagencianavegacao character varying(255) NOT NULL,
                                           codigoembarcacao character varying(255) NOT NULL,
                                           codigoportodestino character varying(255) NOT NULL,
                                           codigoportoembarque character varying(255) NOT NULL,
                                           nomeembarcacao character varying(255) NOT NULL,
                                           numeroviagem character varying(255) NOT NULL,
                                           tipoembarcacao character varying(255) NOT NULL,
                                           manifesto_id bigint NOT NULL
);

CREATE TABLE manifesto.modalferroviario (
                                            id serial,
                                            dataliberacaotrem timestamp without time zone NOT NULL,
                                            destinotrem character varying(255) NOT NULL,
                                            origemtrem character varying(255) NOT NULL,
                                            prefixotrem character varying(255) NOT NULL,
                                            quantidadevagoes numeric(10,4) NOT NULL,
                                            manifesto_id bigint NOT NULL
);

CREATE TABLE manifesto.modalrodoviariomdfe (
                                               id serial,
                                               rntrc character varying(255),
                                               categcombveic integer,
                                               codigoagendamentoporto character varying(255),
                                               manifesto_id bigint NOT NULL,
                                               veiculotracao_id bigint NOT NULL
);

CREATE TABLE manifesto.municipiocarregamento (
                                                 id serial,
                                                 sequencia bigint,
                                                 manifesto_id bigint NOT NULL,
                                                 municipio_id bigint NOT NULL
);

CREATE TABLE manifesto.municipiodescarregamento (
                                                    id serial,
                                                    sequencia bigint,
                                                    documentosfiscais_id bigint NOT NULL,
                                                    municipio_id bigint NOT NULL
);

CREATE TABLE manifesto.percursomanifesto (
                                             id serial,
                                             datainicialviagem timestamp without time zone,
                                             sequencia bigint,
                                             manifesto_id bigint NOT NULL,
                                             estadopercorrido_id bigint NOT NULL
);

CREATE TABLE manifesto.seguromdfe (
                                      id serial,
                                      cpfcnpjresponsavel character varying(14),
                                      numeroapolice character varying(20),
                                      reponsavelseguro character varying(255) NOT NULL,
                                      manifesto_id bigint
);

CREATE TABLE manifesto.terminalcarregamento (
                                                id serial,
                                                codigoterminalcarregamento character varying(255) NOT NULL,
                                                nometerminalcarregamento character varying(255) NOT NULL,
                                                modalaquaviario_id bigint NOT NULL
);

CREATE TABLE manifesto.terminaldescarregamento (
                                                   id serial,
                                                   codigoterminaldescarregamento character varying(255) NOT NULL,
                                                   nometerminaldescarregamento character varying(255) NOT NULL,
                                                   modalaquaviario_id bigint NOT NULL
);

CREATE TABLE manifesto.unidadecarga (
                                        id serial,
                                        identificacaocarga character varying(255) NOT NULL,
                                        quantidaderateada numeric(5,2),
                                        tipounidadecarga character varying(255) NOT NULL,
                                        unidadetransporte_id bigint NOT NULL
);

CREATE TABLE manifesto.unidadecargaaquaviario (
                                                  id serial,
                                                  idunidadecarga character varying(255) NOT NULL,
                                                  tipoemissao character varying(255) NOT NULL,
                                                  modalaquaviario_id bigint NOT NULL
);

CREATE TABLE manifesto.unidadetransporte (
                                             id serial,
                                             identificacaounidadetransporte character varying(255) NOT NULL,
                                             quantidaderateada numeric(5,2),
                                             tipounidadetransporte character varying(255) NOT NULL,
                                             documentofiscalmanifesto_id bigint
);

CREATE TABLE manifesto.vagaotrem (
                                     id serial,
                                     numerovagao character varying(255) NOT NULL,
                                     quantidadevagoes numeric(18,4) NOT NULL,
                                     sequencia character varying(255),
                                     serievagao character varying(255) NOT NULL,
                                     modalferroviario_id bigint NOT NULL
);


CREATE TABLE manifesto.valepedagio (
                                       id serial,
                                       cnpjfornecedora character varying(255) NOT NULL,
                                       cnpjpagamento character varying(255) NOT NULL,
                                       numerocomprovante character varying(20) NOT NULL,
                                       valorvale numeric(15,2) NOT NULL,
                                       modalrodoviariomdfe_id bigint NOT NULL
);

CREATE TABLE notafiscal.adicao (
                                   id serial,
                                   codigofabricante character varying(60),
                                   numeroadicao character varying(3),
                                   numerosequencialitem character varying(3),
                                   valordesconto numeric(14,2),
                                   declaracaoimportacao_id bigint
);

CREATE TABLE notafiscal.auxiliarservico (
                                            id serial,
                                            auxiliargarantia boolean DEFAULT false,
                                            datacancelamento timestamp without time zone,
                                            dataemissao timestamp without time zone NOT NULL,
                                            numero bigint,
                                            observacoes text,
                                            status character varying(255),
                                            troco numeric(15,2),
                                            valorliquido numeric(15,2),
                                            valortotal numeric(15,2),
                                            valortotaldesconto numeric(15,2),
                                            valortotalpago numeric(15,2),
                                            caixaaberto_id bigint,
                                            empresa_id bigint NOT NULL,
                                            funcionario_id bigint,
                                            ordemservico_id bigint,
                                            prestador_id bigint NOT NULL,
                                            tomador_id bigint
);

CREATE TABLE notafiscal.cartacorrecao (
                                          id serial,
                                          correcao text,
                                          xmlenvio text,
                                          xmlretorno text,
                                          dataalteracao date,
                                          datacadastro date,
                                          usuarioalteracao_id bigint,
                                          usuariocadastro_id bigint,
                                          empresaid bigint,
                                          serie integer,
                                          numero bigint,
                                          ambiente character varying(1),
                                          tipofaturamento integer
);

CREATE TABLE notafiscal.certificadodigital (
                                               id serial,
                                               caminho character varying(255),
                                               certificadocartao boolean,
                                               keystoresenha character varying(255),
                                               nomearquivo character varying(255),
                                               nomearquivokeystore character varying(255),
                                               senha character varying(255),
                                               validade timestamp without time zone,
                                               empresa_id bigint,
                                               alias character varying(255),
                                               bytes bytea,
                                               csc character varying(255),
                                               idcsc character varying(255)
);

CREATE TABLE notafiscal.chaveacessoreferenciada (
                                                    id serial,
                                                    chaveacesso character varying(44),
                                                    numero bigint,
                                                    empresaid bigint,
                                                    ambiente character varying(1),
                                                    tipofaturamento integer,
                                                    serie integer
);

CREATE TABLE notafiscal.custonfe (
                                     id serial,
                                     custoitens numeric(14,2),
                                     custototalnfe numeric(14,2),
                                     lucrobrutonfe numeric(14,2),
                                     lucrototalnfe numeric(14,2),
                                     percentualcustonfe numeric(14,2),
                                     valortotalnfe numeric(14,2),
                                     empresa_id bigint,
                                     numero bigint,
                                     empresaid bigint,
                                     ambiente character varying(1),
                                     tipofaturamento integer,
                                     serie integer
);

CREATE TABLE notafiscal.declaracaoexportacao (
                                                 id serial,
                                                 chaveacessonfeexportacao character varying(255),
                                                 isexportacaoindireta boolean,
                                                 numerodrawback character varying(255),
                                                 numeroexportacao bigint,
                                                 quantidadeexportado numeric(16,4),
                                                 itemnotafiscal_id bigint
);

CREATE TABLE notafiscal.declaracaoimportacao (
                                                 id serial,
                                                 codigoexportador character varying(60),
                                                 datadesembraco date,
                                                 dataregistrodi date,
                                                 localdesembaraco character varying(60),
                                                 numerodocumentodi character varying(13),
                                                 valorbasecalculo numeric(13,2),
                                                 valordespesaaduaneira numeric(13,2),
                                                 valorii numeric(13,2),
                                                 valoriof numeric(13,2),
                                                 estadodesembaraco_id bigint,
                                                 itemnotafiscal_id bigint,
                                                 cnpjadquirente character varying(255),
                                                 tipointermedio character varying(2),
                                                 tipoviatransp character varying(2),
                                                 valorafrmm numeric(13,2),
                                                 estadoadquirente_id bigint
);

CREATE TABLE notafiscal.duplicatanota (
                                          id serial,
                                          datavencimento date,
                                          numeroduplicata bigint,
                                          numeroparcela integer,
                                          pago boolean,
                                          valor numeric(14,2),
                                          empresaid bigint,
                                          serie integer,
                                          numero bigint,
                                          ambiente character varying(1),
                                          tipofaturamento integer,
                                          ativa boolean DEFAULT true,
                                          cancelada boolean DEFAULT false,
                                          tipo character varying(255),
                                          empresa_id bigint
);

CREATE TABLE notafiscal.duplicatapaganota (
                                              id serial,
                                              troco numeric(14,2),
                                              datapagamento date,
                                              valordesconto numeric(14,2),
                                              valorjuros numeric(14,2),
                                              valorrecebido numeric(14,2),
                                              duplicata_id bigint,
                                              ativo boolean DEFAULT true,
                                              dataalteracao date,
                                              datacadastro date,
                                              usuarioalteracao_id bigint,
                                              usuariocadastro_id bigint
);

CREATE TABLE notafiscal.especievolume (
                                          id serial,
                                          descricao character varying(60) NOT NULL,
                                          ativo boolean DEFAULT true,
                                          dataalteracao date,
                                          datacadastro date,
                                          usuarioalteracao_id bigint,
                                          usuariocadastro_id bigint
);

CREATE TABLE notafiscal.formapagamentoauxiliarservico (
                                                          id serial,
                                                          acrescimo numeric(13,2),
                                                          bandeiracartao character varying(255),
                                                          cnpjcredenciadora character varying(14),
                                                          desconto numeric(13,2),
                                                          forma character varying(255),
                                                          numerotransacao character varying(255),
                                                          observacao character varying(255),
                                                          observacaopedido text,
                                                          tipo character varying(255),
                                                          troco numeric(13,2),
                                                          valor numeric(13,2),
                                                          valorcotacaomoedaestrangeira numeric(13,2),
                                                          valormoedaestrangeira numeric(13,2),
                                                          valorpago numeric(13,2),
                                                          auxiliarservico_id bigint,
                                                          maquinacartao_id bigint,
                                                          moedaestrangeira_id bigint,
                                                          movimentacaocreditosaida_id bigint,
                                                          vale_id bigint
);

CREATE TABLE notafiscal.formapagamentonf (
                                             id serial,
                                             acrescimo numeric(13,2),
                                             bandeiracartao character varying(255),
                                             cnpjcredenciadora character varying(14),
                                             desconto numeric(13,2),
                                             forma character varying(255),
                                             movimentacaogerada boolean DEFAULT false,
                                             numerotransacao character varying(255),
                                             observacao character varying(255),
                                             observacaopedido text,
                                             tipo character varying(255),
                                             troco numeric(13,2),
                                             valor numeric(13,2),
                                             valorcotacaomoedaestrangeira numeric(13,2),
                                             valormoedaestrangeira numeric(13,2),
                                             valorpago numeric(13,2),
                                             maquinacartao_id bigint,
                                             moedaestrangeira_id bigint,
                                             numero bigint,
                                             empresaid bigint,
                                             ambiente character varying(1),
                                             tipofaturamento integer,
                                             serie integer,
                                             movimentacaocreditosaida_id bigint,
                                             vale_id bigint
);

CREATE TABLE notafiscal.formapagamentonfc (
                                              id serial,
                                              acrescimo numeric(13,2),
                                              bandeiracartao character varying(255),
                                              cnpjcredenciadora character varying(14),
                                              desconto numeric(13,2),
                                              forma character varying(255),
                                              movimentacaogerada boolean DEFAULT false,
                                              numerotransacao character varying(255),
                                              observacao character varying(255),
                                              observacaopedido text,
                                              tipo character varying(255),
                                              troco numeric(13,2),
                                              valor numeric(13,2),
                                              valorcotacaomoedaestrangeira numeric(13,2),
                                              valormoedaestrangeira numeric(13,2),
                                              valorpago numeric(13,2),
                                              maquinacartao_id bigint,
                                              moedaestrangeira_id bigint,
                                              notafiscalconsumidor_id bigint,
                                              movimentacaocreditosaida_id bigint,
                                              vale_id bigint
);

CREATE TABLE notafiscal.formapagamentonfs (
                                              id serial,
                                              acrescimo numeric(13,2),
                                              bandeiracartao character varying(255),
                                              cnpjcredenciadora character varying(14),
                                              desconto numeric(13,2),
                                              forma character varying(255),
                                              movimentacaogerada boolean DEFAULT false,
                                              numerotransacao character varying(255),
                                              observacao character varying(255),
                                              observacaopedido text,
                                              tipo character varying(255),
                                              troco numeric(13,2),
                                              valor numeric(13,2),
                                              valorcotacaomoedaestrangeira numeric(13,2),
                                              valormoedaestrangeira numeric(13,2),
                                              valorpago numeric(13,2),
                                              maquinacartao_id bigint,
                                              moedaestrangeira_id bigint,
                                              notafiscalservico_id bigint,
                                              movimentacaocreditosaida_id bigint,
                                              vale_id bigint
);

CREATE TABLE notafiscal.itemauxiliarservico (
                                                id serial,
                                                descricaoservico text NOT NULL,
                                                posicaoitem integer NOT NULL,
                                                valordesconto numeric(15,2),
                                                valorservico numeric(15,2),
                                                valorservicoliquido numeric(15,2),
                                                dataalteracao date,
                                                datacadastro date,
                                                usuarioalteracao_id bigint,
                                                usuariocadastro_id bigint,
                                                auxiliarservico_id bigint NOT NULL,
                                                kitproduto_id bigint,
                                                servico_id bigint NOT NULL
);

CREATE TABLE notafiscal.itemnotafiscal (
                                           id serial,
                                           aliquotaicms numeric(8,4) NOT NULL,
                                           aliquotaicmsst numeric(8,4),
                                           aliquotaipi numeric(8,4) NOT NULL,
                                           basecalcicms numeric(10,2) NOT NULL,
                                           descricaoproduto character varying(255) NOT NULL,
                                           ipiunitario boolean,
                                           modalidadebcst character varying(1),
                                           percentualredbcicms numeric(8,4),
                                           porcentdesconto numeric(10,2),
                                           posicaoitem integer NOT NULL,
                                           quantidade numeric(10,4) NOT NULL,
                                           valorbcicmsstret numeric(10,2),
                                           valorbcst numeric(10,2),
                                           valoricms numeric(10,2) NOT NULL,
                                           valoricmsst numeric(10,2),
                                           valoricmsstret numeric(10,2),
                                           valoripi numeric(10,2) NOT NULL,
                                           valortotal numeric(17,4) NOT NULL,
                                           valorunitario numeric(21,10) NOT NULL,
                                           cfop_id bigint NOT NULL,
                                           csticms_id bigint NOT NULL,
                                           cstipi_id bigint NOT NULL,
                                           cstpiscofins_id bigint NOT NULL,
                                           empresaid bigint,
                                           serie integer,
                                           numero bigint,
                                           ambiente character varying(1),
                                           tipofaturamento integer,
                                           produto_id bigint NOT NULL,
                                           tipoitem_id bigint NOT NULL,
                                           infadicional character varying(500),
                                           aliquotacofins numeric(8,4),
                                           aliquotapis numeric(8,4),
                                           valorpis numeric(10,2),
                                           valorcofins numeric(10,2),
                                           valorfrete numeric(10,2),
                                           valordesconto numeric(10,2),
                                           valoroutros numeric(10,2),
                                           valorseguro numeric(10,2),
                                           aliquotamva numeric(6,4),
                                           motivodesoneracao character varying(2),
                                           valordesoneracaoicms numeric(10,2),
                                           valormva numeric(10,2),
                                           aliquotaicmsstdestino numeric(6,4),
                                           aliquotaicmsinter numeric(6,4),
                                           aliquotainternaufdest numeric(6,4),
                                           percfcpufdest numeric(6,4),
                                           percicmsinterpart numeric(7,4),
                                           valorbcicmsufdest numeric(13,2),
                                           valorfcpdest numeric(13,2),
                                           valoricmsufdest numeric(13,2),
                                           valoricmsufremet numeric(13,2),
                                           percentualdiferimento numeric(10,2),
                                           valoricmsdiferido numeric(10,2),
                                           valoricmsoperacao numeric(10,2),
                                           estoquegerado boolean,
                                           observacoesadicionais character varying(255),
                                           basecalculofcp numeric(13,2),
                                           basecalculofcpst numeric(13,2),
                                           basecalculofcpstret numeric(13,2),
                                           percentualfcp numeric(10,2),
                                           percentualfcpst numeric(10,2),
                                           percentualfcpstret numeric(10,2),
                                           valorbcfcpufdest numeric(13,2),
                                           valorfcp numeric(13,2),
                                           valorfcpst numeric(13,2),
                                           valorfcpstret numeric(13,2),
                                           reducaobcicmsst numeric(7,4),
                                           aliquotaipidevolvido numeric(6,4),
                                           valoripidevolvido numeric(13,2),
                                           aliquotaicmsefetivo numeric(6,4),
                                           percentualredbcefetivo numeric(6,4),
                                           valorbcefetivo numeric(15,2),
                                           valoricmsefetivo numeric(15,2),
                                           cnpjfabricante character varying(20),
                                           codigobeneficiofiscal character varying(255),
                                           indicadorescalarelevante boolean,
                                           basecalculoicmsstdest numeric(10,2),
                                           valoricmsstdest numeric(10,2),
                                           eantributado character varying(30),
                                           quantidadetributavel numeric(10,4),
                                           tributacaodiferenciada boolean,
                                           unidadetributado character varying(255),
                                           valorunitariotributario numeric(10,4),
                                           quantidadetributada numeric(10,4),
                                           valorunitariotributado numeric(21,10),
                                           promocaoproduto_id bigint,
                                           itemgradeproduto_id bigint,
                                           valortaxaservico numeric(13,2),
                                           valorjuros numeric(13,2),
                                           valortotaloutros numeric(13,2),
                                           liberarcamposescalarelevante boolean,
                                           producaoescalarelevante character varying(255),
                                           valorprazo numeric(15,4),
                                           codigoenquadramentoipi character varying(255),
                                           itempedidocompra bigint,
                                           numeropedidocompra character varying(255),
                                           kitproduto_id bigint
);

CREATE TABLE notafiscal.itemnotafiscalconsumidor (
                                                     id serial,
                                                     aliquotacofins numeric(6,4) NOT NULL,
                                                     aliquotaicms numeric(6,4) NOT NULL,
                                                     aliquotaicmsefetivo numeric(6,4),
                                                     aliquotaicmsst numeric(6,4),
                                                     aliquotaicmsstdestino numeric(6,4),
                                                     aliquotapis numeric(6,4) NOT NULL,
                                                     basecalcicms numeric(10,2) NOT NULL,
                                                     codigobeneficiofiscal character varying(255),
                                                     descricaoproduto character varying(255) NOT NULL,
                                                     estoquegerado boolean DEFAULT false,
                                                     infadicional character varying(500),
                                                     modalidadebcst character varying(1),
                                                     percentualredbcefetivo numeric(6,4),
                                                     percentualredbcicms numeric(6,4),
                                                     posicaoitem integer NOT NULL,
                                                     quantidade numeric(10,4) NOT NULL,
                                                     valorbcefetivo numeric(15,2),
                                                     valorbcicmsstret numeric(10,2),
                                                     valorbcst numeric(10,2),
                                                     valorcofins numeric(10,2) NOT NULL,
                                                     valordesconto numeric(10,2) NOT NULL,
                                                     valorfrete numeric(10,2) NOT NULL,
                                                     valoricms numeric(10,2) NOT NULL,
                                                     valoricmsefetivo numeric(15,2),
                                                     valoricmsst numeric(10,2),
                                                     valoricmsstret numeric(10,2),
                                                     valorjuros numeric(10,2),
                                                     valoroutros numeric(10,2) NOT NULL,
                                                     valorpis numeric(10,2) NOT NULL,
                                                     valorprazo numeric(14,2) DEFAULT 0.00,
                                                     valorseguro numeric(10,2) NOT NULL,
                                                     valortaxaservico numeric(10,2),
                                                     valortotal numeric(10,4) NOT NULL,
                                                     valortotaltributacao numeric(10,2),
                                                     valorunitario numeric(21,10) NOT NULL,
                                                     cfop_id bigint NOT NULL,
                                                     csticms_id bigint NOT NULL,
                                                     cstpiscofins_id bigint NOT NULL,
                                                     kitproduto_id bigint,
                                                     notafiscalconsumidor_id bigint,
                                                     produto_id bigint NOT NULL,
                                                     promocaoproduto_id bigint,
                                                     tipoitem_id bigint NOT NULL
);

CREATE TABLE notafiscal.itemnotafiscalservico (
                                                  id serial,
                                                  aliquota numeric(15,2),
                                                  deducaoiss boolean,
                                                  descricaoservico text NOT NULL,
                                                  justificativadeducao text,
                                                  posicaoitem integer NOT NULL,
                                                  valorbasecalculo numeric(15,2),
                                                  valordeducao numeric(15,2),
                                                  valordesconto numeric(15,2),
                                                  valoriss numeric(15,2),
                                                  valorservico numeric(15,2),
                                                  valorservicoliquido numeric(15,2),
                                                  dataalteracao date,
                                                  datacadastro date,
                                                  usuarioalteracao_id bigint,
                                                  usuariocadastro_id bigint,
                                                  notafiscalservico_id bigint NOT NULL,
                                                  servico_id bigint NOT NULL
);

CREATE TABLE notafiscal.itemorcamento (
                                          id serial,
                                          quantidade numeric(10,4),
                                          valoritem numeric(12,2),
                                          orcamento_id bigint,
                                          produto_id bigint,
                                          aliquotacofins numeric(7,4),
                                          aliquotaicms numeric(7,4),
                                          aliquotaicmsinter numeric(7,4),
                                          aliquotaicmsst numeric(7,4),
                                          aliquotaicmsstdestino numeric(7,4),
                                          aliquotainternaufdest numeric(7,4),
                                          aliquotaipi numeric(7,4),
                                          aliquotaipidevolvido numeric(7,4),
                                          aliquotamva numeric(7,4),
                                          aliquotapis numeric(7,4),
                                          basecalcicms numeric(10,2),
                                          basecalculoicmsstdest numeric(10,2),
                                          codigobeneficiofiscal character varying(255),
                                          desconto numeric(14,2),
                                          descricaoproduto character varying(255),
                                          descricaoservico text,
                                          eantributado character varying(30),
                                          ipiunitario boolean,
                                          modalidadebcst character varying(1),
                                          motivodesoneracao character varying(2),
                                          percfcpufdest numeric(7,4),
                                          percicmsinterpart numeric(7,4),
                                          percentualdiferimento numeric(10,2),
                                          percentualfcp numeric(10,2),
                                          percentualredbcicms numeric(7,4),
                                          posicaoitem integer,
                                          quantidadetributada numeric(10,4),
                                          reducaobcicmsst numeric(7,4),
                                          tributacaodiferenciada boolean DEFAULT false,
                                          unidadetributado character varying(255),
                                          valorbcicmsstret numeric(10,2),
                                          valorbcicmsufdest numeric(13,2),
                                          valorbcst numeric(10,2),
                                          valorcofins numeric(10,2),
                                          valordesoneracaoicms numeric(10,2),
                                          valorfcp numeric(13,2),
                                          valorfcpdest numeric(13,2),
                                          valorfcpst numeric(13,2),
                                          valorfcpstret numeric(13,2),
                                          valorfrete numeric(10,2),
                                          valoricms numeric(10,2),
                                          valoricmsdiferido numeric(10,2),
                                          valoricmsoperacao numeric(10,2),
                                          valoricmsst numeric(10,2),
                                          valoricmsstdest numeric(10,2),
                                          valoricmsstret numeric(10,2),
                                          valoricmsufdest numeric(13,2),
                                          valoricmsufremet numeric(13,2),
                                          valoripi numeric(10,2),
                                          valoripidevolvido numeric(13,2),
                                          valoritemaprazo numeric(21,10),
                                          valormva numeric(10,2),
                                          valoroutros numeric(10,2),
                                          valorpis numeric(10,2),
                                          valorseguro numeric(10,2),
                                          valortotalaprazoliquido numeric(14,2),
                                          valortotalliquido numeric(14,2),
                                          valortotaloutros numeric(13,2),
                                          valorunitariotributado numeric(21,10),
                                          cfop_id bigint,
                                          csticms_id bigint,
                                          cstipi_id bigint,
                                          cstpiscofins_id bigint,
                                          kitproduto_id bigint,
                                          promocaoproduto_id bigint,
                                          servico_id bigint,
                                          tipoitem_id bigint
);

CREATE TABLE notafiscal.lancamentocustonfe (
                                               id serial,
                                               descricao character varying(500) NOT NULL,
                                               valor numeric(14,2),
                                               custonfe_id bigint
);


CREATE TABLE notafiscal.lotenfce (
                                     id serial,
                                     ambiente character varying(1) NOT NULL,
                                     codigoretorno character varying(10),
                                     dataenvio timestamp without time zone NOT NULL,
                                     mensagemretorno text,
                                     numerorecibo character varying(15),
                                     datarecebimento timestamp without time zone
);

CREATE TABLE notafiscal.lotenfe (
                                    id serial,
                                    ambiente character varying(1) NOT NULL,
                                    codigoretorno character varying(10),
                                    dataenvio timestamp without time zone NOT NULL,
                                    mensagemretorno text,
                                    numerorecibo character varying(15),
                                    datarecebimento timestamp without time zone
);


CREATE TABLE notafiscal.lotenfse (
                                     id serial,
                                     numerolote bigint NOT NULL,
                                     quantidaderps bigint NOT NULL,
                                     valortotalbasecalculo numeric(38,0),
                                     valortotaldescontos numeric(38,0),
                                     valortotalservicos numeric(38,0),
                                     dataalteracao date,
                                     datacadastro date,
                                     usuarioalteracao_id bigint,
                                     usuariocadastro_id bigint,
                                     empresa_id bigint NOT NULL,
                                     prestador_id bigint NOT NULL
);

CREATE TABLE notafiscal.manifestacaodestinatario (
                                                     id serial,
                                                     chaveacesso character varying(255),
                                                     codigoretorno character varying(10),
                                                     dataevento timestamp without time zone,
                                                     justificativa text,
                                                     mensagemretorno text,
                                                     tipoevento character varying(255),
                                                     xmlenvio text,
                                                     xmlretorno text,
                                                     dataalteracao date,
                                                     datacadastro date,
                                                     usuarioalteracao_id bigint,
                                                     usuariocadastro_id bigint,
                                                     empresa_id bigint
);

CREATE TABLE notafiscal.notafiscal (
                                       basecalculoicms numeric(10,2),
                                       basecalculoicmsst numeric(10,2),
                                       codigoretorno character varying(10),
                                       conteudoxml text,
                                       dadosadicionais text,
                                       dataautorizacao timestamp without time zone,
                                       dataemissao timestamp without time zone NOT NULL,
                                       datahorasaida timestamp without time zone,
                                       descricaonatuerza character varying(255),
                                       tipofrete character varying(255),
                                       marcavolumes character varying(60),
                                       mensagemretorno text,
                                       modelo character varying(8),
                                       motivocancelamento character varying(255),
                                       motivoinutilizacao character varying(255),
                                       numeracaovolumes character varying(60),
                                       numerochaveacesso character varying(44),
                                       numerodanfe integer,
                                       numeroprotocolo character varying(15),
                                       pesobruto numeric(15,3),
                                       pesoliquido numeric(15,3),
                                       protocolonfe text,
                                       quantidadevolumes integer,
                                       retornocancnfe text,
                                       tipoemissao character varying(1),
                                       valorcofins numeric(10,2),
                                       valordesconto numeric(10,2),
                                       valorfrete numeric(10,2),
                                       valoricms numeric(10,2),
                                       valoricmsst numeric(10,2),
                                       valoripi numeric(10,2),
                                       valoroutrasdespesas numeric(10,2),
                                       valorpis numeric(10,2),
                                       valorseguro numeric(10,2),
                                       valortotal numeric(10,2),
                                       valortotalnota numeric(10,2),
                                       dataalteracao date,
                                       datacadastro date,
                                       usuarioalteracao_id bigint,
                                       usuariocadastro_id bigint,
                                       serie integer NOT NULL,
                                       empresaid bigint NOT NULL,
                                       ambiente character varying(1) NOT NULL,
                                       tipofaturamento integer NOT NULL,
                                       numero bigint NOT NULL,
                                       destinatario_id bigint NOT NULL,
                                       emitente_id bigint,
                                       empresa_id bigint NOT NULL,
                                       especievolumes_id bigint,
                                       lote_id bigint,
                                       natureza_id bigint NOT NULL,
                                       transportador_id bigint,
                                       veiculo_id bigint,
                                       vendedor_id bigint,
                                       chaveacessonfreferenciada character varying(44),
                                       cnpjintermed character varying(14),
                                       codigo bigint DEFAULT 1,
                                       consumidorfinal character varying DEFAULT '1'::character varying,
                                       contabil boolean DEFAULT false,
                                       contranotaprodutorrural boolean,
                                       dadosadicionaispadrao text,
                                       dadosadicionaisplugin text,
                                       datacancelamento timestamp without time zone,
                                       descricaonatureza character varying(255),
                                       dezenas_nota_ms_premiada character varying(255),
                                       digestvalue character varying(255),
                                       finalidade character varying DEFAULT '1'::character varying,
                                       identicadorintermed character varying(60),
                                       indintermed character varying(1) DEFAULT '0'::character varying,
                                       indpres character varying(1) DEFAULT '1'::character varying,
                                       informacoesfisco text,
                                       locdespacho character varying(255),
                                       locexporta character varying(255),
                                       protocoloeventonfe text,
                                       taxaservico numeric(5,2) DEFAULT 0.00,
                                       valoravulsooutrasdespesas numeric(13,2) DEFAULT 0.00,
                                       valordesoneracao numeric(10,2),
                                       valorfundopobreza numeric(13,2),
                                       valorfundopobrezast numeric(13,2),
                                       valorfundopobrezastret numeric(13,2),
                                       valorfundopobrezaufdest numeric(13,2),
                                       valoricmsdiferido numeric(10,2),
                                       valoricmsoperacional numeric(10,2),
                                       valoricmsufdest numeric(13,2),
                                       valoricmsufremet numeric(13,2),
                                       valoripidevolucao numeric(13,2),
                                       valortaxaservico numeric(13,2) DEFAULT 0.00,
                                       valortotalnotaprazo numeric(15,2) DEFAULT 0.00,
                                       valortotalpago numeric(13,2),
                                       valortotaltributacao numeric(10,2),
                                       valortroco numeric(13,2),
                                       versaoxml character varying(255),
                                       caixaaberto_id bigint,
                                       consignacaodevolucao_id bigint,
                                       enderecodestinatario_id bigint,
                                       notafiscalentrada_id bigint,
                                       tabelapreco_id bigint,
                                       ufsaidapais_id bigint,
                                       vendedorfuncionario_id bigint
);

CREATE TABLE notafiscal.notafiscalconsumidor (
                                                 id serial,
                                                 ambiente character varying(1),
                                                 basecalculoicms numeric(10,2),
                                                 basecalculoicmsst numeric(10,2),
                                                 chaveacessonfreferenciada character varying(44),
                                                 chaveconsultaqrcode text,
                                                 codigoretorno character varying(10),
                                                 consumidorfinal character varying DEFAULT '1'::character varying,
                                                 conteudoxml text,
                                                 cpfdestinatario character varying(255),
                                                 dadosadicionais text,
                                                 dataautorizacao timestamp without time zone,
                                                 dataemissao timestamp without time zone NOT NULL,
                                                 descricaonatuerza character varying(255),
                                                 digestvalue character varying(255),
                                                 emaildestinatario character varying(255),
                                                 finalidade character varying DEFAULT '1'::character varying,
                                                 formapagamento integer NOT NULL,
                                                 freteporconta integer NOT NULL,
                                                 indpres character varying(1) DEFAULT '1'::character varying,
                                                 locdespacho character varying(255),
                                                 locexporta character varying(255),
                                                 marcavolumes character varying(60),
                                                 mensagemretorno text,
                                                 modelo character varying(8),
                                                 motivocancelamento character varying(255),
                                                 motivoinutilizacao character varying(255),
                                                 nomedestinatario character varying(255),
                                                 numeracaovolumes character varying(60),
                                                 numero bigint NOT NULL,
                                                 numerochaveacesso character varying(44),
                                                 numerodanfe integer,
                                                 numeroprotocolo character varying(15),
                                                 pesobruto numeric(14,3),
                                                 pesoliquido numeric(14,3),
                                                 protocolonfe text,
                                                 quantidadevolumes integer,
                                                 retornocancnfe text,
                                                 serie integer NOT NULL,
                                                 tipoemissao character varying(1),
                                                 tipofaturamento integer NOT NULL,
                                                 valorcofins numeric(10,2),
                                                 valordesconto numeric(10,2),
                                                 valordesoneracao numeric(10,2),
                                                 valorfrete numeric(10,2),
                                                 valoricms numeric(10,2),
                                                 valoricmsst numeric(10,2),
                                                 valoroutrasdespesas numeric(10,2),
                                                 valorpis numeric(10,2),
                                                 valorseguro numeric(10,2),
                                                 valortotal numeric(10,2),
                                                 valortotalnota numeric(10,2),
                                                 valortotaltributacao numeric(10,2),
                                                 dataalteracao date,
                                                 datacadastro date,
                                                 usuarioalteracao_id bigint,
                                                 usuariocadastro_id bigint,
                                                 consignacaodevolucao_id bigint,
                                                 destinatario_id bigint,
                                                 emitente_id bigint,
                                                 empresa_id bigint NOT NULL,
                                                 especievolumes_id bigint,
                                                 lote_id bigint,
                                                 natureza_id bigint NOT NULL,
                                                 transportador_id bigint,
                                                 ufsaidapais_id bigint,
                                                 veiculo_id bigint,
                                                 vendedorfuncionario_id bigint,
                                                 chave_acesso_substitutiva character varying(255),
                                                 cnpjintermed character varying(14),
                                                 codigo bigint DEFAULT 1,
                                                 contabil boolean DEFAULT false,
                                                 dadosadicionaisplugin text,
                                                 datacancelamento timestamp without time zone,
                                                 descricaonatureza character varying(255),
                                                 dezenas_nota_ms_premiada character varying(255),
                                                 identicadorintermed character varying(60),
                                                 indintermed character varying(1) DEFAULT '0'::character varying,
                                                 observacoes character varying(1000),
                                                 protocoloeventonfe text,
                                                 taxaservico numeric(5,2) DEFAULT 0.00,
                                                 valortroco numeric(13,2),
                                                 versaoxml character varying(255),
                                                 caixaaberto_id bigint,
                                                 delivery_id bigint,
                                                 enderecocliente_id bigint,
                                                 tabelapreco_id bigint,
                                                 valetroco_id bigint
);

CREATE TABLE notafiscal.notafiscalservico (
                                              id serial,
                                              aliquotacofinsretido numeric(15,2),
                                              aliquotacsllretido numeric(15,2),
                                              aliquotainssretido numeric(15,2),
                                              aliquotairpfretido numeric(15,2),
                                              aliquotaiss numeric(15,2),
                                              aliquotaissretido numeric(15,2),
                                              aliquotapisretido numeric(15,2),
                                              ambienteemissao character varying(255) NOT NULL,
                                              codigoautenticacao character varying(255),
                                              codigocnae character varying(255),
                                              conteudoxml text,
                                              datacancelamento timestamp without time zone,
                                              dataemissaonfse timestamp without time zone,
                                              dataemissaorps timestamp without time zone NOT NULL,
                                              descricaoimposto text,
                                              exigibilidadeiss character varying(255),
                                              handletecnospeed bigint,
                                              impostosretido boolean NOT NULL,
                                              incentivadorcultural boolean,
                                              incentivofiscal boolean,
                                              issretido boolean NOT NULL,
                                              mensagemretornotecnospeed text,
                                              motivocancelamento text,
                                              numeroemissorrps character varying(5) NOT NULL,
                                              numeronfse bigint,
                                              numeroprotocolo character varying(255),
                                              numerorps bigint NOT NULL,
                                              serierps character varying(5) NOT NULL,
                                              situacaorespostatecnospeed character varying(255),
                                              statusrps character varying(255) NOT NULL,
                                              tipooperacaodsf character varying(255),
                                              tipotributacao character varying(255) NOT NULL,
                                              troco numeric(15,2),
                                              valorcofinsretido numeric(15,2),
                                              valorcsllretido numeric(15,2),
                                              valorinssretido numeric(15,2),
                                              valorirpfretido numeric(15,2),
                                              valorissretido numeric(15,2),
                                              valorliquidorps numeric(15,2),
                                              valorpisretido numeric(15,2),
                                              valortotalbasecalculo numeric(15,2),
                                              valortotaldesconto numeric(15,2),
                                              valortotaliss numeric(15,2),
                                              valortotalpago numeric(15,2),
                                              valortotalrps numeric(15,2),
                                              dataalteracao date,
                                              datacadastro date,
                                              usuarioalteracao_id bigint,
                                              usuariocadastro_id bigint,
                                              caixaaberto_id bigint,
                                              empresa_id bigint NOT NULL,
                                              enderecotomador_id bigint,
                                              funcionario_id bigint,
                                              lotenfse_id bigint NOT NULL,
                                              prestador_id bigint NOT NULL,
                                              tomador_id bigint
);

CREATE TABLE notafiscal.notaprodutorruralreferenciada (
                                                          id serial,
                                                          cpfcnpjemitente character varying(50) NOT NULL,
                                                          dataemissaonotaprodutor date,
                                                          inscricaoestadual character varying(14),
                                                          isento boolean,
                                                          modelo character varying(255),
                                                          numeronotaprodutor bigint,
                                                          serienotaprodutor character varying(3),
                                                          estadoemitente_id bigint,
                                                          numero bigint,
                                                          empresaid bigint,
                                                          ambiente character varying(1),
                                                          tipofaturamento integer,
                                                          serie integer
);

CREATE TABLE notafiscal.obscontribuintenfe (
                                               id serial,
                                               campo character varying(20) NOT NULL,
                                               texto character varying(160) NOT NULL,
                                               numero bigint,
                                               empresaid bigint,
                                               ambiente character varying(1),
                                               tipofaturamento integer,
                                               serie integer
);

CREATE TABLE notafiscal.orcamento (
                                      id serial,
                                      cpf character varying(255),
                                      descricaoformapagamento character varying(255),
                                      formapagamento integer,
                                      nome character varying(255),
                                      nomeresponsavel character varying(255),
                                      numeroorcamento bigint,
                                      observacao character varying(1500),
                                      orcamento text,
                                      prazoentrega date,
                                      statusorcamento character varying(255),
                                      telefone character varying(255),
                                      tipoorcamento character varying(255),
                                      validade date,
                                      valor numeric(14,2),
                                      valortotal numeric(14,0),
                                      dataalteracao date,
                                      datacadastro date,
                                      usuarioalteracao_id bigint,
                                      usuariocadastro_id bigint,
                                      cliente_id bigint,
                                      empresa_id bigint,
                                      basecalculoicms numeric(10,2),
                                      basecalculoicmsst numeric(10,2),
                                      consumidorfinal boolean DEFAULT true,
                                      contato character varying(255),
                                      dataemissao timestamp without time zone,
                                      descricaoprazoentrega character varying(255),
                                      historiconegociacao character varying(255),
                                      impostos boolean,
                                      orcamentodetalhado boolean DEFAULT false,
                                      tipofrete character varying DEFAULT 'SEM_OCORRENCIA'::character varying,
                                      valoravulsooutrasdespesas numeric(13,2) DEFAULT 0.00,
                                      valorcofins numeric(10,2),
                                      valordescontoprodutos numeric(14,2),
                                      valordescontoservico numeric(14,2),
                                      valordesoneracao numeric(10,2),
                                      valorfrete numeric(14,2),
                                      valorfundopobreza numeric(13,2),
                                      valorfundopobrezast numeric(13,2),
                                      valorfundopobrezastret numeric(13,2),
                                      valorfundopobrezaufdest numeric(13,2),
                                      valoricms numeric(10,2),
                                      valoricmsdiferido numeric(10,2),
                                      valoricmsoperacional numeric(10,2),
                                      valoricmsst numeric(10,2),
                                      valoricmsufdest numeric(13,2),
                                      valoricmsufremet numeric(13,2),
                                      valoripi numeric(10,2),
                                      valoripidevolucao numeric(13,2),
                                      valoroutrasdespesas numeric(10,2),
                                      valorpis numeric(10,2),
                                      valorprodutos numeric(14,2),
                                      valorprodutosaprazo numeric(14,2),
                                      valorseguro numeric(10,2),
                                      valorservico numeric(14,2),
                                      valorservicoadicional numeric(14,2),
                                      valortotalaprazo numeric(14,2),
                                      valortotaltributacao numeric(10,2),
                                      enderecocliente_id bigint,
                                      equipamento_id bigint,
                                      natureza_id bigint,
                                      tabelapreco_id bigint,
                                      vendedor_id bigint,
                                      numero bigint,
                                      empresaid bigint,
                                      ambiente character varying(1),
                                      tipofaturamento integer,
                                      serie integer,
                                      ordemservico_id bigint,
                                      pedido_id bigint
);

CREATE TABLE notafiscal.serie (
                                  id serial,
                                  serie bigint NOT NULL,
                                  dataalteracao date,
                                  datacadastro date,
                                  usuarioalteracao_id bigint,
                                  usuariocadastro_id bigint
);

CREATE TABLE notafiscal.transportador (
                                          id serial,
                                          ativa boolean,
                                          bairro character varying(255) NOT NULL,
                                          cep character varying(8) NOT NULL,
                                          cnpj character varying(50) NOT NULL,
                                          complemento character varying(22),
                                          contribuicaoicms character varying(1) NOT NULL,
                                          email character varying(50),
                                          endereco character varying(34) NOT NULL,
                                          fax character varying(10),
                                          inscricaoestadual character varying(50),
                                          inscricaomunicipal character varying(50),
                                          nomecontato character varying(28),
                                          nomefantasia character varying(60) NOT NULL,
                                          numero character varying(5) NOT NULL,
                                          razaosocial character varying(60),
                                          telefone character varying(12),
                                          municipio_id bigint NOT NULL,
                                          dataalteracao date,
                                          datacadastro date,
                                          usuarioalteracao_id bigint,
                                          usuariocadastro_id bigint,
                                          pais_id bigint
);

CREATE TABLE notafiscal.veiculo (
                                    id serial,
                                    codigoantt character varying(10),
                                    placa character varying(7),
                                    municipio_id bigint NOT NULL,
                                    transportador_id bigint NOT NULL
);

CREATE TABLE public.adiantamentoordemservico (
                                                 id serial,
                                                 dataadiantamento timestamp without time zone NOT NULL,
                                                 forma character varying(255),
                                                 saldo numeric(12,2),
                                                 valor numeric(12,2),
                                                 dataalteracao date,
                                                 datacadastro date,
                                                 usuarioalteracao_id bigint,
                                                 usuariocadastro_id bigint,
                                                 empresa_id bigint NOT NULL,
                                                 movimentacaocreditovaleentrada_id bigint,
                                                 ordemservico_id bigint
);

CREATE TABLE public.adicionalitemdelivery (
                                              id serial,
                                              adicionando boolean,
                                              opcional boolean DEFAULT false,
                                              quantidade numeric(10,4),
                                              valor numeric(12,2),
                                              dataalteracao date,
                                              datacadastro date,
                                              usuarioalteracao_id bigint,
                                              usuariocadastro_id bigint,
                                              adicional_id bigint,
                                              itemdelivery_id bigint
);

CREATE TABLE public.adicionalproduto (
                                         id serial,
                                         adiciona boolean DEFAULT true,
                                         ativo boolean,
                                         codigo bigint,
                                         descricao character varying(500),
                                         opcional boolean DEFAULT false,
                                         remove boolean DEFAULT false,
                                         todasempresas boolean DEFAULT false,
                                         valor numeric(10,2) NOT NULL,
                                         dataalteracao date,
                                         datacadastro date,
                                         usuarioalteracao_id bigint,
                                         usuariocadastro_id bigint,
                                         empresa_id bigint NOT NULL
);

CREATE TABLE public.adicionalprodutocontrole (
                                                 id serial,
                                                 opcional boolean DEFAULT false,
                                                 dataalteracao date,
                                                 datacadastro date,
                                                 usuarioalteracao_id bigint,
                                                 usuariocadastro_id bigint,
                                                 adicional_id bigint,
                                                 departamento_id bigint,
                                                 empresa_id bigint,
                                                 produto_id bigint
);

CREATE TABLE public.anexo (
                              id serial,
                              arquivo bytea,
                              descricao character varying(255),
                              extensao character varying(255),
                              dataalteracao date,
                              datacadastro date,
                              usuarioalteracao_id bigint,
                              usuariocadastro_id bigint,
                              clientefornecedor_id bigint NOT NULL
);

CREATE TABLE public.anotacaopedido (
                                       id serial,
                                       cliente character varying(256),
                                       dataabertura date,
                                       datavencimento date,
                                       descricao text,
                                       endereco character varying(100),
                                       observacao text,
                                       telefone character varying(15),
                                       tipo character varying(100),
                                       valortotal numeric(14,0),
                                       dataalteracao date,
                                       datacadastro date,
                                       usuarioalteracao_id bigint,
                                       usuariocadastro_id bigint,
                                       empresa_id bigint,
                                       statusanotacaopedido_id bigint
);


CREATE TABLE public.atalhobarraferramentas (
                                               id serial,
                                               permissao_agenda boolean DEFAULT false,
                                               permissao_auxiliar_venda boolean DEFAULT false,
                                               permissao_backup boolean DEFAULT true,
                                               permissao_caixa boolean DEFAULT true,
                                               permissao_clientes_fornecedores boolean DEFAULT true,
                                               permissao_configurador_atalhos boolean DEFAULT false,
                                               permissao_conhecimento_transporte boolean DEFAULT true,
                                               permissao_consultar_devolucao_trocas boolean DEFAULT false,
                                               permissao_delivery boolean DEFAULT true,
                                               permissao_emitir_cte boolean DEFAULT false,
                                               permissao_emitir_sat boolean DEFAULT false,
                                               permissao_emitir_mdfe boolean DEFAULT false,
                                               permissao_emitir_nfce boolean DEFAULT false,
                                               permissao_emitir_nfe boolean DEFAULT false,
                                               permissao_emitir_nfse boolean DEFAULT false,
                                               permissao_estoque boolean DEFAULT true,
                                               permissao_manifesto boolean DEFAULT true,
                                               permissao_motorista boolean DEFAULT true,
                                               permissao_ofertas_produto boolean DEFAULT false,
                                               permissao_orcamento boolean DEFAULT false,
                                               permissao_ordem_coleta boolean DEFAULT false,
                                               permissao_ordem_servico boolean DEFAULT true,
                                               permissao_pedido boolean DEFAULT true,
                                               permissao_painel_informativo boolean DEFAULT true,
                                               permissao_produtos boolean DEFAULT true,
                                               permissao_relatorios boolean DEFAULT true,
                                               permissao_sair_sistema boolean DEFAULT false,
                                               permissao_segunda_via_honorario boolean DEFAULT true,
                                               permissao_seguradora boolean DEFAULT true,
                                               permissao_servico boolean DEFAULT false,
                                               tamanhoicones character varying DEFAULT 'PERSONALIZADO'::character varying,
                                               permissao_veiculo boolean DEFAULT true,
                                               permissao_vendas boolean DEFAULT true,
                                               empresa_id bigint,
                                               usuario_id bigint
);

CREATE TABLE public.auditoria (
                                  id bigint NOT NULL,
                                  alteracaoid bigint,
                                  campo character varying(255),
                                  dataalteracao timestamp without time zone,
                                  registroid character varying(255),
                                  tabela character varying(255),
                                  tipooperacao character varying(255),
                                  usuario character varying(255),
                                  valorantigo text,
                                  valornovo text
);


CREATE TABLE public.backup (
                               id serial,
                               backupdiario boolean,
                               caminho character varying(255),
                               databackup date,
                               datagerado timestamp without time zone,
                               destinatario character varying(255) NOT NULL,
                               erro boolean,
                               formabackup character varying(255),
                               motivo character varying(255),
                               tipobackup character varying(255),
                               dataalteracao date,
                               datacadastro date,
                               usuarioalteracao_id bigint,
                               usuariocadastro_id bigint,
                               empresa_id bigint
);


CREATE TABLE public.balanca (
                                id serial,
                                ativo boolean DEFAULT true,
                                baudrate character varying(255) NOT NULL,
                                databits character varying(255) NOT NULL,
                                descricao character varying(255) NOT NULL,
                                divisorpeso character varying(255) NOT NULL,
                                modelo character varying(255),
                                parity character varying(255) NOT NULL,
                                port character varying(255) NOT NULL,
                                stopbits character varying(255) NOT NULL,
                                todasempresas boolean DEFAULT false,
                                dataalteracao date,
                                datacadastro date,
                                usuarioalteracao_id bigint,
                                usuariocadastro_id bigint,
                                empresa_id bigint NOT NULL,
                                tara_id bigint
);


CREATE TABLE public.beneficiofiscal (
                                        id serial,
                                        beneficio character varying(255),
                                        codigo character varying(8) NOT NULL,
                                        datavigencia date,
                                        descricao text NOT NULL,
                                        estado_id bigint
);

CREATE TABLE public.cadastrofacillancado (
                                             id serial,
                                             chaveacesso character varying(255),
                                             dataemissao timestamp without time zone,
                                             xmlimportado text,
                                             dataalteracao date,
                                             datacadastro date,
                                             usuarioalteracao_id bigint,
                                             usuariocadastro_id bigint,
                                             empresa_id bigint NOT NULL
);

CREATE TABLE public.caixa (
                              id serial,
                              aberto boolean,
                              dataabertura timestamp without time zone,
                              datafechamento timestamp without time zone,
                              valorabertura numeric(14,2),
                              valorfechamento numeric(14,2),
                              empresa_id bigint,
                              usuario_id bigint,
                              valorfechamentocartaocreditoinformado numeric(14,2) DEFAULT 0.00,
                              valorfechamentocartaodebitoinformado numeric(14,2) DEFAULT 0.00,
                              valorfechamentocheque numeric(14,2) DEFAULT 0.00,
                              valorfechamentochequeinformado numeric(14,2) DEFAULT 0.00,
                              valorfechamentoinformado numeric(14,2),
                              valorfechamentovalealimentacaoinformado numeric(14,2) DEFAULT 0.00,
                              valorfechamentovalerefeicaoinformado numeric(14,2) DEFAULT 0.00,
                              valorinformadocartoes numeric(14,2) DEFAULT 0.00,
                              valorinformadopix numeric(14,2) DEFAULT 0.00
);

CREATE TABLE public.campoadicional (
                                       id serial,
                                       ativo boolean NOT NULL,
                                       nome character varying(50) NOT NULL,
                                       tipocampo character varying(255)
);

CREATE TABLE public.camposadicionaiscliente (
                                                id serial,
                                                valor text,
                                                campoadicional_id bigint NOT NULL,
                                                dataalteracao date,
                                                datacadastro date,
                                                usuarioalteracao_id bigint,
                                                usuariocadastro_id bigint
);

CREATE TABLE public.cest (
                             id serial,
                             cest character varying(255),
                             datavigencia date,
                             descricaocest text,
                             ncm character varying(255),
                             numeroitem character varying(255),
                             versao character varying DEFAULT '16.01'::character varying
);

CREATE TABLE public.cfop (
                             id serial,
                             codigo character varying(4) NOT NULL,
                             descricao text NOT NULL,
                             tipocfop_id bigint
);

CREATE TABLE public.clientefornecedor (
                                          id serial,
                                          ativo boolean,
                                          bairro character varying(60),
                                          celular character varying(50),
                                          cep character varying(10),
                                          complemento text,
                                          contribuicaoicms integer NOT NULL,
                                          cpfcnpj character varying(14),
                                          datacadastro date,
                                          email character varying(100),
                                          endereco text,
                                          inscricaoestadual character varying(30),
                                          nomefantasia character varying(100),
                                          numero character varying(255),
                                          numeropais character varying(255),
                                          observacoes text,
                                          razaosocial character varying(100),
                                          referencia text,
                                          rg character varying(13),
                                          telefone character varying(50),
                                          tiporegistro character varying(2) NOT NULL,
                                          empresa_id bigint NOT NULL,
                                          municipio_id bigint,
                                          condicionalnaopermitido boolean DEFAULT false,
                                          datanascimento date,
                                          fornecedorvalepedagio boolean DEFAULT false,
                                          imagemcliente bytea,
                                          inscricaomunicipal character varying(30),
                                          inscricaosuframa character varying(10),
                                          isentoinscmunicipal boolean DEFAULT true,
                                          nomecontato character varying(45),
                                          passaporte character varying(255),
                                          tipocadastro character varying(2) DEFAULT 'CF'::character varying,
                                          todasempresas boolean DEFAULT false,
                                          valorcredito numeric(18,2),
                                          dataalteracao date,
                                          usuarioalteracao_id bigint,
                                          usuariocadastro_id bigint,
                                          creditocliente_id bigint,
                                          funcionario_id bigint,
                                          pais_id bigint
);


CREATE TABLE public.clientefornecedor_camposadicionaiscliente (
                                                                  clientefornecedor_id bigint NOT NULL,
                                                                  camposadicionais_id bigint NOT NULL
);


CREATE TABLE public.clientefornecedor_historicoclientefornecedor (
                                                                     clientefornecedor_id bigint NOT NULL,
                                                                     historicos_id bigint NOT NULL
);

CREATE TABLE public.clientefornecedortabelapreco (
                                                     id serial,
                                                     padrao boolean,
                                                     dataalteracao date,
                                                     datacadastro date,
                                                     usuarioalteracao_id bigint,
                                                     usuariocadastro_id bigint,
                                                     clientefornecedor_id bigint NOT NULL,
                                                     tabelapreco_id bigint NOT NULL
);

CREATE TABLE public.cnae (
                             id serial,
                             codigo character varying(12) NOT NULL,
                             descricao text
);

CREATE TABLE public.compromisso (
                                    id serial,
                                    codigo bigint NOT NULL,
                                    data date,
                                    hora time without time zone,
                                    horaaviso time without time zone,
                                    intervalo integer,
                                    lembrar boolean,
                                    mensagem text NOT NULL,
                                    resolvido boolean,
                                    unidade integer,
                                    empresa_id bigint,
                                    dataalteracao date,
                                    datacadastro date,
                                    usuarioalteracao_id bigint,
                                    usuariocadastro_id bigint
);

CREATE TABLE public.compromisso_usuario (
                                            compromisso_id bigint NOT NULL,
                                            usuarios_id bigint NOT NULL
);

CREATE TABLE public.conhecimentotransportedocumentoref (
                                                           id serial,
                                                           aliquotaicms numeric(12,2),
                                                           basecalcicms numeric(12,2),
                                                           csticms integer,
                                                           numerodespacho character varying(255),
                                                           percredbcicms numeric(6,2),
                                                           tipo integer,
                                                           tipotomador integer,
                                                           valoricms numeric(12,2),
                                                           destinatario_id bigint,
                                                           municipiocarga_id bigint,
                                                           municipiotermino_id bigint,
                                                           remetente_id bigint,
                                                           tomador_id bigint
);

CREATE TABLE public.conhecimentotransportedocumentoref_nfconhecimentotransportedocr (
                                                                                        conhecimentotransportedocumentoref_id bigint NOT NULL,
                                                                                        notastransportadas_id bigint NOT NULL
);

CREATE TABLE public.conta (
                              id serial,
                              descricao character varying(255) NOT NULL,
                              numero character varying(255),
                              empresa_id bigint,
                              ativo boolean,
                              numeroconta character varying(255),
                              dataalteracao date,
                              datacadastro date,
                              usuarioalteracao_id bigint,
                              usuariocadastro_id bigint,
                              codigoagencia character varying(255),
                              codigoconta character varying(255),
                              cpfcnpj character varying(14),
                              digitoagencia character varying(4),
                              digitoconta character varying(4),
                              razaosocial character varying(100),
                              bancosenum character varying(255),
                              digitonumeroconvenio character varying(255),
                              loteatual bigint,
                              numerocarteira character varying(255),
                              numeroconvenio character varying(255),
                              sequencianossonumero character varying(255),
                              ultimasequenciaarquivoremessa bigint,
                              variacaocarteira character varying(255),
                              contacaixa boolean
);

CREATE TABLE public.contador (
                                 id serial,
                                 bairro character varying(100),
                                 cep character varying(10),
                                 cnpjempresa character varying(255),
                                 complemento character varying(255),
                                 cpf character varying(255),
                                 crc character varying(255),
                                 email character varying(255),
                                 endereco character varying(255),
                                 fax character varying(255),
                                 nome character varying(255),
                                 nomeempresa character varying(255),
                                 numero character varying(255),
                                 telefone character varying(255),
                                 empresa_id bigint,
                                 municipio_id bigint
);

CREATE TABLE public.contato (
                                id serial,
                                celular character varying(50),
                                contato character varying(255),
                                datacontato date NOT NULL,
                                hora character varying(255),
                                nomecliente character varying(255),
                                observacao text,
                                telefone character varying(50),
                                dataalteracao date,
                                datacadastro date,
                                usuarioalteracao_id bigint,
                                usuariocadastro_id bigint,
                                clientefornecedor_id bigint,
                                empresa_id bigint NOT NULL,
                                tipo_id bigint NOT NULL,
                                compromisso_id bigint
);

CREATE TABLE public.contatoadicional (
                                         id serial,
                                         email character varying(100),
                                         nome character varying(100),
                                         telefone character varying(50),
                                         clientefornecedor_id bigint
);

CREATE TABLE public.cotacao (
                                id serial,
                                datacotacao date,
                                valor numeric(10,4),
                                dataalteracao date,
                                datacadastro date,
                                usuarioalteracao_id bigint,
                                usuariocadastro_id bigint,
                                empresa_id bigint NOT NULL,
                                moeda_id bigint
);

CREATE TABLE public.creditocliente (
                                       id serial,
                                       valorcredito numeric(18,2),
                                       clientefornecedor_id bigint,
                                       empresa_id bigint
);

CREATE TABLE public.cst (
                            id serial,
                            codigo character varying(3) NOT NULL,
                            descricao text NOT NULL,
                            imposto character varying(6) NOT NULL,
                            tipo character varying(255)
);

CREATE TABLE public.databasechangelog (
                                          id character varying(255) NOT NULL,
                                          author character varying(255) NOT NULL,
                                          filename character varying(255) NOT NULL,
                                          dateexecuted timestamp with time zone NOT NULL,
                                          orderexecuted integer NOT NULL,
                                          exectype character varying(10) NOT NULL,
                                          md5sum character varying(35),
                                          description character varying(255),
                                          comments character varying(255),
                                          tag character varying(255),
                                          liquibase character varying(20)
);

CREATE TABLE public.delivery (
                                 id serial,
                                 adicionais numeric(14,2),
                                 bairro character varying(255),
                                 cep character varying(8),
                                 complemento character varying(255),
                                 cpfcliente character varying(14),
                                 data timestamp without time zone,
                                 datafechamento timestamp without time zone,
                                 delivery boolean,
                                 desconto numeric(14,2),
                                 endereco character varying(255),
                                 faturadoantecipadamente boolean DEFAULT false,
                                 geradonotaantecipadamente boolean,
                                 juros numeric(14,2) DEFAULT 0.00,
                                 nomecliente character varying(100),
                                 numerodelivery bigint,
                                 numero character varying(255),
                                 observacoes text,
                                 pagoentregador boolean DEFAULT false,
                                 referencia character varying(255),
                                 status character varying(255),
                                 taxaentrega numeric(14,2),
                                 taxaservico numeric(5,2) DEFAULT 0.00,
                                 telefone character varying(12),
                                 totalpago numeric(14,2),
                                 troco numeric(14,2),
                                 valortaxaservico numeric(38,0),
                                 valortotal numeric(14,2),
                                 dataalteracao date,
                                 datacadastro date,
                                 usuarioalteracao_id bigint,
                                 usuariocadastro_id bigint,
                                 caixaaberto_id bigint,
                                 cidade_id bigint,
                                 cliente_id bigint,
                                 empresa_id bigint,
                                 entregador_id bigint,
                                 tabelapreco_id bigint,
                                 vendedor_id bigint
);

CREATE TABLE public.departamento (
                                     id serial,
                                     codigo bigint NOT NULL,
                                     descricao character varying(500),
                                     empresa_id bigint NOT NULL,
                                     ativo boolean DEFAULT true,
                                     ordenaradicionais character varying DEFAULT 'CODIGO_CRESCENTE'::character varying,
                                     todasempresas boolean DEFAULT false,
                                     dataalteracao date,
                                     datacadastro date,
                                     usuarioalteracao_id bigint,
                                     usuariocadastro_id bigint,
                                     tara_id bigint
);

CREATE TABLE public.dependente (
                                   id serial,
                                   cpf character varying(50),
                                   nome character varying(100),
                                   clientefornecedor_id bigint,
                                   datanascimento date,
                                   dataalteracao date,
                                   datacadastro date,
                                   usuarioalteracao_id bigint,
                                   usuariocadastro_id bigint
);

CREATE TABLE public.devolucaotrocaproduto (
                                              id serial,
                                              cancelada boolean,
                                              clientecpfcnpj character varying(255),
                                              clientenome character varying(255),
                                              datadevolucao timestamp without time zone NOT NULL,
                                              datavenda timestamp without time zone,
                                              numerodocumento bigint,
                                              observacao text,
                                              tipodocumento integer,
                                              tipotroco integer,
                                              totaldevolucao numeric(14,2),
                                              totalpago numeric(14,2),
                                              totaltroca numeric(14,2),
                                              totaltrocaprazo numeric(14,2) DEFAULT 0.00,
                                              totalvale numeric(14,2),
                                              trocovale boolean,
                                              dataalteracao date,
                                              datacadastro date,
                                              usuarioalteracao_id bigint,
                                              usuariocadastro_id bigint,
                                              caixaaberto_id bigint,
                                              cliente_id bigint,
                                              empresa_id bigint,
                                              enderecocliente_id bigint,
                                              entregador_id bigint,
                                              tabelapreco_id bigint,
                                              vendedor_id bigint
);

CREATE TABLE public.documentofiscal (
                                        id serial,
                                        basecalcicms numeric(12,2),
                                        basecalcicmsst numeric(12,2),
                                        cfopentrada character varying(5),
                                        chaveacesso character varying(44),
                                        consumidorfinal character varying(255),
                                        contribuicaoicms integer,
                                        dataemissaodocumento timestamp without time zone NOT NULL,
                                        dataentrada timestamp without time zone NOT NULL,
                                        especie integer NOT NULL,
                                        especievolume character varying(60),
                                        formafrete integer,
                                        formapagamento integer,
                                        infadicionais text,
                                        marcavolumes character varying(60),
                                        naturezaoperacao character varying(100),
                                        numeracaovolumes character varying(60),
                                        numero bigint NOT NULL,
                                        pesobruto numeric(12,3),
                                        pesoliq numeric(12,3),
                                        produtorrural boolean NOT NULL,
                                        quantidadetransportada numeric(12,4),
                                        serie character varying(10) NOT NULL,
                                        situacao character varying(255) NOT NULL,
                                        tipofaturamento integer NOT NULL,
                                        valorfundocombatepobrezadaufdestino numeric(12,2),
                                        valoricmsst numeric(12,2),
                                        valoricms numeric(12,2),
                                        valoricmsufdestino numeric(12,2),
                                        valoricmsufremetente numeric(12,2),
                                        valortotalbcipi numeric(12,2),
                                        valortotalcofins numeric(20,8),
                                        valortotaldescontos numeric(12,2),
                                        valortotaldocumento numeric(12,2),
                                        valortotalfrete numeric(12,2),
                                        valortotalii numeric(12,2),
                                        valortotalipi numeric(12,2),
                                        valortotaloutrasdespesas numeric(12,2),
                                        valortotalpago numeric(12,2),
                                        valortotalpis numeric(20,8),
                                        valortotalprodutos numeric(12,2),
                                        valortotalseguro numeric(12,2),
                                        dataalteracao date,
                                        datacadastro date,
                                        usuarioalteracao_id bigint,
                                        usuariocadastro_id bigint,
                                        cfop_id bigint,
                                        cliente_id bigint,
                                        cte_id bigint,
                                        empresa_id bigint NOT NULL,
                                        fornecedor_id bigint NOT NULL,
                                        transportador_id bigint,
                                        veiculo_id bigint,
                                        fornecimentoconsumo_id bigint
);

CREATE TABLE public.duplicatanotaentrada (
                                             id serial,
                                             datavencimento date,
                                             numeroduplicata character varying(255),
                                             pago boolean,
                                             valor numeric(14,2),
                                             notafiscalentrada_id bigint
);

CREATE TABLE public.emailsbackup (
                                     id serial,
                                     email character varying(255),
                                     nome character varying(255),
                                     telefone character varying(255),
                                     parametrobackup_id bigint,
                                     preferencia_id bigint
);

CREATE TABLE public.empresa (
                                id serial,
                                ativa boolean,
                                bairro character varying(60) NOT NULL,
                                cep character varying(8) NOT NULL,
                                cnpj character varying(50) NOT NULL,
                                complemento character varying(60),
                                contribuicaoicms character varying(1) NOT NULL,
                                email character varying(50),
                                endereco character varying(34) NOT NULL,
                                fax character varying(10),
                                funcaocontato character varying(50),
                                inscricaoestadual character varying(50),
                                inscricaomunicipal character varying(50),
                                issqn boolean,
                                nomecontato character varying(28) NOT NULL,
                                nomefantasia character varying(60) NOT NULL,
                                numero character varying(5) NOT NULL,
                                razaosocial character varying(60) NOT NULL,
                                telefone character varying(12),
                                municipio_id bigint NOT NULL,
                                clifor_id bigint,
                                celular character varying(12),
                                inscricaoestadualsubst character varying(255),
                                rntrc character varying(20),
                                contador_id bigint
);

CREATE TABLE public.endereco (
                                 id serial,
                                 bairro character varying(100),
                                 cep character varying(10),
                                 complemento text,
                                 endereco text,
                                 identificacao character varying(255),
                                 inscricaoestadual character varying(30),
                                 numero character varying(255),
                                 referencia text,
                                 clientefornecedor_id bigint,
                                 municipio_id bigint
);

CREATE TABLE public.entregador (
                                   id serial,
                                   ativo boolean DEFAULT true,
                                   bairro character varying(100),
                                   categoriacnh character varying(255),
                                   celular character varying(50),
                                   cep character varying(10),
                                   cnh character varying(255),
                                   complemento text,
                                   cpf character varying(14),
                                   email character varying(100),
                                   endereco text,
                                   nome character varying(255) NOT NULL,
                                   numero character varying(255),
                                   referencia text,
                                   rg character varying(255),
                                   telefone character varying(50),
                                   terceirizado boolean,
                                   todasempresas boolean DEFAULT true,
                                   empresa_id bigint NOT NULL,
                                   municipio_id bigint
);

CREATE TABLE public.equipamento (
                                    id serial,
                                    ativo boolean NOT NULL,
                                    descricao text,
                                    identificacao character varying(255),
                                    observacao text,
                                    dataalteracao date,
                                    datacadastro date,
                                    usuarioalteracao_id bigint,
                                    usuariocadastro_id bigint,
                                    clientefornecedor_id bigint,
                                    empresa_id bigint,
                                    marca_id bigint
);

CREATE TABLE public.estado (
                               id serial,
                               nome character varying(50) NOT NULL,
                               sigla character varying(3) NOT NULL,
                               pais_id bigint
);

CREATE TABLE public.fatorconversaofornecedor (
                                                 id serial,
                                                 fatorconversao numeric(35,25),
                                                 fornecedor_id bigint,
                                                 produto_id bigint
);


CREATE TABLE public.faturamentomensal (
                                          id serial,
                                          ano character varying(4),
                                          data date,
                                          mes integer,
                                          valorfaturamento numeric(12,2),
                                          empresa_id bigint NOT NULL
);

CREATE TABLE public.formapagamentodelivery (
                                               id serial,
                                               acrescimo numeric(13,2),
                                               bandeiracartao character varying(255),
                                               cnpjcredenciadora character varying(14),
                                               desconto numeric(13,2),
                                               forma character varying(255),
                                               movimentacaogerada boolean DEFAULT false,
                                               numerotransacao character varying(255),
                                               observacao character varying(255),
                                               observacaopedido text,
                                               tipo character varying(255),
                                               troco numeric(13,2),
                                               valor numeric(13,2),
                                               valorcotacaomoedaestrangeira numeric(13,2),
                                               valormoedaestrangeira numeric(13,2),
                                               valorpago numeric(13,2),
                                               delivery_id bigint,
                                               maquinacartao_id bigint,
                                               moedaestrangeira_id bigint,
                                               movimentacaocreditosaida_id bigint,
                                               vale_id bigint
);

CREATE TABLE public.formapagamentodevolucaoproduto (
                                                       id serial,
                                                       acrescimo numeric(13,2),
                                                       bandeiracartao character varying(255),
                                                       cnpjcredenciadora character varying(14),
                                                       desconto numeric(13,2),
                                                       forma character varying(255),
                                                       movimentacaogerada boolean DEFAULT false,
                                                       numerotransacao character varying(255),
                                                       observacao character varying(255),
                                                       observacaopedido text,
                                                       tipo character varying(255),
                                                       troco numeric(13,2),
                                                       valor numeric(13,2),
                                                       valorcotacaomoedaestrangeira numeric(13,2),
                                                       valormoedaestrangeira numeric(13,2),
                                                       valorpago numeric(13,2),
                                                       devolucaoproduto_id bigint,
                                                       maquinacartao_id bigint,
                                                       moedaestrangeira_id bigint,
                                                       movimentacaocreditosaida_id bigint,
                                                       vale_id bigint
);

CREATE TABLE public.formapagamentodocumentofiscal (
                                                      id serial,
                                                      formapagamento integer,
                                                      isprazo boolean,
                                                      quantidadeparcelas character varying(255),
                                                      valorpago numeric(12,2),
                                                      valortotal numeric(12,2),
                                                      documentofiscal_id bigint NOT NULL
);

CREATE TABLE public.formapagamentoordemservico (
                                                   id serial,
                                                   bandeira character varying(255),
                                                   cnpjcredenciadora character varying(14),
                                                   forma character varying(255),
                                                   numerotransacao character varying(255),
                                                   valor numeric(12,2),
                                                   maquinacartao_id bigint,
                                                   ordemservico_id bigint,
                                                   desconto numeric(12,2),
                                                   acrescimo numeric(12,2)
);

CREATE TABLE public.formapagamentopedido (
                                             id serial,
                                             acrescimo numeric(13,2),
                                             bandeiracartao character varying(255),
                                             cnpjcredenciadora character varying(14),
                                             desconto numeric(13,2),
                                             forma character varying(255),
                                             idprovendas bigint,
                                             movimentacaogerada boolean DEFAULT false,
                                             numerotransacao character varying(255),
                                             observacao character varying(255),
                                             observacaopedido text,
                                             tipo character varying(255),
                                             troco numeric(13,2),
                                             valor numeric(13,2),
                                             valorcotacaomoedaestrangeira numeric(13,2),
                                             valormoedaestrangeira numeric(13,2),
                                             valorpago numeric(13,2),
                                             maquinacartao_id bigint,
                                             moedaestrangeira_id bigint,
                                             pedido_id bigint,
                                             movimentacaocreditosaida_id bigint,
                                             vale_id bigint
);

CREATE TABLE public.fornecimentoconsumo (
                                            id serial,
                                            classeconsumo character varying(255),
                                            grupotensao character varying(255),
                                            tipoassinante character varying(255),
                                            tipoligacao character varying(255),
                                            valorcobradoterceiros numeric(12,2),
                                            valordespesasacessorias numeric(12,2),
                                            valorfornecidoconsumido numeric(12,2),
                                            valorserviconaotributadoicms numeric(12,2)
);

CREATE TABLE public.funcionario (
                                    id serial,
                                    ativo boolean DEFAULT true,
                                    bairro character varying(100),
                                    cargo character varying(255),
                                    celular character varying(50),
                                    cep character varying(10),
                                    comissao numeric(14,2),
                                    complemento text,
                                    cpf character varying(14),
                                    dataentrada date,
                                    datanascimento date,
                                    datasaida date,
                                    email character varying(100),
                                    endereco text,
                                    funcao character varying(255),
                                    limitevale numeric(14,2),
                                    nome character varying(255) NOT NULL,
                                    numero character varying(255),
                                    observacoes text,
                                    recebevale boolean,
                                    referencia text,
                                    rg character varying(255),
                                    salario numeric(14,2),
                                    sexo character varying(2),
                                    telefone character varying(50),
                                    todasempresas boolean DEFAULT true,
                                    dataalteracao date,
                                    datacadastro date,
                                    usuarioalteracao_id bigint,
                                    usuariocadastro_id bigint,
                                    empresa_id bigint NOT NULL,
                                    municipio_id bigint
);

CREATE TABLE public.grupodespesareceita (
                                            id serial,
                                            descricao character varying(255) NOT NULL,
                                            numero bigint NOT NULL,
                                            empresa_id bigint,
                                            ativo boolean DEFAULT true,
                                            todasempresas boolean DEFAULT false,
                                            dataalteracao date,
                                            datacadastro date,
                                            usuarioalteracao_id bigint,
                                            usuariocadastro_id bigint
);

CREATE TABLE public.grupoimpressao (
                                       id serial,
                                       codigo character varying(255) NOT NULL,
                                       ipimpressora character varying(255),
                                       localizacao character varying(255) NOT NULL,
                                       nome character varying(255) NOT NULL,
                                       nomeimpressora character varying(255) NOT NULL,
                                       nomeimpressorasistema character varying(255) NOT NULL,
                                       empresa_id bigint NOT NULL,
                                       ativo boolean DEFAULT true,
                                       pdrivername character varying(255)
);

CREATE TABLE public.historicoclientefornecedor (
                                                   id serial,
                                                   campo character varying(255),
                                                   conteudoanterior character varying(255),
                                                   dataalteracao timestamp without time zone
);

CREATE TABLE public.historicoconexaocaixa (
                                              id serial,
                                              dataconexao timestamp without time zone,
                                              datadesconexao timestamp without time zone,
                                              caixa_id bigint,
                                              empresa_id bigint,
                                              usuario_id bigint
);

CREATE TABLE public.historicodescricaoproduto (
                                                  id serial,
                                                  datafinal timestamp without time zone,
                                                  datainicial timestamp without time zone,
                                                  descricaoanterior character varying(255),
                                                  produto_id bigint
);


CREATE TABLE public.historicointegracaoproduto (
                                                   id serial,
                                                   data timestamp without time zone,
                                                   produto character varying(255),
                                                   empresa_id bigint NOT NULL,
                                                   usuario_id bigint NOT NULL
);

CREATE TABLE public.historicoprecocompraproduto (
                                                    id serial,
                                                    data timestamp without time zone,
                                                    quantidade numeric(10,4),
                                                    referencia character varying(255),
                                                    valorunitario numeric(10,4),
                                                    dataalteracao date,
                                                    datacadastro date,
                                                    usuarioalteracao_id bigint,
                                                    usuariocadastro_id bigint,
                                                    empresa_id bigint,
                                                    fornecedor_id bigint,
                                                    notaentrada_id bigint,
                                                    produto_id bigint
);

CREATE TABLE public.historicoprecovendaproduto (
                                                   id serial,
                                                   data timestamp without time zone,
                                                   valorunitario numeric(10,4),
                                                   dataalteracao date,
                                                   datacadastro date,
                                                   usuarioalteracao_id bigint,
                                                   usuariocadastro_id bigint,
                                                   empresa_id bigint,
                                                   notafiscalentrada_id bigint,
                                                   produto_id bigint
);

CREATE TABLE public.imagemequipamento (
                                          id serial,
                                          descricao text,
                                          imagem bytea,
                                          dataalteracao date,
                                          datacadastro date,
                                          usuarioalteracao_id bigint,
                                          usuariocadastro_id bigint,
                                          empresa_id bigint,
                                          equipamento_id bigint
);

CREATE TABLE public.impressaoetiqueta (
                                          id serial,
                                          etiqueta integer NOT NULL,
                                          empresa_id bigint NOT NULL
);

CREATE TABLE public.informacaonutricional (
                                              id serial,
                                              ativo boolean,
                                              carboidratos numeric(4,1) NOT NULL,
                                              codigo integer,
                                              fibraalimentar numeric(3,1) NOT NULL,
                                              fracaomedidacaseira character varying(255) NOT NULL,
                                              gordurassaturadas numeric(3,1) NOT NULL,
                                              gordurastotais numeric(3,1) NOT NULL,
                                              gordurastrans numeric(3,1) NOT NULL,
                                              medidacaseira character varying(255) NOT NULL,
                                              proteinas numeric(3,1) NOT NULL,
                                              quantidademedidacaseira integer NOT NULL,
                                              quantidadeporcao integer NOT NULL,
                                              sodio integer NOT NULL,
                                              unidadeporcao character varying(255) NOT NULL,
                                              valorenergetico integer NOT NULL,
                                              dataalteracao date,
                                              datacadastro date,
                                              usuarioalteracao_id bigint,
                                              usuariocadastro_id bigint,
                                              empresa_id bigint,
                                              produto_id bigint
);


CREATE TABLE public.informacaonutricionalextra (
                                                   id serial,
                                                   descricao character varying(56),
                                                   informacaonutricional_id bigint
);


CREATE TABLE public.inutilizacao (
                                     id serial,
                                     ambiente character varying(1),
                                     codigoretorno character varying(10),
                                     conteudoxml text,
                                     datainutilizacao timestamp without time zone NOT NULL,
                                     idchave character varying(255),
                                     modeloinutilizacao character varying(255),
                                     motivoinutilizacao character varying(255),
                                     numerofinal bigint NOT NULL,
                                     numeroinicial bigint NOT NULL,
                                     protocoloinutilizacao text,
                                     serie integer NOT NULL,
                                     dataalteracao date,
                                     datacadastro date,
                                     usuarioalteracao_id bigint,
                                     usuariocadastro_id bigint,
                                     empresa_id bigint NOT NULL
);


CREATE TABLE public.itemdelivery (
                                     id serial,
                                     acrescimo numeric(14,2) DEFAULT 0.00,
                                     desconto numeric(14,2),
                                     descricaoproduto character varying(255),
                                     juros numeric(14,2) DEFAULT 0.00,
                                     observacoes character varying(255),
                                     quantidade numeric(10,4),
                                     valoritem numeric(12,2),
                                     valortaxa numeric(12,2),
                                     valortaxaservico numeric(14,2),
                                     valortotal numeric(12,2),
                                     delivery_id bigint,
                                     empresa_id bigint,
                                     kitproduto_id bigint,
                                     produto_id bigint
);

CREATE TABLE public.itemdevolucaotroca (
                                           id serial,
                                           desconto numeric(14,2),
                                           descricaoproduto character varying(255),
                                           devolucao boolean,
                                           quantidade numeric(10,4),
                                           valoritem numeric(21,10),
                                           valoritemprazo numeric(21,10) DEFAULT 0.00,
                                           devolucaotrocaproduto_id bigint,
                                           kitproduto_id bigint,
                                           produto_id bigint
);

CREATE TABLE public.itemdocumentofiscal (
                                            id serial,
                                            aliquotacofins numeric(5,2),
                                            aliquotacreditoicms numeric(5,2),
                                            aliquotaicms numeric(5,2),
                                            aliquotaicmsst numeric(5,2),
                                            aliquotaipi numeric(5,2),
                                            aliquotapis numeric(5,2),
                                            cest character varying(255),
                                            cfopentrada character varying(5),
                                            classeenquadipi character varying(10),
                                            codigo character varying(255),
                                            codigoenquadipi character varying(10),
                                            descricaoitem character varying(500) NOT NULL,
                                            excecaoncm character varying(255),
                                            infadicional character varying(500),
                                            modalidadebcst character varying(1),
                                            movimentacaofisica character varying(255),
                                            numeroncm character varying(255),
                                            outrovalor numeric(15,2),
                                            posicaoitem integer NOT NULL,
                                            quantidadecomercial numeric(15,4),
                                            quantidadetributacao numeric(15,4),
                                            usarcsttabela boolean,
                                            valorbccofins numeric(15,2),
                                            valorbcicms numeric(15,2),
                                            valorbcicmsst numeric(15,2),
                                            valorbcicmsstret numeric(15,2),
                                            valorbcipi numeric(15,2),
                                            valorbcpis numeric(15,2),
                                            valorcofins numeric(20,8),
                                            valorcreditoicms numeric(15,2),
                                            valordesconto numeric(15,2),
                                            valorfcpufdest numeric(15,2),
                                            valorfrete numeric(15,2),
                                            valoricms numeric(15,2),
                                            valoricmsst numeric(15,2),
                                            valoricmsstret numeric(15,2),
                                            valoricmsufdest numeric(15,2),
                                            valoricmsufremet numeric(15,2),
                                            valoripi numeric(15,2),
                                            valoroutrasdespesas numeric(15,2),
                                            valorpis numeric(20,8),
                                            valorseguro numeric(15,2),
                                            valortotal numeric(15,2),
                                            valortotalproduto numeric(15,2),
                                            valorunitariocomercial numeric(20,10),
                                            valorunitariotributado numeric(20,10),
                                            cfop_id bigint NOT NULL,
                                            cstcofins_id bigint,
                                            csticms_id bigint,
                                            cstipi_id bigint,
                                            cstpis_id bigint,
                                            documentofiscal_id bigint NOT NULL,
                                            naturezareceitacofins_id bigint,
                                            naturezareceitapis_id bigint,
                                            produto_id bigint,
                                            tipoitem_id bigint,
                                            unidademedida_id bigint
);

CREATE TABLE public.itemgrupoimpressao (
                                           id serial,
                                           empresa_id bigint NOT NULL,
                                           grupoimpressao_id bigint,
                                           produto_id bigint
);

CREATE TABLE public.itemkitproduto (
                                       id serial,
                                       desconto numeric(10,2),
                                       descricao character varying(120) NOT NULL,
                                       quantidade numeric(12,4) NOT NULL,
                                       valor numeric(10,2),
                                       valorproduto numeric(10,2),
                                       dataalteracao date,
                                       datacadastro date,
                                       usuarioalteracao_id bigint,
                                       usuariocadastro_id bigint,
                                       kitproduto_id bigint,
                                       produto_id bigint
);


CREATE TABLE public.itemnotafiscalentrada (
                                              id serial,
                                              aliquotaicms numeric(10,2),
                                              aliquotaicmsst numeric(10,2),
                                              aliquotaipi numeric(10,2),
                                              aliquotapiscofins numeric(10,2),
                                              cfop character varying(255) NOT NULL,
                                              codigointerno character varying(255) NOT NULL,
                                              descricaoproduto character varying(255) NOT NULL,
                                              eancomercial character varying(30),
                                              eantributado character varying(30),
                                              estoquegerado boolean DEFAULT false,
                                              finalidade character varying(255),
                                              infadicional text,
                                              ncm character varying(255) NOT NULL,
                                              origemmercadoria character varying(255),
                                              posicaoitem integer NOT NULL,
                                              quantidade numeric(10,4) NOT NULL,
                                              quantidademovimentada numeric(10,2),
                                              quantidadetributada numeric(10,2),
                                              unidadecomercial character varying(255),
                                              unidadetributado character varying(255),
                                              valorbcicms numeric(10,2),
                                              valorbcicmsst numeric(10,2),
                                              valorbcipi numeric(10,2),
                                              valorbcpiscofins numeric(10,2),
                                              valordesconto numeric(10,2) NOT NULL,
                                              valorfcp numeric(10,2),
                                              valorfcpst numeric(10,2),
                                              valorfrete numeric(10,2),
                                              valoricms numeric(10,2),
                                              valoricmsst numeric(10,2),
                                              valoripi numeric(10,2),
                                              valoroutrasdespesas numeric(10,2),
                                              valorpiscofins numeric(10,2),
                                              valortotal numeric(10,4) NOT NULL,
                                              valorunitario numeric(10,4) NOT NULL,
                                              valorunitariotributado numeric(10,2),
                                              csticms_id bigint,
                                              cstipi_id bigint,
                                              cstpiscofins_id bigint,
                                              notafiscalentrada_id bigint,
                                              produto_id bigint
);

CREATE TABLE public.itemordemservico (
                                         id serial,
                                         desconto numeric(14,2),
                                         quantidade numeric(10,4),
                                         valoritem numeric(12,2),
                                         ordemservico_id bigint,
                                         produto_id bigint,
                                         servico_id bigint,
                                         descricaoitem text,
                                         valortotalliquido numeric(14,2),
                                         responsavel_id bigint,
                                         faturaitem_id bigint,
                                         promocaoproduto_id bigint,
                                         itemgradeproduto_id bigint,
                                         acrescimo numeric(14,2) DEFAULT 0.00,
                                         imprimirvalor boolean DEFAULT false,
                                         kitproduto_id bigint
);

CREATE TABLE public.itempedido (
                                   id serial,
                                   quantidade numeric(10,4),
                                   valoritem numeric(12,2),
                                   pedido_id bigint,
                                   produto_id bigint,
                                   acrescimo numeric(14,2),
                                   desconto numeric(14,2) DEFAULT 0.00,
                                   descricaoproduto character varying(255),
                                   idprovendas bigint,
                                   juros numeric(14,2) DEFAULT 0.00,
                                   posicaoitem integer,
                                   valorprazo numeric(14,2) DEFAULT 0.00,
                                   valortotal numeric(14,4),
                                   kitproduto_id bigint,
                                   marca_id bigint,
                                   natureza_id bigint,
                                   promocaoproduto_id bigint,
                                   faturaitem_id bigint
);

CREATE TABLE public.itempedidocompra (
                                         id serial,
                                         codigoproduto character varying(255),
                                         desconto numeric(14,2) DEFAULT 0.00,
                                         descricaoproduto character varying(255),
                                         posicaoitem integer,
                                         quantidade numeric(10,4),
                                         valortotal numeric(12,2),
                                         valorunitario numeric(12,2),
                                         pedidocompra_id bigint,
                                         produto_id bigint,
                                         unidademedidacomercial_id bigint
);

CREATE TABLE public.kitproduto (
                                   id serial,
                                   ativo boolean,
                                   desconto numeric(10,2),
                                   descricao character varying(120) NOT NULL,
                                   infadicional character varying(500),
                                   localizacao character varying(60),
                                   todasempresas boolean DEFAULT false,
                                   valoritens numeric(10,2),
                                   valorkit numeric(10,2),
                                   dataalteracao date,
                                   datacadastro date,
                                   usuarioalteracao_id bigint,
                                   usuariocadastro_id bigint,
                                   empresa_id bigint,
                                   produto_id bigint
);

CREATE TABLE public.liquidacaoproduto (
                                          id serial,
                                          ativo boolean,
                                          descontoperc numeric(4,2),
                                          iniciovigencia date,
                                          observacao text,
                                          terminovigencia date,
                                          titulo character varying(255),
                                          dataalteracao date,
                                          datacadastro date,
                                          usuarioalteracao_id bigint,
                                          usuariocadastro_id bigint,
                                          departamento_id bigint,
                                          empresa_id bigint,
                                          marca_id bigint,
                                          subdepartamento_id bigint
);

CREATE TABLE public.liquidacaoproduto_produto (
                                                  liquidacaoproduto_id bigint NOT NULL,
                                                  produtos_id bigint NOT NULL
);

CREATE TABLE public.maquinacartao (
                                      id serial,
                                      cnpjcredenciadora character varying(14),
                                      descricao character varying(255),
                                      numeroestabelecimento character varying,
                                      observacao text,
                                      dataalteracao date,
                                      datacadastro date,
                                      usuarioalteracao_id bigint,
                                      usuariocadastro_id bigint,
                                      empresa_id bigint NOT NULL,
                                      ativo boolean DEFAULT true,
                                      todasempresas boolean DEFAULT false,
                                      contabancaria_id bigint,
                                      clientefornecedor_id bigint
);

CREATE TABLE public.marca (
                              id serial,
                              ativo boolean DEFAULT true,
                              codigo bigint NOT NULL,
                              descricao character varying(500),
                              todasempresas boolean DEFAULT false,
                              dataalteracao date,
                              datacadastro date,
                              usuarioalteracao_id bigint,
                              usuariocadastro_id bigint,
                              empresa_id bigint NOT NULL
);

CREATE TABLE public.modalrodoviariomdfe_motorista (
                                                      modalrodoviariomdfe_id bigint NOT NULL,
                                                      condutor_id bigint NOT NULL
);


CREATE TABLE public.modalrodoviariomdfe_valepedagio (
                                                        modalrodoviariomdfe_id bigint NOT NULL,
                                                        valepedagio_id bigint NOT NULL
);


CREATE TABLE public.modalrodoviariomdfe_veiculo (
                                                    modalrodoviariomdfe_id bigint NOT NULL,
                                                    veiculoreboque_id bigint NOT NULL
);


CREATE TABLE public.modulo (
                               id serial,
                               modulo character varying(255) NOT NULL,
                               empresa_id bigint
);

CREATE TABLE public.moeda (
                              id serial,
                              ativo boolean DEFAULT true,
                              descricao character varying(30),
                              todasempresas boolean DEFAULT true,
                              dataalteracao date,
                              datacadastro date,
                              usuarioalteracao_id bigint,
                              usuariocadastro_id bigint,
                              empresa_id bigint NOT NULL
);

CREATE TABLE public.motorista_veiculo (
                                          motorista_id bigint NOT NULL,
                                          veiculosvinculado_id bigint NOT NULL
);

CREATE TABLE public.movimentacaocaixa (
                                          id serial,
                                          datamovimentacao timestamp without time zone,
                                          motivo text,
                                          status character varying(255),
                                          tipomovimentacao character(1),
                                          valor numeric(14,2),
                                          caixa_id bigint,
                                          duplicataecf_id bigint,
                                          duplicatanota_id bigint,
                                          empresaid bigint,
                                          serie integer,
                                          numero bigint,
                                          ambiente character varying(1),
                                          tipofaturamento integer,
                                          movimentacaoextorno_id bigint,
                                          formapagamento character varying DEFAULT 'DINHEIRO'::character varying,
                                          dataalteracao date,
                                          datacadastro date,
                                          usuarioalteracao_id bigint,
                                          usuariocadastro_id bigint,
                                          auxiliarservico_id bigint,
                                          auxiliarvenda_id bigint,
                                          cte_id bigint,
                                          cupomfiscal_id bigint,
                                          devolucaotrocaproduto_id bigint,
                                          formapagamentopedido_id bigint,
                                          movimentacaocreditovaleentrada_id bigint,
                                          nfs_id bigint,
                                          notacompra_id bigint,
                                          notaconsumidor_id bigint,
                                          ordemservico_id bigint
);

CREATE TABLE public.movimentacaocreditoentrada (
                                                   id serial,
                                                   datamovimentacao timestamp without time zone,
                                                   hashvale character varying(255),
                                                   numerocartaoexterno character varying(255),
                                                   observacao text,
                                                   status character varying(255),
                                                   tipo character varying(255),
                                                   valepresente boolean,
                                                   valor numeric(18,2),
                                                   caixaaberto_id bigint,
                                                   creditocliente_id bigint,
                                                   devolucaotrocaproduto_id bigint,
                                                   empresa_id bigint,
                                                   formapagto_id bigint,
                                                   valetroco_id bigint
);

CREATE TABLE public.movimentacaocreditosaida (
                                                 id serial,
                                                 observacao text,
                                                 status character varying(255),
                                                 tipo character varying(255),
                                                 valor numeric(18,2),
                                                 creditocliente_id bigint,
                                                 empresa_id bigint,
                                                 formapagamentoauxvenda_id bigint,
                                                 formapagamentoauxiliarservico_id bigint,
                                                 formapagamentocupomfiscal_id bigint,
                                                 formapagamentodevolucaoproduto_id bigint,
                                                 formapagamentonfse_id bigint,
                                                 formapagamentonfce_id bigint,
                                                 formapagamentonfe_id bigint
);

CREATE TABLE public.movimentoestoque (
                                         id serial,
                                         datamovimentacao timestamp without time zone,
                                         justificativa text,
                                         quantidade numeric(12,4) NOT NULL,
                                         tipomovimento character varying(2) NOT NULL,
                                         clientefornecedor_id bigint,
                                         produto_id bigint NOT NULL,
                                         usuario_id bigint,
                                         origemmovimentacao character varying(255),
                                         quantanterior numeric(12,4),
                                         quantatual numeric(12,4),
                                         dataalteracao date,
                                         datacadastro date,
                                         usuarioalteracao_id bigint,
                                         usuariocadastro_id bigint
);

CREATE TABLE public.municipio (
                                  id serial,
                                  nome character varying(100) NOT NULL,
                                  estado_id bigint
);

CREATE TABLE public.natureza (
                                 id serial,
                                 descricao character varying(255) NOT NULL,
                                 numero bigint NOT NULL,
                                 empresa_id bigint,
                                 ativo boolean DEFAULT true,
                                 todasempresas boolean DEFAULT false,
                                 dataalteracao date,
                                 datacadastro date,
                                 usuarioalteracao_id bigint,
                                 usuariocadastro_id bigint,
                                 tiponatureza character varying(255)
);

CREATE TABLE public.ncm (
                            id serial,
                            descricao text NOT NULL,
                            numero character varying(8) NOT NULL,
                            pai_id bigint,
                            aliquota numeric(7,4),
                            datavigencia date,
                            excecao character varying(255) NOT NULL,
                            versao character varying(255)
);

CREATE TABLE public.nfconhecimentotransportedocreferenciado (
                                                                id serial,
                                                                chaveacesso character varying(255),
                                                                dataemissao date,
                                                                modelo integer,
                                                                numero bigint NOT NULL,
                                                                pesobruto numeric(10,2),
                                                                pesoliquido numeric(10,2),
                                                                quantidadevolume numeric(10,2),
                                                                serie character varying(255) NOT NULL,
                                                                valormercadoria numeric(10,2),
                                                                valornota numeric(10,2),
                                                                conhecimentotransporte_id bigint
);

CREATE TABLE public.notadestinada (
                                      id serial,
                                      chaveacesso character varying(255),
                                      cpfcnpj character varying(20),
                                      dataemissao date,
                                      datalancamento timestamp without time zone,
                                      dataresp timestamp without time zone,
                                      importada boolean,
                                      nsu character varying(255),
                                      numero bigint,
                                      razaosocial character varying(255),
                                      status character varying(255),
                                      tipooperacao integer,
                                      valor numeric(14,2),
                                      dataalteracao date,
                                      datacadastro date,
                                      usuarioalteracao_id bigint,
                                      usuariocadastro_id bigint,
                                      empresa_id bigint NOT NULL,
                                      usuario_id bigint
);

CREATE TABLE public.notafiscalentrada (
                                          id serial,
                                          ambiente character varying(255),
                                          basecalculoicms numeric(10,2),
                                          basecalculoicmsst numeric(10,2),
                                          bloqueadoedicao boolean DEFAULT false,
                                          chaveacesso character varying(44),
                                          dataemissao timestamp without time zone,
                                          dataimportacao timestamp without time zone,
                                          datasaida timestamp without time zone,
                                          especie character varying(5) NOT NULL,
                                          finalidade character varying(255),
                                          formapagamento character varying(1),
                                          infadicionais text,
                                          modelo character varying(255),
                                          movcaixagerada boolean DEFAULT false,
                                          naturezaoperacao character varying(100),
                                          numero bigint NOT NULL,
                                          serie character varying(3) NOT NULL,
                                          tipooperacao integer,
                                          valorcofins numeric(10,2),
                                          valordesconto numeric(10,2),
                                          valorfrete numeric(10,2),
                                          valoricms numeric(10,2),
                                          valoricmsst numeric(10,2),
                                          valorii numeric(10,2),
                                          valoripi numeric(10,2),
                                          valoroutrasdespesas numeric(10,2),
                                          valoroutrasdespesasadicional numeric(10,2),
                                          valorpis numeric(10,2),
                                          valorseguro numeric(10,2),
                                          valortotal numeric(10,2),
                                          valortotalnf numeric(14,2),
                                          xmlimportado text,
                                          dataalteracao date,
                                          datacadastro date,
                                          usuarioalteracao_id bigint,
                                          usuariocadastro_id bigint,
                                          cliente_id bigint,
                                          empresa_id bigint,
                                          fornecedor_id bigint,
                                          natureza_id bigint,
                                          usuarioedicao_id bigint
);

CREATE TABLE public.ordemservico (
                                     id serial,
                                     contato character varying(255),
                                     cpf character varying(255),
                                     dataconclusao timestamp without time zone,
                                     descricaoprazoentrega character varying(255),
                                     impostos boolean,
                                     nome character varying(255),
                                     numeroordem bigint,
                                     observacao character varying(1500),
                                     prazoconclusao date,
                                     servico text,
                                     status character varying(255),
                                     telefone character varying(255),
                                     valorfrete numeric(14,2),
                                     valorprodutos numeric(14,2),
                                     valorservico numeric(14,2),
                                     valortotal numeric(14,2),
                                     dataalteracao date,
                                     datacadastro date,
                                     usuarioalteracao_id bigint,
                                     usuariocadastro_id bigint,
                                     cliente_id bigint,
                                     empresa_id bigint,
                                     natureza_id bigint,
                                     responsavel_id bigint,
                                     valordesconto numeric(14,2),
                                     numerodocumento character varying(255),
                                     valorservicoadicional numeric(14,2),
                                     orcamento_id bigint,
                                     historiconegociacao character varying(255),
                                     dataemissao timestamp without time zone,
                                     imprimirobservacao boolean,
                                     imprimirproblemaconstatadocliente boolean,
                                     imprimirproblemaconstatadotecnico boolean,
                                     imprimirservicoexecutado boolean,
                                     problemaconstatado text,
                                     problemainformado text,
                                     servicoexecutado text,
                                     equipamento_id bigint,
                                     situacao_id bigint,
                                     imprimirnegociacao boolean,
                                     tabelapreco_id bigint,
                                     valoracrescimo numeric(14,2),
                                     vendedor_id bigint,
                                     imprimircamposbrancos boolean,
                                     naoimprimirvalores boolean,
                                     enderecocliente_id bigint,
                                     tipo_id bigint
);

CREATE TABLE public.pais (
                             id serial,
                             nome character varying(255)
);

CREATE TABLE public.papel (
                              id serial,
                              ativo boolean,
                              descricao character varying(100) NOT NULL,
                              permissao_ajuda_atualizar_sistema boolean DEFAULT true,
                              permissao_configuracao_alterar_senha boolean DEFAULT true,
                              ajuda_enviar_log boolean DEFAULT true,
                              ajuda_enviar_solicitacoes boolean DEFAULT true,
                              ajuda_visualizar_log boolean DEFAULT true,
                              auxiliar_servicos boolean DEFAULT true,
                              cadastro_maquina_cartao boolean DEFAULT true,
                              cancelar_cte boolean DEFAULT true,
                              conectar_caixa boolean DEFAULT true,
                              configuracao_barra_ferramentas boolean DEFAULT true,
                              configuracao_parametros_empresa boolean DEFAULT true,
                              configuracao_parametros_cadastro boolean DEFAULT true,
                              configuracao_parametros_forma_pagamento boolean DEFAULT true,
                              configuracao_parametros_impressao boolean DEFAULT true,
                              configuracao_parametros_ncm boolean DEFAULT true,
                              configuracao_parametros_ordem_servico boolean DEFAULT true,
                              configuracao_parametros_produto boolean DEFAULT true,
                              consultar_notas_compras_lancadas boolean DEFAULT true,
                              permissao_conversor_estoque boolean DEFAULT true,
                              permissao_editar_produto boolean DEFAULT true,
                              emitir_cte boolean DEFAULT true,
                              emitir_cupom_fiscal boolean DEFAULT true,
                              emitir_mdfe boolean DEFAULT true,
                              emitir_nfse boolean DEFAULT true,
                              encerramento_manual_mdfe boolean DEFAULT true,
                              estoque_produtos boolean DEFAULT true,
                              permissao_exportar_arquivo_balanca boolean DEFAULT true,
                              exportacao_informacoes_nutricionais_balanca boolean DEFAULT true,
                              permissao_exportar_receituario boolean DEFAULT true,
                              gerenciar_auxiliar_servicos boolean DEFAULT true,
                              gerenciar_cte boolean DEFAULT true,
                              gerenciar_cupons_fiscais boolean DEFAULT true,
                              gerenciar_mdfe boolean DEFAULT true,
                              gerenciar_nfse boolean DEFAULT true,
                              gerenciar_orcamento boolean DEFAULT true,
                              gerenciar_ordem_servico boolean DEFAULT true,
                              gerenciar_pedidos boolean DEFAULT true,
                              importacao_notas_compra boolean DEFAULT true,
                              permissao_importar_csv boolean DEFAULT true,
                              importar_parametros_ncm boolean DEFAULT true,
                              importar_tabela_cest boolean DEFAULT true,
                              importar_tabela_ibpt boolean DEFAULT true,
                              inutilizar_cte boolean DEFAULT true,
                              permissao_lancar_produto_avulso boolean DEFAULT true,
                              permissao_lancar_campos_adicionais boolean DEFAULT true,
                              permissao_lancar_certificado boolean DEFAULT true,
                              permissao_lancar_empresa boolean DEFAULT true,
                              lancar_especies_volume boolean DEFAULT true,
                              lancar_motorista boolean DEFAULT true,
                              lancar_notas_compras boolean DEFAULT true,
                              permissao_lancar_orcamento boolean DEFAULT true,
                              permissao_lancar_ordem_servico boolean DEFAULT true,
                              permissao_lancar_papel boolean DEFAULT true,
                              permissao_lancar_pedido boolean DEFAULT true,
                              lancar_produtos_disponiveis boolean DEFAULT true,
                              lancar_terceiro boolean DEFAULT true,
                              permissao_lancar_transportadores boolean DEFAULT true,
                              permissao_lancar_usuario boolean DEFAULT true,
                              lancar_veiculo_cte boolean DEFAULT true,
                              parametros_cupom_fiscal_sat boolean DEFAULT true,
                              permissao_agenda_compromisso boolean DEFAULT true,
                              permissao_auditoria boolean DEFAULT true,
                              permissao_backup_banco boolean DEFAULT true,
                              permissao_balanca boolean DEFAULT true,
                              permissao_serie boolean DEFAULT true,
                              permissao_cliente_fornecedor boolean DEFAULT true,
                              permissao_configuracao_editar_pref_sistema boolean DEFAULT true,
                              permissao_configuracao_liberacao_modulos boolean DEFAULT true,
                              permissao_consulta_disponibilidade boolean DEFAULT true,
                              permissao_consulta_disponibilidade_cte boolean DEFAULT true,
                              permissao_consulta_disponibilidade_nfc boolean DEFAULT true,
                              permissao_controle_auditoria boolean DEFAULT true,
                              permissao_credito_cliente boolean DEFAULT true,
                              permissao_departamento boolean DEFAULT true,
                              permissao_devolucao_troca boolean DEFAULT true,
                              permissao_ecf_consignacao boolean DEFAULT true,
                              permissao_emitir_etiquetas boolean DEFAULT true,
                              permissao_equipamento boolean DEFAULT true,
                              permissao_ferramentas_backup_nf boolean DEFAULT true,
                              permissao_financeiro_abrir_fechar_caixa boolean DEFAULT true,
                              permissao_financeiro_conferencia_movimentacoes boolean DEFAULT true,
                              permissao_financeiro_contr_caixa_sangria boolean DEFAULT true,
                              permissao_financeiro_contr_caixa_suprimento boolean DEFAULT true,
                              permissao_financeiro_gerenciar_duplicatas boolean DEFAULT true,
                              permissao_financeiro_movimentacoes boolean DEFAULT true,
                              permissao_financeiro_transferencia_entre_caixas boolean DEFAULT true,
                              permissao_funcionarios boolean DEFAULT true,
                              permissao_historico_backup_banco boolean DEFAULT true,
                              permissao_informacao_nutricional boolean DEFAULT true,
                              permissao_liquidacao boolean DEFAULT true,
                              permissao_marca boolean DEFAULT true,
                              permissao_nota_cancelar boolean DEFAULT true,
                              permissao_nota_emitir boolean DEFAULT true,
                              permissao_nota_gerenciar boolean DEFAULT true,
                              permissao_nota_inutilizar boolean DEFAULT true,
                              permissao_nfc_cancelar boolean DEFAULT true,
                              permissao_nfc_emitir boolean DEFAULT true,
                              permissao_nfc_gerenciar boolean DEFAULT true,
                              permissao_nfc_inutilizar boolean DEFAULT true,
                              permissao_parametros_impostos_nfse boolean DEFAULT true,
                              permissao_promocao boolean DEFAULT true,
                              permissao_reativar_produtos boolean DEFAULT true,
                              permissao_relatorios_cfe_apuracao_icms boolean DEFAULT true,
                              permissao_relatorios_cfe_apuracao_pis boolean DEFAULT true,
                              permissao_relatorios_cfe_emitidos boolean DEFAULT true,
                              permissao_relatorios_clientes boolean DEFAULT true,
                              permissao_relatorios_conferencia_caixa boolean DEFAULT true,
                              permissao_relatorios_cte_cst boolean DEFAULT true,
                              permissao_relatorios_cte_emitidos boolean DEFAULT true,
                              permissao_relatorios_cte_motorista boolean DEFAULT true,
                              permissao_relatorios_cte_tomador boolean DEFAULT true,
                              permissao_relatorios_cte_usuario boolean DEFAULT true,
                              permissao_relatorios_detalhamento_nota_fiscal boolean DEFAULT true,
                              permissao_relatorios_equipamento boolean DEFAULT true,
                              permissao_relatorios_espelho_livro_caixa boolean DEFAULT true,
                              permissao_relatorios_estoque_movimentacao_detalhado boolean DEFAULT true,
                              permissao_relatorios_estoque_movimentacao_manual boolean DEFAULT true,
                              permissao_relatorios_estoque_produto_ativo boolean DEFAULT true,
                              permissao_relatorios_estoque_produto_inativo boolean DEFAULT true,
                              permissao_relatorios_estoque_produto_nao_parametrizado boolean DEFAULT true,
                              permissao_relatorios_estoque_produto_negativo boolean DEFAULT true,
                              permissao_relatorios_ficha_cliente boolean DEFAULT true,
                              permissao_relatorios_historico_preco_compra boolean DEFAULT true,
                              permissao_relatorios_manifesto_eletronico boolean DEFAULT true,
                              permissao_relatorios_moviementacao_caixa boolean DEFAULT true,
                              permissao_relatorios_nf_apuracao_icms boolean DEFAULT true,
                              permissao_relatorios_nf_apuracao_pis boolean DEFAULT true,
                              permissao_relatorios_nfc_apuracao_icms boolean DEFAULT true,
                              permissao_relatorios_nfc_apuracao_pis boolean DEFAULT true,
                              permissao_relatorios_nfc_cliente_analitico boolean DEFAULT true,
                              permissao_relatorios_nfc_cliente_sintetico boolean DEFAULT true,
                              permissao_relatorios_nfc_emitidas boolean DEFAULT true,
                              permissao_relatorios_nfc_tributacao_monofasica boolean DEFAULT true,
                              permissao_relatorios_nfc_vendedor_analitico boolean DEFAULT true,
                              permissao_relatorios_nota_cliente_analitico boolean DEFAULT true,
                              permissao_relatorios_nota_cliente_sintetico boolean DEFAULT true,
                              permissao_relatorios_nota_duplicatas_paga boolean DEFAULT true,
                              permissao_relatorios_nota_duplicatas_vencidas boolean DEFAULT true,
                              permissao_relatorios_notafiscalservico_eletronico boolean DEFAULT true,
                              permissao_relatorios_nota_usuario_analitico boolean DEFAULT true,
                              permissao_relatorios_nota_vendedor_analitico boolean DEFAULT true,
                              permissao_relatorios_notas_compra boolean DEFAULT true,
                              permissao_relatorios_ordens_servicos_detalhado boolean DEFAULT true,
                              permissao_relatorios_ordens_servicos_emitidas boolean DEFAULT true,
                              permissao_relatorios_parametro_empresa boolean DEFAULT true,
                              permissao_relatorios_produtos_abaixo_minimo boolean DEFAULT true,
                              permissao_relatorios_produtos_custo_lucro boolean DEFAULT true,
                              permissao_relatorios_produtos_promocao boolean DEFAULT true,
                              permissao_relatorios_produtos_vendidos boolean DEFAULT true,
                              permissao_relatorios_rank_clientes boolean DEFAULT true,
                              permissao_relatorios_ranking_produtos_vendidos boolean DEFAULT true,
                              permissao_relatorios_resumo_caixa boolean DEFAULT true,
                              permissao_relatorios_resumo_de_caixa boolean DEFAULT true,
                              permissao_relatorios_sangria_caixa boolean DEFAULT true,
                              permissao_relatorios_servico_resposavel boolean DEFAULT true,
                              permissao_relatorios_tabela_preco boolean DEFAULT true,
                              permissao_relatorios_usuarios_ativas boolean DEFAULT true,
                              permissao_relatorios_vendas_forma_pagamento boolean DEFAULT true,
                              permissao_relatorios_vendas_departamento boolean DEFAULT true,
                              permissao_relatorio_venda_marca boolean DEFAULT true,
                              permissao_relatorios_vendas_periodo_analitico boolean DEFAULT true,
                              permissao_relatorios_vendas_por_cliente boolean DEFAULT true,
                              permissao_relatorio_venda_vendedor boolean DEFAULT true,
                              permissao_sat_fiscal boolean DEFAULT true,
                              permissao_seguradora boolean DEFAULT true,
                              permissao_servico boolean DEFAULT true,
                              permissao_situacoes boolean DEFAULT true,
                              permissao_subdepartamento boolean DEFAULT true,
                              permissao_substituicao_ncm boolean DEFAULT true,
                              permissao_unidade_medida boolean DEFAULT true,
                              permissao_vale_presente_compras boolean DEFAULT true,
                              permissao_vender_abrir_auxiliar_venda boolean DEFAULT true,
                              permissao_vender_consulta_venda_auxiliar boolean DEFAULT true,
                              permissao_visualisar_dependente boolean DEFAULT true,
                              permitissao_manifestacao_destinatario boolean DEFAULT true,
                              reativar_balancas boolean DEFAULT true,
                              permissao_reativar_campos_adicionais boolean DEFAULT true,
                              permissao_reativar_cliente_fornecedor boolean DEFAULT true,
                              permissao_reativar_departamento boolean DEFAULT true,
                              permissao_reativar_empresa boolean DEFAULT true,
                              permissao_reativar_funcionarios boolean DEFAULT true,
                              permissao_reativar_informacao_nutricional boolean DEFAULT true,
                              reativar_liquidacoes boolean DEFAULT true,
                              reativar_maquina_cartao boolean DEFAULT true,
                              permissao_reativar_marca boolean DEFAULT true,
                              permissao_reativar_papel boolean DEFAULT true,
                              reativar_promocoes boolean DEFAULT true,
                              reativar_sat_fiscal boolean DEFAULT true,
                              permissao_reativar_seguradora boolean DEFAULT true,
                              reativar_servicos boolean DEFAULT true,
                              permissao_reativar_subdepartamento boolean DEFAULT true,
                              permissao_reativar_transportadores boolean DEFAULT true,
                              permissao_reativar_unidade_medida boolean DEFAULT true,
                              permissao_reativar_usuario boolean DEFAULT true,
                              registro_contatos boolean DEFAULT true,
                              relatorio_aniversariantes boolean DEFAULT true,
                              relatorio_auditoria_produto boolean DEFAULT true,
                              relatorio_auxiliar_servico boolean DEFAULT true,
                              relatorio_produtos_departamento boolean DEFAULT true,
                              permissao_relatorio_inutilizacoes boolean DEFAULT true,
                              permissao_relatorio_notaperiodo boolean DEFAULT true,
                              permissao_relatorio_orcamento boolean DEFAULT true,
                              permissao_relatorio_pedido boolean DEFAULT true,
                              tipo_contato boolean DEFAULT true,
                              permissao_cadastro_facil_produto boolean DEFAULT true,
                              configuracoes_enviar_log boolean DEFAULT true,
                              configuracoes_parametros_integracao_contabilidade boolean DEFAULT true,
                              consultar_sat boolean DEFAULT true,
                              extrair_log_sat boolean DEFAULT true,
                              permissao_lancar_contador boolean DEFAULT false,
                              permissao_lancar_tipo_ordem_servico boolean DEFAULT true,
                              permissao_adicional_produto boolean DEFAULT true,
                              permissao_alterar_descricao_ponto_venda boolean DEFAULT true,
                              permissao_alterar_valor_fechamento_caixa boolean DEFAULT true,
                              permissao_alterar_valor_unitario_ponto_venda boolean DEFAULT true,
                              permissao_configuracao_periodo_teste boolean DEFAULT true,
                              permissao_conversor_auxiliar_venda boolean DEFAULT true,
                              permissao_cotacao_moeda boolean DEFAULT true,
                              permissao_delivery boolean DEFAULT false,
                              permissao_documento_fiscal boolean DEFAULT false,
                              permissao_emissao_nota_contabil boolean DEFAULT true,
                              permissao_emitir_ordem_coleta boolean DEFAULT true,
                              permissao_entregador boolean DEFAULT true,
                              "permissão_estoque_com_custo" boolean DEFAULT false,
                              permissao_exportar_sped boolean DEFAULT false,
                              permissao_gerenciar_delivery boolean DEFAULT false,
                              permissao_grafico_comparativo_vendas boolean DEFAULT true,
                              permissao_grupo_impressao boolean DEFAULT true,
                              permissao_integracao_pro_vendas boolean DEFAULT false,
                              permissao_kit_produto boolean DEFAULT true,
                              permissao_lancar_pedido_compra boolean DEFAULT true,
                              permissao_lancar_tara boolean DEFAULT true,
                              permissao_ocultar_totalizadores_delivery boolean DEFAULT false,
                              permissao_ocultar_valores_pedidos boolean DEFAULT false,
                              permissao_oferta_produtos boolean DEFAULT true,
                              permissao_ordem_coleta boolean DEFAULT true,
                              permissao_painel_informativo boolean DEFAULT true,
                              permissao_parametro_backup boolean DEFAULT true,
                              permissao_parametro_fechamento_caixa boolean DEFAULT true,
                              permissao_parametro_orcamento boolean DEFAULT true,
                              permissao_reajuste_total_estoque boolean DEFAULT true,
                              permissao_reativar_kit_produtos boolean DEFAULT true,
                              permissao_reativar_tara boolean DEFAULT true,
                              permissao_relatorio_clientes_inertes boolean DEFAULT true,
                              permissao_relatorios_compromissos boolean DEFAULT true,
                              permissao_relatorio_consignacao boolean DEFAULT true,
                              permissao_relatorio_entregas boolean DEFAULT false,
                              permissao_relatorio_ncm_produto boolean DEFAULT true,
                              permissao_relatorio_oferta_produtos boolean DEFAULT false,
                              permissao_relatorio_ordem_de_entrega boolean DEFAULT true,
                              permissao_relatorio_pedido_detalhado boolean DEFAULT true,
                              permissao_relatorios_produtos_inertes boolean DEFAULT true,
                              permissao_relatorios_produtos_oferta boolean DEFAULT true,
                              permissao_relatorios_produtos_reservados boolean DEFAULT true,
                              permissao_relatorios_produtos_validade boolean DEFAULT true,
                              permissao_relatorio_ranking_servico boolean DEFAULT true,
                              permissao_relatorio_recebimentos_por_forma_pagamento boolean DEFAULT true,
                              permissao_relatorios_registro_inventario boolean DEFAULT true,
                              permissao_relatorio_resumo_cartoes boolean DEFAULT true,
                              permissao_relatorio_resumo_entradas_saidas boolean DEFAULT true,
                              permissao_relatorio_resumo_pix boolean DEFAULT true,
                              permissao_relatorio_resumo_vales boolean DEFAULT true,
                              permissao_relatorios_servico_periodo boolean DEFAULT true,
                              permissao_relatorio_servico_resumo_servico boolean DEFAULT true,
                              permissao_relatorios_tabela_de_preco boolean DEFAULT true,
                              permissao_relatorio_taxa_entrega boolean DEFAULT false,
                              permissao_relatorio_taxa_entrega_vendas boolean DEFAULT true,
                              permissao_relatorio_taxa_servico boolean DEFAULT true,
                              permissao_relatorio_venda_comissao_vendedor boolean DEFAULT true,
                              permissao_relatorio_vendas_fornecedor boolean DEFAULT false,
                              permissao_tabela_preco boolean DEFAULT true,
                              permissao_taxa_entrega boolean DEFAULT true,
                              permissao_visualizar_clientes boolean DEFAULT true,
                              permissao_visualizar_clientes_fornecedores boolean DEFAULT true,
                              permissao_visualizar_fornecedores boolean DEFAULT true,
                              permissao_reativar_adicional_produto boolean DEFAULT true,
                              reativar_cotacao_moeda boolean DEFAULT true,
                              permissao_reativar_entregador boolean DEFAULT true,
                              permissao_reativar_equipamento boolean DEFAULT true,
                              permissao_reativar_especies_volume boolean DEFAULT true,
                              reativar_grupo_impressao boolean DEFAULT true,
                              permissao_reativar_motorista boolean DEFAULT true,
                              permissao_reativar_oferta_produtos boolean DEFAULT true,
                              reativar_tabelas_preco boolean DEFAULT true,
                              permissao_reativar_taxa_entrega boolean DEFAULT true,
                              permissao_reativar_tipo_ordem_servico boolean DEFAULT true,
                              permissao_reativar_veiculo_cte boolean DEFAULT true,
                              relatorio_notas_fiscais_destinadas boolean DEFAULT true,
                              sincronizar_parametros_ncm boolean DEFAULT true
);

CREATE TABLE public.parametrobackup (
                                        id serial,
                                        backup_antes_atualizacao boolean,
                                        bkp_apenas_xml boolean,
                                        bkp_email_contabilidade boolean,
                                        bkp_documentos_fiscais_automatico_mes boolean,
                                        enviar_nfe_compra boolean,
                                        guardar_bkp_ftp boolean,
                                        limitar_quantidade_total_diretorio boolean,
                                        limitar_tamanho_diretorio boolean,
                                        limite_em_giga boolean,
                                        limite_em_mega boolean,
                                        quantidade_total_diretorio integer,
                                        tamanho_maximo_diretorio integer,
                                        empresa_id bigint,
                                        emailcontabilidade character varying(255),
                                        hora_backup_documentos_fiscais time without time zone DEFAULT '00:00:00'::time without time zone,
                                        preferencia_id bigint,
                                        encaminhar_xml_completo boolean DEFAULT false
);

CREATE TABLE public.parametrobeneficiofiscal (
                                                 id serial,
                                                 codigo character varying(255) NOT NULL,
                                                 csticms00 boolean,
                                                 csticms10 boolean,
                                                 csticms20 boolean,
                                                 csticms30 boolean,
                                                 csticms40 boolean,
                                                 csticms41 boolean,
                                                 csticms50 boolean,
                                                 csticms51 boolean,
                                                 csticms60 boolean,
                                                 csticms70 boolean,
                                                 csticms90 boolean,
                                                 datavigencia date,
                                                 datavigenciafinal date,
                                                 descricao text,
                                                 versao character varying(255),
                                                 dataalteracao date,
                                                 datacadastro date,
                                                 usuarioalteracao_id bigint,
                                                 usuariocadastro_id bigint,
                                                 estado_id bigint
);

CREATE TABLE public.parametrocadastro (
                                          id serial,
                                          todasempresasadicionalproduto boolean,
                                          todasempresascliente boolean,
                                          todasempresasdepartamento boolean,
                                          todasempresasentregadores boolean,
                                          todasempresasfuncionario boolean,
                                          todasempresasmarca boolean,
                                          todasempresasmotorista boolean,
                                          todasempresasservico boolean,
                                          todasempresassubdepartamento boolean,
                                          todasempresasterceiro boolean,
                                          todasempresasveiculo boolean,
                                          empresa_id bigint
);

CREATE TABLE public.parametrofechamentocaixa (
                                                 id serial,
                                                 gerarrelatoriodetalhamentovendas boolean DEFAULT false,
                                                 gerarrelatoriomovimentacaocaixa boolean DEFAULT true,
                                                 gerarrelatorioprodutosvendidos boolean DEFAULT false,
                                                 gerarrelatorioresumovales boolean DEFAULT false,
                                                 gerarrelatoriosuprimentosangria boolean DEFAULT false,
                                                 gerarrelatoriosresumos boolean DEFAULT true,
                                                 margem_left_resumo_cartoes integer DEFAULT 0,
                                                 margemleftresumovales integer DEFAULT 0,
                                                 modelorelatoriomovimentacaocaixa character varying DEFAULT 'R'::character varying,
                                                 modelorelatorioresumocartoes character varying DEFAULT 'R'::character varying,
                                                 modelorelatorioresumovendas character varying DEFAULT 'IMPRESSAO_80MM'::character varying,
                                                 modelorelatorioresumovales character varying DEFAULT 'IMPRESSAO_80MM'::character varying,
                                                 tipomovimentacoesrelatoriosangriasuprimento character varying DEFAULT 'SUPRIMENTO_SANGRIA'::character varying,
                                                 empresa_id bigint NOT NULL
);

CREATE TABLE public.parametroformapagamento (
                                                id serial,
                                                desconto numeric(12,2),
                                                forma character varying(255),
                                                juros numeric(12,2),
                                                parcelas numeric(12,0),
                                                tipo character varying(255),
                                                empresa_id bigint NOT NULL
);

CREATE TABLE public.parametroicms (
                                      id serial,
                                      aliquotaicms numeric(14,2),
                                      csticmsconsumidorfinal character varying(255),
                                      csticmsvendaprodestabelecimento character varying(255),
                                      csticmsvendaproducaopr character varying(255),
                                      csticmsvendarevendapr character varying(255),
                                      datavigencia timestamp without time zone,
                                      observacao text,
                                      dataalteracao date,
                                      datacadastro date,
                                      usuarioalteracao_id bigint,
                                      estado_id bigint NOT NULL,
                                      usuariocadastro_id bigint,
                                      parametroncm_id bigint,
                                      datavigenciafinal timestamp without time zone,
                                      versao character varying(255)
);

CREATE TABLE public.parametroimpressao (
                                           id serial,
                                           acionar_guilhotina_automaticamente boolean DEFAULT true,
                                           gerar_relatorio_detalhamento_vendas boolean DEFAULT false,
                                           gerar_relatorio_pedido_matricial boolean DEFAULT false,
                                           imprimir_automaticamente_auxiliar_venda boolean DEFAULT false,
                                           imprimir_automaticamente_credito_cliente boolean DEFAULT false,
                                           imprimir_automaticamente_devolucao_troca boolean DEFAULT false,
                                           imprimir_automaticamente_extrato_cfe boolean DEFAULT false,
                                           imprimir_automaticamente_nfce boolean DEFAULT false,
                                           imprimir_automaticamente_nfe boolean DEFAULT false,
                                           imprimir_automaticamente_orcamento boolean DEFAULT false,
                                           imprimir_automaticamente_ordem_servico boolean DEFAULT false,
                                           imprimir_automaticamente_pedido boolean DEFAULT false,
                                           imprimir_automaticamente_promissoria boolean DEFAULT false,
                                           imprimir_automaticamente_recibo boolean DEFAULT false,
                                           imprimir_automaticamente_relatorio_gerencial boolean DEFAULT false,
                                           imprimir_automaticamente_relatorio_movimentacao_caixa boolean DEFAULT false,
                                           imprimir_automaticamente_relatorio_vale boolean DEFAULT false,
                                           imprimir_automaticamente_resumos boolean DEFAULT false,
                                           imprimir_automaticamente_termo_condicional boolean DEFAULT false,
                                           imprimir_canhoto_pedido boolean DEFAULT false,
                                           imprimir_codigo_barras_ordem_servico boolean DEFAULT false,
                                           margem_left_auxiliar_servico integer DEFAULT 0,
                                           margem_left_auxiliar_venda integer DEFAULT 0,
                                           margem_left_credito_cliente integer DEFAULT 0,
                                           margem_left_devolucao_troca integer DEFAULT 0,
                                           margem_left_extrato_cfe integer DEFAULT 0,
                                           margem_left_extrato_contas integer DEFAULT 0,
                                           margem_left_nfce integer DEFAULT 0,
                                           margem_left_orcamento integer DEFAULT 0,
                                           margem_left_ordem_servico integer DEFAULT 0,
                                           margem_left_pedido integer DEFAULT 0,
                                           margem_left_promissoria integer DEFAULT 0,
                                           margem_left_recibo integer DEFAULT 0,
                                           margem_left_relatorio_movimentacao_caixa integer DEFAULT 0,
                                           margem_left_relatorio_resumo_caixa integer DEFAULT 0,
                                           margem_left_termo_condicional integer DEFAULT 0,
                                           margem_left_vale_compra integer DEFAULT 0,
                                           mensagem_termo_pedido text DEFAULT 'autorizo a execução do(s) serviço(s) nas condições acima discriminadas.'::text,
                                           tipo_impressora_auxiliar_servico text DEFAULT 'IMPRESSAO_A4'::text,
                                           tipo_impressora_auxiliar_venda text DEFAULT 'IMPRESSAO_80MM'::text,
                                           tipo_impressora_credito_cliente text DEFAULT 'IMPRESSAO_80MM'::text,
                                           tipo_impressora_devolucao_troca text DEFAULT 'IMPRESSAO_A4'::text,
                                           tipo_impressora_extrato_cfe text DEFAULT 'IMPRESSAO_80MM'::text,
                                           tipo_impressora_nfce text DEFAULT 'IMPRESSAO_80MM'::text,
                                           tipo_impressora_orcamento text DEFAULT 'IMPRESSAO_A4'::text,
                                           tipo_impressora_ordem_servico text DEFAULT 'IMPRESSAO_A4'::text,
                                           tipo_impressora_pedido text DEFAULT 'IMPRESSAO_A4'::text,
                                           tipo_impressora_promissoria text DEFAULT 'IMPRESSAO_80MM'::text,
                                           tipo_impressora_recibo text DEFAULT 'IMPRESSAO_A4'::text,
                                           tipo_impressora_relatorio_movimentacao_caixa text DEFAULT 'IMPRESSAO_A4'::text,
                                           tipo_impressora_termo_condicional text DEFAULT 'IMPRESSAO_A4'::text,
                                           tipo_impressora_vale_compra text DEFAULT 'IMPRESSAO_A4'::text,
                                           dataalteracao date,
                                           datacadastro date,
                                           usuarioalteracao_id bigint,
                                           usuariocadastro_id bigint,
                                           empresa_id bigint,
                                           grupoimpressaoauxiliarvenda_id bigint,
                                           grupoimpressaocreditocliente_id bigint,
                                           grupoimpressaodanfe_id bigint,
                                           grupoimpressaodanfenfce_id bigint,
                                           grupoimpressaodevolucaotroca_id bigint,
                                           grupoimpressaoextratocfe_id bigint,
                                           grupoimpressaoorcamento_id bigint,
                                           grupoimpressaoordemservico_id bigint,
                                           grupoimpressaopedido_id bigint,
                                           grupoimpressaorelatoriogerencialauxvendas_id bigint,
                                           grupoimpressaorelatoriomovimentacaocaixa_id bigint,
                                           grupoimpressaorelatorioresumovendasandcaixa_id bigint,
                                           grupoimpressaotermocondicional_id bigint,
                                           grupoimpressaovalecompras_id bigint,
                                           grupoimpressaopromissoria_id bigint,
                                           grupoimpressaorecibo_id bigint,
                                           agruparcomprovante boolean DEFAULT false,
                                           agruparprodutosvendidos boolean DEFAULT false,
                                           exportar_observacao_aux_servico boolean DEFAULT true,
                                           gerarcomprovanteauxiliarservico boolean DEFAULT false,
                                           gerarcomprovantepedidoaosalvardelivery boolean DEFAULT false,
                                           gerar_relatorio_pedido_economico boolean DEFAULT false,
                                           imprimir_automaticamente_checklist_ordem_servico boolean DEFAULT false,
                                           imprimirautomaticamentecomprovantepedidodelivery boolean DEFAULT false,
                                           imprimir_automaticamente_comprovante_sangria boolean DEFAULT false,
                                           imprimirautomaticamentedelivery boolean DEFAULT false,
                                           imprimirautomaticamenterelatorioprodutosvendidos boolean DEFAULT false,
                                           imprimirautomaticamenterelatoriosuprimentosangria boolean DEFAULT false,
                                           imprimircomprovantecozinhaunitario boolean,
                                           imprimiretiquetaenderecamento boolean DEFAULT false,
                                           imprimiretiquetaenderecamentopedido boolean DEFAULT false,
                                           imprimir_etiqueta_ordem_servico boolean DEFAULT false,
                                           imprimiretiquetaordemservico3_8x2_1 boolean DEFAULT false,
                                           imprimir_ordemservico_economico boolean DEFAULT false,
                                           imprimirvalegeradodevolucao boolean DEFAULT false,
                                           margemleftcomprovantepedidodelivery integer DEFAULT 0,
                                           margem_left_comprovante_sangria integer DEFAULT 0,
                                           margemleftdelivery integer DEFAULT 0,
                                           margemleftprodutosvendidos integer DEFAULT 0,
                                           modeloorcamento text DEFAULT 'PADRAO'::text,
                                           modeloordemservico text DEFAULT 'PADRAO'::text,
                                           perguntar_se_deseja_imprimir boolean DEFAULT false,
                                           print_number_auxiliar_servico integer DEFAULT 1,
                                           print_number_comprovante_adiantamento integer DEFAULT 1,
                                           print_number_comprovante_auxiliar integer DEFAULT 1,
                                           print_number_comprovante_pedido integer DEFAULT 1,
                                           print_number_comprovante_conta integer DEFAULT 1,
                                           print_number_credito_cliente integer DEFAULT 1,
                                           print_number_danfe integer DEFAULT 1,
                                           print_number_danfe_nfc integer DEFAULT 1,
                                           print_number_delivery integer DEFAULT 1,
                                           print_number_devolucao_troca integer DEFAULT 1,
                                           print_number_extrato_cfe integer DEFAULT 1,
                                           print_number_orcamento integer DEFAULT 1,
                                           print_number_ordeme_servico integer DEFAULT 1,
                                           print_number_pedido integer DEFAULT 1,
                                           print_number_auxservico integer DEFAULT 1,
                                           print_number_realtorio_produtos_vendidos integer DEFAULT 1,
                                           print_number_relatorio_detalhamento_vendas integer DEFAULT 1,
                                           print_number_relatorio_movimentacao_caixa integer DEFAULT 1,
                                           print_number_relatorio_resumo_vendas integer DEFAULT 1,
                                           print_number_relatorio_suprimento integer DEFAULT 1,
                                           print_number_termo_condicional integer DEFAULT 1,
                                           print_number_vale_compra integer DEFAULT 1,
                                           quantidade_itens_foco_dialog_impressao integer,
                                           solicitartiporelatorioorcamento boolean DEFAULT false,
                                           solicitartiporelatorioordemservico boolean DEFAULT false,
                                           tipoimpressaoetiquetaenderecamento text DEFAULT 'ETIQUETA_ENDERECAMENTO_10x5'::text,
                                           tipoimpressaoetiquetaenderecamentopedido text DEFAULT 'ETIQUETA_ENDERECAMENTO_10x5'::text,
                                           tipoimpressoracomprovantepedidodelivery text DEFAULT 'IMPRESSAO_80MM'::text,
                                           tipoimpressoradelivery text DEFAULT 'IMPRESSAO_80MM'::text,
                                           tipo_impressora_produtos_vendidos text DEFAULT 'IMPRESSAO_80MM'::text,
                                           tipo_impressora_relatorio_sangrias_suprimentos_caixa text DEFAULT 'IMPRESSAO_80MM'::text,
                                           visualizacaoprodutosdelivery character varying DEFAULT 'INDIVIDUAL'::character varying,
                                           visualizar_comprovante_ordem_servico boolean DEFAULT true,
                                           grupoimpressaoauxservico_id bigint,
                                           grupoimpressaocomprovantesangria_id bigint,
                                           grupoimpressaorelatoriodelivery_id bigint,
                                           grupoimpressaorelatorioprodutosvendidos_id bigint
);

CREATE TABLE public.parametrointegracaocontabilidade (
                                                         id serial,
                                                         sieg_ativo boolean,
                                                         sieg_emailcontabilidade character varying(255),
                                                         sieg_envioautomaticoxml boolean,
                                                         sieg_urlapi character varying(255),
                                                         dataalteracao date,
                                                         datacadastro date,
                                                         usuarioalteracao_id bigint,
                                                         usuariocadastro_id bigint,
                                                         empresa_id bigint NOT NULL
);

CREATE TABLE public.parametroipi (
                                     id serial,
                                     aliquotaipiadvalorem numeric(14,4),
                                     cstipientrada character varying(255),
                                     cstipisaida character varying(255),
                                     datavigencia timestamp without time zone,
                                     excecao text,
                                     formaipi integer,
                                     observacao text,
                                     quandoutilizar text,
                                     valoripiunidade numeric(14,4),
                                     dataalteracao date,
                                     datacadastro date,
                                     usuarioalteracao_id bigint,
                                     usuariocadastro_id bigint,
                                     parametroncm_id bigint,
                                     datavigenciafinal timestamp without time zone,
                                     versao character varying(255)
);

CREATE TABLE public.parametroncm (
                                     id serial,
                                     datavigencia timestamp without time zone,
                                     observacao text,
                                     dataalteracao date,
                                     datacadastro date,
                                     usuarioalteracao_id bigint,
                                     usuariocadastro_id bigint,
                                     datavigenciafinal timestamp without time zone,
                                     excecaoncm character varying(2),
                                     numeroncm character varying(8),
                                     versao character varying(255)
);


CREATE TABLE public.parametronotificacao (
                                             id serial,
                                             layoutnotficacao text DEFAULT 'PRETO'::text,
                                             temponotificacao integer DEFAULT 15,
                                             transparencianotificacao boolean DEFAULT true,
                                             empresa_id bigint,
                                             usuario_id bigint,
                                             utilizartodasnotificacoes boolean DEFAULT false
);

CREATE TABLE public.parametroorcamento (
                                           id serial,
                                           diasvencimentoorcamento integer DEFAULT 0,
                                           mostrarinformacaoproduto boolean DEFAULT false,
                                           mostrarmargemlucroorcamento boolean DEFAULT true,
                                           msg character varying(255),
                                           numinicialorcamento bigint,
                                           observacao character varying(1000),
                                           ocultarrodapecomprovante boolean DEFAULT false,
                                           utilizarorcamentodetalhado boolean DEFAULT false,
                                           empresa_id bigint,
                                           usuario_id bigint
);

CREATE TABLE public.parametroordemservico (
                                              id serial,
                                              diasuteisconclusao bigint,
                                              exibirprodutoservicochecklist boolean DEFAULT false,
                                              exportarobservacao boolean DEFAULT false,
                                              habilitarchecklist boolean DEFAULT false,
                                              imprimircamposbrancos boolean,
                                              imprimirobservacao boolean,
                                              imprimirproblemaconstatadocliente boolean,
                                              imprimirproblemaconstatadotecnico boolean,
                                              imprimirservicoexecutado boolean,
                                              informar_valor_pre_ordem boolean DEFAULT false,
                                              insercaounitariaitensservicos boolean DEFAULT true,
                                              mensagemtermoordemservico character varying(500),
                                              naoimprimirvalores boolean DEFAULT false,
                                              nomeequipamento character varying(255),
                                              numinicialordem bigint,
                                              observacaoordem character varying(2000),
                                              dataalteracao date,
                                              datacadastro date,
                                              usuarioalteracao_id bigint,
                                              usuariocadastro_id bigint,
                                              empresa_id bigint NOT NULL
);

CREATE TABLE public.parametroordemservico_checklist (
                                                        parametroordemservico_id bigint,
                                                        checklist character varying(255)
);

CREATE TABLE public.parametropiscofins (
                                           id serial,
                                           aliquotacofinsentradadiferenciada numeric(14,4),
                                           aliquotacofinsentradadiferenciadaindustria numeric(14,4),
                                           aliquotacofinsmonofasico numeric(14,4),
                                           aliquotapisentradadiferenciada numeric(14,4),
                                           aliquotapisentradadiferenciadaindustria numeric(14,4),
                                           aliquotapismonofasico numeric(14,4),
                                           cstpiscofinscomerciorevenda character varying(255),
                                           cstpiscofinsentradaproduto character varying(255),
                                           cstpiscofinsentradaprodutoindustria character varying(255),
                                           cstpiscofinsindustria character varying(255),
                                           datavigencia timestamp without time zone,
                                           observacao text,
                                           tributacaotabcstcomercio text,
                                           tributacaotabcstentrada text,
                                           tributacaotabcstentradaindustria text,
                                           tributacaotabcstindustria text,
                                           dataalteracao date,
                                           datacadastro date,
                                           usuarioalteracao_id bigint,
                                           usuariocadastro_id bigint,
                                           parametroncm_id bigint,
                                           tabelacstspedcomercio_id bigint,
                                           tabelacstspedentrada_id bigint,
                                           tabelacstspedentradaindustria_id bigint,
                                           tabelacstspedindustria_id bigint,
                                           datavigenciafinal timestamp without time zone,
                                           versao character varying(255)
);

CREATE TABLE public.parametroproduto (
                                         id serial,
                                         aliquotacofins numeric(4,2),
                                         aliquotaicms numeric(4,2),
                                         aliquotaipi numeric(4,2),
                                         aliquotapis numeric(4,2),
                                         cfop_id bigint,
                                         empresa_id bigint,
                                         produto_id bigint NOT NULL,
                                         tipoitem_id bigint NOT NULL,
                                         aliquotafcp numeric(4,2),
                                         aliquotamva numeric(7,4),
                                         ignorarcfop boolean DEFAULT false,
                                         modalidadebcst character varying(1),
                                         reducaobasecalculo numeric(5,2),
                                         csticms_id bigint,
                                         cstipi_id bigint,
                                         cstpiscofins_id bigint,
                                         estado_id bigint
);

CREATE TABLE public.parametrosempresa (
                                          id serial,
                                          contribuinteicms boolean,
                                          contribuinteipi boolean,
                                          contribuinteiss boolean,
                                          empresa_id bigint,
                                          regimetributario_id bigint,
                                          aliquotacofins numeric(4,2),
                                          aliquotacofinspisdiferenciada boolean DEFAULT false,
                                          aliquotaibpt numeric(4,2),
                                          aliquotaicms numeric(4,2),
                                          aliquotapis numeric(4,2),
                                          aliquotasimplesnacional numeric(4,2),
                                          exibircreditoicmsporitem boolean DEFAULT true,
                                          faturamentosuperior360mil boolean DEFAULT false,
                                          naoenviaripi boolean DEFAULT false,
                                          percentualcreditoicmssn numeric(4,2) DEFAULT 0.00,
                                          quantidadeconsultadiariaintegracaoprodutogtech integer DEFAULT 30,
                                          regimeespecialempresa character varying(255),
                                          tributacaogeral_id bigint
);

CREATE TABLE public.parametrosempresa_cnae (
                                               parametrosempresa_id bigint NOT NULL,
                                               cnaes_id bigint NOT NULL
);


CREATE TABLE public.parametrosimpostosnfse (
                                               id serial,
                                               aliquotacofinsretido numeric(15,2),
                                               aliquotacsllretido numeric(15,2),
                                               aliquotainssretido numeric(15,2),
                                               aliquotairpfretido numeric(15,2),
                                               aliquotaiss numeric(15,2),
                                               aliquotaissretido numeric(15,2),
                                               aliquotapisretido numeric(15,2),
                                               arredondarcima boolean DEFAULT false,
                                               issretidopadrao boolean DEFAULT false,
                                               mensagemtributos character varying(100) NOT NULL,
                                               percentualaproxtributo numeric(15,2),
                                               vigencia date NOT NULL,
                                               empresa_id bigint NOT NULL,
                                               regimetributario_id bigint
);

CREATE TABLE public.parametrotecnospeedapi (
                                               id serial,
                                               cnpj character varying(255),
                                               grupo character varying(255),
                                               ipservidoredoc character varying(255),
                                               login character varying(255),
                                               portaservidoredoc integer,
                                               senha character varying(255),
                                               servico character varying(255),
                                               time_out_comunicacao integer DEFAULT 1,
                                               empresa_id bigint NOT NULL
);

CREATE TABLE public.parcelapagamentodocumentofiscal (
                                                        id serial,
                                                        datavencimento date NOT NULL,
                                                        numeroparcela integer,
                                                        valor numeric(10,2) NOT NULL,
                                                        formapagamento_id bigint
);

CREATE TABLE public.parcelapagamentoordemservico (
                                                     id serial,
                                                     datavencimento date NOT NULL,
                                                     numeroparcela integer,
                                                     valor numeric(10,2) NOT NULL,
                                                     formapagamento_id bigint
);

CREATE TABLE public.pedido (
                               id serial,
                               datavencimento date,
                               numeropedido bigint,
                               observacao character varying(5000),
                               statuspedido character varying(255),
                               valor numeric(14,2),
                               valortotal numeric(14,2),
                               dataalteracao date,
                               datacadastro date,
                               usuarioalteracao_id bigint,
                               usuariocadastro_id bigint,
                               cliente_id bigint NOT NULL,
                               empresa_id bigint,
                               vendedor_id bigint,
                               acrescimo numeric(14,2),
                               contato character varying(255),
                               cpf character varying(255),
                               dataemissao timestamp without time zone,
                               desconto numeric(14,2),
                               descricaoformapagamento character varying(255),
                               descricaoprazoentrega character varying(255),
                               finalizadoprovendas boolean,
                               formapagamento integer,
                               historiconegociacao character varying(255),
                               impostos boolean,
                               isvendaaprazo boolean DEFAULT false,
                               juros numeric(14,2),
                               nome character varying(255),
                               nomeresponsavel character varying(255),
                               numerodocumento character varying(255),
                               pedidoprovendas bigint,
                               prazoentrega date,
                               telefone character varying(255),
                               tipofrete character varying DEFAULT 'SEM_OCORRENCIA'::character varying,
                               troco numeric(14,2),
                               validade date,
                               valordescontoprodutos numeric(14,2),
                               valorfrete numeric(14,2),
                               valorprodutos numeric(14,2),
                               valorprodutosaprazo numeric(14,2),
                               valorrecebido numeric(14,2),
                               valorservicoadicional numeric(14,2),
                               valortotalaprazo numeric(14,2),
                               caixaaberto_id bigint,
                               enderecocliente_id bigint,
                               entregador_id bigint,
                               natureza_id bigint,
                               situacaopedido_id bigint,
                               tabelapreco_id bigint,
                               vendedorfuncionario_id bigint,
                               orcamento_id bigint
);

CREATE TABLE public.pedidocompra (
                                     id serial,
                                     contato character varying(255),
                                     descricaoformapagamento character varying(255),
                                     descricaoprazoentrega character varying(255),
                                     emailfornecedor character varying(255),
                                     formapagamento integer,
                                     historiconegociacao character varying(255),
                                     numeropedidocompra bigint,
                                     observacao character varying(1500),
                                     prazoentrega date,
                                     statuspedido character varying(255),
                                     valordescontoprodutos numeric(14,2),
                                     valorfrete numeric(14,2),
                                     valorprodutos numeric(14,2),
                                     valortotal numeric(14,2),
                                     vendedor character varying(255),
                                     dataalteracao date,
                                     datacadastro date,
                                     usuarioalteracao_id bigint,
                                     usuariocadastro_id bigint,
                                     empresa_id bigint,
                                     fornecedor_id bigint NOT NULL,
                                     situacaopedido_id bigint,
                                     vendedorfuncionario_id bigint
);

CREATE TABLE public.percentualcreditoicms (
                                              id serial,
                                              aliquota numeric(10,2),
                                              valorfinal numeric(12,2),
                                              valorinicial numeric(12,2)
);


CREATE TABLE public.preferencia (
                                    id serial,
                                    ambiente character varying(255),
                                    ambientecte character varying(255),
                                    datascan timestamp without time zone,
                                    enderecoemail character varying(255),
                                    enderecoservidoremail character varying(255),
                                    forma character varying(255),
                                    formacte character varying(255),
                                    gerenciarcontascte boolean DEFAULT false,
                                    imagem bytea,
                                    imagemdacte bytea,
                                    mensagemcupom text,
                                    nomeimagem character varying(255),
                                    nomeimagemdacte character varying(255),
                                    numeromaxreboque integer,
                                    numeromaxveiculo integer,
                                    portaservidoremail integer,
                                    senhaemail character varying(255),
                                    transmitiraosalvar boolean DEFAULT false,
                                    transmitiraosalvarcte boolean DEFAULT false,
                                    usuarioemail character varying(255),
                                    empresa_id bigint,
                                    baixaautomaticanota boolean DEFAULT false,
                                    provisaoautomaticaduplicata boolean DEFAULT false,
                                    contapadraonota_id bigint,
                                    naturezapadraonota_id bigint,
                                    grupo_id bigint,
                                    dataliberacao timestamp without time zone DEFAULT '2025-04-01 00:00:00'::timestamp without time zone,
                                    temponotificacao integer DEFAULT 30,
                                    envioautomaticodacte boolean DEFAULT false,
                                    envioautomaticodanfe boolean DEFAULT false,
                                    cpfcnpjcontabilidade character varying(14),
                                    nomecontabilidade character varying(255),
                                    enviaremailautomaticamentepedidocompra boolean DEFAULT false,
                                    serienfe integer,
                                    numinicialnfe bigint,
                                    abrirdialoginformacoescliente boolean DEFAULT false,
                                    alertarvendedor boolean DEFAULT false,
                                    ambientemdfe character varying DEFAULT 'PRODUCAO'::character varying,
                                    ambientenfc character varying DEFAULT 'PRODUCAO'::character varying,
                                    ambientenfse character varying DEFAULT 'PRODUCAO'::character varying,
                                    ambientesat character varying DEFAULT 'PRODUCAO'::character varying,
                                    backupantesatualizacao boolean,
                                    backupapenasxml boolean,
                                    backupautomaticomes boolean,
                                    backupemailcontabilidade boolean,
                                    bloquear_campo_cotacao_forma_pagamento boolean DEFAULT false,
                                    buscaautomaticaprodutosaodigitar boolean DEFAULT true,
                                    cadastro_facil_importar_dados text DEFAULT 'NENHUM'::text,
                                    caixaocultarestornos boolean DEFAULT false,
                                    codigosequencialatual integer DEFAULT 1,
                                    codigotributacaomunicipio character varying(255),
                                    consulta_automatica_status_sat boolean DEFAULT false,
                                    controlarestoque boolean DEFAULT false,
                                    cpfnota boolean DEFAULT false,
                                    descricaopadraovales text DEFAULT 'Vales-compra'::text,
                                    diasclienteinerte integer,
                                    diasdevolucaocondicional integer DEFAULT 3,
                                    diasprodutoinerte integer,
                                    editarcontato boolean DEFAULT false,
                                    email_averbacao character varying(255),
                                    emailcontabilidade character varying(255),
                                    encaminhar_xml_completo boolean DEFAULT false,
                                    enderecoemailsecundario character varying(255),
                                    enderecoservidoremailsecundario character varying(255),
                                    enviaremailpedidoautomaticamente boolean DEFAULT false,
                                    enviarnfcompra boolean,
                                    envioautomaticodanfenfc boolean,
                                    envioautomaticorps boolean DEFAULT false,
                                    exibirapenasclientesvinculadosaofuncionario boolean DEFAULT false,
                                    exibir_apenas_pedidos_atrelados_ao_vendedor boolean DEFAULT false,
                                    exibir_colunas_estoque_reservado_disponivel boolean DEFAULT false,
                                    exibir_colunas_estoque_total boolean DEFAULT true,
                                    exibirestoquevermelho boolean DEFAULT true,
                                    exibit_localizacao_produto_pedido boolean DEFAULT false,
                                    exibirvaloresajustemanual boolean DEFAULT false,
                                    flag_gerar_conteudo_xml boolean DEFAULT false,
                                    forma_emissao_sat character varying DEFAULT 'PRODUCAO'::character varying,
                                    formamdfe character varying DEFAULT 'NORMAL'::character varying,
                                    formanfce character varying DEFAULT 'normal'::character varying,
                                    gerarcodigosequencial boolean DEFAULT false,
                                    gerarmovimentacaopagamentoentregador boolean DEFAULT true,
                                    habilitartrocavendedor boolean DEFAULT false,
                                    imagemecf bytea,
                                    imprimirautomaticamenterelatoriovale boolean DEFAULT true,
                                    infcomplementarnfce character varying(255),
                                    infcomplementarnfe character varying(255),
                                    informarsenhaalterarestoque boolean DEFAULT false,
                                    informarsenhaalterarvalorcompra boolean DEFAULT false,
                                    informarsenhacancelaritem boolean DEFAULT false,
                                    informar_senha_desconto_venda boolean DEFAULT false,
                                    informar_senha_tabela_preco boolean DEFAULT false,
                                    informarsenhavalorabaixominimo boolean DEFAULT false,
                                    informar_senha_venda_estoque_minimo boolean DEFAULT false,
                                    insercaounitariaservico boolean DEFAULT false,
                                    inserir_produto_unitario_nfe boolean DEFAULT false,
                                    inserir_produto_unitario_pedido boolean DEFAULT false,
                                    justificativacontingencia character varying DEFAULT 'TRANSMITIDA EM CONTINGENCIA OFFLINE'::character varying,
                                    larguradetalhesprodutopdv integer DEFAULT 270,
                                    margemleftextratocfe integer DEFAULT 0,
                                    margemleftvalecompra integer DEFAULT 0,
                                    mensagemetiqueta character varying(255),
                                    municipionfse character varying DEFAULT 'TOLEDO'::character varying,
                                    nao_alterar_valor_venda_nota_compra boolean DEFAULT false,
                                    nao_exibir_adicionais boolean DEFAULT false,
                                    naoexibiremailsenvio boolean,
                                    nao_permitir_venda_estoque_reservado boolean DEFAULT false,
                                    nomebanco character varying(255),
                                    nomeimagemecf character varying(255),
                                    notificarcompromissos boolean DEFAULT false,
                                    numinicialcte bigint DEFAULT 1,
                                    numinicialloterps bigint,
                                    numinicialmdf bigint DEFAULT 1,
                                    numinicialnfc bigint,
                                    numinicialpedido bigint,
                                    numinicialpedidodecompra bigint,
                                    numinicialrps bigint,
                                    numero_casas_apos_virgula_moeda integer DEFAULT 2,
                                    numero_casas_apos_virgula_quantidade integer DEFAULT 2,
                                    numerocasasaposvirgulaquantidadeitemnfe integer,
                                    numerocasasaposvirgulavalounititemnfe integer,
                                    numero_casas_apos_virgula_valor_unitario integer DEFAULT 2,
                                    obrigatoriedadedatnasc boolean DEFAULT false,
                                    obrigatorio_informar_valor_cotacao_dia boolean DEFAULT false,
                                    observacoesdelivery character varying(255),
                                    observacoespedido character varying(255),
                                    ocultarinfoadicional boolean DEFAULT false,
                                    operadorasterisco boolean DEFAULT true,
                                    operadorxis boolean DEFAULT true,
                                    periodogerenciamento text DEFAULT 'DIARIO'::text,
                                    periodotesteativado boolean DEFAULT false,
                                    periodotestedatafinal timestamp without time zone,
                                    permitirselecaoenderecoadicional boolean DEFAULT false,
                                    portaservidoremailsecundario integer,
                                    produtoparavenda boolean DEFAULT false,
                                    provedorcfesat character varying DEFAULT 'ACBR_MONITOR'::character varying,
                                    provedornfse character varying DEFAULT 'EQUIPLANO'::character varying,
                                    qtddigitosgerador integer DEFAULT 4,
                                    realizarmovimentacaoaposacerto boolean DEFAULT false,
                                    reportarerrosuporte boolean DEFAULT true,
                                    senhabanco character varying(255),
                                    senhacancelaritem character varying(255),
                                    senhacreditocliente boolean DEFAULT false,
                                    senhaemailsecundario character varying(255),
                                    senhaoperacoescaixa boolean DEFAULT true,
                                    seriecte integer DEFAULT 1,
                                    seriemdf integer DEFAULT 1,
                                    serienfc integer,
                                    serienfs character varying(255),
                                    solicitarcofirmacaofechamentopontodevendas boolean DEFAULT true,
                                    solicitarsenhaalterarvalorfechamentocaixa boolean DEFAULT false,
                                    solicitar_senha_alterar_valor_pedido_ordemservico boolean DEFAULT false,
                                    solicitar_senha_cancelar_vendas boolean DEFAULT false,
                                    solicitarsenhadelivery boolean DEFAULT false,
                                    solicitar_senha_modificar_vendedor boolean DEFAULT false,
                                    solicitarsenhasuprimentosangriadecaixa boolean DEFAULT false,
                                    solicitar_senha_venda_estoque_reservado boolean DEFAULT false,
                                    taxaservicovendas numeric(5,2) DEFAULT 0.00,
                                    tempo_consulta_sat integer DEFAULT 15,
                                    tipodescontopadrao text DEFAULT 'PERCENTUAL'::text,
                                    tipoemail character varying DEFAULT 'OUTROS'::character varying,
                                    tipoemailsecundario character varying DEFAULT 'GERMANTECH'::character varying,
                                    tipoemissormdfe character varying(255),
                                    tipoimpressoravalecompra text DEFAULT 'IMPRESSAO_A4'::text,
                                    mostra_tipo_pagamento_info_nfe boolean DEFAULT true,
                                    transmitiraosalvarmdfe boolean,
                                    transmitiraosalvarnfs boolean DEFAULT false,
                                    ultimaconsultansu timestamp without time zone,
                                    usuariobanco character varying(255),
                                    usuarioemailsecundario character varying(255),
                                    utilizarcodigofabricante boolean DEFAULT false,
                                    utilizarcomissaoproduto boolean DEFAULT false,
                                    utilizarcomissaovendedor boolean DEFAULT true,
                                    utilizarfotoprodutopdv boolean DEFAULT false,
                                    utilizar_ncm_pedido boolean DEFAULT false,
                                    utilizar_selecao_modelos_etiqueta boolean DEFAULT false,
                                    utilizartabelapreco boolean DEFAULT false,
                                    utilizartabelaprecoproduto boolean DEFAULT false,
                                    utilizartaxaservicoauxiliarvenda boolean DEFAULT true,
                                    utilizartaxaservicodeliverybalcao boolean DEFAULT true,
                                    utilizartaxaservicodeliveryentrega boolean DEFAULT true,
                                    utilizartaxaserviconfce boolean DEFAULT true,
                                    utilizartaxaserviconfe boolean DEFAULT true,
                                    utilizartaxaservicosat boolean DEFAULT true,
                                    utilizarvalorprazo boolean DEFAULT false,
                                    validarestoqueinsuficiente boolean DEFAULT false,
                                    validartaxaentrega boolean DEFAULT true,
                                    valorsugestaodescontovenda numeric(10,2),
                                    verificar_notadestinada_iniciar_sistema boolean DEFAULT true,
                                    verificar_transmissao_nfce_contingencia boolean DEFAULT true,
                                    versao_sat character varying DEFAULT 'VERSAO_007'::character varying,
                                    cfoppadraonfc_id bigint,
                                    moedapadrao_id bigint,
                                    servicopadrao_id bigint
);

CREATE TABLE public.preferencia_emailsbackup (
                                                 preferencia_id bigint NOT NULL,
                                                 listaemailsbackup_id bigint NOT NULL
);

CREATE TABLE public.produto (
                                id serial,
                                ativo boolean,
                                codigofornecedor character varying(4),
                                codigointerno character varying(60) NOT NULL,
                                derivadopetroleo boolean,
                                descricao character varying(120) NOT NULL,
                                diavalidadeproduto integer,
                                eancomercial character varying(30),
                                eantributado character varying(30),
                                infadicional character varying(500),
                                origemmercadoria character varying(255),
                                pesobruto numeric(10,4),
                                pesoliquido numeric(10,4),
                                quantidademinima numeric(12,4) NOT NULL,
                                quantidadetributacao numeric(10,4),
                                unidadecomercial character varying(255),
                                unidadetributado character varying(255),
                                usar_csts_ncms boolean,
                                valorunitariocomercial numeric(10,2) NOT NULL,
                                valorunitariotributado numeric(10,2),
                                codigoanp character varying(9),
                                codigocodif character varying(21),
                                quantidadecombustivel numeric(16,4),
                                estadoconsumo_id bigint,
                                dataalteracao date,
                                datacadastro date,
                                usuarioalteracao_id bigint,
                                usuariocadastro_id bigint,
                                csticms_id bigint,
                                cstipi_id bigint,
                                cstpiscofins_id bigint,
                                departamento_id bigint,
                                empresa_id bigint,
                                ncm character varying(255),
                                produtonaocomercial boolean,
                                todasempresas boolean,
                                quantidadereservada numeric(15,4),
                                eanvalido boolean,
                                cest character varying(255),
                                cnpjfabricante character varying(20),
                                codigobeneficiofiscal character varying(255),
                                codigofabricante character varying(60),
                                datadesativacao timestamp without time zone,
                                datavalidade date,
                                descontomaximo numeric(14,2),
                                estoqueminimo numeric(10,4),
                                exportabalanca boolean,
                                fatorconversao numeric(35,25),
                                grupoimpressaodesativado boolean,
                                imagemproduto bytea,
                                localizacao character varying(60),
                                margemcomissao numeric(6,2),
                                margemlucrofixa numeric(10,2),
                                numeroexcecao character varying(255),
                                obrigatorioinformaradicional boolean DEFAULT false,
                                ordenaradicionais character varying DEFAULT 'CODIGO_CRESCENTE'::character varying,
                                percentuallucro numeric(14,2),
                                producaopropriasujeitaipi boolean DEFAULT false,
                                tributacaodiferenciada boolean DEFAULT false,
                                usarcodfabricante boolean DEFAULT false,
                                utilizabalanca boolean,
                                valoraprazo numeric(21,10),
                                valorcompra numeric(21,10),
                                valorminimo numeric(21,10),
                                valorsugerido numeric(14,2),
                                descricaoprodutoanp character varying(255),
                                margemgasderivadopetroleo numeric(7,4),
                                margemgasnaturalinternacional numeric(7,4),
                                margemgasnaturalnatiocnal numeric(7,4),
                                valorpartidaglp numeric(15,2),
                                informacaonutricional_id bigint,
                                marca_id bigint,
                                subdepartamento_id bigint,
                                tipoitem_id bigint,
                                unidademedidacomercial_id bigint,
                                kitproduto_id bigint,
                                tara_id bigint
);


CREATE TABLE public.produtofornecedor (
                                          id serial,
                                          codigointernofornecedor character varying(60),
                                          clientefornecedor_id bigint,
                                          produto_id bigint,
                                          empresa_id bigint,
                                          datacadastro timestamp without time zone
);


CREATE TABLE public.produtotabelapreco (
                                           id serial,
                                           padrao boolean,
                                           dataalteracao date,
                                           datacadastro date,
                                           usuarioalteracao_id bigint,
                                           usuariocadastro_id bigint,
                                           produto_id bigint NOT NULL,
                                           tabelapreco_id bigint NOT NULL
);

CREATE TABLE public.promocaoproduto (
                                        id serial,
                                        ativo boolean,
                                        descontoperc numeric(4,2),
                                        descontovalor numeric(10,2),
                                        domingo boolean DEFAULT false,
                                        horariosdiferenciados boolean DEFAULT false,
                                        iniciohorario character varying(255),
                                        iniciovigencia date,
                                        precofinal numeric(10,2),
                                        quantidademinima numeric(10,4) NOT NULL,
                                        quantidadetipo character varying(255) DEFAULT 'APARTIR'::character varying,
                                        quartafeira boolean DEFAULT false,
                                        quintafeira boolean DEFAULT false,
                                        sabado boolean DEFAULT false,
                                        segundafeira boolean DEFAULT false,
                                        sextafeira boolean DEFAULT false,
                                        tercafeira boolean DEFAULT false,
                                        terminohorario character varying(255),
                                        terminovigencia date,
                                        tipodesconto character varying DEFAULT 'PERCENTUAL'::character varying,
                                        valorpromocional numeric(10,2),
                                        dataalteracao date,
                                        datacadastro date,
                                        usuarioalteracao_id bigint,
                                        usuariocadastro_id bigint,
                                        empresa_id bigint,
                                        produto_id bigint NOT NULL
);

CREATE TABLE public.regimetributario (
                                         id serial,
                                         aliquotacofins numeric(4,2),
                                         aliquotapis numeric(4,2),
                                         codigo character varying(2) NOT NULL,
                                         descricao character varying(255) NOT NULL
);

CREATE TABLE public.seguradora (
                                   id serial,
                                   apolices bytea,
                                   ativa boolean,
                                   cnpj character varying(14) NOT NULL,
                                   nome character varying(30) NOT NULL,
                                   seguradorapadrao boolean,
                                   todasempresas boolean,
                                   dataalteracao date,
                                   datacadastro date,
                                   usuarioalteracao_id bigint,
                                   usuariocadastro_id bigint,
                                   empresa_id bigint
);

CREATE SEQUENCE public.seq_gen_sequence
    START WITH 50
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE public.servico (
                                id serial,
                                codigoservico bigint,
                                descricao text,
                                valor numeric(18,2),
                                empresa_id bigint,
                                ativo boolean DEFAULT true,
                                todasempresas boolean DEFAULT false,
                                dataalteracao date,
                                datacadastro date,
                                usuarioalteracao_id bigint,
                                usuariocadastro_id bigint,
                                codigoserviconfse character varying(255),
                                codigosubserviconfse character varying(255),
                                garantia boolean DEFAULT false,
                                aliquota numeric(8,2),
                                codigoatividade character varying(255),
                                codigoservicosaopaulo character varying(255)
);

CREATE TABLE public.serviconfse (
                                    id serial,
                                    codigoservico character varying(255),
                                    descricaoservico text,
                                    dataalteracao date,
                                    datacadastro date,
                                    usuarioalteracao_id bigint,
                                    usuariocadastro_id bigint
);

CREATE TABLE public.situacao (
                                 id serial,
                                 cor character varying(255),
                                 descricao character varying(255),
                                 status character varying(255),
                                 tipoarquivo character varying(255),
                                 situacaopadrao boolean DEFAULT false,
                                 dataalteracao date,
                                 datacadastro date,
                                 usuarioalteracao_id bigint,
                                 usuariocadastro_id bigint,
                                 empresa_id bigint
);

CREATE TABLE public.situacaocheque (
                                       id serial,
                                       ativo boolean NOT NULL,
                                       todasempresas boolean,
                                       cor character varying(255),
                                       descricao character varying(255),
                                       padrao boolean,
                                       statuschequeemitido character varying(255),
                                       statuschequerecebido character varying(255),
                                       tipocheque character varying(255),
                                       dataalteracao date,
                                       datacadastro date,
                                       usuarioalteracao_id bigint,
                                       usuariocadastro_id bigint,
                                       empresa_id bigint
);

CREATE TABLE public.statusanotacaopedido (
                                             id serial,
                                             blue integer DEFAULT 0 NOT NULL,
                                             descricao character varying(256),
                                             green integer DEFAULT 0 NOT NULL,
                                             red integer DEFAULT 0 NOT NULL,
                                             dataalteracao date,
                                             datacadastro date,
                                             usuarioalteracao_id bigint,
                                             usuariocadastro_id bigint,
                                             empresa_id bigint
);

CREATE TABLE public.subdepartamento (
                                        id serial,
                                        ativo boolean DEFAULT true,
                                        codigo bigint NOT NULL,
                                        descricao character varying(500),
                                        todasempresas boolean DEFAULT false,
                                        dataalteracao date,
                                        datacadastro date,
                                        usuarioalteracao_id bigint,
                                        usuariocadastro_id bigint,
                                        departamento_id bigint,
                                        empresa_id bigint NOT NULL
);

CREATE TABLE public.subserviconfse (
                                       id serial,
                                       codigosubservico character varying(255),
                                       descricaosubservico text,
                                       dataalteracao date,
                                       datacadastro date,
                                       usuarioalteracao_id bigint,
                                       usuariocadastro_id bigint,
                                       serviconfse_id bigint NOT NULL
);

CREATE TABLE public.tabelacstsped (
                                      id serial,
                                      codigo bigint NOT NULL,
                                      cst character varying(255),
                                      datafinal timestamp without time zone,
                                      datainicial timestamp without time zone,
                                      descricao character varying(500) NOT NULL
);

CREATE TABLE public.tabelaibpt (
                                   id serial,
                                   aliquotaestadual numeric(14,2),
                                   aliquotaimportadosfederal numeric(14,2),
                                   aliquotamunicipal numeric(14,2),
                                   aliquotanacionalfederal numeric(14,2),
                                   codigoncm character varying(255),
                                   excecaoncm character varying(255),
                                   tipo character varying(255),
                                   versao character varying(255),
                                   vigenciafim date,
                                   vigenciainicio date,
                                   estado_id bigint
);

CREATE TABLE public.tabelapreco (
                                    id serial,
                                    ativo boolean DEFAULT true,
                                    basecalculooperacao character varying DEFAULT 'VALOR_VENDA'::character varying,
                                    codigo character varying(255),
                                    formaoperacao character varying(255),
                                    nome character varying(255),
                                    observacao character varying(255),
                                    tipooperacao character varying(255),
                                    todasempresas boolean DEFAULT false,
                                    valor numeric(14,2),
                                    dataalteracao date,
                                    datacadastro date,
                                    usuarioalteracao_id bigint,
                                    usuariocadastro_id bigint,
                                    empresa_id bigint NOT NULL
);

CREATE TABLE public.tabelapreco_usuario (
                                            tabelapreco_id bigint NOT NULL,
                                            usuarios_id bigint NOT NULL
);

CREATE TABLE public.tara (
                             id serial,
                             ativo boolean,
                             codigointerno bigint NOT NULL,
                             descricao character varying(120) NOT NULL,
                             valortara numeric(6,3) NOT NULL,
                             empresa_id bigint
);

CREATE TABLE public.taxaentrega (
                                    id serial,
                                    ativo boolean DEFAULT true,
                                    codigo bigint NOT NULL,
                                    nome character varying(255),
                                    padrao boolean,
                                    valor numeric(38,0),
                                    empresa_id bigint NOT NULL
);

CREATE TABLE public.taxaentregabairros (
                                           id serial,
                                           bairro character varying(255),
                                           municipio_id bigint,
                                           taxaentrega_id bigint
);

CREATE TABLE public.tipo (
                             id serial,
                             descricao character varying(255),
                             numero bigint,
                             dataalteracao date,
                             datacadastro date,
                             ativo boolean,
                             todasempresas boolean,
                             usuarioalteracao_id bigint,
                             usuariocadastro_id bigint,
                             empresa_id bigint
);

CREATE TABLE public.tipocfop (
                                 id serial,
                                 codigo character varying(4),
                                 descricao text,
                                 entradasaida character varying(1)
);

CREATE TABLE public.tipocontato (
                                    id serial,
                                    ativo boolean NOT NULL,
                                    descricao character varying(255),
                                    dataalteracao date,
                                    datacadastro date,
                                    usuarioalteracao_id bigint,
                                    usuariocadastro_id bigint,
                                    empresa_id bigint NOT NULL
);

CREATE TABLE public.tipoitem (
                                 id serial,
                                 codigo character varying(255),
                                 descricao character varying(255)
);

CREATE TABLE public.tokenintegracao (
                                        id serial,
                                        chave character varying(255),
                                        datavalidade date,
                                        token character varying(255),
                                        dataalteracao date,
                                        datacadastro date,
                                        usuarioalteracao_id bigint,
                                        usuariocadastro_id bigint
);

CREATE TABLE public.tributacaogeralempresa (
                                               id serial,
                                               aliquotacofins numeric(4,2),
                                               aliquotafcp numeric(4,2),
                                               aliquotaibpt numeric(4,2),
                                               aliquotaicms numeric(4,2),
                                               aliquotaipi numeric(4,2),
                                               aliquotapis numeric(4,2),
                                               ativo boolean,
                                               dataalteracao date,
                                               datacadastro date,
                                               usuarioalteracao_id bigint,
                                               usuariocadastro_id bigint,
                                               cfop_id bigint,
                                               csticms_id bigint,
                                               cstipi_id bigint,
                                               cstpiscofins_id bigint,
                                               tipoitem_id bigint,
                                               empresa_id bigint NOT NULL
);

CREATE TABLE public.tributacaoporncm (
                                         id serial,
                                         aliquotacofins numeric(4,2),
                                         aliquotacofinspisdiferenciada boolean DEFAULT false,
                                         aliquotaibpt numeric(4,2),
                                         aliquotaicms numeric(4,2),
                                         aliquotaipi numeric(4,2),
                                         aliquotapis numeric(4,2),
                                         cfop_id bigint NOT NULL,
                                         csticmsusual_id bigint NOT NULL,
                                         cstipiusual_id bigint NOT NULL,
                                         cstpiscofinsusual_id bigint NOT NULL,
                                         empresa_id bigint,
                                         tipoitem_id bigint NOT NULL,
                                         estado_id bigint NOT NULL,
                                         excecaoncm character varying(2),
                                         numeroncm character varying(8),
                                         ignorarcfop boolean DEFAULT false,
                                         aliquotafcp numeric(4,2),
                                         aliquotamva numeric(7,4),
                                         modalidadebcst character varying(1),
                                         reducaobasecalculo numeric(5,2)
);

CREATE TABLE public.unidademedida (
                                      id serial,
                                      ativo boolean DEFAULT true,
                                      descricao character varying(60),
                                      sigla character varying(3) NOT NULL,
                                      dataalteracao date,
                                      datacadastro date,
                                      usuarioalteracao_id bigint,
                                      usuariocadastro_id bigint
);

CREATE TABLE public.usuario (
                                id serial,
                                ativo boolean,
                                dataexpiracao date,
                                expira boolean,
                                nome character varying(100) NOT NULL,
                                senha character varying(50) NOT NULL,
                                usuario character varying(50) NOT NULL,
                                empresa_id bigint NOT NULL,
                                papel_id bigint,
                                senhacriptografada character varying,
                                caixa_id bigint,
                                imagemusuario bytea,
                                notificado_painel_informativo_iniciar_sistema boolean DEFAULT false,
                                painel_informativo_iniciar_sistema boolean DEFAULT true,
                                visualizartodosclientes boolean,
                                funcionario_id bigint,
                                usuarioconexaocaixa_id bigint
);

CREATE TABLE public.usuariocaixa (
                                     id serial,
                                     caixa_id bigint,
                                     empresa_id bigint,
                                     usuario_id bigint
);

CREATE TABLE public.usuarioempresa (
                                       id serial,
                                       dataalteracao date,
                                       datacadastro date,
                                       usuarioalteracao_id bigint,
                                       usuariocadastro_id bigint,
                                       empresa_id bigint,
                                       usuario_id bigint
);

CREATE TABLE public.veiculo_veiculo (
                                        veiculocte_id bigint NOT NULL,
                                        veiculosvinculado_id bigint NOT NULL
);

CREATE TABLE public.vendasorigem (
                                     id serial,
                                     auxiliarservico_id bigint,
                                     auxiliarvenda_id bigint,
                                     cupomfiscalsat_id bigint,
                                     numero bigint,
                                     empresaid bigint,
                                     ambiente character varying(1),
                                     tipofaturamento integer,
                                     serie integer,
                                     notafiscalconsumidor_id bigint,
                                     notafiscalservico_id bigint,
                                     ordemservico_id bigint,
                                     pedido_id bigint
);

CREATE TABLE public.versaosistema (
                                      id serial,
                                      dataatualizacao timestamp without time zone,
                                      sistema character varying(255),
                                      versao character varying(255),
                                      dataalteracao date,
                                      datacadastro date,
                                      usuarioalteracao_id bigint,
                                      usuariocadastro_id bigint
);


CREATE TABLE public.version (
    version integer NOT NULL
);

CREATE TABLE public.volumenotafiscalentrada (
                                                id serial,
                                                especievolumes character varying(255),
                                                pesobruto numeric(14,3),
                                                pesoliquido numeric(14,3),
                                                quantidadevolumes integer,
                                                notafiscalentrada_id bigint
);

CREATE TABLE public.databasechangeloglock
(
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp with time zone,
    lockedby character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id)
);

CREATE TABLE public.contapagarreceber
(
    id serial,
    cancelada boolean DEFAULT false,
    dataordemservico date,
    datapagamento date,
    datavencimento date,
    desconto numeric(14,2),
    descricaoconta character varying(255) COLLATE pg_catalog."default",
    dtemissaoboleto date,
    dtemissaocfe date,
    dtemissaocte date,
    dtemissaonfce date,
    dtemissaonfe date,
    dtemissaooutrodoc date,
    dtemissaorps date,
    enderecoclifor character varying(255) COLLATE pg_catalog."default",
    formapagamento character varying(255) COLLATE pg_catalog."default",
    intervaloparcela integer,
    juropreferencia numeric(14,2),
    juros numeric(14,2) DEFAULT 0.0,
    motivocancelamento character varying(255) COLLATE pg_catalog."default",
    multa numeric(14,2) DEFAULT 0.0,
    multapreferencia numeric(14,2),
    nomeclifor character varying(255) COLLATE pg_catalog."default",
    nossonumero character varying(50) COLLATE pg_catalog."default",
    nrparcela integer,
    numeroauxvenda bigint,
    numerocfe bigint,
    numerocte bigint,
    numerodocumento bigint,
    numerogrupoparcelas bigint,
    numeronfce bigint,
    numeronfe bigint,
    numeroordemservico bigint,
    numerooutrodoc bigint,
    numerorecibo bigint,
    numerorps bigint,
    observacao text COLLATE pg_catalog."default",
    origem character varying(255) COLLATE pg_catalog."default",
    percentualtaxaantecipacaomaquina numeric(14,2) DEFAULT 0.00,
    percentualtaxamaquina numeric(14,2) DEFAULT 0.00,
    tipo integer,
    troco numeric(14,2),
    valor numeric(14,2),
    valorpago numeric(14,2),
    valortaxaantecipacaomaquina numeric(14,2) DEFAULT 0.00,
    valortaxamaquina numeric(14,2) DEFAULT 0.00,
    dataalteracao date,
    datacadastro date,
    numero bigint,
    CONSTRAINT contapagarreceber_pkey PRIMARY KEY (id)
);

CREATE TABLE public.boletogerado
(
    id serial,
    aceite boolean,
    codigodebarras character varying(255) COLLATE pg_catalog."default",
    codigoespeciemoeda integer,
    codigomovimentoretorno character varying(255) COLLATE pg_catalog."default",
    datadocumento date,
    datapagamento timestamp without time zone,
    dataprocessamento date,
    datavencimento date,
    especiedocumento character varying(255) COLLATE pg_catalog."default",
    especiemoeda character varying(255) COLLATE pg_catalog."default",
    geradoremessa boolean,
    instrucoes1 character varying(255) COLLATE pg_catalog."default",
    instrucoes2 character varying(255) COLLATE pg_catalog."default",
    instrucoes3 character varying(255) COLLATE pg_catalog."default",
    instrucoes4 character varying(255) COLLATE pg_catalog."default",
    instrucoes5 character varying(255) COLLATE pg_catalog."default",
    instrucoes6 character varying(255) COLLATE pg_catalog."default",
    instrucoes7 character varying(255) COLLATE pg_catalog."default",
    instrucoes8 character varying(255) COLLATE pg_catalog."default",
    instrucoes9 character varying(255) COLLATE pg_catalog."default",
    linhadigitavel character varying(255) COLLATE pg_catalog."default",
    locaispagamento character varying(255) COLLATE pg_catalog."default",
    lote bigint,
    motivomovimentoretorno character varying(255) COLLATE pg_catalog."default",
    motivoretorno character varying(255) COLLATE pg_catalog."default",
    movimentacaoremessa character varying COLLATE pg_catalog."default" DEFAULT 'ENTRADA_DE_TITULOS'::character varying,
    nossonumero character varying(255) COLLATE pg_catalog."default",
    numerodocumento character varying(255) COLLATE pg_catalog."default",
    quantidademoeda numeric(15,2),
    situacaobanco character varying COLLATE pg_catalog."default" DEFAULT 'BOLETO_GERADO'::character varying,
    status character varying COLLATE pg_catalog."default" DEFAULT 'ENTRADA_DE_TITULOS'::character varying,
    statusmovimentoretorno character varying(255) COLLATE pg_catalog."default",
    valoracrescimos numeric(15,2),
    valorboleto numeric(15,2),
    valordeducoes numeric(15,2),
    valordescontos numeric(15,2),
    valormoeda numeric(15,2),
    valormulta numeric(15,2),
    valortotalboleto numeric(15,2),
    variacaocarteira character varying(255) COLLATE pg_catalog."default",
    dataalteracao date,
    datacadastro date,
    clifor_id bigint,
    contapagarreceber_id bigint,
    empresa_id bigint,
    CONSTRAINT boletogerado_pkey PRIMARY KEY (id),
    CONSTRAINT fk_boletogerado_clifor_id FOREIGN KEY (clifor_id)
        REFERENCES public.clientefornecedor (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_boletogerado_contapagarreceber_id FOREIGN KEY (contapagarreceber_id)
        REFERENCES public.contapagarreceber (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_boletogerado_empresa_id FOREIGN KEY (empresa_id)
        REFERENCES public.empresa (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)


ALTER TABLE ONLY cte.cartacorrecaocte
    ADD CONSTRAINT cartacorrecaocte_pkey PRIMARY KEY (id);


--
-- TOC entry 5488 (class 2606 OID 2380081)
-- Name: cte cte_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT cte_pkey PRIMARY KEY (id);


--
-- TOC entry 5491 (class 2606 OID 2380083)
-- Name: ctecomplementado ctecomplementado_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ctecomplementado
    ADD CONSTRAINT ctecomplementado_pkey PRIMARY KEY (id);


--
-- TOC entry 5494 (class 2606 OID 2380085)
-- Name: documentoanterior documentoanterior_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.documentoanterior
    ADD CONSTRAINT documentoanterior_pkey PRIMARY KEY (id);


--
-- TOC entry 5498 (class 2606 OID 2380087)
-- Name: documentoanterioreletronico documentoanterioreletronico_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.documentoanterioreletronico
    ADD CONSTRAINT documentoanterioreletronico_pkey PRIMARY KEY (id);


--
-- TOC entry 5501 (class 2606 OID 2380089)
-- Name: documentoanteriorpapel documentoanteriorpapel_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.documentoanteriorpapel
    ADD CONSTRAINT documentoanteriorpapel_pkey PRIMARY KEY (id);


--
-- TOC entry 5503 (class 2606 OID 2380091)
-- Name: emissordocumentoanterior emissordocumentoanterior_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.emissordocumentoanterior
    ADD CONSTRAINT emissordocumentoanterior_pkey PRIMARY KEY (id);


--
-- TOC entry 5507 (class 2606 OID 2380093)
-- Name: fiscalicmsinterestadual fiscalicmsinterestadual_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.fiscalicmsinterestadual
    ADD CONSTRAINT fiscalicmsinterestadual_pkey PRIMARY KEY (id);


--
-- TOC entry 5509 (class 2606 OID 2380095)
-- Name: formapagamentocte formapagamentocte_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.formapagamentocte
    ADD CONSTRAINT formapagamentocte_pkey PRIMARY KEY (id);


--
-- TOC entry 5516 (class 2606 OID 2380097)
-- Name: historico_veiculo historico_veiculo_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.historico_veiculo
    ADD CONSTRAINT historico_veiculo_pkey PRIMARY KEY (id);


--
-- TOC entry 5523 (class 2606 OID 2380099)
-- Name: identificacaodocanterior identificacaodocanterior_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.identificacaodocanterior
    ADD CONSTRAINT identificacaodocanterior_pkey PRIMARY KEY (id);


--
-- TOC entry 5525 (class 2606 OID 2380101)
-- Name: informacaocorrecao informacaocorrecao_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.informacaocorrecao
    ADD CONSTRAINT informacaocorrecao_pkey PRIMARY KEY (id);


--
-- TOC entry 5528 (class 2606 OID 2380103)
-- Name: itemservico itemservico_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.itemservico
    ADD CONSTRAINT itemservico_pkey PRIMARY KEY (id);


--
-- TOC entry 5531 (class 2606 OID 2380105)
-- Name: itemservicolist itemservicolist_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.itemservicolist
    ADD CONSTRAINT itemservicolist_pkey PRIMARY KEY (id);


--
-- TOC entry 5535 (class 2606 OID 2380107)
-- Name: lacre lacre_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.lacre
    ADD CONSTRAINT lacre_pkey PRIMARY KEY (id);


--
-- TOC entry 5537 (class 2606 OID 2380109)
-- Name: lotecte lotecte_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.lotecte
    ADD CONSTRAINT lotecte_pkey PRIMARY KEY (id);


--
-- TOC entry 5539 (class 2606 OID 2380111)
-- Name: modalrodoviario modalrodoviario_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.modalrodoviario
    ADD CONSTRAINT modalrodoviario_pkey PRIMARY KEY (id);


--
-- TOC entry 5545 (class 2606 OID 2380113)
-- Name: motorista motorista_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.motorista
    ADD CONSTRAINT motorista_pkey PRIMARY KEY (id);


--
-- TOC entry 5548 (class 2606 OID 2380115)
-- Name: notafiscalcte notafiscalcte_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.notafiscalcte
    ADD CONSTRAINT notafiscalcte_pkey PRIMARY KEY (id);


--
-- TOC entry 5553 (class 2606 OID 2380117)
-- Name: notaprodutorcte notaprodutorcte_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.notaprodutorcte
    ADD CONSTRAINT notaprodutorcte_pkey PRIMARY KEY (id);


--
-- TOC entry 5555 (class 2606 OID 2380119)
-- Name: obscontribuintecte obscontribuintecte_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.obscontribuintecte
    ADD CONSTRAINT obscontribuintecte_pkey PRIMARY KEY (id);


--
-- TOC entry 5557 (class 2606 OID 2380121)
-- Name: obsfiscocte obsfiscocte_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.obsfiscocte
    ADD CONSTRAINT obsfiscocte_pkey PRIMARY KEY (id);


--
-- TOC entry 5569 (class 2606 OID 2380123)
-- Name: ordemcoleta ordemcoleta_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoleta
    ADD CONSTRAINT ordemcoleta_pkey PRIMARY KEY (id);


--
-- TOC entry 5573 (class 2606 OID 2380125)
-- Name: ordemcoletacte ordemcoletacte_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoletacte
    ADD CONSTRAINT ordemcoletacte_pkey PRIMARY KEY (id);


--
-- TOC entry 5576 (class 2606 OID 2380127)
-- Name: outrodocumento outrodocumento_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.outrodocumento
    ADD CONSTRAINT outrodocumento_pkey PRIMARY KEY (id);


--
-- TOC entry 5579 (class 2606 OID 2380129)
-- Name: quantidadecarga quantidadecarga_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.quantidadecarga
    ADD CONSTRAINT quantidadecarga_pkey PRIMARY KEY (id);


--
-- TOC entry 5581 (class 2606 OID 2380131)
-- Name: seguro seguro_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.seguro
    ADD CONSTRAINT seguro_pkey PRIMARY KEY (id);


--
-- TOC entry 5583 (class 2606 OID 2380133)
-- Name: terceiro terceiro_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.terceiro
    ADD CONSTRAINT terceiro_pkey PRIMARY KEY (id);


--
-- TOC entry 5586 (class 2606 OID 2380135)
-- Name: tipomedidacte tipomedidacte_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.tipomedidacte
    ADD CONSTRAINT tipomedidacte_pkey PRIMARY KEY (id);


--
-- TOC entry 5588 (class 2606 OID 2380137)
-- Name: veiculo veiculo_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.veiculo
    ADD CONSTRAINT veiculo_pkey PRIMARY KEY (id);


--
-- TOC entry 5591 (class 2606 OID 2380139)
-- Name: volumeordemcoleta volumeordemcoleta_pkey; Type: CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.volumeordemcoleta
    ADD CONSTRAINT volumeordemcoleta_pkey PRIMARY KEY (id);


--
-- TOC entry 5593 (class 2606 OID 2380141)
-- Name: auxiliarvenda auxiliarvenda_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.auxiliarvenda
    ADD CONSTRAINT auxiliarvenda_pkey PRIMARY KEY (id);


--
-- TOC entry 5606 (class 2606 OID 2380143)
-- Name: consignacao consignacao_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.consignacao
    ADD CONSTRAINT consignacao_pkey PRIMARY KEY (id);


--
-- TOC entry 5612 (class 2606 OID 2380145)
-- Name: consignacaodevolucao consignacaodevolucao_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.consignacaodevolucao
    ADD CONSTRAINT consignacaodevolucao_pkey PRIMARY KEY (id);


--
-- TOC entry 5618 (class 2606 OID 2380147)
-- Name: cupomfiscal cupomfiscal_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.cupomfiscal
    ADD CONSTRAINT cupomfiscal_pkey PRIMARY KEY (id);


--
-- TOC entry 5631 (class 2606 OID 2380149)
-- Name: duplicata duplicata_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.duplicata
    ADD CONSTRAINT duplicata_pkey PRIMARY KEY (id);


--
-- TOC entry 5636 (class 2606 OID 2380151)
-- Name: duplicatarecebida duplicatarecebida_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.duplicatarecebida
    ADD CONSTRAINT duplicatarecebida_pkey PRIMARY KEY (id);


--
-- TOC entry 5641 (class 2606 OID 2380153)
-- Name: formapagamentoauxiliarvenda formapagamentoauxiliarvenda_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentoauxiliarvenda
    ADD CONSTRAINT formapagamentoauxiliarvenda_pkey PRIMARY KEY (id);


--
-- TOC entry 5648 (class 2606 OID 2380155)
-- Name: formapagamentocreditocliente formapagamentocreditocliente_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentocreditocliente
    ADD CONSTRAINT formapagamentocreditocliente_pkey PRIMARY KEY (id);


--
-- TOC entry 5653 (class 2606 OID 2380157)
-- Name: formapagamentocupomfiscal formapagamentocupomfiscal_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentocupomfiscal
    ADD CONSTRAINT formapagamentocupomfiscal_pkey PRIMARY KEY (id);


--
-- TOC entry 5659 (class 2606 OID 2380159)
-- Name: itemconsignacao itemconsignacao_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemconsignacao
    ADD CONSTRAINT itemconsignacao_pkey PRIMARY KEY (id);


--
-- TOC entry 5663 (class 2606 OID 2380161)
-- Name: itemconsignacaodevolucao itemconsignacaodevolucao_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemconsignacaodevolucao
    ADD CONSTRAINT itemconsignacaodevolucao_pkey PRIMARY KEY (id);


--
-- TOC entry 5667 (class 2606 OID 2380163)
-- Name: itemcupomfiscal itemcupomfiscal_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemcupomfiscal
    ADD CONSTRAINT itemcupomfiscal_pkey PRIMARY KEY (id);


--
-- TOC entry 5675 (class 2606 OID 2380165)
-- Name: itemusoconsumo itemusoconsumo_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemusoconsumo
    ADD CONSTRAINT itemusoconsumo_pkey PRIMARY KEY (id);


--
-- TOC entry 5679 (class 2606 OID 2380167)
-- Name: numeroduplicata numeroduplicata_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.numeroduplicata
    ADD CONSTRAINT numeroduplicata_pkey PRIMARY KEY (id);


--
-- TOC entry 5683 (class 2606 OID 2380169)
-- Name: produtoauxiliarvenda produtoauxiliarvenda_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.produtoauxiliarvenda
    ADD CONSTRAINT produtoauxiliarvenda_pkey PRIMARY KEY (id);


--
-- TOC entry 5691 (class 2606 OID 2380171)
-- Name: satfiscal satfiscal_pkey; Type: CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.satfiscal
    ADD CONSTRAINT satfiscal_pkey PRIMARY KEY (id);


--
-- TOC entry 5693 (class 2606 OID 2380173)
-- Name: autorizacaoxml autorizacaoxml_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.autorizacaoxml
    ADD CONSTRAINT autorizacaoxml_pkey PRIMARY KEY (id);


--
-- TOC entry 5696 (class 2606 OID 2380175)
-- Name: averbacaoseguromdfe averbacaoseguromdfe_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.averbacaoseguromdfe
    ADD CONSTRAINT averbacaoseguromdfe_pkey PRIMARY KEY (id);


--
-- TOC entry 5700 (class 2606 OID 2380177)
-- Name: documentofiscalmanifesto documentofiscalmanifesto_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.documentofiscalmanifesto
    ADD CONSTRAINT documentofiscalmanifesto_pkey PRIMARY KEY (id);


--
-- TOC entry 5702 (class 2606 OID 2380179)
-- Name: documentosfiscais documentosfiscais_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.documentosfiscais
    ADD CONSTRAINT documentosfiscais_pkey PRIMARY KEY (id);


--
-- TOC entry 5705 (class 2606 OID 2380181)
-- Name: embarcacaocomboio embarcacaocomboio_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.embarcacaocomboio
    ADD CONSTRAINT embarcacaocomboio_pkey PRIMARY KEY (id);


--
-- TOC entry 5708 (class 2606 OID 2380183)
-- Name: informacoesciotmdfe informacoesciotmdfe_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.informacoesciotmdfe
    ADD CONSTRAINT informacoesciotmdfe_pkey PRIMARY KEY (id);


--
-- TOC entry 5711 (class 2606 OID 2380185)
-- Name: informacoescontratantemdfe informacoescontratantemdfe_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.informacoescontratantemdfe
    ADD CONSTRAINT informacoescontratantemdfe_pkey PRIMARY KEY (id);


--
-- TOC entry 5714 (class 2606 OID 2380187)
-- Name: informacoesseguradoramdfe informacoesseguradoramdfe_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.informacoesseguradoramdfe
    ADD CONSTRAINT informacoesseguradoramdfe_pkey PRIMARY KEY (id);


--
-- TOC entry 5719 (class 2606 OID 2380189)
-- Name: lacresmdfe lacresmdfe_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.lacresmdfe
    ADD CONSTRAINT lacresmdfe_pkey PRIMARY KEY (id);


--
-- TOC entry 5722 (class 2606 OID 2380191)
-- Name: lacresunidadecarga lacresunidadecarga_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.lacresunidadecarga
    ADD CONSTRAINT lacresunidadecarga_pkey PRIMARY KEY (id);


--
-- TOC entry 5724 (class 2606 OID 2380193)
-- Name: lacresunidadetransporte lacresunidadetransporte_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.lacresunidadetransporte
    ADD CONSTRAINT lacresunidadetransporte_pkey PRIMARY KEY (id);


--
-- TOC entry 5734 (class 2606 OID 2380195)
-- Name: manifesto manifesto_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.manifesto
    ADD CONSTRAINT manifesto_pkey PRIMARY KEY (id);


--
-- TOC entry 5737 (class 2606 OID 2380197)
-- Name: modalaereo modalaereo_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.modalaereo
    ADD CONSTRAINT modalaereo_pkey PRIMARY KEY (id);


--
-- TOC entry 5740 (class 2606 OID 2380199)
-- Name: modalaquaviario modalaquaviario_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.modalaquaviario
    ADD CONSTRAINT modalaquaviario_pkey PRIMARY KEY (id);


--
-- TOC entry 5743 (class 2606 OID 2380201)
-- Name: modalferroviario modalferroviario_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.modalferroviario
    ADD CONSTRAINT modalferroviario_pkey PRIMARY KEY (id);


--
-- TOC entry 5747 (class 2606 OID 2380203)
-- Name: modalrodoviariomdfe modalrodoviariomdfe_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.modalrodoviariomdfe
    ADD CONSTRAINT modalrodoviariomdfe_pkey PRIMARY KEY (id);


--
-- TOC entry 5751 (class 2606 OID 2380205)
-- Name: municipiocarregamento municipiocarregamento_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.municipiocarregamento
    ADD CONSTRAINT municipiocarregamento_pkey PRIMARY KEY (id);


--
-- TOC entry 5754 (class 2606 OID 2380207)
-- Name: municipiodescarregamento municipiodescarregamento_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.municipiodescarregamento
    ADD CONSTRAINT municipiodescarregamento_pkey PRIMARY KEY (id);


--
-- TOC entry 5759 (class 2606 OID 2380209)
-- Name: percursomanifesto percursomanifesto_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.percursomanifesto
    ADD CONSTRAINT percursomanifesto_pkey PRIMARY KEY (id);


--
-- TOC entry 5762 (class 2606 OID 2380211)
-- Name: seguromdfe seguromdfe_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.seguromdfe
    ADD CONSTRAINT seguromdfe_pkey PRIMARY KEY (id);


--
-- TOC entry 5765 (class 2606 OID 2380213)
-- Name: terminalcarregamento terminalcarregamento_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.terminalcarregamento
    ADD CONSTRAINT terminalcarregamento_pkey PRIMARY KEY (id);


--
-- TOC entry 5767 (class 2606 OID 2380215)
-- Name: terminaldescarregamento terminaldescarregamento_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.terminaldescarregamento
    ADD CONSTRAINT terminaldescarregamento_pkey PRIMARY KEY (id);


--
-- TOC entry 5771 (class 2606 OID 2380217)
-- Name: unidadecarga unidadecarga_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.unidadecarga
    ADD CONSTRAINT unidadecarga_pkey PRIMARY KEY (id);


--
-- TOC entry 5773 (class 2606 OID 2380219)
-- Name: unidadecargaaquaviario unidadecargaaquaviario_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.unidadecargaaquaviario
    ADD CONSTRAINT unidadecargaaquaviario_pkey PRIMARY KEY (id);


--
-- TOC entry 5776 (class 2606 OID 2380221)
-- Name: unidadetransporte unidadetransporte_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.unidadetransporte
    ADD CONSTRAINT unidadetransporte_pkey PRIMARY KEY (id);


--
-- TOC entry 5780 (class 2606 OID 2380223)
-- Name: vagaotrem vagaotrem_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.vagaotrem
    ADD CONSTRAINT vagaotrem_pkey PRIMARY KEY (id);


--
-- TOC entry 5783 (class 2606 OID 2380225)
-- Name: valepedagio valepedagio_pkey; Type: CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.valepedagio
    ADD CONSTRAINT valepedagio_pkey PRIMARY KEY (id);


--
-- TOC entry 5785 (class 2606 OID 2380227)
-- Name: adicao adicao_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.adicao
    ADD CONSTRAINT adicao_pkey PRIMARY KEY (id);


--
-- TOC entry 5788 (class 2606 OID 2380229)
-- Name: auxiliarservico auxiliarservico_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.auxiliarservico
    ADD CONSTRAINT auxiliarservico_pkey PRIMARY KEY (id);


--
-- TOC entry 5796 (class 2606 OID 2380231)
-- Name: cartacorrecao cartacorrecao_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.cartacorrecao
    ADD CONSTRAINT cartacorrecao_pkey PRIMARY KEY (id);


--
-- TOC entry 5801 (class 2606 OID 2380233)
-- Name: certificadodigital certificadodigital_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.certificadodigital
    ADD CONSTRAINT certificadodigital_pkey PRIMARY KEY (id);


--
-- TOC entry 5804 (class 2606 OID 2380235)
-- Name: chaveacessoreferenciada chaveacessoreferenciada_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.chaveacessoreferenciada
    ADD CONSTRAINT chaveacessoreferenciada_pkey PRIMARY KEY (id);


--
-- TOC entry 5807 (class 2606 OID 2380237)
-- Name: custonfe custonfe_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.custonfe
    ADD CONSTRAINT custonfe_pkey PRIMARY KEY (id);


--
-- TOC entry 5812 (class 2606 OID 2380239)
-- Name: declaracaoexportacao declaracaoexportacao_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.declaracaoexportacao
    ADD CONSTRAINT declaracaoexportacao_pkey PRIMARY KEY (id);


--
-- TOC entry 5815 (class 2606 OID 2380241)
-- Name: declaracaoimportacao declaracaoimportacao_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.declaracaoimportacao
    ADD CONSTRAINT declaracaoimportacao_pkey PRIMARY KEY (id);


--
-- TOC entry 5818 (class 2606 OID 2380243)
-- Name: duplicatanota duplicatanota_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.duplicatanota
    ADD CONSTRAINT duplicatanota_pkey PRIMARY KEY (id);


--
-- TOC entry 5824 (class 2606 OID 2380245)
-- Name: duplicatapaganota duplicatapaganota_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.duplicatapaganota
    ADD CONSTRAINT duplicatapaganota_pkey PRIMARY KEY (id);


--
-- TOC entry 5829 (class 2606 OID 2380247)
-- Name: especievolume especievolume_descricao_key; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.especievolume
    ADD CONSTRAINT especievolume_descricao_key UNIQUE (descricao);


--
-- TOC entry 5831 (class 2606 OID 2380249)
-- Name: especievolume especievolume_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.especievolume
    ADD CONSTRAINT especievolume_pkey PRIMARY KEY (id);


--
-- TOC entry 5833 (class 2606 OID 2380251)
-- Name: formapagamentoauxiliarservico formapagamentoauxiliarservico_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentoauxiliarservico
    ADD CONSTRAINT formapagamentoauxiliarservico_pkey PRIMARY KEY (id);


--
-- TOC entry 5840 (class 2606 OID 2380253)
-- Name: formapagamentonf formapagamentonf_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonf
    ADD CONSTRAINT formapagamentonf_pkey PRIMARY KEY (id);


--
-- TOC entry 5848 (class 2606 OID 2380255)
-- Name: formapagamentonfc formapagamentonfc_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonfc
    ADD CONSTRAINT formapagamentonfc_pkey PRIMARY KEY (id);


--
-- TOC entry 5854 (class 2606 OID 2380257)
-- Name: formapagamentonfs formapagamentonfs_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonfs
    ADD CONSTRAINT formapagamentonfs_pkey PRIMARY KEY (id);


--
-- TOC entry 5864 (class 2606 OID 2380259)
-- Name: itemauxiliarservico itemauxiliarservico_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemauxiliarservico
    ADD CONSTRAINT itemauxiliarservico_pkey PRIMARY KEY (id);


--
-- TOC entry 5868 (class 2606 OID 2380261)
-- Name: itemnotafiscal itemnotafiscal_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscal
    ADD CONSTRAINT itemnotafiscal_pkey PRIMARY KEY (id);


--
-- TOC entry 5879 (class 2606 OID 2380263)
-- Name: itemnotafiscalconsumidor itemnotafiscalconsumidor_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalconsumidor
    ADD CONSTRAINT itemnotafiscalconsumidor_pkey PRIMARY KEY (id);


--
-- TOC entry 5887 (class 2606 OID 2380265)
-- Name: itemnotafiscalservico itemnotafiscalservico_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalservico
    ADD CONSTRAINT itemnotafiscalservico_pkey PRIMARY KEY (id);


--
-- TOC entry 5893 (class 2606 OID 2380267)
-- Name: itemorcamento itemorcamento_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemorcamento
    ADD CONSTRAINT itemorcamento_pkey PRIMARY KEY (id);


--
-- TOC entry 5898 (class 2606 OID 2380269)
-- Name: lancamentocustonfe lancamentocustonfe_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.lancamentocustonfe
    ADD CONSTRAINT lancamentocustonfe_pkey PRIMARY KEY (id);


--
-- TOC entry 5900 (class 2606 OID 2380271)
-- Name: lotenfce lotenfce_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.lotenfce
    ADD CONSTRAINT lotenfce_pkey PRIMARY KEY (id);


--
-- TOC entry 5902 (class 2606 OID 2380273)
-- Name: lotenfe lotenfe_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.lotenfe
    ADD CONSTRAINT lotenfe_pkey PRIMARY KEY (id);


--
-- TOC entry 5908 (class 2606 OID 2380275)
-- Name: lotenfse lotenfse_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.lotenfse
    ADD CONSTRAINT lotenfse_pkey PRIMARY KEY (id);


--
-- TOC entry 5911 (class 2606 OID 2380277)
-- Name: manifestacaodestinatario manifestacaodestinatario_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.manifestacaodestinatario
    ADD CONSTRAINT manifestacaodestinatario_pkey PRIMARY KEY (id);


--
-- TOC entry 5932 (class 2606 OID 2380279)
-- Name: notafiscal notafiscal_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscal
    ADD CONSTRAINT notafiscal_pkey PRIMARY KEY (serie, empresaid, ambiente, tipofaturamento, numero);


--
-- TOC entry 5951 (class 2606 OID 2380281)
-- Name: notafiscalconsumidor notafiscalconsumidor_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT notafiscalconsumidor_pkey PRIMARY KEY (id);


--
-- TOC entry 5965 (class 2606 OID 2380283)
-- Name: notafiscalservico notafiscalservico_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalservico
    ADD CONSTRAINT notafiscalservico_pkey PRIMARY KEY (id);


--
-- TOC entry 5967 (class 2606 OID 2380285)
-- Name: notaprodutorruralreferenciada notaprodutorruralreferenciada_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notaprodutorruralreferenciada
    ADD CONSTRAINT notaprodutorruralreferenciada_pkey PRIMARY KEY (id);


--
-- TOC entry 5972 (class 2606 OID 2380287)
-- Name: obscontribuintenfe obscontribuintenfe_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.obscontribuintenfe
    ADD CONSTRAINT obscontribuintenfe_pkey PRIMARY KEY (id);


--
-- TOC entry 5981 (class 2606 OID 2380289)
-- Name: orcamento orcamento_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.orcamento
    ADD CONSTRAINT orcamento_pkey PRIMARY KEY (id);


--
-- TOC entry 5983 (class 2606 OID 2380291)
-- Name: serie serie_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.serie
    ADD CONSTRAINT serie_pkey PRIMARY KEY (id);


--
-- TOC entry 5985 (class 2606 OID 2380293)
-- Name: serie serie_serie_key; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.serie
    ADD CONSTRAINT serie_serie_key UNIQUE (serie);


--
-- TOC entry 5988 (class 2606 OID 2380295)
-- Name: transportador transportador_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.transportador
    ADD CONSTRAINT transportador_pkey PRIMARY KEY (id);


--
-- TOC entry 5992 (class 2606 OID 2380297)
-- Name: veiculo veiculo_pkey; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.veiculo
    ADD CONSTRAINT veiculo_pkey PRIMARY KEY (id);


--
-- TOC entry 5994 (class 2606 OID 2380299)
-- Name: veiculo veiculo_placa_key; Type: CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.veiculo
    ADD CONSTRAINT veiculo_placa_key UNIQUE (placa);


--
-- TOC entry 5997 (class 2606 OID 2380301)
-- Name: adiantamentoordemservico adiantamentoordemservico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adiantamentoordemservico
    ADD CONSTRAINT adiantamentoordemservico_pkey PRIMARY KEY (id);


--
-- TOC entry 6004 (class 2606 OID 2380303)
-- Name: adicionalitemdelivery adicionalitemdelivery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalitemdelivery
    ADD CONSTRAINT adicionalitemdelivery_pkey PRIMARY KEY (id);


--
-- TOC entry 6009 (class 2606 OID 2380305)
-- Name: adicionalproduto adicionalproduto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalproduto
    ADD CONSTRAINT adicionalproduto_pkey PRIMARY KEY (id);


--
-- TOC entry 6017 (class 2606 OID 2380307)
-- Name: adicionalprodutocontrole adicionalprodutocontrole_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalprodutocontrole
    ADD CONSTRAINT adicionalprodutocontrole_pkey PRIMARY KEY (id);


--
-- TOC entry 6025 (class 2606 OID 2380309)
-- Name: anexo anexo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT anexo_pkey PRIMARY KEY (id);


--
-- TOC entry 6030 (class 2606 OID 2380311)
-- Name: anotacaopedido anotacaopedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anotacaopedido
    ADD CONSTRAINT anotacaopedido_pkey PRIMARY KEY (id);


--
-- TOC entry 6036 (class 2606 OID 2380313)
-- Name: atalhobarraferramentas atalhobarraferramentas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atalhobarraferramentas
    ADD CONSTRAINT atalhobarraferramentas_pkey PRIMARY KEY (id);


--
-- TOC entry 6040 (class 2606 OID 2380315)
-- Name: auditoria auditoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria
    ADD CONSTRAINT auditoria_pkey PRIMARY KEY (id);


--
-- TOC entry 6042 (class 2606 OID 2380317)
-- Name: backup backup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.backup
    ADD CONSTRAINT backup_pkey PRIMARY KEY (id);


--
-- TOC entry 6047 (class 2606 OID 2380319)
-- Name: balanca balanca_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balanca
    ADD CONSTRAINT balanca_pkey PRIMARY KEY (id);


--
-- TOC entry 6053 (class 2606 OID 2380321)
-- Name: beneficiofiscal beneficiofiscal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficiofiscal
    ADD CONSTRAINT beneficiofiscal_pkey PRIMARY KEY (id);


--
-- TOC entry 6058 (class 2606 OID 2380323)
-- Name: cadastrofacillancado cadastrofacillancado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cadastrofacillancado
    ADD CONSTRAINT cadastrofacillancado_pkey PRIMARY KEY (id);


--
-- TOC entry 6063 (class 2606 OID 2380325)
-- Name: caixa caixa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caixa
    ADD CONSTRAINT caixa_pkey PRIMARY KEY (id);


--
-- TOC entry 6068 (class 2606 OID 2380327)
-- Name: campoadicional campoadicional_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campoadicional
    ADD CONSTRAINT campoadicional_pkey PRIMARY KEY (id);


--
-- TOC entry 6070 (class 2606 OID 2380329)
-- Name: camposadicionaiscliente camposadicionaiscliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camposadicionaiscliente
    ADD CONSTRAINT camposadicionaiscliente_pkey PRIMARY KEY (id);


--
-- TOC entry 6073 (class 2606 OID 2380331)
-- Name: cest cest_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cest
    ADD CONSTRAINT cest_pkey PRIMARY KEY (id);


--
-- TOC entry 6079 (class 2606 OID 2380333)
-- Name: cfop cfop_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cfop
    ADD CONSTRAINT cfop_pkey PRIMARY KEY (id);


--
-- TOC entry 6090 (class 2606 OID 2380335)
-- Name: clientefornecedor_camposadicionaiscliente clientefornecedor_camposadicionaiscliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedor_camposadicionaiscliente
    ADD CONSTRAINT clientefornecedor_camposadicionaiscliente_pkey PRIMARY KEY (clientefornecedor_id, camposadicionais_id);


--
-- TOC entry 6094 (class 2606 OID 2380337)
-- Name: clientefornecedor_historicoclientefornecedor clientefornecedor_historicoclientefornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedor_historicoclientefornecedor
    ADD CONSTRAINT clientefornecedor_historicoclientefornecedor_pkey PRIMARY KEY (clientefornecedor_id, historicos_id);


--
-- TOC entry 6083 (class 2606 OID 2380339)
-- Name: clientefornecedor clientefornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedor
    ADD CONSTRAINT clientefornecedor_pkey PRIMARY KEY (id);


--
-- TOC entry 6098 (class 2606 OID 2380341)
-- Name: clientefornecedortabelapreco clientefornecedortabelapreco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedortabelapreco
    ADD CONSTRAINT clientefornecedortabelapreco_pkey PRIMARY KEY (id);


--
-- TOC entry 6104 (class 2606 OID 2380343)
-- Name: cnae cnae_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cnae
    ADD CONSTRAINT cnae_pkey PRIMARY KEY (id);


--
-- TOC entry 6107 (class 2606 OID 2380345)
-- Name: compromisso compromisso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compromisso
    ADD CONSTRAINT compromisso_pkey PRIMARY KEY (id);


--
-- TOC entry 6110 (class 2606 OID 2380347)
-- Name: compromisso_usuario compromisso_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compromisso_usuario
    ADD CONSTRAINT compromisso_usuario_pkey PRIMARY KEY (compromisso_id, usuarios_id);


--
-- TOC entry 6123 (class 2606 OID 2380349)
-- Name: conhecimentotransportedocumentoref_nfconhecimentotransportedocr conhecimentotransportedocumentoref_nfconhecimentotransport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conhecimentotransportedocumentoref_nfconhecimentotransportedocr
    ADD CONSTRAINT conhecimentotransportedocumentoref_nfconhecimentotransport_pkey PRIMARY KEY (conhecimentotransportedocumentoref_id, notastransportadas_id);


--
-- TOC entry 6119 (class 2606 OID 2380351)
-- Name: conhecimentotransportedocumentoref conhecimentotransportedocumentoref_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conhecimentotransportedocumentoref
    ADD CONSTRAINT conhecimentotransportedocumentoref_pkey PRIMARY KEY (id);


--
-- TOC entry 6125 (class 2606 OID 2380353)
-- Name: conta conta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conta
    ADD CONSTRAINT conta_pkey PRIMARY KEY (id);


--
-- TOC entry 6127 (class 2606 OID 2380355)
-- Name: contador contador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contador
    ADD CONSTRAINT contador_pkey PRIMARY KEY (id);


--
-- TOC entry 6131 (class 2606 OID 2380357)
-- Name: contato contato_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contato
    ADD CONSTRAINT contato_pkey PRIMARY KEY (id);


--
-- TOC entry 6139 (class 2606 OID 2380359)
-- Name: contatoadicional contatoadicional_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contatoadicional
    ADD CONSTRAINT contatoadicional_pkey PRIMARY KEY (id);


--
-- TOC entry 6142 (class 2606 OID 2380361)
-- Name: cotacao cotacao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cotacao
    ADD CONSTRAINT cotacao_pkey PRIMARY KEY (id);


--
-- TOC entry 6149 (class 2606 OID 2380363)
-- Name: creditocliente creditocliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creditocliente
    ADD CONSTRAINT creditocliente_pkey PRIMARY KEY (id);


--
-- TOC entry 6153 (class 2606 OID 2380365)
-- Name: cst cst_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cst
    ADD CONSTRAINT cst_pkey PRIMARY KEY (id);


--
-- TOC entry 6160 (class 2606 OID 2380367)
-- Name: delivery delivery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_pkey PRIMARY KEY (id);


--
-- TOC entry 6172 (class 2606 OID 2380369)
-- Name: departamento departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (id);


--
-- TOC entry 6176 (class 2606 OID 2380371)
-- Name: dependente dependente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dependente
    ADD CONSTRAINT dependente_pkey PRIMARY KEY (id);


--
-- TOC entry 6181 (class 2606 OID 2380373)
-- Name: devolucaotrocaproduto devolucaotrocaproduto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devolucaotrocaproduto
    ADD CONSTRAINT devolucaotrocaproduto_pkey PRIMARY KEY (id);


--
-- TOC entry 6190 (class 2606 OID 2380375)
-- Name: documentofiscal documentofiscal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentofiscal
    ADD CONSTRAINT documentofiscal_pkey PRIMARY KEY (id);


--
-- TOC entry 6205 (class 2606 OID 2380377)
-- Name: duplicatanotaentrada duplicatanotaentrada_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.duplicatanotaentrada
    ADD CONSTRAINT duplicatanotaentrada_pkey PRIMARY KEY (id);


--
-- TOC entry 6208 (class 2606 OID 2380379)
-- Name: emailsbackup emailsbackup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emailsbackup
    ADD CONSTRAINT emailsbackup_pkey PRIMARY KEY (id);


--
-- TOC entry 6213 (class 2606 OID 2380381)
-- Name: empresa empresa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_pkey PRIMARY KEY (id);


--
-- TOC entry 6217 (class 2606 OID 2380383)
-- Name: endereco endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- TOC entry 6221 (class 2606 OID 2380385)
-- Name: entregador entregador_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entregador
    ADD CONSTRAINT entregador_nome_key UNIQUE (nome);


--
-- TOC entry 6223 (class 2606 OID 2380387)
-- Name: entregador entregador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entregador
    ADD CONSTRAINT entregador_pkey PRIMARY KEY (id);


--
-- TOC entry 6227 (class 2606 OID 2380389)
-- Name: equipamento equipamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipamento
    ADD CONSTRAINT equipamento_pkey PRIMARY KEY (id);


--
-- TOC entry 6235 (class 2606 OID 2380391)
-- Name: estado estado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estado
    ADD CONSTRAINT estado_pkey PRIMARY KEY (id);


--
-- TOC entry 6240 (class 2606 OID 2380393)
-- Name: fatorconversaofornecedor fatorconversaofornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fatorconversaofornecedor
    ADD CONSTRAINT fatorconversaofornecedor_pkey PRIMARY KEY (id);


--
-- TOC entry 6243 (class 2606 OID 2380395)
-- Name: faturamentomensal faturamentomensal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faturamentomensal
    ADD CONSTRAINT faturamentomensal_pkey PRIMARY KEY (id);


--
-- TOC entry 6250 (class 2606 OID 2380397)
-- Name: formapagamentodelivery formapagamentodelivery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodelivery
    ADD CONSTRAINT formapagamentodelivery_pkey PRIMARY KEY (id);


--
-- TOC entry 6257 (class 2606 OID 2380399)
-- Name: formapagamentodevolucaoproduto formapagamentodevolucaoproduto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodevolucaoproduto
    ADD CONSTRAINT formapagamentodevolucaoproduto_pkey PRIMARY KEY (id);


--
-- TOC entry 6264 (class 2606 OID 2380401)
-- Name: formapagamentodocumentofiscal formapagamentodocumentofiscal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodocumentofiscal
    ADD CONSTRAINT formapagamentodocumentofiscal_pkey PRIMARY KEY (id);


--
-- TOC entry 6267 (class 2606 OID 2380403)
-- Name: formapagamentoordemservico formapagamentoordemservico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentoordemservico
    ADD CONSTRAINT formapagamentoordemservico_pkey PRIMARY KEY (id);


--
-- TOC entry 6272 (class 2606 OID 2380405)
-- Name: formapagamentopedido formapagamentopedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentopedido
    ADD CONSTRAINT formapagamentopedido_pkey PRIMARY KEY (id);


--
-- TOC entry 6278 (class 2606 OID 2380407)
-- Name: fornecimentoconsumo fornecimentoconsumo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecimentoconsumo
    ADD CONSTRAINT fornecimentoconsumo_pkey PRIMARY KEY (id);


--
-- TOC entry 6280 (class 2606 OID 2380409)
-- Name: funcionario funcionario_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_nome_key UNIQUE (nome);


--
-- TOC entry 6282 (class 2606 OID 2380411)
-- Name: funcionario funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (id);


--
-- TOC entry 6288 (class 2606 OID 2380413)
-- Name: grupodespesareceita grupodespesareceita_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupodespesareceita
    ADD CONSTRAINT grupodespesareceita_pkey PRIMARY KEY (id);


--
-- TOC entry 6291 (class 2606 OID 2380415)
-- Name: grupoimpressao grupoimpressao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupoimpressao
    ADD CONSTRAINT grupoimpressao_pkey PRIMARY KEY (id);


--
-- TOC entry 6296 (class 2606 OID 2380417)
-- Name: historicoclientefornecedor historicoclientefornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoclientefornecedor
    ADD CONSTRAINT historicoclientefornecedor_pkey PRIMARY KEY (id);


--
-- TOC entry 6298 (class 2606 OID 2380419)
-- Name: historicoconexaocaixa historicoconexaocaixa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoconexaocaixa
    ADD CONSTRAINT historicoconexaocaixa_pkey PRIMARY KEY (id);


--
-- TOC entry 6303 (class 2606 OID 2380421)
-- Name: historicodescricaoproduto historicodescricaoproduto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicodescricaoproduto
    ADD CONSTRAINT historicodescricaoproduto_pkey PRIMARY KEY (id);


--
-- TOC entry 6306 (class 2606 OID 2380423)
-- Name: historicointegracaoproduto historicointegracaoproduto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicointegracaoproduto
    ADD CONSTRAINT historicointegracaoproduto_pkey PRIMARY KEY (id);


--
-- TOC entry 6310 (class 2606 OID 2380425)
-- Name: historicoprecocompraproduto historicoprecocompraproduto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoprecocompraproduto
    ADD CONSTRAINT historicoprecocompraproduto_pkey PRIMARY KEY (id);


--
-- TOC entry 6318 (class 2606 OID 2380427)
-- Name: historicoprecovendaproduto historicoprecovendaproduto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoprecovendaproduto
    ADD CONSTRAINT historicoprecovendaproduto_pkey PRIMARY KEY (id);


--
-- TOC entry 6325 (class 2606 OID 2380429)
-- Name: imagemequipamento imagemequipamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagemequipamento
    ADD CONSTRAINT imagemequipamento_pkey PRIMARY KEY (id);


--
-- TOC entry 6331 (class 2606 OID 2380431)
-- Name: impressaoetiqueta impressaoetiqueta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.impressaoetiqueta
    ADD CONSTRAINT impressaoetiqueta_pkey PRIMARY KEY (id);


--
-- TOC entry 6336 (class 2606 OID 2380433)
-- Name: informacaonutricional informacaonutricional_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.informacaonutricional
    ADD CONSTRAINT informacaonutricional_pkey PRIMARY KEY (id);


--
-- TOC entry 6342 (class 2606 OID 2380435)
-- Name: informacaonutricionalextra informacaonutricionalextra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.informacaonutricionalextra
    ADD CONSTRAINT informacaonutricionalextra_pkey PRIMARY KEY (id);


--
-- TOC entry 6345 (class 2606 OID 2380437)
-- Name: inutilizacao inutilizacao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inutilizacao
    ADD CONSTRAINT inutilizacao_pkey PRIMARY KEY (id);


--
-- TOC entry 6350 (class 2606 OID 2380439)
-- Name: itemdelivery itemdelivery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdelivery
    ADD CONSTRAINT itemdelivery_pkey PRIMARY KEY (id);


--
-- TOC entry 6356 (class 2606 OID 2380441)
-- Name: itemdevolucaotroca itemdevolucaotroca_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdevolucaotroca
    ADD CONSTRAINT itemdevolucaotroca_pkey PRIMARY KEY (id);


--
-- TOC entry 6362 (class 2606 OID 2380443)
-- Name: itemdocumentofiscal itemdocumentofiscal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdocumentofiscal
    ADD CONSTRAINT itemdocumentofiscal_pkey PRIMARY KEY (id);


--
-- TOC entry 6374 (class 2606 OID 2380445)
-- Name: itemgrupoimpressao itemgrupoimpressao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemgrupoimpressao
    ADD CONSTRAINT itemgrupoimpressao_pkey PRIMARY KEY (id);


--
-- TOC entry 6379 (class 2606 OID 2380447)
-- Name: itemkitproduto itemkitproduto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemkitproduto
    ADD CONSTRAINT itemkitproduto_pkey PRIMARY KEY (id);


--
-- TOC entry 6386 (class 2606 OID 2380449)
-- Name: itemnotafiscalentrada itemnotafiscalentrada_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemnotafiscalentrada
    ADD CONSTRAINT itemnotafiscalentrada_pkey PRIMARY KEY (id);


--
-- TOC entry 6392 (class 2606 OID 2380451)
-- Name: itemordemservico itemordemservico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemordemservico
    ADD CONSTRAINT itemordemservico_pkey PRIMARY KEY (id);


--
-- TOC entry 6396 (class 2606 OID 2380453)
-- Name: itempedido itempedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itempedido
    ADD CONSTRAINT itempedido_pkey PRIMARY KEY (id);


--
-- TOC entry 6401 (class 2606 OID 2380455)
-- Name: itempedidocompra itempedidocompra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itempedidocompra
    ADD CONSTRAINT itempedidocompra_pkey PRIMARY KEY (id);


--
-- TOC entry 6409 (class 2606 OID 2380457)
-- Name: kitproduto kitproduto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kitproduto
    ADD CONSTRAINT kitproduto_pkey PRIMARY KEY (id);


--
-- TOC entry 6417 (class 2606 OID 2380459)
-- Name: liquidacaoproduto liquidacaoproduto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidacaoproduto
    ADD CONSTRAINT liquidacaoproduto_pkey PRIMARY KEY (id);


--
-- TOC entry 6419 (class 2606 OID 2380461)
-- Name: liquidacaoproduto_produto liquidacaoproduto_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidacaoproduto_produto
    ADD CONSTRAINT liquidacaoproduto_produto_pkey PRIMARY KEY (liquidacaoproduto_id, produtos_id);


--
-- TOC entry 6426 (class 2606 OID 2380463)
-- Name: maquinacartao maquinacartao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maquinacartao
    ADD CONSTRAINT maquinacartao_pkey PRIMARY KEY (id);


--
-- TOC entry 6432 (class 2606 OID 2380465)
-- Name: marca marca_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marca
    ADD CONSTRAINT marca_pkey PRIMARY KEY (id);


--
-- TOC entry 6436 (class 2606 OID 2380467)
-- Name: modalrodoviariomdfe_motorista modalrodoviariomdfe_motorista_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modalrodoviariomdfe_motorista
    ADD CONSTRAINT modalrodoviariomdfe_motorista_pkey PRIMARY KEY (modalrodoviariomdfe_id, condutor_id);


--
-- TOC entry 6440 (class 2606 OID 2380469)
-- Name: modalrodoviariomdfe_valepedagio modalrodoviariomdfe_valepedagio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modalrodoviariomdfe_valepedagio
    ADD CONSTRAINT modalrodoviariomdfe_valepedagio_pkey PRIMARY KEY (modalrodoviariomdfe_id, valepedagio_id);


--
-- TOC entry 6444 (class 2606 OID 2380471)
-- Name: modalrodoviariomdfe_veiculo modalrodoviariomdfe_veiculo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modalrodoviariomdfe_veiculo
    ADD CONSTRAINT modalrodoviariomdfe_veiculo_pkey PRIMARY KEY (modalrodoviariomdfe_id, veiculoreboque_id);


--
-- TOC entry 6447 (class 2606 OID 2380473)
-- Name: modulo modulo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modulo
    ADD CONSTRAINT modulo_pkey PRIMARY KEY (id);


--
-- TOC entry 6452 (class 2606 OID 2380475)
-- Name: moeda moeda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moeda
    ADD CONSTRAINT moeda_pkey PRIMARY KEY (id);


--
-- TOC entry 6456 (class 2606 OID 2380477)
-- Name: motorista_veiculo motorista_veiculo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motorista_veiculo
    ADD CONSTRAINT motorista_veiculo_pkey PRIMARY KEY (motorista_id, veiculosvinculado_id);


--
-- TOC entry 6463 (class 2606 OID 2380479)
-- Name: movimentacaocaixa movimentacaocaixa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocaixa
    ADD CONSTRAINT movimentacaocaixa_pkey PRIMARY KEY (id);


--
-- TOC entry 6465 (class 2606 OID 2380481)
-- Name: movimentacaocreditoentrada movimentacaocreditoentrada_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditoentrada
    ADD CONSTRAINT movimentacaocreditoentrada_pkey PRIMARY KEY (id);


--
-- TOC entry 6474 (class 2606 OID 2380483)
-- Name: movimentacaocreditosaida movimentacaocreditosaida_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditosaida
    ADD CONSTRAINT movimentacaocreditosaida_pkey PRIMARY KEY (id);


--
-- TOC entry 6490 (class 2606 OID 2380485)
-- Name: movimentoestoque movimentoestoque_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentoestoque
    ADD CONSTRAINT movimentoestoque_pkey PRIMARY KEY (id);


--
-- TOC entry 6494 (class 2606 OID 2380487)
-- Name: municipio municipio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT municipio_pkey PRIMARY KEY (id);


--
-- TOC entry 6496 (class 2606 OID 2380489)
-- Name: natureza natureza_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.natureza
    ADD CONSTRAINT natureza_pkey PRIMARY KEY (id);


--
-- TOC entry 6501 (class 2606 OID 2380491)
-- Name: ncm ncm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ncm
    ADD CONSTRAINT ncm_pkey PRIMARY KEY (id);


--
-- TOC entry 6504 (class 2606 OID 2380493)
-- Name: nfconhecimentotransportedocreferenciado nfconhecimentotransportedocreferenciado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nfconhecimentotransportedocreferenciado
    ADD CONSTRAINT nfconhecimentotransportedocreferenciado_pkey PRIMARY KEY (id);


--
-- TOC entry 6510 (class 2606 OID 2380495)
-- Name: notadestinada notadestinada_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notadestinada
    ADD CONSTRAINT notadestinada_pkey PRIMARY KEY (id);


--
-- TOC entry 6520 (class 2606 OID 2380497)
-- Name: notafiscalentrada notafiscalentrada_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notafiscalentrada
    ADD CONSTRAINT notafiscalentrada_pkey PRIMARY KEY (id);


--
-- TOC entry 6529 (class 2606 OID 2380499)
-- Name: ordemservico ordemservico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordemservico
    ADD CONSTRAINT ordemservico_pkey PRIMARY KEY (id);


--
-- TOC entry 6532 (class 2606 OID 2380501)
-- Name: pais pais_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pais
    ADD CONSTRAINT pais_pkey PRIMARY KEY (id);


--
-- TOC entry 6534 (class 2606 OID 2380503)
-- Name: papel papel_descricao_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.papel
    ADD CONSTRAINT papel_descricao_key UNIQUE (descricao);


--
-- TOC entry 6536 (class 2606 OID 2380505)
-- Name: papel papel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.papel
    ADD CONSTRAINT papel_pkey PRIMARY KEY (id);


--
-- TOC entry 6538 (class 2606 OID 2380507)
-- Name: parametrobackup parametrobackup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrobackup
    ADD CONSTRAINT parametrobackup_pkey PRIMARY KEY (id);


--
-- TOC entry 6542 (class 2606 OID 2380509)
-- Name: parametrobeneficiofiscal parametrobeneficiofiscal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrobeneficiofiscal
    ADD CONSTRAINT parametrobeneficiofiscal_pkey PRIMARY KEY (id);


--
-- TOC entry 6547 (class 2606 OID 2380511)
-- Name: parametrocadastro parametrocadastro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrocadastro
    ADD CONSTRAINT parametrocadastro_pkey PRIMARY KEY (id);


--
-- TOC entry 6551 (class 2606 OID 2380513)
-- Name: parametrofechamentocaixa parametrofechamentocaixa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrofechamentocaixa
    ADD CONSTRAINT parametrofechamentocaixa_pkey PRIMARY KEY (id);


--
-- TOC entry 6554 (class 2606 OID 2380515)
-- Name: parametroformapagamento parametroformapagamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroformapagamento
    ADD CONSTRAINT parametroformapagamento_pkey PRIMARY KEY (id);


--
-- TOC entry 6560 (class 2606 OID 2380517)
-- Name: parametroicms parametroicms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroicms
    ADD CONSTRAINT parametroicms_pkey PRIMARY KEY (id);


--
-- TOC entry 6567 (class 2606 OID 2380519)
-- Name: parametroimpressao parametroimpressao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT parametroimpressao_pkey PRIMARY KEY (id);


--
-- TOC entry 6583 (class 2606 OID 2380521)
-- Name: parametrointegracaocontabilidade parametrointegracaocontabilidade_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrointegracaocontabilidade
    ADD CONSTRAINT parametrointegracaocontabilidade_pkey PRIMARY KEY (id);


--
-- TOC entry 6592 (class 2606 OID 2380523)
-- Name: parametroipi parametroipi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroipi
    ADD CONSTRAINT parametroipi_pkey PRIMARY KEY (id);


--
-- TOC entry 6597 (class 2606 OID 2380525)
-- Name: parametroncm parametroncm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroncm
    ADD CONSTRAINT parametroncm_pkey PRIMARY KEY (id);


--
-- TOC entry 6599 (class 2606 OID 2380527)
-- Name: parametronotificacao parametronotificacao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametronotificacao
    ADD CONSTRAINT parametronotificacao_pkey PRIMARY KEY (id);


--
-- TOC entry 6603 (class 2606 OID 2380529)
-- Name: parametroorcamento parametroorcamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroorcamento
    ADD CONSTRAINT parametroorcamento_pkey PRIMARY KEY (id);


--
-- TOC entry 6607 (class 2606 OID 2380531)
-- Name: parametroordemservico parametroordemservico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroordemservico
    ADD CONSTRAINT parametroordemservico_pkey PRIMARY KEY (id);


--
-- TOC entry 6616 (class 2606 OID 2380533)
-- Name: parametropiscofins parametropiscofins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametropiscofins
    ADD CONSTRAINT parametropiscofins_pkey PRIMARY KEY (id);


--
-- TOC entry 6627 (class 2606 OID 2380535)
-- Name: parametroproduto parametroproduto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroproduto
    ADD CONSTRAINT parametroproduto_pkey PRIMARY KEY (id);


--
-- TOC entry 6636 (class 2606 OID 2380537)
-- Name: parametrosempresa_cnae parametrosempresa_cnae_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrosempresa_cnae
    ADD CONSTRAINT parametrosempresa_cnae_pkey PRIMARY KEY (parametrosempresa_id, cnaes_id);


--
-- TOC entry 6633 (class 2606 OID 2380539)
-- Name: parametrosempresa parametrosempresa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrosempresa
    ADD CONSTRAINT parametrosempresa_pkey PRIMARY KEY (id);


--
-- TOC entry 6641 (class 2606 OID 2380541)
-- Name: parametrosimpostosnfse parametrosimpostosnfse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrosimpostosnfse
    ADD CONSTRAINT parametrosimpostosnfse_pkey PRIMARY KEY (id);


--
-- TOC entry 6646 (class 2606 OID 2380543)
-- Name: parametrotecnospeedapi parametrotecnospeedapi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrotecnospeedapi
    ADD CONSTRAINT parametrotecnospeedapi_pkey PRIMARY KEY (id);


--
-- TOC entry 6648 (class 2606 OID 2380545)
-- Name: parcelapagamentodocumentofiscal parcelapagamentodocumentofiscal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parcelapagamentodocumentofiscal
    ADD CONSTRAINT parcelapagamentodocumentofiscal_pkey PRIMARY KEY (id);


--
-- TOC entry 6651 (class 2606 OID 2380547)
-- Name: parcelapagamentoordemservico parcelapagamentoordemservico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parcelapagamentoordemservico
    ADD CONSTRAINT parcelapagamentoordemservico_pkey PRIMARY KEY (id);


--
-- TOC entry 6660 (class 2606 OID 2380549)
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (id);


--
-- TOC entry 6669 (class 2606 OID 2380551)
-- Name: pedidocompra pedidocompra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidocompra
    ADD CONSTRAINT pedidocompra_pkey PRIMARY KEY (id);


--
-- TOC entry 6672 (class 2606 OID 2380553)
-- Name: percentualcreditoicms percentualcreditoicms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percentualcreditoicms
    ADD CONSTRAINT percentualcreditoicms_pkey PRIMARY KEY (id);


--
-- TOC entry 6677 (class 2606 OID 2380557)
-- Name: preferencia_emailsbackup preferencia_emailsbackup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preferencia_emailsbackup
    ADD CONSTRAINT preferencia_emailsbackup_pkey PRIMARY KEY (preferencia_id, listaemailsbackup_id);


--
-- TOC entry 6675 (class 2606 OID 2380559)
-- Name: preferencia preferencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preferencia
    ADD CONSTRAINT preferencia_pkey PRIMARY KEY (id);


--
-- TOC entry 6692 (class 2606 OID 2380561)
-- Name: produto produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (id);


--
-- TOC entry 6699 (class 2606 OID 2380563)
-- Name: produtofornecedor produtofornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtofornecedor
    ADD CONSTRAINT produtofornecedor_pkey PRIMARY KEY (id);


--
-- TOC entry 6705 (class 2606 OID 2380565)
-- Name: produtotabelapreco produtotabelapreco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtotabelapreco
    ADD CONSTRAINT produtotabelapreco_pkey PRIMARY KEY (id);


--
-- TOC entry 6711 (class 2606 OID 2380567)
-- Name: promocaoproduto promocaoproduto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocaoproduto
    ADD CONSTRAINT promocaoproduto_pkey PRIMARY KEY (id);


--
-- TOC entry 6713 (class 2606 OID 2380569)
-- Name: regimetributario regimetributario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regimetributario
    ADD CONSTRAINT regimetributario_pkey PRIMARY KEY (id);


--
-- TOC entry 6718 (class 2606 OID 2380571)
-- Name: seguradora seguradora_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguradora
    ADD CONSTRAINT seguradora_pkey PRIMARY KEY (id);


--
-- TOC entry 6722 (class 2606 OID 2380573)
-- Name: servico servico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servico
    ADD CONSTRAINT servico_pkey PRIMARY KEY (id);


--
-- TOC entry 6727 (class 2606 OID 2380575)
-- Name: serviconfse serviconfse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviconfse
    ADD CONSTRAINT serviconfse_pkey PRIMARY KEY (id);


--
-- TOC entry 6733 (class 2606 OID 2380577)
-- Name: situacao situacao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.situacao
    ADD CONSTRAINT situacao_pkey PRIMARY KEY (id);


--
-- TOC entry 6738 (class 2606 OID 2380579)
-- Name: situacaocheque situacaocheque_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.situacaocheque
    ADD CONSTRAINT situacaocheque_pkey PRIMARY KEY (id);


--
-- TOC entry 6742 (class 2606 OID 2380581)
-- Name: statusanotacaopedido statusanotacaopedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statusanotacaopedido
    ADD CONSTRAINT statusanotacaopedido_pkey PRIMARY KEY (id);


--
-- TOC entry 6749 (class 2606 OID 2380583)
-- Name: subdepartamento subdepartamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subdepartamento
    ADD CONSTRAINT subdepartamento_pkey PRIMARY KEY (id);


--
-- TOC entry 6754 (class 2606 OID 2380585)
-- Name: subserviconfse subserviconfse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subserviconfse
    ADD CONSTRAINT subserviconfse_pkey PRIMARY KEY (id);


--
-- TOC entry 6756 (class 2606 OID 2380587)
-- Name: tabelacstsped tabelacstsped_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabelacstsped
    ADD CONSTRAINT tabelacstsped_pkey PRIMARY KEY (id);


--
-- TOC entry 6760 (class 2606 OID 2380589)
-- Name: tabelaibpt tabelaibpt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabelaibpt
    ADD CONSTRAINT tabelaibpt_pkey PRIMARY KEY (id);


--
-- TOC entry 6765 (class 2606 OID 2380591)
-- Name: tabelapreco tabelapreco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabelapreco
    ADD CONSTRAINT tabelapreco_pkey PRIMARY KEY (id);


--
-- TOC entry 6769 (class 2606 OID 2380593)
-- Name: tabelapreco_usuario tabelapreco_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabelapreco_usuario
    ADD CONSTRAINT tabelapreco_usuario_pkey PRIMARY KEY (tabelapreco_id, usuarios_id);


--
-- TOC entry 6773 (class 2606 OID 2380595)
-- Name: tara tara_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tara
    ADD CONSTRAINT tara_pkey PRIMARY KEY (id);


--
-- TOC entry 6776 (class 2606 OID 2380597)
-- Name: taxaentrega taxaentrega_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxaentrega
    ADD CONSTRAINT taxaentrega_pkey PRIMARY KEY (id);


--
-- TOC entry 6780 (class 2606 OID 2380599)
-- Name: taxaentregabairros taxaentregabairros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxaentregabairros
    ADD CONSTRAINT taxaentregabairros_pkey PRIMARY KEY (id);


--
-- TOC entry 6785 (class 2606 OID 2380601)
-- Name: tipo tipo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo
    ADD CONSTRAINT tipo_pkey PRIMARY KEY (id);


--
-- TOC entry 6787 (class 2606 OID 2380603)
-- Name: tipocfop tipocfop_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipocfop
    ADD CONSTRAINT tipocfop_pkey PRIMARY KEY (id);


--
-- TOC entry 6792 (class 2606 OID 2380605)
-- Name: tipocontato tipocontato_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipocontato
    ADD CONSTRAINT tipocontato_pkey PRIMARY KEY (id);


--
-- TOC entry 6794 (class 2606 OID 2380607)
-- Name: tipoitem tipoitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipoitem
    ADD CONSTRAINT tipoitem_pkey PRIMARY KEY (id);


--
-- TOC entry 6798 (class 2606 OID 2380609)
-- Name: tokenintegracao tokenintegracao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokenintegracao
    ADD CONSTRAINT tokenintegracao_pkey PRIMARY KEY (id);


--
-- TOC entry 6807 (class 2606 OID 2380611)
-- Name: tributacaogeralempresa tributacaogeralempresa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaogeralempresa
    ADD CONSTRAINT tributacaogeralempresa_pkey PRIMARY KEY (id);


--
-- TOC entry 6818 (class 2606 OID 2380613)
-- Name: tributacaoporncm tributacaoporncm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaoporncm
    ADD CONSTRAINT tributacaoporncm_pkey PRIMARY KEY (id);


--
-- TOC entry 6823 (class 2606 OID 2380615)
-- Name: unidademedida unidademedida_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidademedida
    ADD CONSTRAINT unidademedida_pkey PRIMARY KEY (id);


--
-- TOC entry 6828 (class 2606 OID 2380617)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 6834 (class 2606 OID 2380619)
-- Name: usuariocaixa usuariocaixa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuariocaixa
    ADD CONSTRAINT usuariocaixa_pkey PRIMARY KEY (id);


--
-- TOC entry 6837 (class 2606 OID 2380621)
-- Name: usuarioempresa usuarioempresa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarioempresa
    ADD CONSTRAINT usuarioempresa_pkey PRIMARY KEY (id);


--
-- TOC entry 6841 (class 2606 OID 2380623)
-- Name: veiculo_veiculo veiculo_veiculo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.veiculo_veiculo
    ADD CONSTRAINT veiculo_veiculo_pkey PRIMARY KEY (veiculocte_id, veiculosvinculado_id);


--
-- TOC entry 6856 (class 2606 OID 2380625)
-- Name: vendasorigem vendasorigem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendasorigem
    ADD CONSTRAINT vendasorigem_pkey PRIMARY KEY (id);


--
-- TOC entry 6860 (class 2606 OID 2380627)
-- Name: versaosistema versaosistema_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.versaosistema
    ADD CONSTRAINT versaosistema_pkey PRIMARY KEY (id);


--
-- TOC entry 6862 (class 2606 OID 2380629)
-- Name: version version_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.version
    ADD CONSTRAINT version_pkey PRIMARY KEY (version);


--
-- TOC entry 6865 (class 2606 OID 2380631)
-- Name: volumenotafiscalentrada volumenotafiscalentrada_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volumenotafiscalentrada
    ADD CONSTRAINT volumenotafiscalentrada_pkey PRIMARY KEY (id);


--
-- TOC entry 5499 (class 1259 OID 2380632)
-- Name: dcmntnteriorpapelfkdcmntanteriorpapelidentificacaodocanteriorid; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX dcmntnteriorpapelfkdcmntanteriorpapelidentificacaodocanteriorid ON cte.documentoanteriorpapel USING btree (identificacaodocanterior_id);


--
-- TOC entry 5496 (class 1259 OID 2380633)
-- Name: dcmntntrrltronicofkdcmntntrrletronicoidentificacaodocanteriorid; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX dcmntntrrltronicofkdcmntntrrletronicoidentificacaodocanteriorid ON cte.documentoanterioreletronico USING btree (identificacaodocanterior_id);


--
-- TOC entry 5521 (class 1259 OID 2380634)
-- Name: dntfccdocanteriorfkdntfccodocanterioremissordocumentoanteriorid; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX dntfccdocanteriorfkdntfccodocanterioremissordocumentoanteriorid ON cte.identificacaodocanterior USING btree (emissordocumentoanterior_id);


--
-- TOC entry 5510 (class 1259 OID 2380635)
-- Name: formapagamentoctefkformapagamentoctemovimentacaocreditosaida_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX formapagamentoctefkformapagamentoctemovimentacaocreditosaida_id ON cte.formapagamentocte USING btree (movimentacaocreditosaida_id);


--
-- TOC entry 5489 (class 1259 OID 2380636)
-- Name: idx_cte_empresa_numero_serie_ambiente; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE UNIQUE INDEX idx_cte_empresa_numero_serie_ambiente ON cte.cte USING btree (empresa_id, numero, serie, ambiente) WHERE (datacadastro > '2021-03-05'::date);


--
-- TOC entry 5483 (class 1259 OID 2380637)
-- Name: idx_datacarta; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX idx_datacarta ON cte.cartacorrecaocte USING btree (datacarta);


--
-- TOC entry 5484 (class 1259 OID 2380638)
-- Name: ix_cartacorrecaocte_fk_cartacorrecaocte_cte_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_cartacorrecaocte_fk_cartacorrecaocte_cte_id ON cte.cartacorrecaocte USING btree (cte_id);


--
-- TOC entry 5485 (class 1259 OID 2380639)
-- Name: ix_cartacorrecaocte_fk_cartacorrecaocte_usuarioalteracao_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_cartacorrecaocte_fk_cartacorrecaocte_usuarioalteracao_id ON cte.cartacorrecaocte USING btree (usuarioalteracao_id);


--
-- TOC entry 5486 (class 1259 OID 2380640)
-- Name: ix_cartacorrecaocte_fk_cartacorrecaocte_usuariocadastro_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_cartacorrecaocte_fk_cartacorrecaocte_usuariocadastro_id ON cte.cartacorrecaocte USING btree (usuariocadastro_id);


--
-- TOC entry 5492 (class 1259 OID 2380641)
-- Name: ix_ctecomplementado_fk_ctecomplementado_empresa_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_ctecomplementado_fk_ctecomplementado_empresa_id ON cte.ctecomplementado USING btree (empresa_id);


--
-- TOC entry 5495 (class 1259 OID 2380642)
-- Name: ix_documentoanterior_fk_documentoanterior_cte_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_documentoanterior_fk_documentoanterior_cte_id ON cte.documentoanterior USING btree (cte_id);


--
-- TOC entry 5511 (class 1259 OID 2380643)
-- Name: ix_formapagamentocte_fk_formapagamentocte_cte_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_formapagamentocte_fk_formapagamentocte_cte_id ON cte.formapagamentocte USING btree (cte_id);


--
-- TOC entry 5512 (class 1259 OID 2380644)
-- Name: ix_formapagamentocte_fk_formapagamentocte_maquinacartao_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_formapagamentocte_fk_formapagamentocte_maquinacartao_id ON cte.formapagamentocte USING btree (maquinacartao_id);


--
-- TOC entry 5513 (class 1259 OID 2380645)
-- Name: ix_formapagamentocte_fk_formapagamentocte_moedaestrangeira_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_formapagamentocte_fk_formapagamentocte_moedaestrangeira_id ON cte.formapagamentocte USING btree (moedaestrangeira_id);


--
-- TOC entry 5514 (class 1259 OID 2380646)
-- Name: ix_formapagamentocte_fk_formapagamentocte_vale_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_formapagamentocte_fk_formapagamentocte_vale_id ON cte.formapagamentocte USING btree (vale_id);


--
-- TOC entry 5517 (class 1259 OID 2380647)
-- Name: ix_historico_veiculo_fk_historico_veiculo_empresa_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_historico_veiculo_fk_historico_veiculo_empresa_id ON cte.historico_veiculo USING btree (empresa_id);


--
-- TOC entry 5518 (class 1259 OID 2380648)
-- Name: ix_historico_veiculo_fk_historico_veiculo_usuarioalteracao_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_historico_veiculo_fk_historico_veiculo_usuarioalteracao_id ON cte.historico_veiculo USING btree (usuarioalteracao_id);


--
-- TOC entry 5519 (class 1259 OID 2380649)
-- Name: ix_historico_veiculo_fk_historico_veiculo_usuariocadastro_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_historico_veiculo_fk_historico_veiculo_usuariocadastro_id ON cte.historico_veiculo USING btree (usuariocadastro_id);


--
-- TOC entry 5520 (class 1259 OID 2380650)
-- Name: ix_historico_veiculo_fk_historico_veiculo_veiculo_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_historico_veiculo_fk_historico_veiculo_veiculo_id ON cte.historico_veiculo USING btree (veiculo_id);


--
-- TOC entry 5526 (class 1259 OID 2380651)
-- Name: ix_informacaocorrecao_fk_informacaocorrecao_cartacorrecao_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_informacaocorrecao_fk_informacaocorrecao_cartacorrecao_id ON cte.informacaocorrecao USING btree (cartacorrecao_id);


--
-- TOC entry 5529 (class 1259 OID 2380652)
-- Name: ix_itemservico_fk_itemservico_cte_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_itemservico_fk_itemservico_cte_id ON cte.itemservico USING btree (cte_id);


--
-- TOC entry 5532 (class 1259 OID 2380653)
-- Name: ix_itemservicolist_fk_itemservicolist_empresa_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_itemservicolist_fk_itemservicolist_empresa_id ON cte.itemservicolist USING btree (empresa_id);


--
-- TOC entry 5533 (class 1259 OID 2380654)
-- Name: ix_lacre_fk_lacre_modalrodo_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_lacre_fk_lacre_modalrodo_id ON cte.lacre USING btree (modalrodo_id);


--
-- TOC entry 5540 (class 1259 OID 2380655)
-- Name: ix_motorista_fk_motorista_empresa_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_motorista_fk_motorista_empresa_id ON cte.motorista USING btree (empresa_id);


--
-- TOC entry 5541 (class 1259 OID 2380656)
-- Name: ix_motorista_fk_motorista_municipio_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_motorista_fk_motorista_municipio_id ON cte.motorista USING btree (municipio_id);


--
-- TOC entry 5542 (class 1259 OID 2380657)
-- Name: ix_motorista_fk_motorista_usuarioalteracao_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_motorista_fk_motorista_usuarioalteracao_id ON cte.motorista USING btree (usuarioalteracao_id);


--
-- TOC entry 5543 (class 1259 OID 2380658)
-- Name: ix_motorista_fk_motorista_usuariocadastro_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_motorista_fk_motorista_usuariocadastro_id ON cte.motorista USING btree (usuariocadastro_id);


--
-- TOC entry 5546 (class 1259 OID 2380659)
-- Name: ix_notafiscalcte_fk_notafiscalcte_cte_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_notafiscalcte_fk_notafiscalcte_cte_id ON cte.notafiscalcte USING btree (cte_id);


--
-- TOC entry 5549 (class 1259 OID 2380660)
-- Name: ix_notaprodutorcte_fk_notaprodutorcte_cfop_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_notaprodutorcte_fk_notaprodutorcte_cfop_id ON cte.notaprodutorcte USING btree (cfop_id);


--
-- TOC entry 5550 (class 1259 OID 2380661)
-- Name: ix_notaprodutorcte_fk_notaprodutorcte_cte_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_notaprodutorcte_fk_notaprodutorcte_cte_id ON cte.notaprodutorcte USING btree (cte_id);


--
-- TOC entry 5551 (class 1259 OID 2380662)
-- Name: ix_notaprodutorcte_fk_notaprodutorcte_empresa_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_notaprodutorcte_fk_notaprodutorcte_empresa_id ON cte.notaprodutorcte USING btree (empresa_id);


--
-- TOC entry 5558 (class 1259 OID 2380663)
-- Name: ix_ordemcoleta_fk_ordemcoleta_destinatario_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_ordemcoleta_fk_ordemcoleta_destinatario_id ON cte.ordemcoleta USING btree (destinatario_id);


--
-- TOC entry 5559 (class 1259 OID 2380664)
-- Name: ix_ordemcoleta_fk_ordemcoleta_empresa_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_ordemcoleta_fk_ordemcoleta_empresa_id ON cte.ordemcoleta USING btree (empresa_id);


--
-- TOC entry 5560 (class 1259 OID 2380665)
-- Name: ix_ordemcoleta_fk_ordemcoleta_enderecodestinatario_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_ordemcoleta_fk_ordemcoleta_enderecodestinatario_id ON cte.ordemcoleta USING btree (enderecodestinatario_id);


--
-- TOC entry 5561 (class 1259 OID 2380666)
-- Name: ix_ordemcoleta_fk_ordemcoleta_enderecoremetente_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_ordemcoleta_fk_ordemcoleta_enderecoremetente_id ON cte.ordemcoleta USING btree (enderecoremetente_id);


--
-- TOC entry 5562 (class 1259 OID 2380667)
-- Name: ix_ordemcoleta_fk_ordemcoleta_motorista_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_ordemcoleta_fk_ordemcoleta_motorista_id ON cte.ordemcoleta USING btree (motorista_id);


--
-- TOC entry 5563 (class 1259 OID 2380668)
-- Name: ix_ordemcoleta_fk_ordemcoleta_proprietario_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_ordemcoleta_fk_ordemcoleta_proprietario_id ON cte.ordemcoleta USING btree (proprietario_id);


--
-- TOC entry 5564 (class 1259 OID 2380669)
-- Name: ix_ordemcoleta_fk_ordemcoleta_remetente_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_ordemcoleta_fk_ordemcoleta_remetente_id ON cte.ordemcoleta USING btree (remetente_id);


--
-- TOC entry 5565 (class 1259 OID 2380670)
-- Name: ix_ordemcoleta_fk_ordemcoleta_usuarioalteracao_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_ordemcoleta_fk_ordemcoleta_usuarioalteracao_id ON cte.ordemcoleta USING btree (usuarioalteracao_id);


--
-- TOC entry 5566 (class 1259 OID 2380671)
-- Name: ix_ordemcoleta_fk_ordemcoleta_usuariocadastro_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_ordemcoleta_fk_ordemcoleta_usuariocadastro_id ON cte.ordemcoleta USING btree (usuariocadastro_id);


--
-- TOC entry 5567 (class 1259 OID 2380672)
-- Name: ix_ordemcoleta_fk_ordemcoleta_veiculo_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_ordemcoleta_fk_ordemcoleta_veiculo_id ON cte.ordemcoleta USING btree (veiculo_id);


--
-- TOC entry 5570 (class 1259 OID 2380673)
-- Name: ix_ordemcoletacte_fk_ordemcoletacte_modalrodo_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_ordemcoletacte_fk_ordemcoletacte_modalrodo_id ON cte.ordemcoletacte USING btree (modalrodo_id);


--
-- TOC entry 5571 (class 1259 OID 2380674)
-- Name: ix_ordemcoletacte_fk_ordemcoletacte_uf_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_ordemcoletacte_fk_ordemcoletacte_uf_id ON cte.ordemcoletacte USING btree (uf_id);


--
-- TOC entry 5574 (class 1259 OID 2380675)
-- Name: ix_outrodocumento_fk_outrodocumento_cte_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_outrodocumento_fk_outrodocumento_cte_id ON cte.outrodocumento USING btree (cte_id);


--
-- TOC entry 5577 (class 1259 OID 2380676)
-- Name: ix_quantidadecarga_fk_quantidadecarga_cte_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_quantidadecarga_fk_quantidadecarga_cte_id ON cte.quantidadecarga USING btree (cte_id);


--
-- TOC entry 5584 (class 1259 OID 2380677)
-- Name: ix_tipomedidacte_fk_tipomedidacte_empresa_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_tipomedidacte_fk_tipomedidacte_empresa_id ON cte.tipomedidacte USING btree (empresa_id);


--
-- TOC entry 5589 (class 1259 OID 2380678)
-- Name: ix_volumeordemcoleta_fk_volumeordemcoleta_ordemcoleta_id; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX ix_volumeordemcoleta_fk_volumeordemcoleta_ordemcoleta_id ON cte.volumeordemcoleta USING btree (ordemcoleta_id);


--
-- TOC entry 5504 (class 1259 OID 2380679)
-- Name: mssrdocumentoanteriorfkmssrdocumentoanteriorclientefornecedorid; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX mssrdocumentoanteriorfkmssrdocumentoanteriorclientefornecedorid ON cte.emissordocumentoanterior USING btree (clientefornecedor_id);


--
-- TOC entry 5505 (class 1259 OID 2380680)
-- Name: mssrdocumentoanteriorfkmssrdocumentoanteriordocumentoanteriorid; Type: INDEX; Schema: cte; Owner: postgres
--

CREATE INDEX mssrdocumentoanteriorfkmssrdocumentoanteriordocumentoanteriorid ON cte.emissordocumentoanterior USING btree (documentoanterior_id);


--
-- TOC entry 5642 (class 1259 OID 2380681)
-- Name: formapagamentoauxiliarvendafkformapagamentoauxiliarvendavale_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX formapagamentoauxiliarvendafkformapagamentoauxiliarvendavale_id ON ecf.formapagamentoauxiliarvenda USING btree (vale_id);


--
-- TOC entry 5651 (class 1259 OID 2380682)
-- Name: formapagamentocupomfiscal_fk_formapagamentocupomfiscal_vale_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX formapagamentocupomfiscal_fk_formapagamentocupomfiscal_vale_id ON ecf.formapagamentocupomfiscal USING btree (vale_id);


--
-- TOC entry 5654 (class 1259 OID 2380683)
-- Name: frmapagamentocupomfiscalfkfrmapagamentocupomfiscalcupomfiscalid; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX frmapagamentocupomfiscalfkfrmapagamentocupomfiscalcupomfiscalid ON ecf.formapagamentocupomfiscal USING btree (cupomfiscal_id);


--
-- TOC entry 5655 (class 1259 OID 2380684)
-- Name: frmpgamentocupomfiscalfkfrmapagamentocupomfiscalmaquinacartaoid; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX frmpgamentocupomfiscalfkfrmapagamentocupomfiscalmaquinacartaoid ON ecf.formapagamentocupomfiscal USING btree (maquinacartao_id);


--
-- TOC entry 5649 (class 1259 OID 2380685)
-- Name: frmpgmentocreditoclientefkfrmpgamentocreditoclientemovcreditoid; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX frmpgmentocreditoclientefkfrmpgamentocreditoclientemovcreditoid ON ecf.formapagamentocreditocliente USING btree (movcredito_id);


--
-- TOC entry 5656 (class 1259 OID 2380686)
-- Name: frmpgmentocupomfiscalfkfrmpgamentocupomfiscalmoedaestrangeiraid; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX frmpgmentocupomfiscalfkfrmpgamentocupomfiscalmoedaestrangeiraid ON ecf.formapagamentocupomfiscal USING btree (moedaestrangeira_id);


--
-- TOC entry 5643 (class 1259 OID 2380687)
-- Name: frmpgmntauxiliarvendafkfrmpgmntoauxiliarvendamoedaestrangeiraid; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX frmpgmntauxiliarvendafkfrmpgmntoauxiliarvendamoedaestrangeiraid ON ecf.formapagamentoauxiliarvenda USING btree (moedaestrangeira_id);


--
-- TOC entry 5657 (class 1259 OID 2380688)
-- Name: frmpgmntcpmfiscalfkfrmpgmntcpomfiscalmovimentacaocreditosaidaid; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX frmpgmntcpmfiscalfkfrmpgmntcpomfiscalmovimentacaocreditosaidaid ON ecf.formapagamentocupomfiscal USING btree (movimentacaocreditosaida_id);


--
-- TOC entry 5644 (class 1259 OID 2380689)
-- Name: frmpgmntoauxiliarvendafkfrmpgamentoauxiliarvendaauxiliarvendaid; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX frmpgmntoauxiliarvendafkfrmpgamentoauxiliarvendaauxiliarvendaid ON ecf.formapagamentoauxiliarvenda USING btree (auxiliarvenda_id);


--
-- TOC entry 5645 (class 1259 OID 2380690)
-- Name: frmpgmntoauxiliarvendafkfrmpgamentoauxiliarvendamaquinacartaoid; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX frmpgmntoauxiliarvendafkfrmpgamentoauxiliarvendamaquinacartaoid ON ecf.formapagamentoauxiliarvenda USING btree (maquinacartao_id);


--
-- TOC entry 5650 (class 1259 OID 2380691)
-- Name: frmpgmntocreditoclientefkfrmpgmntocreditoclientemaquinacartaoid; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX frmpgmntocreditoclientefkfrmpgmntocreditoclientemaquinacartaoid ON ecf.formapagamentocreditocliente USING btree (maquinacartao_id);


--
-- TOC entry 5646 (class 1259 OID 2380692)
-- Name: frmpgmntxlarvendafkfrmpgmntxliarvendamovimentacaocreditosaidaid; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX frmpgmntxlarvendafkfrmpgmntxliarvendamovimentacaocreditosaidaid ON ecf.formapagamentoauxiliarvenda USING btree (movimentacaocreditosaida_id);


--
-- TOC entry 5684 (class 1259 OID 2380693)
-- Name: id_sat_fiscal; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX id_sat_fiscal ON ecf.satfiscal USING btree (fabricante, modelo, numeroserie);


--
-- TOC entry 5594 (class 1259 OID 2380694)
-- Name: idx_auxiliar_venda_condicional; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_auxiliar_venda_condicional ON ecf.auxiliarvenda USING btree (consignacaodevolucao_id);


--
-- TOC entry 5595 (class 1259 OID 2380695)
-- Name: idx_auxiliar_venda_data; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_auxiliar_venda_data ON ecf.auxiliarvenda USING btree (datavenda);


--
-- TOC entry 5596 (class 1259 OID 2380696)
-- Name: idx_auxiliar_venda_empresa; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_auxiliar_venda_empresa ON ecf.auxiliarvenda USING btree (empresa_id);


--
-- TOC entry 5597 (class 1259 OID 2380697)
-- Name: idx_auxiliar_venda_vendedor; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_auxiliar_venda_vendedor ON ecf.auxiliarvenda USING btree (vendedor_id);


--
-- TOC entry 5607 (class 1259 OID 2380698)
-- Name: idx_clifor; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_clifor ON ecf.consignacao USING btree (cliente_id);


--
-- TOC entry 5685 (class 1259 OID 2380699)
-- Name: idx_codigo_ativacao_sat; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_codigo_ativacao_sat ON ecf.satfiscal USING btree (codigoativacao);


--
-- TOC entry 5613 (class 1259 OID 2380700)
-- Name: idx_consig; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_consig ON ecf.consignacaodevolucao USING btree (consignacao_id);


--
-- TOC entry 5619 (class 1259 OID 2380701)
-- Name: idx_cupom_fiscal; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_cupom_fiscal ON ecf.cupomfiscal USING btree (numero, ambiente, empresa_id);


--
-- TOC entry 5620 (class 1259 OID 2380702)
-- Name: idx_cupom_fiscal_emissao; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_cupom_fiscal_emissao ON ecf.cupomfiscal USING btree (dataemissao);


--
-- TOC entry 5621 (class 1259 OID 2380703)
-- Name: idx_cupom_fiscal_empresa; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_cupom_fiscal_empresa ON ecf.cupomfiscal USING btree (empresa_id);


--
-- TOC entry 5622 (class 1259 OID 2380704)
-- Name: idx_cupom_fiscal_empresa_emissao; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_cupom_fiscal_empresa_emissao ON ecf.cupomfiscal USING btree (empresa_id, dataemissao);


--
-- TOC entry 5623 (class 1259 OID 2380705)
-- Name: idx_cupom_fiscal_ultimo_numero; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_cupom_fiscal_ultimo_numero ON ecf.cupomfiscal USING btree (ambiente, empresa_id);


--
-- TOC entry 5632 (class 1259 OID 2380706)
-- Name: idx_data; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_data ON ecf.duplicata USING btree (datavencimento);


--
-- TOC entry 5637 (class 1259 OID 2380707)
-- Name: idx_data_pag; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_data_pag ON ecf.duplicatarecebida USING btree (datapagamento);


--
-- TOC entry 5633 (class 1259 OID 2380708)
-- Name: idx_data_pago; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_data_pago ON ecf.duplicata USING btree (datavencimento, pago);


--
-- TOC entry 5608 (class 1259 OID 2380709)
-- Name: idx_dataprevdev; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_dataprevdev ON ecf.consignacao USING btree (dataprevistadevolucao);


--
-- TOC entry 5614 (class 1259 OID 2380710)
-- Name: idx_dtentr; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_dtentr ON ecf.consignacaodevolucao USING btree (dataentrega);


--
-- TOC entry 5638 (class 1259 OID 2380711)
-- Name: idx_duplicata_cod; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_duplicata_cod ON ecf.duplicatarecebida USING btree (duplicata_id);


--
-- TOC entry 5686 (class 1259 OID 2380712)
-- Name: idx_num_serie_sat; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_num_serie_sat ON ecf.satfiscal USING btree (numeroserie);


--
-- TOC entry 5634 (class 1259 OID 2380713)
-- Name: idx_numero; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX idx_numero ON ecf.duplicata USING btree (numeroparcela);


--
-- TOC entry 5598 (class 1259 OID 2380714)
-- Name: ix_auxiliarvenda_fk_auxiliarvenda_clientefornecedor_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_auxiliarvenda_fk_auxiliarvenda_clientefornecedor_id ON ecf.auxiliarvenda USING btree (clientefornecedor_id);


--
-- TOC entry 5599 (class 1259 OID 2380715)
-- Name: ix_auxiliarvenda_fk_auxiliarvenda_consignacaodevolucao_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_auxiliarvenda_fk_auxiliarvenda_consignacaodevolucao_id ON ecf.auxiliarvenda USING btree (consignacaodevolucao_id);


--
-- TOC entry 5600 (class 1259 OID 2380716)
-- Name: ix_auxiliarvenda_fk_auxiliarvenda_dependente_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_auxiliarvenda_fk_auxiliarvenda_dependente_id ON ecf.auxiliarvenda USING btree (dependente_id);


--
-- TOC entry 5601 (class 1259 OID 2380717)
-- Name: ix_auxiliarvenda_fk_auxiliarvenda_empresa_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_auxiliarvenda_fk_auxiliarvenda_empresa_id ON ecf.auxiliarvenda USING btree (empresa_id);


--
-- TOC entry 5602 (class 1259 OID 2380718)
-- Name: ix_auxiliarvenda_fk_auxiliarvenda_usuarioalteracao_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_auxiliarvenda_fk_auxiliarvenda_usuarioalteracao_id ON ecf.auxiliarvenda USING btree (usuarioalteracao_id);


--
-- TOC entry 5603 (class 1259 OID 2380719)
-- Name: ix_auxiliarvenda_fk_auxiliarvenda_usuariocadastro_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_auxiliarvenda_fk_auxiliarvenda_usuariocadastro_id ON ecf.auxiliarvenda USING btree (usuariocadastro_id);


--
-- TOC entry 5604 (class 1259 OID 2380720)
-- Name: ix_auxiliarvenda_fk_auxiliarvenda_vendedor_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_auxiliarvenda_fk_auxiliarvenda_vendedor_id ON ecf.auxiliarvenda USING btree (vendedor_id);


--
-- TOC entry 5609 (class 1259 OID 2380721)
-- Name: ix_consignacao_fk_consignacao_cliente_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_consignacao_fk_consignacao_cliente_id ON ecf.consignacao USING btree (cliente_id);


--
-- TOC entry 5610 (class 1259 OID 2380722)
-- Name: ix_consignacao_fk_consignacao_usuario_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_consignacao_fk_consignacao_usuario_id ON ecf.consignacao USING btree (usuario_id);


--
-- TOC entry 5615 (class 1259 OID 2380723)
-- Name: ix_consignacaodevolucao_fk_consignacaodevolucao_consignacao_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_consignacaodevolucao_fk_consignacaodevolucao_consignacao_id ON ecf.consignacaodevolucao USING btree (consignacao_id);


--
-- TOC entry 5616 (class 1259 OID 2380724)
-- Name: ix_consignacaodevolucao_fk_consignacaodevolucao_usuario_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_consignacaodevolucao_fk_consignacaodevolucao_usuario_id ON ecf.consignacaodevolucao USING btree (usuario_id);


--
-- TOC entry 5624 (class 1259 OID 2380725)
-- Name: ix_cupomfiscal_fk_cupomfiscal_destinatario_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_cupomfiscal_fk_cupomfiscal_destinatario_id ON ecf.cupomfiscal USING btree (destinatario_id);


--
-- TOC entry 5625 (class 1259 OID 2380726)
-- Name: ix_cupomfiscal_fk_cupomfiscal_emitente_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_cupomfiscal_fk_cupomfiscal_emitente_id ON ecf.cupomfiscal USING btree (emitente_id);


--
-- TOC entry 5626 (class 1259 OID 2380727)
-- Name: ix_cupomfiscal_fk_cupomfiscal_empresa_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_cupomfiscal_fk_cupomfiscal_empresa_id ON ecf.cupomfiscal USING btree (empresa_id);


--
-- TOC entry 5627 (class 1259 OID 2380728)
-- Name: ix_cupomfiscal_fk_cupomfiscal_usuarioalteracao_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_cupomfiscal_fk_cupomfiscal_usuarioalteracao_id ON ecf.cupomfiscal USING btree (usuarioalteracao_id);


--
-- TOC entry 5628 (class 1259 OID 2380729)
-- Name: ix_cupomfiscal_fk_cupomfiscal_usuariocadastro_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_cupomfiscal_fk_cupomfiscal_usuariocadastro_id ON ecf.cupomfiscal USING btree (usuariocadastro_id);


--
-- TOC entry 5629 (class 1259 OID 2380730)
-- Name: ix_cupomfiscal_fk_cupomfiscal_vendedor_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_cupomfiscal_fk_cupomfiscal_vendedor_id ON ecf.cupomfiscal USING btree (vendedor_id);


--
-- TOC entry 5639 (class 1259 OID 2380731)
-- Name: ix_duplicatarecebida_fk_duplicatarecebida_duplicata_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_duplicatarecebida_fk_duplicatarecebida_duplicata_id ON ecf.duplicatarecebida USING btree (duplicata_id);


--
-- TOC entry 5660 (class 1259 OID 2380732)
-- Name: ix_itemconsignacao_fk_itemconsignacao_consignacao_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_itemconsignacao_fk_itemconsignacao_consignacao_id ON ecf.itemconsignacao USING btree (consignacao_id);


--
-- TOC entry 5661 (class 1259 OID 2380733)
-- Name: ix_itemconsignacao_fk_itemconsignacao_produto_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_itemconsignacao_fk_itemconsignacao_produto_id ON ecf.itemconsignacao USING btree (produto_id);


--
-- TOC entry 5664 (class 1259 OID 2380734)
-- Name: ix_itemconsignacaodevolucao_fk_itemconsignacaodevolucao_item_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_itemconsignacaodevolucao_fk_itemconsignacaodevolucao_item_id ON ecf.itemconsignacaodevolucao USING btree (item_id);


--
-- TOC entry 5668 (class 1259 OID 2380735)
-- Name: ix_itemcupomfiscal_fk_itemcupomfiscal_cfop_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_itemcupomfiscal_fk_itemcupomfiscal_cfop_id ON ecf.itemcupomfiscal USING btree (cfop_id);


--
-- TOC entry 5669 (class 1259 OID 2380736)
-- Name: ix_itemcupomfiscal_fk_itemcupomfiscal_csticms_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_itemcupomfiscal_fk_itemcupomfiscal_csticms_id ON ecf.itemcupomfiscal USING btree (csticms_id);


--
-- TOC entry 5670 (class 1259 OID 2380737)
-- Name: ix_itemcupomfiscal_fk_itemcupomfiscal_cstpiscofins_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_itemcupomfiscal_fk_itemcupomfiscal_cstpiscofins_id ON ecf.itemcupomfiscal USING btree (cstpiscofins_id);


--
-- TOC entry 5671 (class 1259 OID 2380738)
-- Name: ix_itemcupomfiscal_fk_itemcupomfiscal_cupomfiscal_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_itemcupomfiscal_fk_itemcupomfiscal_cupomfiscal_id ON ecf.itemcupomfiscal USING btree (cupomfiscal_id);


--
-- TOC entry 5672 (class 1259 OID 2380739)
-- Name: ix_itemcupomfiscal_fk_itemcupomfiscal_produto_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_itemcupomfiscal_fk_itemcupomfiscal_produto_id ON ecf.itemcupomfiscal USING btree (produto_id);


--
-- TOC entry 5673 (class 1259 OID 2380740)
-- Name: ix_itemcupomfiscal_fk_itemcupomfiscal_tipoitem_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_itemcupomfiscal_fk_itemcupomfiscal_tipoitem_id ON ecf.itemcupomfiscal USING btree (tipoitem_id);


--
-- TOC entry 5676 (class 1259 OID 2380741)
-- Name: ix_itemusoconsumo_fk_itemusoconsumo_ordemservico_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_itemusoconsumo_fk_itemusoconsumo_ordemservico_id ON ecf.itemusoconsumo USING btree (ordemservico_id);


--
-- TOC entry 5677 (class 1259 OID 2380742)
-- Name: ix_itemusoconsumo_fk_itemusoconsumo_produto_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_itemusoconsumo_fk_itemusoconsumo_produto_id ON ecf.itemusoconsumo USING btree (produto_id);


--
-- TOC entry 5680 (class 1259 OID 2380743)
-- Name: ix_produtoauxiliarvenda_fk_produtoauxiliarvenda_produto_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_produtoauxiliarvenda_fk_produtoauxiliarvenda_produto_id ON ecf.produtoauxiliarvenda USING btree (produto_id);


--
-- TOC entry 5687 (class 1259 OID 2380744)
-- Name: ix_satfiscal_fk_satfiscal_empresa_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_satfiscal_fk_satfiscal_empresa_id ON ecf.satfiscal USING btree (empresa_id);


--
-- TOC entry 5688 (class 1259 OID 2380745)
-- Name: ix_satfiscal_fk_satfiscal_usuarioalteracao_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_satfiscal_fk_satfiscal_usuarioalteracao_id ON ecf.satfiscal USING btree (usuarioalteracao_id);


--
-- TOC entry 5689 (class 1259 OID 2380746)
-- Name: ix_satfiscal_fk_satfiscal_usuariocadastro_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX ix_satfiscal_fk_satfiscal_usuariocadastro_id ON ecf.satfiscal USING btree (usuariocadastro_id);


--
-- TOC entry 5681 (class 1259 OID 2380747)
-- Name: produtoauxiliarvenda_fk_produtoauxiliarvenda_auxiliarvenda_id; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX produtoauxiliarvenda_fk_produtoauxiliarvenda_auxiliarvenda_id ON ecf.produtoauxiliarvenda USING btree (auxiliarvenda_id);


--
-- TOC entry 5665 (class 1259 OID 2380748)
-- Name: tmcnsgncaodevolucaofktmcnsgnacaodevolucaoconsignacaodevolucaoid; Type: INDEX; Schema: ecf; Owner: postgres
--

CREATE INDEX tmcnsgncaodevolucaofktmcnsgnacaodevolucaoconsignacaodevolucaoid ON ecf.itemconsignacaodevolucao USING btree (consignacaodevolucao_id);


--
-- TOC entry 5698 (class 1259 OID 2380749)
-- Name: dcmntfsclmnifestofkdcmntfsclmanifestomunicipiodescarregamentoid; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX dcmntfsclmnifestofkdcmntfsclmanifestomunicipiodescarregamentoid ON manifesto.documentofiscalmanifesto USING btree (municipiodescarregamento_id);


--
-- TOC entry 5726 (class 1259 OID 2380750)
-- Name: idx_manifesto_empresa; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX idx_manifesto_empresa ON manifesto.manifesto USING btree (empresa_id);


--
-- TOC entry 5709 (class 1259 OID 2380751)
-- Name: informacoesciotmdfefkinformacoesciotmdfe_modalrodoviariomdfe_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX informacoesciotmdfefkinformacoesciotmdfe_modalrodoviariomdfe_id ON manifesto.informacoesciotmdfe USING btree (modalrodoviariomdfe_id);


--
-- TOC entry 5694 (class 1259 OID 2380752)
-- Name: ix_autorizacaoxml_fk_autorizacaoxml_manifesto_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_autorizacaoxml_fk_autorizacaoxml_manifesto_id ON manifesto.autorizacaoxml USING btree (manifesto_id);


--
-- TOC entry 5697 (class 1259 OID 2380753)
-- Name: ix_averbacaoseguromdfe_fk_averbacaoseguromdfe_seguromdfe_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_averbacaoseguromdfe_fk_averbacaoseguromdfe_seguromdfe_id ON manifesto.averbacaoseguromdfe USING btree (seguromdfe_id);


--
-- TOC entry 5703 (class 1259 OID 2380754)
-- Name: ix_documentosfiscais_fk_documentosfiscais_manifesto_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_documentosfiscais_fk_documentosfiscais_manifesto_id ON manifesto.documentosfiscais USING btree (manifesto_id);


--
-- TOC entry 5706 (class 1259 OID 2380755)
-- Name: ix_embarcacaocomboio_fk_embarcacaocomboio_modalaquaviario_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_embarcacaocomboio_fk_embarcacaocomboio_modalaquaviario_id ON manifesto.embarcacaocomboio USING btree (modalaquaviario_id);


--
-- TOC entry 5717 (class 1259 OID 2380756)
-- Name: ix_lacresmdfe_fk_lacresmdfe_manifesto_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_lacresmdfe_fk_lacresmdfe_manifesto_id ON manifesto.lacresmdfe USING btree (manifesto_id);


--
-- TOC entry 5720 (class 1259 OID 2380757)
-- Name: ix_lacresunidadecarga_fk_lacresunidadecarga_unidadecarga_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_lacresunidadecarga_fk_lacresunidadecarga_unidadecarga_id ON manifesto.lacresunidadecarga USING btree (unidadecarga_id);


--
-- TOC entry 5727 (class 1259 OID 2380758)
-- Name: ix_manifesto_fk_manifesto_emitente_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_manifesto_fk_manifesto_emitente_id ON manifesto.manifesto USING btree (emitente_id);


--
-- TOC entry 5728 (class 1259 OID 2380759)
-- Name: ix_manifesto_fk_manifesto_empresa_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_manifesto_fk_manifesto_empresa_id ON manifesto.manifesto USING btree (empresa_id);


--
-- TOC entry 5729 (class 1259 OID 2380760)
-- Name: ix_manifesto_fk_manifesto_ufcarregamento_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_manifesto_fk_manifesto_ufcarregamento_id ON manifesto.manifesto USING btree (ufcarregamento_id);


--
-- TOC entry 5730 (class 1259 OID 2380761)
-- Name: ix_manifesto_fk_manifesto_ufdescarregamento_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_manifesto_fk_manifesto_ufdescarregamento_id ON manifesto.manifesto USING btree (ufdescarregamento_id);


--
-- TOC entry 5731 (class 1259 OID 2380762)
-- Name: ix_manifesto_fk_manifesto_usuarioalteracao_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_manifesto_fk_manifesto_usuarioalteracao_id ON manifesto.manifesto USING btree (usuarioalteracao_id);


--
-- TOC entry 5732 (class 1259 OID 2380763)
-- Name: ix_manifesto_fk_manifesto_usuariocadastro_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_manifesto_fk_manifesto_usuariocadastro_id ON manifesto.manifesto USING btree (usuariocadastro_id);


--
-- TOC entry 5735 (class 1259 OID 2380764)
-- Name: ix_modalaereo_fk_modalaereo_manifesto_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_modalaereo_fk_modalaereo_manifesto_id ON manifesto.modalaereo USING btree (manifesto_id);


--
-- TOC entry 5738 (class 1259 OID 2380765)
-- Name: ix_modalaquaviario_fk_modalaquaviario_manifesto_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_modalaquaviario_fk_modalaquaviario_manifesto_id ON manifesto.modalaquaviario USING btree (manifesto_id);


--
-- TOC entry 5741 (class 1259 OID 2380766)
-- Name: ix_modalferroviario_fk_modalferroviario_manifesto_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_modalferroviario_fk_modalferroviario_manifesto_id ON manifesto.modalferroviario USING btree (manifesto_id);


--
-- TOC entry 5744 (class 1259 OID 2380767)
-- Name: ix_modalrodoviariomdfe_fk_modalrodoviariomdfe_manifesto_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_modalrodoviariomdfe_fk_modalrodoviariomdfe_manifesto_id ON manifesto.modalrodoviariomdfe USING btree (manifesto_id);


--
-- TOC entry 5745 (class 1259 OID 2380768)
-- Name: ix_modalrodoviariomdfe_fk_modalrodoviariomdfe_veiculotracao_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_modalrodoviariomdfe_fk_modalrodoviariomdfe_veiculotracao_id ON manifesto.modalrodoviariomdfe USING btree (veiculotracao_id);


--
-- TOC entry 5748 (class 1259 OID 2380769)
-- Name: ix_municipiocarregamento_fk_municipiocarregamento_manifesto_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_municipiocarregamento_fk_municipiocarregamento_manifesto_id ON manifesto.municipiocarregamento USING btree (manifesto_id);


--
-- TOC entry 5749 (class 1259 OID 2380770)
-- Name: ix_municipiocarregamento_fk_municipiocarregamento_municipio_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_municipiocarregamento_fk_municipiocarregamento_municipio_id ON manifesto.municipiocarregamento USING btree (municipio_id);


--
-- TOC entry 5756 (class 1259 OID 2380771)
-- Name: ix_percursomanifesto_fk_percursomanifesto_estadopercorrido_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_percursomanifesto_fk_percursomanifesto_estadopercorrido_id ON manifesto.percursomanifesto USING btree (estadopercorrido_id);


--
-- TOC entry 5757 (class 1259 OID 2380772)
-- Name: ix_percursomanifesto_fk_percursomanifesto_manifesto_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_percursomanifesto_fk_percursomanifesto_manifesto_id ON manifesto.percursomanifesto USING btree (manifesto_id);


--
-- TOC entry 5760 (class 1259 OID 2380773)
-- Name: ix_seguromdfe_fk_seguromdfe_manifesto_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_seguromdfe_fk_seguromdfe_manifesto_id ON manifesto.seguromdfe USING btree (manifesto_id);


--
-- TOC entry 5769 (class 1259 OID 2380774)
-- Name: ix_unidadecarga_fk_unidadecarga_unidadetransporte_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_unidadecarga_fk_unidadecarga_unidadetransporte_id ON manifesto.unidadecarga USING btree (unidadetransporte_id);


--
-- TOC entry 5778 (class 1259 OID 2380775)
-- Name: ix_vagaotrem_fk_vagaotrem_modalferroviario_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_vagaotrem_fk_vagaotrem_modalferroviario_id ON manifesto.vagaotrem USING btree (modalferroviario_id);


--
-- TOC entry 5781 (class 1259 OID 2380776)
-- Name: ix_valepedagio_fk_valepedagio_modalrodoviariomdfe_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX ix_valepedagio_fk_valepedagio_modalrodoviariomdfe_id ON manifesto.valepedagio USING btree (modalrodoviariomdfe_id);


--
-- TOC entry 5725 (class 1259 OID 2380777)
-- Name: lcrsnidadetransportefklcresunidadetransporteunidadetransporteid; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX lcrsnidadetransportefklcresunidadetransporteunidadetransporteid ON manifesto.lacresunidadetransporte USING btree (unidadetransporte_id);


--
-- TOC entry 5752 (class 1259 OID 2380778)
-- Name: mncpodescarregamentofkmncipiodescarregamentodocumentosfiscaisid; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX mncpodescarregamentofkmncipiodescarregamentodocumentosfiscaisid ON manifesto.municipiodescarregamento USING btree (documentosfiscais_id);


--
-- TOC entry 5755 (class 1259 OID 2380779)
-- Name: municipiodescarregamentofkmunicipiodescarregamento_municipio_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX municipiodescarregamentofkmunicipiodescarregamento_municipio_id ON manifesto.municipiodescarregamento USING btree (municipio_id);


--
-- TOC entry 5715 (class 1259 OID 2380780)
-- Name: nformacoesseguradoramdfefkinformacoesseguradoramdfeseguradoraid; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX nformacoesseguradoramdfefkinformacoesseguradoramdfeseguradoraid ON manifesto.informacoesseguradoramdfe USING btree (seguradora_id);


--
-- TOC entry 5716 (class 1259 OID 2380781)
-- Name: nformacoesseguradoramdfefkinformacoesseguradoramdfeseguromdfeid; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX nformacoesseguradoramdfefkinformacoesseguradoramdfeseguromdfeid ON manifesto.informacoesseguradoramdfe USING btree (seguromdfe_id);


--
-- TOC entry 5712 (class 1259 OID 2380782)
-- Name: nfrmcscntratantemdfefknfrmcscntratantemdfemodalrodoviariomdfeid; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX nfrmcscntratantemdfefknfrmcscntratantemdfemodalrodoviariomdfeid ON manifesto.informacoescontratantemdfe USING btree (modalrodoviariomdfe_id);


--
-- TOC entry 5763 (class 1259 OID 2380783)
-- Name: terminalcarregamento_fk_terminalcarregamento_modalaquaviario_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX terminalcarregamento_fk_terminalcarregamento_modalaquaviario_id ON manifesto.terminalcarregamento USING btree (modalaquaviario_id);


--
-- TOC entry 5768 (class 1259 OID 2380784)
-- Name: trminaldescarregamentofktrminaldescarregamentomodalaquaviarioid; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX trminaldescarregamentofktrminaldescarregamentomodalaquaviarioid ON manifesto.terminaldescarregamento USING btree (modalaquaviario_id);


--
-- TOC entry 5774 (class 1259 OID 2380785)
-- Name: unidadecargaaquaviariofkunidadecargaaquaviariomodalaquaviarioid; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX unidadecargaaquaviariofkunidadecargaaquaviariomodalaquaviarioid ON manifesto.unidadecargaaquaviario USING btree (modalaquaviario_id);


--
-- TOC entry 5777 (class 1259 OID 2380786)
-- Name: unidadetransportefkunidadetransportedocumentofiscalmanifesto_id; Type: INDEX; Schema: manifesto; Owner: postgres
--

CREATE INDEX unidadetransportefkunidadetransportedocumentofiscalmanifesto_id ON manifesto.unidadetransporte USING btree (documentofiscalmanifesto_id);


--
-- TOC entry 5805 (class 1259 OID 2380787)
-- Name: chaveacessoreferenciadafkchaveacessoreferenciadatipofaturamento; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX chaveacessoreferenciadafkchaveacessoreferenciadatipofaturamento ON notafiscal.chaveacessoreferenciada USING btree (tipofaturamento, empresaid, numero, ambiente, serie);


--
-- TOC entry 5810 (class 1259 OID 2380788)
-- Name: declaracaoexportacao_fk_declaracaoexportacao_itemnotafiscal_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX declaracaoexportacao_fk_declaracaoexportacao_itemnotafiscal_id ON notafiscal.declaracaoexportacao USING btree (itemnotafiscal_id);


--
-- TOC entry 5813 (class 1259 OID 2380789)
-- Name: declaracaoimportacao_fk_declaracaoimportacao_itemnotafiscal_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX declaracaoimportacao_fk_declaracaoimportacao_itemnotafiscal_id ON notafiscal.declaracaoimportacao USING btree (itemnotafiscal_id);


--
-- TOC entry 5816 (class 1259 OID 2380790)
-- Name: declaracaoimportacaofkdeclaracaoimportacao_estadodesembaraco_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX declaracaoimportacaofkdeclaracaoimportacao_estadodesembaraco_id ON notafiscal.declaracaoimportacao USING btree (estadodesembaraco_id);


--
-- TOC entry 5846 (class 1259 OID 2380791)
-- Name: formapagamentonfc_fk_formapagamentonfc_notafiscalconsumidor_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX formapagamentonfc_fk_formapagamentonfc_notafiscalconsumidor_id ON notafiscal.formapagamentonfc USING btree (notafiscalconsumidor_id);


--
-- TOC entry 5849 (class 1259 OID 2380792)
-- Name: formapagamentonfcfkformapagamentonfcmovimentacaocreditosaida_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX formapagamentonfcfkformapagamentonfcmovimentacaocreditosaida_id ON notafiscal.formapagamentonfc USING btree (movimentacaocreditosaida_id);


--
-- TOC entry 5841 (class 1259 OID 2380793)
-- Name: formapagamentonffk_formapagamentonf_movimentacaocreditosaida_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX formapagamentonffk_formapagamentonf_movimentacaocreditosaida_id ON notafiscal.formapagamentonf USING btree (movimentacaocreditosaida_id);


--
-- TOC entry 5855 (class 1259 OID 2380794)
-- Name: formapagamentonfsfkformapagamentonfsmovimentacaocreditosaida_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX formapagamentonfsfkformapagamentonfsmovimentacaocreditosaida_id ON notafiscal.formapagamentonfs USING btree (movimentacaocreditosaida_id);


--
-- TOC entry 5834 (class 1259 OID 2380795)
-- Name: frmpagamentoauxiliarservicofkfrmapagamentoauxiliarservicovaleid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX frmpagamentoauxiliarservicofkfrmapagamentoauxiliarservicovaleid ON notafiscal.formapagamentoauxiliarservico USING btree (vale_id);


--
-- TOC entry 5835 (class 1259 OID 2380796)
-- Name: frmpgmntuxiliarservicofkfrmpgmntoauxiliarservicomaquinacartaoid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX frmpgmntuxiliarservicofkfrmpgmntoauxiliarservicomaquinacartaoid ON notafiscal.formapagamentoauxiliarservico USING btree (maquinacartao_id);


--
-- TOC entry 5836 (class 1259 OID 2380797)
-- Name: frmpgmntxiliarservicofkfrmpgmntauxiliarservicoauxiliarservicoid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX frmpgmntxiliarservicofkfrmpgmntauxiliarservicoauxiliarservicoid ON notafiscal.formapagamentoauxiliarservico USING btree (auxiliarservico_id);


--
-- TOC entry 5837 (class 1259 OID 2380798)
-- Name: frmpgmntxiliarservicofkfrmpgmntuxiliarservicomoedaestrangeiraid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX frmpgmntxiliarservicofkfrmpgmntuxiliarservicomoedaestrangeiraid ON notafiscal.formapagamentoauxiliarservico USING btree (moedaestrangeira_id);


--
-- TOC entry 5838 (class 1259 OID 2380799)
-- Name: frmpgmntxlrsrvicofkfrmpgmntxlrservicomovimentacaocreditosaidaid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX frmpgmntxlrsrvicofkfrmpgmntxlrservicomovimentacaocreditosaidaid ON notafiscal.formapagamentoauxiliarservico USING btree (movimentacaocreditosaida_id);


--
-- TOC entry 5819 (class 1259 OID 2380800)
-- Name: idx_data; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_data ON notafiscal.duplicatanota USING btree (datavencimento);


--
-- TOC entry 5825 (class 1259 OID 2380801)
-- Name: idx_data_pag; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_data_pag ON notafiscal.duplicatapaganota USING btree (datapagamento);


--
-- TOC entry 5820 (class 1259 OID 2380802)
-- Name: idx_data_pago; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_data_pago ON notafiscal.duplicatanota USING btree (datavencimento, pago);


--
-- TOC entry 5973 (class 1259 OID 2380803)
-- Name: idx_data_validade; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_data_validade ON notafiscal.orcamento USING btree (validade);


--
-- TOC entry 5914 (class 1259 OID 2380804)
-- Name: idx_dest; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_dest ON notafiscal.notafiscal USING btree (destinatario_id);


--
-- TOC entry 5915 (class 1259 OID 2380805)
-- Name: idx_dest_emit; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_dest_emit ON notafiscal.notafiscal USING btree (emitente_id, destinatario_id);


--
-- TOC entry 5826 (class 1259 OID 2380806)
-- Name: idx_duplicata_cod; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_duplicata_cod ON notafiscal.duplicatapaganota USING btree (duplicata_id);


--
-- TOC entry 5933 (class 1259 OID 2380807)
-- Name: idx_nota_consumidor_emissao; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_nota_consumidor_emissao ON notafiscal.notafiscalconsumidor USING btree (dataemissao);


--
-- TOC entry 5934 (class 1259 OID 2380808)
-- Name: idx_nota_consumidor_empresa; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_nota_consumidor_empresa ON notafiscal.notafiscalconsumidor USING btree (empresa_id);


--
-- TOC entry 5935 (class 1259 OID 2380809)
-- Name: idx_nota_consumidor_empresa_emissao; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_nota_consumidor_empresa_emissao ON notafiscal.notafiscalconsumidor USING btree (empresa_id, dataemissao);


--
-- TOC entry 5916 (class 1259 OID 2380810)
-- Name: idx_nota_emissao; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_nota_emissao ON notafiscal.notafiscal USING btree (dataemissao);


--
-- TOC entry 5917 (class 1259 OID 2380811)
-- Name: idx_nota_empresa; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_nota_empresa ON notafiscal.notafiscal USING btree (empresa_id);


--
-- TOC entry 5918 (class 1259 OID 2380812)
-- Name: idx_nota_empresa_emissao; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_nota_empresa_emissao ON notafiscal.notafiscal USING btree (empresa_id, dataemissao);


--
-- TOC entry 5919 (class 1259 OID 2380813)
-- Name: idx_nota_fiscal; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_nota_fiscal ON notafiscal.notafiscal USING btree (serie, numero, tipofaturamento, empresaid);


--
-- TOC entry 5936 (class 1259 OID 2380814)
-- Name: idx_nota_fiscal_consumidor; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_nota_fiscal_consumidor ON notafiscal.notafiscalconsumidor USING btree (serie, numero, ambiente, empresa_id);


--
-- TOC entry 5937 (class 1259 OID 2380815)
-- Name: idx_nota_fiscal_consumidor_condicional; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_nota_fiscal_consumidor_condicional ON notafiscal.notafiscalconsumidor USING btree (consignacaodevolucao_id);


--
-- TOC entry 5938 (class 1259 OID 2380816)
-- Name: idx_nota_fiscal_consumidor_ultimo_numero; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_nota_fiscal_consumidor_ultimo_numero ON notafiscal.notafiscalconsumidor USING btree (serie, numero, empresa_id);


--
-- TOC entry 5939 (class 1259 OID 2380817)
-- Name: idx_notafiscalconsumidor; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_notafiscalconsumidor ON notafiscal.notafiscalconsumidor USING btree (serie, numero, ambiente);


--
-- TOC entry 5821 (class 1259 OID 2380818)
-- Name: idx_numero; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_numero ON notafiscal.duplicatanota USING btree (numeroparcela);


--
-- TOC entry 5974 (class 1259 OID 2380819)
-- Name: idx_orc_num; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX idx_orc_num ON notafiscal.orcamento USING btree (numeroorcamento);


--
-- TOC entry 5975 (class 1259 OID 2380820)
-- Name: idx_orcamento_numero_unique; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE UNIQUE INDEX idx_orcamento_numero_unique ON notafiscal.orcamento USING btree (numeroorcamento, empresa_id);


--
-- TOC entry 5860 (class 1259 OID 2380821)
-- Name: itemauxiliarservico_fk_itemauxiliarservico_auxiliarservico_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX itemauxiliarservico_fk_itemauxiliarservico_auxiliarservico_id ON notafiscal.itemauxiliarservico USING btree (auxiliarservico_id);


--
-- TOC entry 5861 (class 1259 OID 2380822)
-- Name: itemauxiliarservico_fk_itemauxiliarservico_usuarioalteracao_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX itemauxiliarservico_fk_itemauxiliarservico_usuarioalteracao_id ON notafiscal.itemauxiliarservico USING btree (usuarioalteracao_id);


--
-- TOC entry 5862 (class 1259 OID 2380823)
-- Name: itemauxiliarservico_fk_itemauxiliarservico_usuariocadastro_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX itemauxiliarservico_fk_itemauxiliarservico_usuariocadastro_id ON notafiscal.itemauxiliarservico USING btree (usuariocadastro_id);


--
-- TOC entry 5876 (class 1259 OID 2380824)
-- Name: itemnotafiscalconsumidor_fk_itemnotafiscalconsumidor_csticms_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX itemnotafiscalconsumidor_fk_itemnotafiscalconsumidor_csticms_id ON notafiscal.itemnotafiscalconsumidor USING btree (csticms_id);


--
-- TOC entry 5877 (class 1259 OID 2380825)
-- Name: itemnotafiscalconsumidor_fk_itemnotafiscalconsumidor_produto_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX itemnotafiscalconsumidor_fk_itemnotafiscalconsumidor_produto_id ON notafiscal.itemnotafiscalconsumidor USING btree (produto_id);


--
-- TOC entry 5880 (class 1259 OID 2380826)
-- Name: itemnotafiscalconsumidorfk_itemnotafiscalconsumidor_tipoitem_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX itemnotafiscalconsumidorfk_itemnotafiscalconsumidor_tipoitem_id ON notafiscal.itemnotafiscalconsumidor USING btree (tipoitem_id);


--
-- TOC entry 5881 (class 1259 OID 2380827)
-- Name: itemnotafiscalconsumidorfkitemnotafiscalconsumidorkitproduto_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX itemnotafiscalconsumidorfkitemnotafiscalconsumidorkitproduto_id ON notafiscal.itemnotafiscalconsumidor USING btree (kitproduto_id);


--
-- TOC entry 5888 (class 1259 OID 2380828)
-- Name: itemnotafiscalservicofkitemnotafiscalservico_usuariocadastro_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX itemnotafiscalservicofkitemnotafiscalservico_usuariocadastro_id ON notafiscal.itemnotafiscalservico USING btree (usuariocadastro_id);


--
-- TOC entry 5889 (class 1259 OID 2380829)
-- Name: itemnotafiscalservicofkitemnotafiscalserviconotafiscalservicoid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX itemnotafiscalservicofkitemnotafiscalserviconotafiscalservicoid ON notafiscal.itemnotafiscalservico USING btree (notafiscalservico_id);


--
-- TOC entry 5890 (class 1259 OID 2380830)
-- Name: itemnotafiscalservicofkitemnotafiscalservicousuarioalteracao_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX itemnotafiscalservicofkitemnotafiscalservicousuarioalteracao_id ON notafiscal.itemnotafiscalservico USING btree (usuarioalteracao_id);


--
-- TOC entry 5786 (class 1259 OID 2380831)
-- Name: ix_adicao_fk_adicao_declaracaoimportacao_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_adicao_fk_adicao_declaracaoimportacao_id ON notafiscal.adicao USING btree (declaracaoimportacao_id);


--
-- TOC entry 5789 (class 1259 OID 2380832)
-- Name: ix_auxiliarservico_fk_auxiliarservico_caixaaberto_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_auxiliarservico_fk_auxiliarservico_caixaaberto_id ON notafiscal.auxiliarservico USING btree (caixaaberto_id);


--
-- TOC entry 5790 (class 1259 OID 2380833)
-- Name: ix_auxiliarservico_fk_auxiliarservico_empresa_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_auxiliarservico_fk_auxiliarservico_empresa_id ON notafiscal.auxiliarservico USING btree (empresa_id);


--
-- TOC entry 5791 (class 1259 OID 2380834)
-- Name: ix_auxiliarservico_fk_auxiliarservico_funcionario_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_auxiliarservico_fk_auxiliarservico_funcionario_id ON notafiscal.auxiliarservico USING btree (funcionario_id);


--
-- TOC entry 5792 (class 1259 OID 2380835)
-- Name: ix_auxiliarservico_fk_auxiliarservico_ordemservico_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_auxiliarservico_fk_auxiliarservico_ordemservico_id ON notafiscal.auxiliarservico USING btree (ordemservico_id);


--
-- TOC entry 5793 (class 1259 OID 2380836)
-- Name: ix_auxiliarservico_fk_auxiliarservico_prestador_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_auxiliarservico_fk_auxiliarservico_prestador_id ON notafiscal.auxiliarservico USING btree (prestador_id);


--
-- TOC entry 5794 (class 1259 OID 2380837)
-- Name: ix_auxiliarservico_fk_auxiliarservico_tomador_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_auxiliarservico_fk_auxiliarservico_tomador_id ON notafiscal.auxiliarservico USING btree (tomador_id);


--
-- TOC entry 5797 (class 1259 OID 2380838)
-- Name: ix_cartacorrecao_fk_cartacorrecao_serie; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_cartacorrecao_fk_cartacorrecao_serie ON notafiscal.cartacorrecao USING btree (serie, empresaid, ambiente, tipofaturamento, numero);


--
-- TOC entry 5798 (class 1259 OID 2380839)
-- Name: ix_cartacorrecao_fk_cartacorrecao_usuarioalteracao_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_cartacorrecao_fk_cartacorrecao_usuarioalteracao_id ON notafiscal.cartacorrecao USING btree (usuarioalteracao_id);


--
-- TOC entry 5799 (class 1259 OID 2380840)
-- Name: ix_cartacorrecao_fk_cartacorrecao_usuariocadastro_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_cartacorrecao_fk_cartacorrecao_usuariocadastro_id ON notafiscal.cartacorrecao USING btree (usuariocadastro_id);


--
-- TOC entry 5802 (class 1259 OID 2380841)
-- Name: ix_certificadodigital_fk_certificadodigital_empresa_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_certificadodigital_fk_certificadodigital_empresa_id ON notafiscal.certificadodigital USING btree (empresa_id);


--
-- TOC entry 5808 (class 1259 OID 2380842)
-- Name: ix_custonfe_fk_custonfe_empresa_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_custonfe_fk_custonfe_empresa_id ON notafiscal.custonfe USING btree (empresa_id);


--
-- TOC entry 5809 (class 1259 OID 2380843)
-- Name: ix_custonfe_fk_custonfe_tipofaturamento; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_custonfe_fk_custonfe_tipofaturamento ON notafiscal.custonfe USING btree (tipofaturamento, empresaid, numero, ambiente, serie);


--
-- TOC entry 5822 (class 1259 OID 2380844)
-- Name: ix_duplicatanota_fk_duplicatanota_serie; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_duplicatanota_fk_duplicatanota_serie ON notafiscal.duplicatanota USING btree (serie, empresaid, ambiente, tipofaturamento, numero);


--
-- TOC entry 5827 (class 1259 OID 2380845)
-- Name: ix_duplicatapaganota_fk_duplicatapaganota_duplicata_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_duplicatapaganota_fk_duplicatapaganota_duplicata_id ON notafiscal.duplicatapaganota USING btree (duplicata_id);


--
-- TOC entry 5842 (class 1259 OID 2380846)
-- Name: ix_formapagamentonf_fk_formapagamentonf_maquinacartao_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_formapagamentonf_fk_formapagamentonf_maquinacartao_id ON notafiscal.formapagamentonf USING btree (maquinacartao_id);


--
-- TOC entry 5843 (class 1259 OID 2380847)
-- Name: ix_formapagamentonf_fk_formapagamentonf_moedaestrangeira_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_formapagamentonf_fk_formapagamentonf_moedaestrangeira_id ON notafiscal.formapagamentonf USING btree (moedaestrangeira_id);


--
-- TOC entry 5844 (class 1259 OID 2380848)
-- Name: ix_formapagamentonf_fk_formapagamentonf_tipofaturamento; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_formapagamentonf_fk_formapagamentonf_tipofaturamento ON notafiscal.formapagamentonf USING btree (tipofaturamento, empresaid, numero, ambiente, serie);


--
-- TOC entry 5845 (class 1259 OID 2380849)
-- Name: ix_formapagamentonf_fk_formapagamentonf_vale_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_formapagamentonf_fk_formapagamentonf_vale_id ON notafiscal.formapagamentonf USING btree (vale_id);


--
-- TOC entry 5850 (class 1259 OID 2380850)
-- Name: ix_formapagamentonfc_fk_formapagamentonfc_maquinacartao_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_formapagamentonfc_fk_formapagamentonfc_maquinacartao_id ON notafiscal.formapagamentonfc USING btree (maquinacartao_id);


--
-- TOC entry 5851 (class 1259 OID 2380851)
-- Name: ix_formapagamentonfc_fk_formapagamentonfc_moedaestrangeira_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_formapagamentonfc_fk_formapagamentonfc_moedaestrangeira_id ON notafiscal.formapagamentonfc USING btree (moedaestrangeira_id);


--
-- TOC entry 5852 (class 1259 OID 2380852)
-- Name: ix_formapagamentonfc_fk_formapagamentonfc_vale_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_formapagamentonfc_fk_formapagamentonfc_vale_id ON notafiscal.formapagamentonfc USING btree (vale_id);


--
-- TOC entry 5856 (class 1259 OID 2380853)
-- Name: ix_formapagamentonfs_fk_formapagamentonfs_maquinacartao_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_formapagamentonfs_fk_formapagamentonfs_maquinacartao_id ON notafiscal.formapagamentonfs USING btree (maquinacartao_id);


--
-- TOC entry 5857 (class 1259 OID 2380854)
-- Name: ix_formapagamentonfs_fk_formapagamentonfs_moedaestrangeira_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_formapagamentonfs_fk_formapagamentonfs_moedaestrangeira_id ON notafiscal.formapagamentonfs USING btree (moedaestrangeira_id);


--
-- TOC entry 5858 (class 1259 OID 2380855)
-- Name: ix_formapagamentonfs_fk_formapagamentonfs_notafiscalservico_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_formapagamentonfs_fk_formapagamentonfs_notafiscalservico_id ON notafiscal.formapagamentonfs USING btree (notafiscalservico_id);


--
-- TOC entry 5859 (class 1259 OID 2380856)
-- Name: ix_formapagamentonfs_fk_formapagamentonfs_vale_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_formapagamentonfs_fk_formapagamentonfs_vale_id ON notafiscal.formapagamentonfs USING btree (vale_id);


--
-- TOC entry 5865 (class 1259 OID 2380857)
-- Name: ix_itemauxiliarservico_fk_itemauxiliarservico_kitproduto_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_itemauxiliarservico_fk_itemauxiliarservico_kitproduto_id ON notafiscal.itemauxiliarservico USING btree (kitproduto_id);


--
-- TOC entry 5866 (class 1259 OID 2380858)
-- Name: ix_itemauxiliarservico_fk_itemauxiliarservico_servico_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_itemauxiliarservico_fk_itemauxiliarservico_servico_id ON notafiscal.itemauxiliarservico USING btree (servico_id);


--
-- TOC entry 5869 (class 1259 OID 2380859)
-- Name: ix_itemnotafiscal_fk_itemnotafiscal_cfop_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_itemnotafiscal_fk_itemnotafiscal_cfop_id ON notafiscal.itemnotafiscal USING btree (cfop_id);


--
-- TOC entry 5870 (class 1259 OID 2380860)
-- Name: ix_itemnotafiscal_fk_itemnotafiscal_csticms_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_itemnotafiscal_fk_itemnotafiscal_csticms_id ON notafiscal.itemnotafiscal USING btree (csticms_id);


--
-- TOC entry 5871 (class 1259 OID 2380861)
-- Name: ix_itemnotafiscal_fk_itemnotafiscal_cstipi_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_itemnotafiscal_fk_itemnotafiscal_cstipi_id ON notafiscal.itemnotafiscal USING btree (cstipi_id);


--
-- TOC entry 5872 (class 1259 OID 2380862)
-- Name: ix_itemnotafiscal_fk_itemnotafiscal_cstpiscofins_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_itemnotafiscal_fk_itemnotafiscal_cstpiscofins_id ON notafiscal.itemnotafiscal USING btree (cstpiscofins_id);


--
-- TOC entry 5873 (class 1259 OID 2380863)
-- Name: ix_itemnotafiscal_fk_itemnotafiscal_produto_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_itemnotafiscal_fk_itemnotafiscal_produto_id ON notafiscal.itemnotafiscal USING btree (produto_id);


--
-- TOC entry 5874 (class 1259 OID 2380864)
-- Name: ix_itemnotafiscal_fk_itemnotafiscal_serie; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_itemnotafiscal_fk_itemnotafiscal_serie ON notafiscal.itemnotafiscal USING btree (serie, empresaid, ambiente, tipofaturamento, numero);


--
-- TOC entry 5875 (class 1259 OID 2380865)
-- Name: ix_itemnotafiscal_fk_itemnotafiscal_tipoitem_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_itemnotafiscal_fk_itemnotafiscal_tipoitem_id ON notafiscal.itemnotafiscal USING btree (tipoitem_id);


--
-- TOC entry 5882 (class 1259 OID 2380866)
-- Name: ix_itemnotafiscalconsumidor_fk_itemnotafiscalconsumidor_cfop_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_itemnotafiscalconsumidor_fk_itemnotafiscalconsumidor_cfop_id ON notafiscal.itemnotafiscalconsumidor USING btree (cfop_id);


--
-- TOC entry 5891 (class 1259 OID 2380867)
-- Name: ix_itemnotafiscalservico_fk_itemnotafiscalservico_servico_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_itemnotafiscalservico_fk_itemnotafiscalservico_servico_id ON notafiscal.itemnotafiscalservico USING btree (servico_id);


--
-- TOC entry 5894 (class 1259 OID 2380868)
-- Name: ix_itemorcamento_fk_itemorcamento_orcamento_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_itemorcamento_fk_itemorcamento_orcamento_id ON notafiscal.itemorcamento USING btree (orcamento_id);


--
-- TOC entry 5895 (class 1259 OID 2380869)
-- Name: ix_itemorcamento_fk_itemorcamento_produto_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_itemorcamento_fk_itemorcamento_produto_id ON notafiscal.itemorcamento USING btree (produto_id);


--
-- TOC entry 5896 (class 1259 OID 2380870)
-- Name: ix_lancamentocustonfe_fk_lancamentocustonfe_custonfe_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_lancamentocustonfe_fk_lancamentocustonfe_custonfe_id ON notafiscal.lancamentocustonfe USING btree (custonfe_id);


--
-- TOC entry 5903 (class 1259 OID 2380871)
-- Name: ix_lotenfse_fk_lotenfse_empresa_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_lotenfse_fk_lotenfse_empresa_id ON notafiscal.lotenfse USING btree (empresa_id);


--
-- TOC entry 5904 (class 1259 OID 2380872)
-- Name: ix_lotenfse_fk_lotenfse_prestador_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_lotenfse_fk_lotenfse_prestador_id ON notafiscal.lotenfse USING btree (prestador_id);


--
-- TOC entry 5905 (class 1259 OID 2380873)
-- Name: ix_lotenfse_fk_lotenfse_usuarioalteracao_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_lotenfse_fk_lotenfse_usuarioalteracao_id ON notafiscal.lotenfse USING btree (usuarioalteracao_id);


--
-- TOC entry 5906 (class 1259 OID 2380874)
-- Name: ix_lotenfse_fk_lotenfse_usuariocadastro_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_lotenfse_fk_lotenfse_usuariocadastro_id ON notafiscal.lotenfse USING btree (usuariocadastro_id);


--
-- TOC entry 5920 (class 1259 OID 2380875)
-- Name: ix_notafiscal_fk_notafiscal_destinatario_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscal_fk_notafiscal_destinatario_id ON notafiscal.notafiscal USING btree (destinatario_id);


--
-- TOC entry 5921 (class 1259 OID 2380876)
-- Name: ix_notafiscal_fk_notafiscal_emitente_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscal_fk_notafiscal_emitente_id ON notafiscal.notafiscal USING btree (emitente_id);


--
-- TOC entry 5922 (class 1259 OID 2380877)
-- Name: ix_notafiscal_fk_notafiscal_empresa_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscal_fk_notafiscal_empresa_id ON notafiscal.notafiscal USING btree (empresa_id);


--
-- TOC entry 5923 (class 1259 OID 2380878)
-- Name: ix_notafiscal_fk_notafiscal_especievolumes_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscal_fk_notafiscal_especievolumes_id ON notafiscal.notafiscal USING btree (especievolumes_id);


--
-- TOC entry 5924 (class 1259 OID 2380879)
-- Name: ix_notafiscal_fk_notafiscal_lote_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscal_fk_notafiscal_lote_id ON notafiscal.notafiscal USING btree (lote_id);


--
-- TOC entry 5925 (class 1259 OID 2380880)
-- Name: ix_notafiscal_fk_notafiscal_natureza_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscal_fk_notafiscal_natureza_id ON notafiscal.notafiscal USING btree (natureza_id);


--
-- TOC entry 5926 (class 1259 OID 2380881)
-- Name: ix_notafiscal_fk_notafiscal_transportador_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscal_fk_notafiscal_transportador_id ON notafiscal.notafiscal USING btree (transportador_id);


--
-- TOC entry 5927 (class 1259 OID 2380882)
-- Name: ix_notafiscal_fk_notafiscal_usuarioalteracao_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscal_fk_notafiscal_usuarioalteracao_id ON notafiscal.notafiscal USING btree (usuarioalteracao_id);


--
-- TOC entry 5928 (class 1259 OID 2380883)
-- Name: ix_notafiscal_fk_notafiscal_usuariocadastro_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscal_fk_notafiscal_usuariocadastro_id ON notafiscal.notafiscal USING btree (usuariocadastro_id);


--
-- TOC entry 5929 (class 1259 OID 2380884)
-- Name: ix_notafiscal_fk_notafiscal_veiculo_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscal_fk_notafiscal_veiculo_id ON notafiscal.notafiscal USING btree (veiculo_id);


--
-- TOC entry 5930 (class 1259 OID 2380885)
-- Name: ix_notafiscal_fk_notafiscal_vendedor_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscal_fk_notafiscal_vendedor_id ON notafiscal.notafiscal USING btree (vendedor_id);


--
-- TOC entry 5940 (class 1259 OID 2380886)
-- Name: ix_notafiscalconsumidor_fk_notafiscalconsumidor_destinatario_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalconsumidor_fk_notafiscalconsumidor_destinatario_id ON notafiscal.notafiscalconsumidor USING btree (destinatario_id);


--
-- TOC entry 5941 (class 1259 OID 2380887)
-- Name: ix_notafiscalconsumidor_fk_notafiscalconsumidor_emitente_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalconsumidor_fk_notafiscalconsumidor_emitente_id ON notafiscal.notafiscalconsumidor USING btree (emitente_id);


--
-- TOC entry 5942 (class 1259 OID 2380888)
-- Name: ix_notafiscalconsumidor_fk_notafiscalconsumidor_empresa_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalconsumidor_fk_notafiscalconsumidor_empresa_id ON notafiscal.notafiscalconsumidor USING btree (empresa_id);


--
-- TOC entry 5943 (class 1259 OID 2380889)
-- Name: ix_notafiscalconsumidor_fk_notafiscalconsumidor_lote_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalconsumidor_fk_notafiscalconsumidor_lote_id ON notafiscal.notafiscalconsumidor USING btree (lote_id);


--
-- TOC entry 5944 (class 1259 OID 2380890)
-- Name: ix_notafiscalconsumidor_fk_notafiscalconsumidor_natureza_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalconsumidor_fk_notafiscalconsumidor_natureza_id ON notafiscal.notafiscalconsumidor USING btree (natureza_id);


--
-- TOC entry 5945 (class 1259 OID 2380891)
-- Name: ix_notafiscalconsumidor_fk_notafiscalconsumidor_ufsaidapais_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalconsumidor_fk_notafiscalconsumidor_ufsaidapais_id ON notafiscal.notafiscalconsumidor USING btree (ufsaidapais_id);


--
-- TOC entry 5946 (class 1259 OID 2380892)
-- Name: ix_notafiscalconsumidor_fk_notafiscalconsumidor_veiculo_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalconsumidor_fk_notafiscalconsumidor_veiculo_id ON notafiscal.notafiscalconsumidor USING btree (veiculo_id);


--
-- TOC entry 5955 (class 1259 OID 2380893)
-- Name: ix_notafiscalservico_fk_notafiscalservico_caixaaberto_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalservico_fk_notafiscalservico_caixaaberto_id ON notafiscal.notafiscalservico USING btree (caixaaberto_id);


--
-- TOC entry 5956 (class 1259 OID 2380894)
-- Name: ix_notafiscalservico_fk_notafiscalservico_empresa_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalservico_fk_notafiscalservico_empresa_id ON notafiscal.notafiscalservico USING btree (empresa_id);


--
-- TOC entry 5957 (class 1259 OID 2380895)
-- Name: ix_notafiscalservico_fk_notafiscalservico_enderecotomador_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalservico_fk_notafiscalservico_enderecotomador_id ON notafiscal.notafiscalservico USING btree (enderecotomador_id);


--
-- TOC entry 5958 (class 1259 OID 2380896)
-- Name: ix_notafiscalservico_fk_notafiscalservico_funcionario_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalservico_fk_notafiscalservico_funcionario_id ON notafiscal.notafiscalservico USING btree (funcionario_id);


--
-- TOC entry 5959 (class 1259 OID 2380897)
-- Name: ix_notafiscalservico_fk_notafiscalservico_lotenfse_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalservico_fk_notafiscalservico_lotenfse_id ON notafiscal.notafiscalservico USING btree (lotenfse_id);


--
-- TOC entry 5960 (class 1259 OID 2380898)
-- Name: ix_notafiscalservico_fk_notafiscalservico_prestador_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalservico_fk_notafiscalservico_prestador_id ON notafiscal.notafiscalservico USING btree (prestador_id);


--
-- TOC entry 5961 (class 1259 OID 2380899)
-- Name: ix_notafiscalservico_fk_notafiscalservico_tomador_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalservico_fk_notafiscalservico_tomador_id ON notafiscal.notafiscalservico USING btree (tomador_id);


--
-- TOC entry 5962 (class 1259 OID 2380900)
-- Name: ix_notafiscalservico_fk_notafiscalservico_usuarioalteracao_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalservico_fk_notafiscalservico_usuarioalteracao_id ON notafiscal.notafiscalservico USING btree (usuarioalteracao_id);


--
-- TOC entry 5963 (class 1259 OID 2380901)
-- Name: ix_notafiscalservico_fk_notafiscalservico_usuariocadastro_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_notafiscalservico_fk_notafiscalservico_usuariocadastro_id ON notafiscal.notafiscalservico USING btree (usuariocadastro_id);


--
-- TOC entry 5970 (class 1259 OID 2380902)
-- Name: ix_obscontribuintenfe_fk_obscontribuintenfe_tipofaturamento; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_obscontribuintenfe_fk_obscontribuintenfe_tipofaturamento ON notafiscal.obscontribuintenfe USING btree (tipofaturamento, empresaid, numero, ambiente, serie);


--
-- TOC entry 5976 (class 1259 OID 2380903)
-- Name: ix_orcamento_fk_orcamento_cliente_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_orcamento_fk_orcamento_cliente_id ON notafiscal.orcamento USING btree (cliente_id);


--
-- TOC entry 5977 (class 1259 OID 2380904)
-- Name: ix_orcamento_fk_orcamento_empresa_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_orcamento_fk_orcamento_empresa_id ON notafiscal.orcamento USING btree (empresa_id);


--
-- TOC entry 5978 (class 1259 OID 2380905)
-- Name: ix_orcamento_fk_orcamento_usuarioalteracao_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_orcamento_fk_orcamento_usuarioalteracao_id ON notafiscal.orcamento USING btree (usuarioalteracao_id);


--
-- TOC entry 5979 (class 1259 OID 2380906)
-- Name: ix_orcamento_fk_orcamento_usuariocadastro_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_orcamento_fk_orcamento_usuariocadastro_id ON notafiscal.orcamento USING btree (usuariocadastro_id);


--
-- TOC entry 5986 (class 1259 OID 2380907)
-- Name: ix_transportador_fk_transportador_municipio_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_transportador_fk_transportador_municipio_id ON notafiscal.transportador USING btree (municipio_id);


--
-- TOC entry 5989 (class 1259 OID 2380908)
-- Name: ix_veiculo_fk_veiculo_municipio_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_veiculo_fk_veiculo_municipio_id ON notafiscal.veiculo USING btree (municipio_id);


--
-- TOC entry 5990 (class 1259 OID 2380909)
-- Name: ix_veiculo_fk_veiculo_transportador_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ix_veiculo_fk_veiculo_transportador_id ON notafiscal.veiculo USING btree (transportador_id);


--
-- TOC entry 5909 (class 1259 OID 2380910)
-- Name: manifestacaodestinatario_fk_manifestacaodestinatario_empresa_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX manifestacaodestinatario_fk_manifestacaodestinatario_empresa_id ON notafiscal.manifestacaodestinatario USING btree (empresa_id);


--
-- TOC entry 5912 (class 1259 OID 2380911)
-- Name: mnfstacaodestinatariofkmnfestacaodestinatariousuarioalteracaoid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX mnfstacaodestinatariofkmnfestacaodestinatariousuarioalteracaoid ON notafiscal.manifestacaodestinatario USING btree (usuarioalteracao_id);


--
-- TOC entry 5913 (class 1259 OID 2380912)
-- Name: mnfstacaodestinatariofkmnifestacaodestinatariousuariocadastroid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX mnfstacaodestinatariofkmnifestacaodestinatariousuariocadastroid ON notafiscal.manifestacaodestinatario USING btree (usuariocadastro_id);


--
-- TOC entry 5947 (class 1259 OID 2380913)
-- Name: notafiscalconsumidor_fk_notafiscalconsumidor_especievolumes_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX notafiscalconsumidor_fk_notafiscalconsumidor_especievolumes_id ON notafiscal.notafiscalconsumidor USING btree (especievolumes_id);


--
-- TOC entry 5948 (class 1259 OID 2380914)
-- Name: notafiscalconsumidor_fk_notafiscalconsumidor_transportador_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX notafiscalconsumidor_fk_notafiscalconsumidor_transportador_id ON notafiscal.notafiscalconsumidor USING btree (transportador_id);


--
-- TOC entry 5949 (class 1259 OID 2380915)
-- Name: notafiscalconsumidor_fk_notafiscalconsumidor_usuariocadastro_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX notafiscalconsumidor_fk_notafiscalconsumidor_usuariocadastro_id ON notafiscal.notafiscalconsumidor USING btree (usuariocadastro_id);


--
-- TOC entry 5952 (class 1259 OID 2380916)
-- Name: notafiscalconsumidorfk_notafiscalconsumidor_usuarioalteracao_id; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX notafiscalconsumidorfk_notafiscalconsumidor_usuarioalteracao_id ON notafiscal.notafiscalconsumidor USING btree (usuarioalteracao_id);


--
-- TOC entry 5953 (class 1259 OID 2380917)
-- Name: notafiscalconsumidorfknotafiscalconsumidorvendedorfuncionarioid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX notafiscalconsumidorfknotafiscalconsumidorvendedorfuncionarioid ON notafiscal.notafiscalconsumidor USING btree (vendedorfuncionario_id);


--
-- TOC entry 5954 (class 1259 OID 2380918)
-- Name: ntafiscalconsumidorfknotafiscalconsumidorconsignacaodevolucaoid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ntafiscalconsumidorfknotafiscalconsumidorconsignacaodevolucaoid ON notafiscal.notafiscalconsumidor USING btree (consignacaodevolucao_id);


--
-- TOC entry 5968 (class 1259 OID 2380919)
-- Name: ntprdtrrrlreferenciadafkntprdtrrralreferenciadaestadoemitenteid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ntprdtrrrlreferenciadafkntprdtrrralreferenciadaestadoemitenteid ON notafiscal.notaprodutorruralreferenciada USING btree (estadoemitente_id);


--
-- TOC entry 5969 (class 1259 OID 2380920)
-- Name: ntprdtrrrlreferenciadafkntprdtrruralreferenciadatipofaturamento; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX ntprdtrrrlreferenciadafkntprdtrruralreferenciadatipofaturamento ON notafiscal.notaprodutorruralreferenciada USING btree (tipofaturamento, empresaid, numero, ambiente, serie);


--
-- TOC entry 5883 (class 1259 OID 2380921)
-- Name: temnotafiscalconsumidorfkitemnotafiscalconsumidorcstpiscofinsid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX temnotafiscalconsumidorfkitemnotafiscalconsumidorcstpiscofinsid ON notafiscal.itemnotafiscalconsumidor USING btree (cstpiscofins_id);


--
-- TOC entry 5884 (class 1259 OID 2380922)
-- Name: tmnotafiscalconsumidorfktmnotafiscalconsumidorpromocaoprodutoid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX tmnotafiscalconsumidorfktmnotafiscalconsumidorpromocaoprodutoid ON notafiscal.itemnotafiscalconsumidor USING btree (promocaoproduto_id);


--
-- TOC entry 5885 (class 1259 OID 2380923)
-- Name: tmntfscalconsumidorfktmntfiscalconsumidornotafiscalconsumidorid; Type: INDEX; Schema: notafiscal; Owner: postgres
--

CREATE INDEX tmntfscalconsumidorfktmntfiscalconsumidornotafiscalconsumidorid ON notafiscal.itemnotafiscalconsumidor USING btree (notafiscalconsumidor_id);


--
-- TOC entry 5995 (class 1259 OID 2380924)
-- Name: adiantamentoordemservico_fk_adiantamentoordemservico_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX adiantamentoordemservico_fk_adiantamentoordemservico_empresa_id ON public.adiantamentoordemservico USING btree (empresa_id);


--
-- TOC entry 6002 (class 1259 OID 2380925)
-- Name: adicionalitemdelivery_fk_adicionalitemdelivery_itemdelivery_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX adicionalitemdelivery_fk_adicionalitemdelivery_itemdelivery_id ON public.adicionalitemdelivery USING btree (itemdelivery_id);


--
-- TOC entry 6005 (class 1259 OID 2380926)
-- Name: adicionalitemdeliveryfkadicionalitemdelivery_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX adicionalitemdeliveryfkadicionalitemdelivery_usuariocadastro_id ON public.adicionalitemdelivery USING btree (usuariocadastro_id);


--
-- TOC entry 6006 (class 1259 OID 2380927)
-- Name: adicionalitemdeliveryfkadicionalitemdeliveryusuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX adicionalitemdeliveryfkadicionalitemdeliveryusuarioalteracao_id ON public.adicionalitemdelivery USING btree (usuarioalteracao_id);


--
-- TOC entry 6014 (class 1259 OID 2380928)
-- Name: adicionalprodutocontrole_fk_adicionalprodutocontrole_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX adicionalprodutocontrole_fk_adicionalprodutocontrole_empresa_id ON public.adicionalprodutocontrole USING btree (empresa_id);


--
-- TOC entry 6015 (class 1259 OID 2380929)
-- Name: adicionalprodutocontrole_fk_adicionalprodutocontrole_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX adicionalprodutocontrole_fk_adicionalprodutocontrole_produto_id ON public.adicionalprodutocontrole USING btree (produto_id);


--
-- TOC entry 6018 (class 1259 OID 2380930)
-- Name: adicionalprodutocontrolefkadicionalprodutocontrole_adicional_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX adicionalprodutocontrolefkadicionalprodutocontrole_adicional_id ON public.adicionalprodutocontrole USING btree (adicional_id);


--
-- TOC entry 6056 (class 1259 OID 2380931)
-- Name: cadastrofacillancado_fk_cadastrofacillancado_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cadastrofacillancado_fk_cadastrofacillancado_usuariocadastro_id ON public.cadastrofacillancado USING btree (usuariocadastro_id);


--
-- TOC entry 6059 (class 1259 OID 2380932)
-- Name: cadastrofacillancadofk_cadastrofacillancado_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cadastrofacillancadofk_cadastrofacillancado_usuarioalteracao_id ON public.cadastrofacillancado USING btree (usuarioalteracao_id);


--
-- TOC entry 6091 (class 1259 OID 2380933)
-- Name: clntfrncdrcmpsdcnsclntclntfrncdrcmpsdcnsclntclientefornecedorid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX clntfrncdrcmpsdcnsclntclntfrncdrcmpsdcnsclntclientefornecedorid ON public.clientefornecedor_camposadicionaiscliente USING btree (clientefornecedor_id);


--
-- TOC entry 6092 (class 1259 OID 2380934)
-- Name: clntfrncdrcmpsdcnsclntclntfrncdrcmpsdcnsclntecamposadicionaisid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX clntfrncdrcmpsdcnsclntclntfrncdrcmpsdcnsclntecamposadicionaisid ON public.clientefornecedor_camposadicionaiscliente USING btree (camposadicionais_id);


--
-- TOC entry 6095 (class 1259 OID 2380935)
-- Name: clntfrncdrhstrcclntfrncdrclntfrncdrhstrcclntfrncdrclntfrncdorid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX clntfrncdrhstrcclntfrncdrclntfrncdrhstrcclntfrncdrclntfrncdorid ON public.clientefornecedor_historicoclientefornecedor USING btree (clientefornecedor_id);


--
-- TOC entry 6096 (class 1259 OID 2380936)
-- Name: clntfrncdrhstrcclntfrncdrfkclntfrncdrhstrcclntfrncdrhstoricosid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX clntfrncdrhstrcclntfrncdrfkclntfrncdrhstrcclntfrncdrhstoricosid ON public.clientefornecedor_historicoclientefornecedor USING btree (historicos_id);


--
-- TOC entry 6099 (class 1259 OID 2380937)
-- Name: clntfrncdrtabelaprecofkclntfrncdortabelaprecousuarioalteracaoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX clntfrncdrtabelaprecofkclntfrncdortabelaprecousuarioalteracaoid ON public.clientefornecedortabelapreco USING btree (usuarioalteracao_id);


--
-- TOC entry 6100 (class 1259 OID 2380938)
-- Name: clntfrncdrtabelaprecofkclntfrncdrtabelaprecoclientefornecedorid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX clntfrncdrtabelaprecofkclntfrncdrtabelaprecoclientefornecedorid ON public.clientefornecedortabelapreco USING btree (clientefornecedor_id);


--
-- TOC entry 6101 (class 1259 OID 2380939)
-- Name: clntfrncdrtabelaprecofkclntfrncedortabelaprecousuariocadastroid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX clntfrncdrtabelaprecofkclntfrncedortabelaprecousuariocadastroid ON public.clientefornecedortabelapreco USING btree (usuariocadastro_id);


--
-- TOC entry 6102 (class 1259 OID 2380940)
-- Name: clntfrnecedortabelaprecofkclntfrnecedortabelaprecotabelaprecoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX clntfrnecedortabelaprecofkclntfrnecedortabelaprecotabelaprecoid ON public.clientefornecedortabelapreco USING btree (tabelapreco_id);


--
-- TOC entry 6071 (class 1259 OID 2380941)
-- Name: cmposadicionaisclientefkcamposadicionaisclientecampoadicionalid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cmposadicionaisclientefkcamposadicionaisclientecampoadicionalid ON public.camposadicionaiscliente USING btree (campoadicional_id);


--
-- TOC entry 6120 (class 1259 OID 2380942)
-- Name: cnhcmcnhcmnttrnsprtdcmntrfnfcnhcmnttrnsprtdcrfrncdntstrnsprtdsd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cnhcmcnhcmnttrnsprtdcmntrfnfcnhcmnttrnsprtdcrfrncdntstrnsprtdsd ON public.conhecimentotransportedocumentoref_nfconhecimentotransportedocr USING btree (notastransportadas_id);


--
-- TOC entry 6113 (class 1259 OID 2380943)
-- Name: cnhcmnttrnsprtdcmentoreffkcnhcmnttrnsprtdocumentorefremetenteid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cnhcmnttrnsprtdcmentoreffkcnhcmnttrnsprtdocumentorefremetenteid ON public.conhecimentotransportedocumentoref USING btree (remetente_id);


--
-- TOC entry 6114 (class 1259 OID 2380944)
-- Name: cnhcmnttrnsprtdcmntoreffkcnhcmnttrnsprtdcmentorefdestinatarioid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cnhcmnttrnsprtdcmntoreffkcnhcmnttrnsprtdcmentorefdestinatarioid ON public.conhecimentotransportedocumentoref USING btree (destinatario_id);


--
-- TOC entry 6115 (class 1259 OID 2380945)
-- Name: cnhcmnttrnsprtdcmntreffkcnhcmnttrnsprtdcmntorefmunicipiocargaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cnhcmnttrnsprtdcmntreffkcnhcmnttrnsprtdcmntorefmunicipiocargaid ON public.conhecimentotransportedocumentoref USING btree (municipiocarga_id);


--
-- TOC entry 6116 (class 1259 OID 2380946)
-- Name: cnhcmnttrnsprtdcmntrffkcnhcmnttrnsprtdcmntrefmunicipioterminoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cnhcmnttrnsprtdcmntrffkcnhcmnttrnsprtdcmntrefmunicipioterminoid ON public.conhecimentotransportedocumentoref USING btree (municipiotermino_id);


--
-- TOC entry 6121 (class 1259 OID 2380947)
-- Name: cnhcmnttrnsprtdcmntrfnfcnhcmnttrnsprtdcrfcnhcmnttrnsprtdcmntrfd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cnhcmnttrnsprtdcmntrfnfcnhcmnttrnsprtdcrfcnhcmnttrnsprtdcmntrfd ON public.conhecimentotransportedocumentoref_nfconhecimentotransportedocr USING btree (conhecimentotransportedocumentoref_id);


--
-- TOC entry 6117 (class 1259 OID 2380948)
-- Name: cnhcmnttrnsprtdcumentoreffkcnhcmnttrnsprtedocumentoreftomadorid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cnhcmnttrnsprtdcumentoreffkcnhcmnttrnsprtedocumentoreftomadorid ON public.conhecimentotransportedocumentoref USING btree (tomador_id);


--
-- TOC entry 6147 (class 1259 OID 2380949)
-- Name: creditocliente_indice; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX creditocliente_indice ON public.creditocliente USING btree (clientefornecedor_id, empresa_id);


--
-- TOC entry 6019 (class 1259 OID 2380950)
-- Name: dconalprodutocontrolefkdcionalprodutocontroleusuarioalteracaoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX dconalprodutocontrolefkdcionalprodutocontroleusuarioalteracaoid ON public.adicionalprodutocontrole USING btree (usuarioalteracao_id);


--
-- TOC entry 6020 (class 1259 OID 2380951)
-- Name: dconalprodutocontrolefkdicionalprodutocontroleusuariocadastroid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX dconalprodutocontrolefkdicionalprodutocontroleusuariocadastroid ON public.adicionalprodutocontrole USING btree (usuariocadastro_id);


--
-- TOC entry 6178 (class 1259 OID 2380952)
-- Name: devolucaotrocaproduto_fk_devolucaotrocaproduto_caixaaberto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX devolucaotrocaproduto_fk_devolucaotrocaproduto_caixaaberto_id ON public.devolucaotrocaproduto USING btree (caixaaberto_id);


--
-- TOC entry 6179 (class 1259 OID 2380953)
-- Name: devolucaotrocaproduto_fk_devolucaotrocaproduto_tabelapreco_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX devolucaotrocaproduto_fk_devolucaotrocaproduto_tabelapreco_id ON public.devolucaotrocaproduto USING btree (tabelapreco_id);


--
-- TOC entry 6182 (class 1259 OID 2380954)
-- Name: devolucaotrocaprodutofkdevolucaotrocaproduto_enderecocliente_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX devolucaotrocaprodutofkdevolucaotrocaproduto_enderecocliente_id ON public.devolucaotrocaproduto USING btree (enderecocliente_id);


--
-- TOC entry 6183 (class 1259 OID 2380955)
-- Name: devolucaotrocaprodutofkdevolucaotrocaproduto_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX devolucaotrocaprodutofkdevolucaotrocaproduto_usuariocadastro_id ON public.devolucaotrocaproduto USING btree (usuariocadastro_id);


--
-- TOC entry 6184 (class 1259 OID 2380956)
-- Name: devolucaotrocaprodutofkdevolucaotrocaprodutousuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX devolucaotrocaprodutofkdevolucaotrocaprodutousuarioalteracao_id ON public.devolucaotrocaproduto USING btree (usuarioalteracao_id);


--
-- TOC entry 5998 (class 1259 OID 2380957)
-- Name: diantamentoordemservicofkadiantamentoordemservicoordemservicoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX diantamentoordemservicofkadiantamentoordemservicoordemservicoid ON public.adiantamentoordemservico USING btree (ordemservico_id);


--
-- TOC entry 6021 (class 1259 OID 2380958)
-- Name: dicionalprodutocontrolefkadicionalprodutocontroledepartamentoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX dicionalprodutocontrolefkadicionalprodutocontroledepartamentoid ON public.adicionalprodutocontrole USING btree (departamento_id);


--
-- TOC entry 5999 (class 1259 OID 2380959)
-- Name: dntamentoordemservicofkdantamentoordemservicousuarioalteracaoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX dntamentoordemservicofkdantamentoordemservicousuarioalteracaoid ON public.adiantamentoordemservico USING btree (usuarioalteracao_id);


--
-- TOC entry 6000 (class 1259 OID 2380960)
-- Name: dntamentoordemservicofkdiantamentoordemservicousuariocadastroid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX dntamentoordemservicofkdiantamentoordemservicousuariocadastroid ON public.adiantamentoordemservico USING btree (usuariocadastro_id);


--
-- TOC entry 6001 (class 1259 OID 2380961)
-- Name: dntmntrdmsrvcofkdntmntrdmsrvicomovimentacaocreditovaleentradaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX dntmntrdmsrvcofkdntmntrdmsrvicomovimentacaocreditovaleentradaid ON public.adiantamentoordemservico USING btree (movimentacaocreditovaleentrada_id);


--
-- TOC entry 6206 (class 1259 OID 2380962)
-- Name: duplicatanotaentradafkduplicatanotaentrada_notafiscalentrada_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX duplicatanotaentradafkduplicatanotaentrada_notafiscalentrada_id ON public.duplicatanotaentrada USING btree (notafiscalentrada_id);


--
-- TOC entry 6238 (class 1259 OID 2380963)
-- Name: fatorconversaofornecedor_fk_fatorconversaofornecedor_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fatorconversaofornecedor_fk_fatorconversaofornecedor_produto_id ON public.fatorconversaofornecedor USING btree (produto_id);


--
-- TOC entry 6241 (class 1259 OID 2380964)
-- Name: fatorconversaofornecedorfkfatorconversaofornecedorfornecedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fatorconversaofornecedorfkfatorconversaofornecedorfornecedor_id ON public.fatorconversaofornecedor USING btree (fornecedor_id);


--
-- TOC entry 6251 (class 1259 OID 2380965)
-- Name: formapagamentodeliveryfkformapagamentodelivery_maquinacartao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX formapagamentodeliveryfkformapagamentodelivery_maquinacartao_id ON public.formapagamentodelivery USING btree (maquinacartao_id);


--
-- TOC entry 6270 (class 1259 OID 2380966)
-- Name: formapagamentopedido_fk_formapagamentopedido_maquinacartao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX formapagamentopedido_fk_formapagamentopedido_maquinacartao_id ON public.formapagamentopedido USING btree (maquinacartao_id);


--
-- TOC entry 6273 (class 1259 OID 2380967)
-- Name: formapagamentopedidofk_formapagamentopedido_moedaestrangeira_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX formapagamentopedidofk_formapagamentopedido_moedaestrangeira_id ON public.formapagamentopedido USING btree (moedaestrangeira_id);


--
-- TOC entry 6084 (class 1259 OID 2380968)
-- Name: fornecedor_nome_indice; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fornecedor_nome_indice ON public.clientefornecedor USING btree (razaosocial, nomefantasia);


--
-- TOC entry 6252 (class 1259 OID 2380969)
-- Name: frmapagamentodeliveryfkformapagamentodeliverymoedaestrangeiraid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX frmapagamentodeliveryfkformapagamentodeliverymoedaestrangeiraid ON public.formapagamentodelivery USING btree (moedaestrangeira_id);


--
-- TOC entry 6258 (class 1259 OID 2380970)
-- Name: frmpgamentodevolucaoprodutofkfrmpagamentodevolucaoprodutovaleid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX frmpgamentodevolucaoprodutofkfrmpagamentodevolucaoprodutovaleid ON public.formapagamentodevolucaoproduto USING btree (vale_id);


--
-- TOC entry 6268 (class 1259 OID 2380971)
-- Name: frmpgamentoordemservicofkfrmpagamentoordemservicoordemservicoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX frmpgamentoordemservicofkfrmpagamentoordemservicoordemservicoid ON public.formapagamentoordemservico USING btree (ordemservico_id);


--
-- TOC entry 6274 (class 1259 OID 2380972)
-- Name: frmpgamentopedidofkfrmpagamentopedidomovimentacaocreditosaidaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX frmpgamentopedidofkfrmpagamentopedidomovimentacaocreditosaidaid ON public.formapagamentopedido USING btree (movimentacaocreditosaida_id);


--
-- TOC entry 6269 (class 1259 OID 2380973)
-- Name: frmpgmentoordemservicofkfrmpagamentoordemservicomaquinacartaoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX frmpgmentoordemservicofkfrmpagamentoordemservicomaquinacartaoid ON public.formapagamentoordemservico USING btree (maquinacartao_id);


--
-- TOC entry 6265 (class 1259 OID 2380974)
-- Name: frmpgmntdcmentofiscalfkfrmpgmntdocumentofiscaldocumentofiscalid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX frmpgmntdcmentofiscalfkfrmpgmntdocumentofiscaldocumentofiscalid ON public.formapagamentodocumentofiscal USING btree (documentofiscal_id);


--
-- TOC entry 6259 (class 1259 OID 2380975)
-- Name: frmpgmntdvlcaoprodutofkfrmpgmntdvlucaoprodutodevolucaoprodutoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX frmpgmntdvlcaoprodutofkfrmpgmntdvlucaoprodutodevolucaoprodutoid ON public.formapagamentodevolucaoproduto USING btree (devolucaoproduto_id);


--
-- TOC entry 6260 (class 1259 OID 2380976)
-- Name: frmpgmntdvlcaoprodutofkfrmpgmntdvlucaoprodutomoedaestrangeiraid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX frmpgmntdvlcaoprodutofkfrmpgmntdvlucaoprodutomoedaestrangeiraid ON public.formapagamentodevolucaoproduto USING btree (moedaestrangeira_id);


--
-- TOC entry 6261 (class 1259 OID 2380977)
-- Name: frmpgmntdvlcprdtofkfrmpgmntdvlcprdutomovimentacaocreditosaidaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX frmpgmntdvlcprdtofkfrmpgmntdvlcprdutomovimentacaocreditosaidaid ON public.formapagamentodevolucaoproduto USING btree (movimentacaocreditosaida_id);


--
-- TOC entry 6262 (class 1259 OID 2380978)
-- Name: frmpgmntdvlucaoprodutofkfrmpgmntdevolucaoprodutomaquinacartaoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX frmpgmntdvlucaoprodutofkfrmpgmntdevolucaoprodutomaquinacartaoid ON public.formapagamentodevolucaoproduto USING btree (maquinacartao_id);


--
-- TOC entry 6253 (class 1259 OID 2380979)
-- Name: frmpgmntodeliveryfkfrmpgmentodeliverymovimentacaocreditosaidaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX frmpgmntodeliveryfkfrmpgmentodeliverymovimentacaocreditosaidaid ON public.formapagamentodelivery USING btree (movimentacaocreditosaida_id);


--
-- TOC entry 6304 (class 1259 OID 2380980)
-- Name: historicodescricaoprodutofkhistoricodescricaoproduto_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX historicodescricaoprodutofkhistoricodescricaoproduto_produto_id ON public.historicodescricaoproduto USING btree (produto_id);


--
-- TOC entry 6307 (class 1259 OID 2380981)
-- Name: historicointegracaoprodutofkhistoricointegracaoprodutoempresaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX historicointegracaoprodutofkhistoricointegracaoprodutoempresaid ON public.historicointegracaoproduto USING btree (empresa_id);


--
-- TOC entry 6308 (class 1259 OID 2380982)
-- Name: historicointegracaoprodutofkhistoricointegracaoprodutousuarioid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX historicointegracaoprodutofkhistoricointegracaoprodutousuarioid ON public.historicointegracaoproduto USING btree (usuario_id);


--
-- TOC entry 6319 (class 1259 OID 2380983)
-- Name: historicoprecovendaprodutofkhistoricoprecovendaprodutoempresaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX historicoprecovendaprodutofkhistoricoprecovendaprodutoempresaid ON public.historicoprecovendaproduto USING btree (empresa_id);


--
-- TOC entry 6320 (class 1259 OID 2380984)
-- Name: historicoprecovendaprodutofkhistoricoprecovendaprodutoprodutoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX historicoprecovendaprodutofkhistoricoprecovendaprodutoprodutoid ON public.historicoprecovendaproduto USING btree (produto_id);


--
-- TOC entry 6311 (class 1259 OID 2380985)
-- Name: hstoricoprecocompraprodutofkhstoricoprecocompraprodutoempresaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hstoricoprecocompraprodutofkhstoricoprecocompraprodutoempresaid ON public.historicoprecocompraproduto USING btree (empresa_id);


--
-- TOC entry 6312 (class 1259 OID 2380986)
-- Name: hstoricoprecocompraprodutofkhstoricoprecocompraprodutoprodutoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hstoricoprecocompraprodutofkhstoricoprecocompraprodutoprodutoid ON public.historicoprecocompraproduto USING btree (produto_id);


--
-- TOC entry 6313 (class 1259 OID 2380987)
-- Name: hstrcoprecocompraprodutofkhstricoprecocompraprodutofornecedorid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hstrcoprecocompraprodutofkhstricoprecocompraprodutofornecedorid ON public.historicoprecocompraproduto USING btree (fornecedor_id);


--
-- TOC entry 6314 (class 1259 OID 2380988)
-- Name: hstrcprccompraprodutofkhstrcprcocompraprodutousuarioalteracaoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hstrcprccompraprodutofkhstrcprcocompraprodutousuarioalteracaoid ON public.historicoprecocompraproduto USING btree (usuarioalteracao_id);


--
-- TOC entry 6315 (class 1259 OID 2380989)
-- Name: hstrcprccompraprodutofkhstrcprecocompraprodutousuariocadastroid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hstrcprccompraprodutofkhstrcprecocompraprodutousuariocadastroid ON public.historicoprecocompraproduto USING btree (usuariocadastro_id);


--
-- TOC entry 6321 (class 1259 OID 2380990)
-- Name: hstrcprcovendaprodutofkhstrcprecovendaprodutousuarioalteracaoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hstrcprcovendaprodutofkhstrcprecovendaprodutousuarioalteracaoid ON public.historicoprecovendaproduto USING btree (usuarioalteracao_id);


--
-- TOC entry 6322 (class 1259 OID 2380991)
-- Name: hstrcprcvendaprodutofkhstrcprecovendaprodutonotafiscalentradaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hstrcprcvendaprodutofkhstrcprecovendaprodutonotafiscalentradaid ON public.historicoprecovendaproduto USING btree (notafiscalentrada_id);


--
-- TOC entry 6316 (class 1259 OID 2380992)
-- Name: hstrcprecocompraprodutofkhstricoprecocompraprodutonotaentradaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hstrcprecocompraprodutofkhstricoprecocompraprodutonotaentradaid ON public.historicoprecocompraproduto USING btree (notaentrada_id);


--
-- TOC entry 6323 (class 1259 OID 2380993)
-- Name: hstrcprecovendaprodutofkhstrcprecovendaprodutousuariocadastroid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hstrcprecovendaprodutofkhstrcprecovendaprodutousuariocadastroid ON public.historicoprecovendaproduto USING btree (usuariocadastro_id);


--
-- TOC entry 6010 (class 1259 OID 2380994)
-- Name: idx_adicional_codigo_empresa_unicidade; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_adicional_codigo_empresa_unicidade ON public.adicionalproduto USING btree (codigo, empresa_id);


--
-- TOC entry 6022 (class 1259 OID 2380995)
-- Name: idx_adicional_departamento_unicidade; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_adicional_departamento_unicidade ON public.adicionalprodutocontrole USING btree (adicional_id, departamento_id);


--
-- TOC entry 6023 (class 1259 OID 2380996)
-- Name: idx_adicional_produto_unicidade; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_adicional_produto_unicidade ON public.adicionalprodutocontrole USING btree (adicional_id, produto_id);


--
-- TOC entry 6842 (class 1259 OID 2380997)
-- Name: idx_auxiliar_servico; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auxiliar_servico ON public.vendasorigem USING btree (auxiliarservico_id);


--
-- TOC entry 6843 (class 1259 OID 2380998)
-- Name: idx_auxiliar_venda; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auxiliar_venda ON public.vendasorigem USING btree (auxiliarvenda_id);


--
-- TOC entry 6054 (class 1259 OID 2380999)
-- Name: idx_beneficiofiscal_estado_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_beneficiofiscal_estado_unique ON public.beneficiofiscal USING btree (datavigencia, codigo, estado_id);


--
-- TOC entry 6060 (class 1259 OID 2381000)
-- Name: idx_cadastro_facil_lancado_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cadastro_facil_lancado_unique ON public.cadastrofacillancado USING btree (chaveacesso, empresa_id);


--
-- TOC entry 6064 (class 1259 OID 2381001)
-- Name: idx_caixa_aberto_usuario_empresa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_caixa_aberto_usuario_empresa ON public.caixa USING btree (usuario_id, empresa_id, aberto) WHERE (aberto IS TRUE);


--
-- TOC entry 6074 (class 1259 OID 2381002)
-- Name: idx_cest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cest ON public.cest USING btree (cest, ncm, descricaocest, datavigencia);


--
-- TOC entry 6075 (class 1259 OID 2381003)
-- Name: idx_cest_ncm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cest_ncm ON public.cest USING btree (cest, ncm);


--
-- TOC entry 6080 (class 1259 OID 2381004)
-- Name: idx_cfop; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cfop ON public.cfop USING btree (codigo);


--
-- TOC entry 6511 (class 1259 OID 2381005)
-- Name: idx_chave_acesso; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_chave_acesso ON public.notafiscalentrada USING btree (chaveacesso);


--
-- TOC entry 6085 (class 1259 OID 2381006)
-- Name: idx_clientefornecedor_cpfcnpj; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_clientefornecedor_cpfcnpj ON public.clientefornecedor USING btree (cpfcnpj) WHERE (((cpfcnpj)::text <> '00000000000'::text) AND ((cpfcnpj)::text <> '00000000000000'::text) AND (datacadastro > '2021-02-10'::date));


--
-- TOC entry 6105 (class 1259 OID 2381007)
-- Name: idx_cnae_codigo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cnae_codigo ON public.cnae USING btree (codigo);


--
-- TOC entry 6076 (class 1259 OID 2381008)
-- Name: idx_codigo_cest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_codigo_cest ON public.cest USING btree (cest);


--
-- TOC entry 6154 (class 1259 OID 2381009)
-- Name: idx_codigo_cst; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_codigo_cst ON public.cst USING btree (codigo);


--
-- TOC entry 6333 (class 1259 OID 2381010)
-- Name: idx_codigo_empresa_informacao; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_codigo_empresa_informacao ON public.informacaonutricional USING btree (codigo, empresa_id);


--
-- TOC entry 6155 (class 1259 OID 2381011)
-- Name: idx_cst; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cst ON public.cst USING btree (descricao, codigo);


--
-- TOC entry 6483 (class 1259 OID 2381012)
-- Name: idx_data; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_data ON public.movimentoestoque USING btree (datamovimentacao);


--
-- TOC entry 6244 (class 1259 OID 2381013)
-- Name: idx_datefat; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_datefat ON public.faturamentomensal USING btree (data);


--
-- TOC entry 6245 (class 1259 OID 2381014)
-- Name: idx_datefat_empresa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_datefat_empresa ON public.faturamentomensal USING btree (data, empresa_id);


--
-- TOC entry 6161 (class 1259 OID 2381015)
-- Name: idx_delivery_data; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_delivery_data ON public.delivery USING btree (data);


--
-- TOC entry 6209 (class 1259 OID 2381016)
-- Name: idx_emailbackup; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_emailbackup ON public.emailsbackup USING btree (id);


--
-- TOC entry 6673 (class 1259 OID 2381017)
-- Name: idx_empresa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_empresa ON public.preferencia USING btree (empresa_id);


--
-- TOC entry 6628 (class 1259 OID 2381018)
-- Name: idx_emrpesa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_emrpesa ON public.parametrosempresa USING btree (empresa_id);


--
-- TOC entry 6228 (class 1259 OID 2381019)
-- Name: idx_equipamento; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_equipamento ON public.equipamento USING btree (identificacao, empresa_id, clientefornecedor_id);


--
-- TOC entry 6484 (class 1259 OID 2381020)
-- Name: idx_estoque_produto_data; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_estoque_produto_data ON public.movimentoestoque USING btree (produto_id, datamovimentacao);


--
-- TOC entry 6485 (class 1259 OID 2381021)
-- Name: idx_estoque_tipo_data; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_estoque_tipo_data ON public.movimentoestoque USING btree (tipomovimento, datamovimentacao);


--
-- TOC entry 6246 (class 1259 OID 2381022)
-- Name: idx_fat_mes_ano; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fat_mes_ano ON public.faturamentomensal USING btree (mes, ano);


--
-- TOC entry 6693 (class 1259 OID 2381023)
-- Name: idx_fornec; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fornec ON public.produtofornecedor USING btree (clientefornecedor_id);


--
-- TOC entry 6694 (class 1259 OID 2381024)
-- Name: idx_fornecedor_ci; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fornecedor_ci ON public.produtofornecedor USING btree (clientefornecedor_id, codigointernofornecedor);


--
-- TOC entry 6695 (class 1259 OID 2381025)
-- Name: idx_fornecedor_ci_prod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fornecedor_ci_prod ON public.produtofornecedor USING btree (clientefornecedor_id, codigointernofornecedor, produto_id);


--
-- TOC entry 6086 (class 1259 OID 2381026)
-- Name: idx_fornecedor_cnpj; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fornecedor_cnpj ON public.clientefornecedor USING btree (cpfcnpj);


--
-- TOC entry 6289 (class 1259 OID 2381027)
-- Name: idx_grupo_unicidade; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_grupo_unicidade ON public.grupodespesareceita USING btree (numero, empresa_id);


--
-- TOC entry 6292 (class 1259 OID 2381028)
-- Name: idx_grupoimpressao_codigo_empresa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_grupoimpressao_codigo_empresa ON public.grupoimpressao USING btree (nome, codigo, empresa_id);


--
-- TOC entry 6293 (class 1259 OID 2381029)
-- Name: idx_grupoimpressao_empresa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_grupoimpressao_empresa ON public.grupoimpressao USING btree (nome, nomeimpressora, empresa_id);


--
-- TOC entry 6156 (class 1259 OID 2381030)
-- Name: idx_imposto_cst; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_imposto_cst ON public.cst USING btree (imposto);


--
-- TOC entry 6824 (class 1259 OID 2381031)
-- Name: idx_login_senha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_login_senha ON public.usuario USING btree (usuario, senha);


--
-- TOC entry 6445 (class 1259 OID 2381032)
-- Name: idx_modulo_modulo_empresa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_modulo_modulo_empresa ON public.modulo USING btree (modulo, empresa_id);


--
-- TOC entry 6497 (class 1259 OID 2381033)
-- Name: idx_ncm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ncm ON public.ncm USING btree (numero, descricao);


--
-- TOC entry 6077 (class 1259 OID 2381034)
-- Name: idx_ncm_forcest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ncm_forcest ON public.cest USING btree (ncm);


--
-- TOC entry 6498 (class 1259 OID 2381035)
-- Name: idx_ncm_numero; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ncm_numero ON public.ncm USING btree (numero);


--
-- TOC entry 6191 (class 1259 OID 2381036)
-- Name: idx_nf_clifor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_nf_clifor ON public.documentofiscal USING btree (cliente_id, empresa_id);


--
-- TOC entry 6192 (class 1259 OID 2381037)
-- Name: idx_nf_dtlanct; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_nf_dtlanct ON public.documentofiscal USING btree (dataemissaodocumento, empresa_id);


--
-- TOC entry 6236 (class 1259 OID 2381038)
-- Name: idx_nome; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_nome ON public.estado USING btree (nome);


--
-- TOC entry 6491 (class 1259 OID 2381039)
-- Name: idx_nome_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_nome_estado ON public.municipio USING btree (nome, estado_id);


--
-- TOC entry 6530 (class 1259 OID 2381040)
-- Name: idx_nome_pais; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_nome_pais ON public.pais USING btree (nome);


--
-- TOC entry 6844 (class 1259 OID 2381041)
-- Name: idx_nota_fiscal; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_nota_fiscal ON public.vendasorigem USING btree (serie, numero, tipofaturamento, empresaid);


--
-- TOC entry 6845 (class 1259 OID 2381042)
-- Name: idx_nota_fiscal_consumidor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_nota_fiscal_consumidor ON public.vendasorigem USING btree (notafiscalconsumidor_id);


--
-- TOC entry 6846 (class 1259 OID 2381043)
-- Name: idx_nota_fiscal_servico; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_nota_fiscal_servico ON public.vendasorigem USING btree (notafiscalservico_id);


--
-- TOC entry 6521 (class 1259 OID 2381044)
-- Name: idx_ordem_numero; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ordem_numero ON public.ordemservico USING btree (numeroordem, empresa_id);


--
-- TOC entry 6539 (class 1259 OID 2381045)
-- Name: idx_parametro_beneficio_fiscal_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_parametro_beneficio_fiscal_unique ON public.parametrobeneficiofiscal USING btree (codigo, datavigencia, estado_id);


--
-- TOC entry 6555 (class 1259 OID 2381046)
-- Name: idx_parametro_icms; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_parametro_icms ON public.parametroicms USING btree (datavigencia, parametroncm_id, estado_id);


--
-- TOC entry 6587 (class 1259 OID 2381047)
-- Name: idx_parametro_ipi; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_parametro_ipi ON public.parametroipi USING btree (datavigencia, parametroncm_id);


--
-- TOC entry 6593 (class 1259 OID 2381048)
-- Name: idx_parametro_ncm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_parametro_ncm ON public.parametroncm USING btree (datavigencia, numeroncm, excecaoncm);


--
-- TOC entry 6611 (class 1259 OID 2381049)
-- Name: idx_parametro_piscofins; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_parametro_piscofins ON public.parametropiscofins USING btree (datavigencia, parametroncm_id);


--
-- TOC entry 6621 (class 1259 OID 2381050)
-- Name: idx_parametro_produto; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_parametro_produto ON public.parametroproduto USING btree (produto_id);


--
-- TOC entry 6629 (class 1259 OID 2381051)
-- Name: idx_parametros_empresa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_parametros_empresa ON public.parametrosempresa USING btree (empresa_id, regimetributario_id);


--
-- TOC entry 6661 (class 1259 OID 2381052)
-- Name: idx_pedido_compra_numero; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_pedido_compra_numero ON public.pedidocompra USING btree (numeropedidocompra, empresa_id);


--
-- TOC entry 6653 (class 1259 OID 2381053)
-- Name: idx_pedido_numero; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_pedido_numero ON public.pedido USING btree (numeropedido, empresa_id);


--
-- TOC entry 6680 (class 1259 OID 2381054)
-- Name: idx_prod_unicidade; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_prod_unicidade ON public.produto USING btree (codigointerno, empresa_id);


--
-- TOC entry 6681 (class 1259 OID 2381055)
-- Name: idx_produto; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_produto ON public.produto USING btree (codigointerno);


--
-- TOC entry 6682 (class 1259 OID 2381056)
-- Name: idx_produto_ean_com; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_produto_ean_com ON public.produto USING btree (eancomercial);


--
-- TOC entry 6334 (class 1259 OID 2381057)
-- Name: idx_produto_empresa_informacao; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_produto_empresa_informacao ON public.informacaonutricional USING btree (produto_id, empresa_id);


--
-- TOC entry 6728 (class 1259 OID 2381058)
-- Name: idx_situacao; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_situacao ON public.situacao USING btree (descricao, status, empresa_id);


--
-- TOC entry 6757 (class 1259 OID 2381059)
-- Name: idx_tabela_ibpt; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_tabela_ibpt ON public.tabelaibpt USING btree (codigoncm, excecaoncm, vigenciainicio, vigenciafim, versao, estado_id);


--
-- TOC entry 6799 (class 1259 OID 2381060)
-- Name: idx_tributacao_empresa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_tributacao_empresa ON public.tributacaogeralempresa USING btree (empresa_id);


--
-- TOC entry 6173 (class 1259 OID 2381061)
-- Name: idx_unicidade_codigo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unicidade_codigo ON public.departamento USING btree (codigo, empresa_id);


--
-- TOC entry 6427 (class 1259 OID 2381062)
-- Name: idx_unicidade_codigo_marca; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unicidade_codigo_marca ON public.marca USING btree (codigo, empresa_id);


--
-- TOC entry 6770 (class 1259 OID 2381063)
-- Name: idx_unicidade_codigointerno_tara; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unicidade_codigointerno_tara ON public.tara USING btree (codigointerno, empresa_id);


--
-- TOC entry 6819 (class 1259 OID 2381064)
-- Name: idx_unicidade_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unicidade_id ON public.unidademedida USING btree (id, sigla);


--
-- TOC entry 6247 (class 1259 OID 2381065)
-- Name: idx_unique_mes_ano_fat; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unique_mes_ano_fat ON public.faturamentomensal USING btree (mes, ano, empresa_id);


--
-- TOC entry 6810 (class 1259 OID 2381066)
-- Name: idx_unique_tributacaoncm_ncm_ignorarcfop; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unique_tributacaoncm_ncm_ignorarcfop ON public.tributacaoporncm USING btree (numeroncm, excecaoncm, ignorarcfop, empresa_id) WHERE (ignorarcfop IS TRUE);


--
-- TOC entry 6829 (class 1259 OID 2381067)
-- Name: idx_usuario_empresa_caixa_liberacao; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_usuario_empresa_caixa_liberacao ON public.usuariocaixa USING btree (usuario_id, empresa_id, caixa_id);


--
-- TOC entry 6835 (class 1259 OID 2381068)
-- Name: idx_usuario_empresa_liberacao; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_usuario_empresa_liberacao ON public.usuarioempresa USING btree (usuario_id, empresa_id);


--
-- TOC entry 6670 (class 1259 OID 2381069)
-- Name: idx_valores; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_valores ON public.percentualcreditoicms USING btree (valorinicial, valorfinal);


--
-- TOC entry 6337 (class 1259 OID 2381070)
-- Name: informacaonutricionalfkinformacaonutricional_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX informacaonutricionalfkinformacaonutricional_usuariocadastro_id ON public.informacaonutricional USING btree (usuariocadastro_id);


--
-- TOC entry 6338 (class 1259 OID 2381071)
-- Name: informacaonutricionalfkinformacaonutricionalusuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX informacaonutricionalfkinformacaonutricionalusuarioalteracao_id ON public.informacaonutricional USING btree (usuarioalteracao_id);


--
-- TOC entry 6357 (class 1259 OID 2381072)
-- Name: itemdevolucaotrocafkitemdevolucaotroca_devolucaotrocaproduto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX itemdevolucaotrocafkitemdevolucaotroca_devolucaotrocaproduto_id ON public.itemdevolucaotroca USING btree (devolucaotrocaproduto_id);


--
-- TOC entry 6360 (class 1259 OID 2381073)
-- Name: itemdocumentofiscal_fk_itemdocumentofiscal_documentofiscal_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX itemdocumentofiscal_fk_itemdocumentofiscal_documentofiscal_id ON public.itemdocumentofiscal USING btree (documentofiscal_id);


--
-- TOC entry 6363 (class 1259 OID 2381074)
-- Name: itemdocumentofiscalfk_itemdocumentofiscal_naturezareceitapis_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX itemdocumentofiscalfk_itemdocumentofiscal_naturezareceitapis_id ON public.itemdocumentofiscal USING btree (naturezareceitapis_id);


--
-- TOC entry 6364 (class 1259 OID 2381075)
-- Name: itemdocumentofiscalfkitemdocumentofiscalnaturezareceitacofinsid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX itemdocumentofiscalfkitemdocumentofiscalnaturezareceitacofinsid ON public.itemdocumentofiscal USING btree (naturezareceitacofins_id);


--
-- TOC entry 6384 (class 1259 OID 2381076)
-- Name: itemnotafiscalentrada_fk_itemnotafiscalentrada_cstpiscofins_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX itemnotafiscalentrada_fk_itemnotafiscalentrada_cstpiscofins_id ON public.itemnotafiscalentrada USING btree (cstpiscofins_id);


--
-- TOC entry 6387 (class 1259 OID 2381077)
-- Name: itemnotafiscalentradafkitemnotafiscalentradanotafiscalentradaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX itemnotafiscalentradafkitemnotafiscalentradanotafiscalentradaid ON public.itemnotafiscalentrada USING btree (notafiscalentrada_id);


--
-- TOC entry 6399 (class 1259 OID 2381078)
-- Name: itempedidocompra_fk_itempedidocompra_unidademedidacomercial_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX itempedidocompra_fk_itempedidocompra_unidademedidacomercial_id ON public.itempedidocompra USING btree (unidademedidacomercial_id);


--
-- TOC entry 6007 (class 1259 OID 2381079)
-- Name: ix_adicionalitemdelivery_fk_adicionalitemdelivery_adicional_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_adicionalitemdelivery_fk_adicionalitemdelivery_adicional_id ON public.adicionalitemdelivery USING btree (adicional_id);


--
-- TOC entry 6011 (class 1259 OID 2381080)
-- Name: ix_adicionalproduto_fk_adicionalproduto_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_adicionalproduto_fk_adicionalproduto_empresa_id ON public.adicionalproduto USING btree (empresa_id);


--
-- TOC entry 6012 (class 1259 OID 2381081)
-- Name: ix_adicionalproduto_fk_adicionalproduto_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_adicionalproduto_fk_adicionalproduto_usuarioalteracao_id ON public.adicionalproduto USING btree (usuarioalteracao_id);


--
-- TOC entry 6013 (class 1259 OID 2381082)
-- Name: ix_adicionalproduto_fk_adicionalproduto_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_adicionalproduto_fk_adicionalproduto_usuariocadastro_id ON public.adicionalproduto USING btree (usuariocadastro_id);


--
-- TOC entry 6026 (class 1259 OID 2381083)
-- Name: ix_anexo_fk_anexo_clientefornecedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_anexo_fk_anexo_clientefornecedor_id ON public.anexo USING btree (clientefornecedor_id);


--
-- TOC entry 6027 (class 1259 OID 2381084)
-- Name: ix_anexo_fk_anexo_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_anexo_fk_anexo_usuarioalteracao_id ON public.anexo USING btree (usuarioalteracao_id);


--
-- TOC entry 6028 (class 1259 OID 2381085)
-- Name: ix_anexo_fk_anexo_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_anexo_fk_anexo_usuariocadastro_id ON public.anexo USING btree (usuariocadastro_id);


--
-- TOC entry 6031 (class 1259 OID 2381086)
-- Name: ix_anotacaopedido_fk_anotacaopedido_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_anotacaopedido_fk_anotacaopedido_empresa_id ON public.anotacaopedido USING btree (empresa_id);


--
-- TOC entry 6032 (class 1259 OID 2381087)
-- Name: ix_anotacaopedido_fk_anotacaopedido_statusanotacaopedido_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_anotacaopedido_fk_anotacaopedido_statusanotacaopedido_id ON public.anotacaopedido USING btree (statusanotacaopedido_id);


--
-- TOC entry 6033 (class 1259 OID 2381088)
-- Name: ix_anotacaopedido_fk_anotacaopedido_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_anotacaopedido_fk_anotacaopedido_usuarioalteracao_id ON public.anotacaopedido USING btree (usuarioalteracao_id);


--
-- TOC entry 6034 (class 1259 OID 2381089)
-- Name: ix_anotacaopedido_fk_anotacaopedido_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_anotacaopedido_fk_anotacaopedido_usuariocadastro_id ON public.anotacaopedido USING btree (usuariocadastro_id);


--
-- TOC entry 6037 (class 1259 OID 2381090)
-- Name: ix_atalhobarraferramentas_fk_atalhobarraferramentas_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_atalhobarraferramentas_fk_atalhobarraferramentas_empresa_id ON public.atalhobarraferramentas USING btree (empresa_id);


--
-- TOC entry 6038 (class 1259 OID 2381091)
-- Name: ix_atalhobarraferramentas_fk_atalhobarraferramentas_usuario_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_atalhobarraferramentas_fk_atalhobarraferramentas_usuario_id ON public.atalhobarraferramentas USING btree (usuario_id);


--
-- TOC entry 6043 (class 1259 OID 2381092)
-- Name: ix_backup_fk_backup_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_backup_fk_backup_empresa_id ON public.backup USING btree (empresa_id);


--
-- TOC entry 6044 (class 1259 OID 2381093)
-- Name: ix_backup_fk_backup_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_backup_fk_backup_usuarioalteracao_id ON public.backup USING btree (usuarioalteracao_id);


--
-- TOC entry 6045 (class 1259 OID 2381094)
-- Name: ix_backup_fk_backup_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_backup_fk_backup_usuariocadastro_id ON public.backup USING btree (usuariocadastro_id);


--
-- TOC entry 6048 (class 1259 OID 2381095)
-- Name: ix_balanca_fk_balanca_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_balanca_fk_balanca_empresa_id ON public.balanca USING btree (empresa_id);


--
-- TOC entry 6049 (class 1259 OID 2381096)
-- Name: ix_balanca_fk_balanca_tara_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_balanca_fk_balanca_tara_id ON public.balanca USING btree (tara_id);


--
-- TOC entry 6050 (class 1259 OID 2381097)
-- Name: ix_balanca_fk_balanca_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_balanca_fk_balanca_usuarioalteracao_id ON public.balanca USING btree (usuarioalteracao_id);


--
-- TOC entry 6051 (class 1259 OID 2381098)
-- Name: ix_balanca_fk_balanca_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_balanca_fk_balanca_usuariocadastro_id ON public.balanca USING btree (usuariocadastro_id);


--
-- TOC entry 6055 (class 1259 OID 2381099)
-- Name: ix_beneficiofiscal_fk_beneficiofiscal_estado_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_beneficiofiscal_fk_beneficiofiscal_estado_id ON public.beneficiofiscal USING btree (estado_id);


--
-- TOC entry 6061 (class 1259 OID 2381100)
-- Name: ix_cadastrofacillancado_fk_cadastrofacillancado_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_cadastrofacillancado_fk_cadastrofacillancado_empresa_id ON public.cadastrofacillancado USING btree (empresa_id);


--
-- TOC entry 6065 (class 1259 OID 2381101)
-- Name: ix_caixa_fk_caixa_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_caixa_fk_caixa_empresa_id ON public.caixa USING btree (empresa_id);


--
-- TOC entry 6066 (class 1259 OID 2381102)
-- Name: ix_caixa_fk_caixa_usuario_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_caixa_fk_caixa_usuario_id ON public.caixa USING btree (usuario_id);


--
-- TOC entry 6081 (class 1259 OID 2381103)
-- Name: ix_cfop_fk_cfop_tipocfop_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_cfop_fk_cfop_tipocfop_id ON public.cfop USING btree (tipocfop_id);


--
-- TOC entry 6087 (class 1259 OID 2381104)
-- Name: ix_clientefornecedor_fk_clientefornecedor_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_clientefornecedor_fk_clientefornecedor_empresa_id ON public.clientefornecedor USING btree (empresa_id);


--
-- TOC entry 6088 (class 1259 OID 2381105)
-- Name: ix_clientefornecedor_fk_clientefornecedor_municipio_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_clientefornecedor_fk_clientefornecedor_municipio_id ON public.clientefornecedor USING btree (municipio_id);


--
-- TOC entry 6108 (class 1259 OID 2381106)
-- Name: ix_compromisso_fk_compromisso_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_compromisso_fk_compromisso_empresa_id ON public.compromisso USING btree (empresa_id);


--
-- TOC entry 6111 (class 1259 OID 2381107)
-- Name: ix_compromisso_usuario_fk_compromisso_usuario_compromisso_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_compromisso_usuario_fk_compromisso_usuario_compromisso_id ON public.compromisso_usuario USING btree (compromisso_id);


--
-- TOC entry 6112 (class 1259 OID 2381108)
-- Name: ix_compromisso_usuario_fk_compromisso_usuario_usuarios_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_compromisso_usuario_fk_compromisso_usuario_usuarios_id ON public.compromisso_usuario USING btree (usuarios_id);


--
-- TOC entry 6128 (class 1259 OID 2381109)
-- Name: ix_contador_fk_contador_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contador_fk_contador_empresa_id ON public.contador USING btree (empresa_id);


--
-- TOC entry 6129 (class 1259 OID 2381110)
-- Name: ix_contador_fk_contador_municipio_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contador_fk_contador_municipio_id ON public.contador USING btree (municipio_id);


--
-- TOC entry 6132 (class 1259 OID 2381111)
-- Name: ix_contato_fk_contato_clientefornecedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contato_fk_contato_clientefornecedor_id ON public.contato USING btree (clientefornecedor_id);


--
-- TOC entry 6133 (class 1259 OID 2381112)
-- Name: ix_contato_fk_contato_compromisso_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contato_fk_contato_compromisso_id ON public.contato USING btree (compromisso_id);


--
-- TOC entry 6134 (class 1259 OID 2381113)
-- Name: ix_contato_fk_contato_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contato_fk_contato_empresa_id ON public.contato USING btree (empresa_id);


--
-- TOC entry 6135 (class 1259 OID 2381114)
-- Name: ix_contato_fk_contato_tipo_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contato_fk_contato_tipo_id ON public.contato USING btree (tipo_id);


--
-- TOC entry 6136 (class 1259 OID 2381115)
-- Name: ix_contato_fk_contato_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contato_fk_contato_usuarioalteracao_id ON public.contato USING btree (usuarioalteracao_id);


--
-- TOC entry 6137 (class 1259 OID 2381116)
-- Name: ix_contato_fk_contato_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contato_fk_contato_usuariocadastro_id ON public.contato USING btree (usuariocadastro_id);


--
-- TOC entry 6140 (class 1259 OID 2381117)
-- Name: ix_contatoadicional_fk_contatoadicional_clientefornecedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contatoadicional_fk_contatoadicional_clientefornecedor_id ON public.contatoadicional USING btree (clientefornecedor_id);


--
-- TOC entry 6143 (class 1259 OID 2381118)
-- Name: ix_cotacao_fk_cotacao_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_cotacao_fk_cotacao_empresa_id ON public.cotacao USING btree (empresa_id);


--
-- TOC entry 6144 (class 1259 OID 2381119)
-- Name: ix_cotacao_fk_cotacao_moeda_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_cotacao_fk_cotacao_moeda_id ON public.cotacao USING btree (moeda_id);


--
-- TOC entry 6145 (class 1259 OID 2381120)
-- Name: ix_cotacao_fk_cotacao_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_cotacao_fk_cotacao_usuarioalteracao_id ON public.cotacao USING btree (usuarioalteracao_id);


--
-- TOC entry 6146 (class 1259 OID 2381121)
-- Name: ix_cotacao_fk_cotacao_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_cotacao_fk_cotacao_usuariocadastro_id ON public.cotacao USING btree (usuariocadastro_id);


--
-- TOC entry 6150 (class 1259 OID 2381122)
-- Name: ix_creditocliente_fk_creditocliente_clientefornecedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_creditocliente_fk_creditocliente_clientefornecedor_id ON public.creditocliente USING btree (clientefornecedor_id);


--
-- TOC entry 6151 (class 1259 OID 2381123)
-- Name: ix_creditocliente_fk_creditocliente_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_creditocliente_fk_creditocliente_empresa_id ON public.creditocliente USING btree (empresa_id);


--
-- TOC entry 6162 (class 1259 OID 2381124)
-- Name: ix_delivery_fk_delivery_caixaaberto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_delivery_fk_delivery_caixaaberto_id ON public.delivery USING btree (caixaaberto_id);


--
-- TOC entry 6163 (class 1259 OID 2381125)
-- Name: ix_delivery_fk_delivery_cidade_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_delivery_fk_delivery_cidade_id ON public.delivery USING btree (cidade_id);


--
-- TOC entry 6164 (class 1259 OID 2381126)
-- Name: ix_delivery_fk_delivery_cliente_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_delivery_fk_delivery_cliente_id ON public.delivery USING btree (cliente_id);


--
-- TOC entry 6165 (class 1259 OID 2381127)
-- Name: ix_delivery_fk_delivery_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_delivery_fk_delivery_empresa_id ON public.delivery USING btree (empresa_id);


--
-- TOC entry 6166 (class 1259 OID 2381128)
-- Name: ix_delivery_fk_delivery_entregador_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_delivery_fk_delivery_entregador_id ON public.delivery USING btree (entregador_id);


--
-- TOC entry 6167 (class 1259 OID 2381129)
-- Name: ix_delivery_fk_delivery_tabelapreco_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_delivery_fk_delivery_tabelapreco_id ON public.delivery USING btree (tabelapreco_id);


--
-- TOC entry 6168 (class 1259 OID 2381130)
-- Name: ix_delivery_fk_delivery_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_delivery_fk_delivery_usuarioalteracao_id ON public.delivery USING btree (usuarioalteracao_id);


--
-- TOC entry 6169 (class 1259 OID 2381131)
-- Name: ix_delivery_fk_delivery_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_delivery_fk_delivery_usuariocadastro_id ON public.delivery USING btree (usuariocadastro_id);


--
-- TOC entry 6170 (class 1259 OID 2381132)
-- Name: ix_delivery_fk_delivery_vendedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_delivery_fk_delivery_vendedor_id ON public.delivery USING btree (vendedor_id);


--
-- TOC entry 6174 (class 1259 OID 2381133)
-- Name: ix_departamento_fk_departamento_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_departamento_fk_departamento_empresa_id ON public.departamento USING btree (empresa_id);


--
-- TOC entry 6177 (class 1259 OID 2381134)
-- Name: ix_dependente_fk_dependente_clientefornecedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_dependente_fk_dependente_clientefornecedor_id ON public.dependente USING btree (clientefornecedor_id);


--
-- TOC entry 6185 (class 1259 OID 2381135)
-- Name: ix_devolucaotrocaproduto_fk_devolucaotrocaproduto_cliente_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_devolucaotrocaproduto_fk_devolucaotrocaproduto_cliente_id ON public.devolucaotrocaproduto USING btree (cliente_id);


--
-- TOC entry 6186 (class 1259 OID 2381136)
-- Name: ix_devolucaotrocaproduto_fk_devolucaotrocaproduto_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_devolucaotrocaproduto_fk_devolucaotrocaproduto_empresa_id ON public.devolucaotrocaproduto USING btree (empresa_id);


--
-- TOC entry 6187 (class 1259 OID 2381137)
-- Name: ix_devolucaotrocaproduto_fk_devolucaotrocaproduto_entregador_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_devolucaotrocaproduto_fk_devolucaotrocaproduto_entregador_id ON public.devolucaotrocaproduto USING btree (entregador_id);


--
-- TOC entry 6188 (class 1259 OID 2381138)
-- Name: ix_devolucaotrocaproduto_fk_devolucaotrocaproduto_vendedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_devolucaotrocaproduto_fk_devolucaotrocaproduto_vendedor_id ON public.devolucaotrocaproduto USING btree (vendedor_id);


--
-- TOC entry 6193 (class 1259 OID 2381139)
-- Name: ix_documentofiscal_fk_documentofiscal_cfop_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_documentofiscal_fk_documentofiscal_cfop_id ON public.documentofiscal USING btree (cfop_id);


--
-- TOC entry 6194 (class 1259 OID 2381140)
-- Name: ix_documentofiscal_fk_documentofiscal_cliente_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_documentofiscal_fk_documentofiscal_cliente_id ON public.documentofiscal USING btree (cliente_id);


--
-- TOC entry 6195 (class 1259 OID 2381141)
-- Name: ix_documentofiscal_fk_documentofiscal_cte_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_documentofiscal_fk_documentofiscal_cte_id ON public.documentofiscal USING btree (cte_id);


--
-- TOC entry 6196 (class 1259 OID 2381142)
-- Name: ix_documentofiscal_fk_documentofiscal_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_documentofiscal_fk_documentofiscal_empresa_id ON public.documentofiscal USING btree (empresa_id);


--
-- TOC entry 6197 (class 1259 OID 2381143)
-- Name: ix_documentofiscal_fk_documentofiscal_fornecedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_documentofiscal_fk_documentofiscal_fornecedor_id ON public.documentofiscal USING btree (fornecedor_id);


--
-- TOC entry 6198 (class 1259 OID 2381144)
-- Name: ix_documentofiscal_fk_documentofiscal_fornecimentoconsumo_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_documentofiscal_fk_documentofiscal_fornecimentoconsumo_id ON public.documentofiscal USING btree (fornecimentoconsumo_id);


--
-- TOC entry 6199 (class 1259 OID 2381145)
-- Name: ix_documentofiscal_fk_documentofiscal_transportador_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_documentofiscal_fk_documentofiscal_transportador_id ON public.documentofiscal USING btree (transportador_id);


--
-- TOC entry 6200 (class 1259 OID 2381146)
-- Name: ix_documentofiscal_fk_documentofiscal_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_documentofiscal_fk_documentofiscal_usuarioalteracao_id ON public.documentofiscal USING btree (usuarioalteracao_id);


--
-- TOC entry 6201 (class 1259 OID 2381147)
-- Name: ix_documentofiscal_fk_documentofiscal_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_documentofiscal_fk_documentofiscal_usuariocadastro_id ON public.documentofiscal USING btree (usuariocadastro_id);


--
-- TOC entry 6202 (class 1259 OID 2381148)
-- Name: ix_documentofiscal_fk_documentofiscal_veiculo_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_documentofiscal_fk_documentofiscal_veiculo_id ON public.documentofiscal USING btree (veiculo_id);


--
-- TOC entry 6210 (class 1259 OID 2381149)
-- Name: ix_emailsbackup_fk_emailsbackup_parametrobackup_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_emailsbackup_fk_emailsbackup_parametrobackup_id ON public.emailsbackup USING btree (parametrobackup_id);


--
-- TOC entry 6211 (class 1259 OID 2381150)
-- Name: ix_emailsbackup_fk_emailsbackup_preferencia_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_emailsbackup_fk_emailsbackup_preferencia_id ON public.emailsbackup USING btree (preferencia_id);


--
-- TOC entry 6214 (class 1259 OID 2381151)
-- Name: ix_empresa_fk_empresa_clifor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_empresa_fk_empresa_clifor_id ON public.empresa USING btree (clifor_id);


--
-- TOC entry 6215 (class 1259 OID 2381152)
-- Name: ix_empresa_fk_empresa_municipio_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_empresa_fk_empresa_municipio_id ON public.empresa USING btree (municipio_id);


--
-- TOC entry 6218 (class 1259 OID 2381153)
-- Name: ix_endereco_fk_endereco_clientefornecedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_endereco_fk_endereco_clientefornecedor_id ON public.endereco USING btree (clientefornecedor_id);


--
-- TOC entry 6219 (class 1259 OID 2381154)
-- Name: ix_endereco_fk_endereco_municipio_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_endereco_fk_endereco_municipio_id ON public.endereco USING btree (municipio_id);


--
-- TOC entry 6224 (class 1259 OID 2381155)
-- Name: ix_entregador_fk_entregador_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_entregador_fk_entregador_empresa_id ON public.entregador USING btree (empresa_id);


--
-- TOC entry 6225 (class 1259 OID 2381156)
-- Name: ix_entregador_fk_entregador_municipio_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_entregador_fk_entregador_municipio_id ON public.entregador USING btree (municipio_id);


--
-- TOC entry 6229 (class 1259 OID 2381157)
-- Name: ix_equipamento_fk_equipamento_clientefornecedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_equipamento_fk_equipamento_clientefornecedor_id ON public.equipamento USING btree (clientefornecedor_id);


--
-- TOC entry 6230 (class 1259 OID 2381158)
-- Name: ix_equipamento_fk_equipamento_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_equipamento_fk_equipamento_empresa_id ON public.equipamento USING btree (empresa_id);


--
-- TOC entry 6231 (class 1259 OID 2381159)
-- Name: ix_equipamento_fk_equipamento_marca_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_equipamento_fk_equipamento_marca_id ON public.equipamento USING btree (marca_id);


--
-- TOC entry 6232 (class 1259 OID 2381160)
-- Name: ix_equipamento_fk_equipamento_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_equipamento_fk_equipamento_usuarioalteracao_id ON public.equipamento USING btree (usuarioalteracao_id);


--
-- TOC entry 6233 (class 1259 OID 2381161)
-- Name: ix_equipamento_fk_equipamento_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_equipamento_fk_equipamento_usuariocadastro_id ON public.equipamento USING btree (usuariocadastro_id);


--
-- TOC entry 6237 (class 1259 OID 2381162)
-- Name: ix_estado_fk_estado_pais_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_estado_fk_estado_pais_id ON public.estado USING btree (pais_id);


--
-- TOC entry 6248 (class 1259 OID 2381163)
-- Name: ix_faturamentomensal_fk_faturamentomensal_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_faturamentomensal_fk_faturamentomensal_empresa_id ON public.faturamentomensal USING btree (empresa_id);


--
-- TOC entry 6254 (class 1259 OID 2381164)
-- Name: ix_formapagamentodelivery_fk_formapagamentodelivery_delivery_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_formapagamentodelivery_fk_formapagamentodelivery_delivery_id ON public.formapagamentodelivery USING btree (delivery_id);


--
-- TOC entry 6255 (class 1259 OID 2381165)
-- Name: ix_formapagamentodelivery_fk_formapagamentodelivery_vale_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_formapagamentodelivery_fk_formapagamentodelivery_vale_id ON public.formapagamentodelivery USING btree (vale_id);


--
-- TOC entry 6275 (class 1259 OID 2381166)
-- Name: ix_formapagamentopedido_fk_formapagamentopedido_pedido_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_formapagamentopedido_fk_formapagamentopedido_pedido_id ON public.formapagamentopedido USING btree (pedido_id);


--
-- TOC entry 6276 (class 1259 OID 2381167)
-- Name: ix_formapagamentopedido_fk_formapagamentopedido_vale_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_formapagamentopedido_fk_formapagamentopedido_vale_id ON public.formapagamentopedido USING btree (vale_id);


--
-- TOC entry 6283 (class 1259 OID 2381168)
-- Name: ix_funcionario_fk_funcionario_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_funcionario_fk_funcionario_empresa_id ON public.funcionario USING btree (empresa_id);


--
-- TOC entry 6284 (class 1259 OID 2381169)
-- Name: ix_funcionario_fk_funcionario_municipio_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_funcionario_fk_funcionario_municipio_id ON public.funcionario USING btree (municipio_id);


--
-- TOC entry 6285 (class 1259 OID 2381170)
-- Name: ix_funcionario_fk_funcionario_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_funcionario_fk_funcionario_usuarioalteracao_id ON public.funcionario USING btree (usuarioalteracao_id);


--
-- TOC entry 6286 (class 1259 OID 2381171)
-- Name: ix_funcionario_fk_funcionario_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_funcionario_fk_funcionario_usuariocadastro_id ON public.funcionario USING btree (usuariocadastro_id);


--
-- TOC entry 6294 (class 1259 OID 2381172)
-- Name: ix_grupoimpressao_fk_grupoimpressao_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_grupoimpressao_fk_grupoimpressao_empresa_id ON public.grupoimpressao USING btree (empresa_id);


--
-- TOC entry 6299 (class 1259 OID 2381173)
-- Name: ix_historicoconexaocaixa_fk_historicoconexaocaixa_caixa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_historicoconexaocaixa_fk_historicoconexaocaixa_caixa_id ON public.historicoconexaocaixa USING btree (caixa_id);


--
-- TOC entry 6300 (class 1259 OID 2381174)
-- Name: ix_historicoconexaocaixa_fk_historicoconexaocaixa_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_historicoconexaocaixa_fk_historicoconexaocaixa_empresa_id ON public.historicoconexaocaixa USING btree (empresa_id);


--
-- TOC entry 6301 (class 1259 OID 2381175)
-- Name: ix_historicoconexaocaixa_fk_historicoconexaocaixa_usuario_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_historicoconexaocaixa_fk_historicoconexaocaixa_usuario_id ON public.historicoconexaocaixa USING btree (usuario_id);


--
-- TOC entry 6326 (class 1259 OID 2381176)
-- Name: ix_imagemequipamento_fk_imagemequipamento_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_imagemequipamento_fk_imagemequipamento_empresa_id ON public.imagemequipamento USING btree (empresa_id);


--
-- TOC entry 6327 (class 1259 OID 2381177)
-- Name: ix_imagemequipamento_fk_imagemequipamento_equipamento_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_imagemequipamento_fk_imagemequipamento_equipamento_id ON public.imagemequipamento USING btree (equipamento_id);


--
-- TOC entry 6328 (class 1259 OID 2381178)
-- Name: ix_imagemequipamento_fk_imagemequipamento_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_imagemequipamento_fk_imagemequipamento_usuarioalteracao_id ON public.imagemequipamento USING btree (usuarioalteracao_id);


--
-- TOC entry 6329 (class 1259 OID 2381179)
-- Name: ix_imagemequipamento_fk_imagemequipamento_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_imagemequipamento_fk_imagemequipamento_usuariocadastro_id ON public.imagemequipamento USING btree (usuariocadastro_id);


--
-- TOC entry 6332 (class 1259 OID 2381180)
-- Name: ix_impressaoetiqueta_fk_impressaoetiqueta_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_impressaoetiqueta_fk_impressaoetiqueta_empresa_id ON public.impressaoetiqueta USING btree (empresa_id);


--
-- TOC entry 6339 (class 1259 OID 2381181)
-- Name: ix_informacaonutricional_fk_informacaonutricional_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_informacaonutricional_fk_informacaonutricional_empresa_id ON public.informacaonutricional USING btree (empresa_id);


--
-- TOC entry 6340 (class 1259 OID 2381182)
-- Name: ix_informacaonutricional_fk_informacaonutricional_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_informacaonutricional_fk_informacaonutricional_produto_id ON public.informacaonutricional USING btree (produto_id);


--
-- TOC entry 6346 (class 1259 OID 2381183)
-- Name: ix_inutilizacao_fk_inutilizacao_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inutilizacao_fk_inutilizacao_empresa_id ON public.inutilizacao USING btree (empresa_id);


--
-- TOC entry 6347 (class 1259 OID 2381184)
-- Name: ix_inutilizacao_fk_inutilizacao_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inutilizacao_fk_inutilizacao_usuarioalteracao_id ON public.inutilizacao USING btree (usuarioalteracao_id);


--
-- TOC entry 6348 (class 1259 OID 2381185)
-- Name: ix_inutilizacao_fk_inutilizacao_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_inutilizacao_fk_inutilizacao_usuariocadastro_id ON public.inutilizacao USING btree (usuariocadastro_id);


--
-- TOC entry 6351 (class 1259 OID 2381186)
-- Name: ix_itemdelivery_fk_itemdelivery_delivery_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdelivery_fk_itemdelivery_delivery_id ON public.itemdelivery USING btree (delivery_id);


--
-- TOC entry 6352 (class 1259 OID 2381187)
-- Name: ix_itemdelivery_fk_itemdelivery_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdelivery_fk_itemdelivery_empresa_id ON public.itemdelivery USING btree (empresa_id);


--
-- TOC entry 6353 (class 1259 OID 2381188)
-- Name: ix_itemdelivery_fk_itemdelivery_kitproduto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdelivery_fk_itemdelivery_kitproduto_id ON public.itemdelivery USING btree (kitproduto_id);


--
-- TOC entry 6354 (class 1259 OID 2381189)
-- Name: ix_itemdelivery_fk_itemdelivery_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdelivery_fk_itemdelivery_produto_id ON public.itemdelivery USING btree (produto_id);


--
-- TOC entry 6358 (class 1259 OID 2381190)
-- Name: ix_itemdevolucaotroca_fk_itemdevolucaotroca_kitproduto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdevolucaotroca_fk_itemdevolucaotroca_kitproduto_id ON public.itemdevolucaotroca USING btree (kitproduto_id);


--
-- TOC entry 6359 (class 1259 OID 2381191)
-- Name: ix_itemdevolucaotroca_fk_itemdevolucaotroca_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdevolucaotroca_fk_itemdevolucaotroca_produto_id ON public.itemdevolucaotroca USING btree (produto_id);


--
-- TOC entry 6365 (class 1259 OID 2381192)
-- Name: ix_itemdocumentofiscal_fk_itemdocumentofiscal_cfop_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdocumentofiscal_fk_itemdocumentofiscal_cfop_id ON public.itemdocumentofiscal USING btree (cfop_id);


--
-- TOC entry 6366 (class 1259 OID 2381193)
-- Name: ix_itemdocumentofiscal_fk_itemdocumentofiscal_cstcofins_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdocumentofiscal_fk_itemdocumentofiscal_cstcofins_id ON public.itemdocumentofiscal USING btree (cstcofins_id);


--
-- TOC entry 6367 (class 1259 OID 2381194)
-- Name: ix_itemdocumentofiscal_fk_itemdocumentofiscal_csticms_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdocumentofiscal_fk_itemdocumentofiscal_csticms_id ON public.itemdocumentofiscal USING btree (csticms_id);


--
-- TOC entry 6368 (class 1259 OID 2381195)
-- Name: ix_itemdocumentofiscal_fk_itemdocumentofiscal_cstipi_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdocumentofiscal_fk_itemdocumentofiscal_cstipi_id ON public.itemdocumentofiscal USING btree (cstipi_id);


--
-- TOC entry 6369 (class 1259 OID 2381196)
-- Name: ix_itemdocumentofiscal_fk_itemdocumentofiscal_cstpis_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdocumentofiscal_fk_itemdocumentofiscal_cstpis_id ON public.itemdocumentofiscal USING btree (cstpis_id);


--
-- TOC entry 6370 (class 1259 OID 2381197)
-- Name: ix_itemdocumentofiscal_fk_itemdocumentofiscal_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdocumentofiscal_fk_itemdocumentofiscal_produto_id ON public.itemdocumentofiscal USING btree (produto_id);


--
-- TOC entry 6371 (class 1259 OID 2381198)
-- Name: ix_itemdocumentofiscal_fk_itemdocumentofiscal_tipoitem_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdocumentofiscal_fk_itemdocumentofiscal_tipoitem_id ON public.itemdocumentofiscal USING btree (tipoitem_id);


--
-- TOC entry 6372 (class 1259 OID 2381199)
-- Name: ix_itemdocumentofiscal_fk_itemdocumentofiscal_unidademedida_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemdocumentofiscal_fk_itemdocumentofiscal_unidademedida_id ON public.itemdocumentofiscal USING btree (unidademedida_id);


--
-- TOC entry 6375 (class 1259 OID 2381200)
-- Name: ix_itemgrupoimpressao_fk_itemgrupoimpressao_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemgrupoimpressao_fk_itemgrupoimpressao_empresa_id ON public.itemgrupoimpressao USING btree (empresa_id);


--
-- TOC entry 6376 (class 1259 OID 2381201)
-- Name: ix_itemgrupoimpressao_fk_itemgrupoimpressao_grupoimpressao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemgrupoimpressao_fk_itemgrupoimpressao_grupoimpressao_id ON public.itemgrupoimpressao USING btree (grupoimpressao_id);


--
-- TOC entry 6377 (class 1259 OID 2381202)
-- Name: ix_itemgrupoimpressao_fk_itemgrupoimpressao_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemgrupoimpressao_fk_itemgrupoimpressao_produto_id ON public.itemgrupoimpressao USING btree (produto_id);


--
-- TOC entry 6380 (class 1259 OID 2381203)
-- Name: ix_itemkitproduto_fk_itemkitproduto_kitproduto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemkitproduto_fk_itemkitproduto_kitproduto_id ON public.itemkitproduto USING btree (kitproduto_id);


--
-- TOC entry 6381 (class 1259 OID 2381204)
-- Name: ix_itemkitproduto_fk_itemkitproduto_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemkitproduto_fk_itemkitproduto_produto_id ON public.itemkitproduto USING btree (produto_id);


--
-- TOC entry 6382 (class 1259 OID 2381205)
-- Name: ix_itemkitproduto_fk_itemkitproduto_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemkitproduto_fk_itemkitproduto_usuarioalteracao_id ON public.itemkitproduto USING btree (usuarioalteracao_id);


--
-- TOC entry 6383 (class 1259 OID 2381206)
-- Name: ix_itemkitproduto_fk_itemkitproduto_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemkitproduto_fk_itemkitproduto_usuariocadastro_id ON public.itemkitproduto USING btree (usuariocadastro_id);


--
-- TOC entry 6388 (class 1259 OID 2381207)
-- Name: ix_itemnotafiscalentrada_fk_itemnotafiscalentrada_csticms_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemnotafiscalentrada_fk_itemnotafiscalentrada_csticms_id ON public.itemnotafiscalentrada USING btree (csticms_id);


--
-- TOC entry 6389 (class 1259 OID 2381208)
-- Name: ix_itemnotafiscalentrada_fk_itemnotafiscalentrada_cstipi_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemnotafiscalentrada_fk_itemnotafiscalentrada_cstipi_id ON public.itemnotafiscalentrada USING btree (cstipi_id);


--
-- TOC entry 6390 (class 1259 OID 2381209)
-- Name: ix_itemnotafiscalentrada_fk_itemnotafiscalentrada_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemnotafiscalentrada_fk_itemnotafiscalentrada_produto_id ON public.itemnotafiscalentrada USING btree (produto_id);


--
-- TOC entry 6393 (class 1259 OID 2381210)
-- Name: ix_itemordemservico_fk_itemordemservico_ordemservico_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemordemservico_fk_itemordemservico_ordemservico_id ON public.itemordemservico USING btree (ordemservico_id);


--
-- TOC entry 6394 (class 1259 OID 2381211)
-- Name: ix_itemordemservico_fk_itemordemservico_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itemordemservico_fk_itemordemservico_produto_id ON public.itemordemservico USING btree (produto_id);


--
-- TOC entry 6397 (class 1259 OID 2381212)
-- Name: ix_itempedido_fk_itempedido_pedido_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itempedido_fk_itempedido_pedido_id ON public.itempedido USING btree (pedido_id);


--
-- TOC entry 6398 (class 1259 OID 2381213)
-- Name: ix_itempedido_fk_itempedido_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itempedido_fk_itempedido_produto_id ON public.itempedido USING btree (produto_id);


--
-- TOC entry 6402 (class 1259 OID 2381214)
-- Name: ix_itempedidocompra_fk_itempedidocompra_pedidocompra_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itempedidocompra_fk_itempedidocompra_pedidocompra_id ON public.itempedidocompra USING btree (pedidocompra_id);


--
-- TOC entry 6403 (class 1259 OID 2381215)
-- Name: ix_itempedidocompra_fk_itempedidocompra_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itempedidocompra_fk_itempedidocompra_produto_id ON public.itempedidocompra USING btree (produto_id);


--
-- TOC entry 6404 (class 1259 OID 2381216)
-- Name: ix_kitproduto_fk_kitproduto_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_kitproduto_fk_kitproduto_empresa_id ON public.kitproduto USING btree (empresa_id);


--
-- TOC entry 6405 (class 1259 OID 2381217)
-- Name: ix_kitproduto_fk_kitproduto_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_kitproduto_fk_kitproduto_produto_id ON public.kitproduto USING btree (produto_id);


--
-- TOC entry 6406 (class 1259 OID 2381218)
-- Name: ix_kitproduto_fk_kitproduto_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_kitproduto_fk_kitproduto_usuarioalteracao_id ON public.kitproduto USING btree (usuarioalteracao_id);


--
-- TOC entry 6407 (class 1259 OID 2381219)
-- Name: ix_kitproduto_fk_kitproduto_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_kitproduto_fk_kitproduto_usuariocadastro_id ON public.kitproduto USING btree (usuariocadastro_id);


--
-- TOC entry 6410 (class 1259 OID 2381220)
-- Name: ix_liquidacaoproduto_fk_liquidacaoproduto_departamento_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_liquidacaoproduto_fk_liquidacaoproduto_departamento_id ON public.liquidacaoproduto USING btree (departamento_id);


--
-- TOC entry 6411 (class 1259 OID 2381221)
-- Name: ix_liquidacaoproduto_fk_liquidacaoproduto_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_liquidacaoproduto_fk_liquidacaoproduto_empresa_id ON public.liquidacaoproduto USING btree (empresa_id);


--
-- TOC entry 6412 (class 1259 OID 2381222)
-- Name: ix_liquidacaoproduto_fk_liquidacaoproduto_marca_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_liquidacaoproduto_fk_liquidacaoproduto_marca_id ON public.liquidacaoproduto USING btree (marca_id);


--
-- TOC entry 6413 (class 1259 OID 2381223)
-- Name: ix_liquidacaoproduto_fk_liquidacaoproduto_subdepartamento_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_liquidacaoproduto_fk_liquidacaoproduto_subdepartamento_id ON public.liquidacaoproduto USING btree (subdepartamento_id);


--
-- TOC entry 6414 (class 1259 OID 2381224)
-- Name: ix_liquidacaoproduto_fk_liquidacaoproduto_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_liquidacaoproduto_fk_liquidacaoproduto_usuarioalteracao_id ON public.liquidacaoproduto USING btree (usuarioalteracao_id);


--
-- TOC entry 6415 (class 1259 OID 2381225)
-- Name: ix_liquidacaoproduto_fk_liquidacaoproduto_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_liquidacaoproduto_fk_liquidacaoproduto_usuariocadastro_id ON public.liquidacaoproduto USING btree (usuariocadastro_id);


--
-- TOC entry 6422 (class 1259 OID 2381226)
-- Name: ix_maquinacartao_fk_maquinacartao_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_maquinacartao_fk_maquinacartao_empresa_id ON public.maquinacartao USING btree (empresa_id);


--
-- TOC entry 6423 (class 1259 OID 2381227)
-- Name: ix_maquinacartao_fk_maquinacartao_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_maquinacartao_fk_maquinacartao_usuarioalteracao_id ON public.maquinacartao USING btree (usuarioalteracao_id);


--
-- TOC entry 6424 (class 1259 OID 2381228)
-- Name: ix_maquinacartao_fk_maquinacartao_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_maquinacartao_fk_maquinacartao_usuariocadastro_id ON public.maquinacartao USING btree (usuariocadastro_id);


--
-- TOC entry 6428 (class 1259 OID 2381229)
-- Name: ix_marca_fk_marca_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_marca_fk_marca_empresa_id ON public.marca USING btree (empresa_id);


--
-- TOC entry 6429 (class 1259 OID 2381230)
-- Name: ix_marca_fk_marca_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_marca_fk_marca_usuarioalteracao_id ON public.marca USING btree (usuarioalteracao_id);


--
-- TOC entry 6430 (class 1259 OID 2381231)
-- Name: ix_marca_fk_marca_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_marca_fk_marca_usuariocadastro_id ON public.marca USING btree (usuariocadastro_id);


--
-- TOC entry 6448 (class 1259 OID 2381232)
-- Name: ix_moeda_fk_moeda_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_moeda_fk_moeda_empresa_id ON public.moeda USING btree (empresa_id);


--
-- TOC entry 6449 (class 1259 OID 2381233)
-- Name: ix_moeda_fk_moeda_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_moeda_fk_moeda_usuarioalteracao_id ON public.moeda USING btree (usuarioalteracao_id);


--
-- TOC entry 6450 (class 1259 OID 2381234)
-- Name: ix_moeda_fk_moeda_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_moeda_fk_moeda_usuariocadastro_id ON public.moeda USING btree (usuariocadastro_id);


--
-- TOC entry 6453 (class 1259 OID 2381235)
-- Name: ix_motorista_veiculo_fk_motorista_veiculo_motorista_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_motorista_veiculo_fk_motorista_veiculo_motorista_id ON public.motorista_veiculo USING btree (motorista_id);


--
-- TOC entry 6454 (class 1259 OID 2381236)
-- Name: ix_motorista_veiculo_fk_motorista_veiculo_veiculosvinculado_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_motorista_veiculo_fk_motorista_veiculo_veiculosvinculado_id ON public.motorista_veiculo USING btree (veiculosvinculado_id);


--
-- TOC entry 6457 (class 1259 OID 2381237)
-- Name: ix_movimentacaocaixa_fk_movimentacaocaixa_caixa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_movimentacaocaixa_fk_movimentacaocaixa_caixa_id ON public.movimentacaocaixa USING btree (caixa_id);


--
-- TOC entry 6458 (class 1259 OID 2381238)
-- Name: ix_movimentacaocaixa_fk_movimentacaocaixa_duplicataecf_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_movimentacaocaixa_fk_movimentacaocaixa_duplicataecf_id ON public.movimentacaocaixa USING btree (duplicataecf_id);


--
-- TOC entry 6459 (class 1259 OID 2381239)
-- Name: ix_movimentacaocaixa_fk_movimentacaocaixa_duplicatanota_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_movimentacaocaixa_fk_movimentacaocaixa_duplicatanota_id ON public.movimentacaocaixa USING btree (duplicatanota_id);


--
-- TOC entry 6460 (class 1259 OID 2381240)
-- Name: ix_movimentacaocaixa_fk_movimentacaocaixa_serie; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_movimentacaocaixa_fk_movimentacaocaixa_serie ON public.movimentacaocaixa USING btree (serie, empresaid, ambiente, tipofaturamento, numero);


--
-- TOC entry 6486 (class 1259 OID 2381241)
-- Name: ix_movimentoestoque_fk_movimentoestoque_clientefornecedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_movimentoestoque_fk_movimentoestoque_clientefornecedor_id ON public.movimentoestoque USING btree (clientefornecedor_id);


--
-- TOC entry 6487 (class 1259 OID 2381242)
-- Name: ix_movimentoestoque_fk_movimentoestoque_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_movimentoestoque_fk_movimentoestoque_produto_id ON public.movimentoestoque USING btree (produto_id);


--
-- TOC entry 6488 (class 1259 OID 2381243)
-- Name: ix_movimentoestoque_fk_movimentoestoque_usuario_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_movimentoestoque_fk_movimentoestoque_usuario_id ON public.movimentoestoque USING btree (usuario_id);


--
-- TOC entry 6492 (class 1259 OID 2381244)
-- Name: ix_municipio_fk_municipio_estado_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_municipio_fk_municipio_estado_id ON public.municipio USING btree (estado_id);


--
-- TOC entry 6505 (class 1259 OID 2381245)
-- Name: ix_notadestinada_fk_notadestinada_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notadestinada_fk_notadestinada_empresa_id ON public.notadestinada USING btree (empresa_id);


--
-- TOC entry 6506 (class 1259 OID 2381246)
-- Name: ix_notadestinada_fk_notadestinada_usuario_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notadestinada_fk_notadestinada_usuario_id ON public.notadestinada USING btree (usuario_id);


--
-- TOC entry 6507 (class 1259 OID 2381247)
-- Name: ix_notadestinada_fk_notadestinada_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notadestinada_fk_notadestinada_usuarioalteracao_id ON public.notadestinada USING btree (usuarioalteracao_id);


--
-- TOC entry 6508 (class 1259 OID 2381248)
-- Name: ix_notadestinada_fk_notadestinada_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notadestinada_fk_notadestinada_usuariocadastro_id ON public.notadestinada USING btree (usuariocadastro_id);


--
-- TOC entry 6512 (class 1259 OID 2381249)
-- Name: ix_notafiscalentrada_fk_notafiscalentrada_cliente_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notafiscalentrada_fk_notafiscalentrada_cliente_id ON public.notafiscalentrada USING btree (cliente_id);


--
-- TOC entry 6513 (class 1259 OID 2381250)
-- Name: ix_notafiscalentrada_fk_notafiscalentrada_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notafiscalentrada_fk_notafiscalentrada_empresa_id ON public.notafiscalentrada USING btree (empresa_id);


--
-- TOC entry 6514 (class 1259 OID 2381251)
-- Name: ix_notafiscalentrada_fk_notafiscalentrada_fornecedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notafiscalentrada_fk_notafiscalentrada_fornecedor_id ON public.notafiscalentrada USING btree (fornecedor_id);


--
-- TOC entry 6515 (class 1259 OID 2381252)
-- Name: ix_notafiscalentrada_fk_notafiscalentrada_natureza_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notafiscalentrada_fk_notafiscalentrada_natureza_id ON public.notafiscalentrada USING btree (natureza_id);


--
-- TOC entry 6516 (class 1259 OID 2381253)
-- Name: ix_notafiscalentrada_fk_notafiscalentrada_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notafiscalentrada_fk_notafiscalentrada_usuarioalteracao_id ON public.notafiscalentrada USING btree (usuarioalteracao_id);


--
-- TOC entry 6517 (class 1259 OID 2381254)
-- Name: ix_notafiscalentrada_fk_notafiscalentrada_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notafiscalentrada_fk_notafiscalentrada_usuariocadastro_id ON public.notafiscalentrada USING btree (usuariocadastro_id);


--
-- TOC entry 6518 (class 1259 OID 2381255)
-- Name: ix_notafiscalentrada_fk_notafiscalentrada_usuarioedicao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notafiscalentrada_fk_notafiscalentrada_usuarioedicao_id ON public.notafiscalentrada USING btree (usuarioedicao_id);


--
-- TOC entry 6522 (class 1259 OID 2381256)
-- Name: ix_ordemservico_fk_ordemservico_cliente_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_ordemservico_fk_ordemservico_cliente_id ON public.ordemservico USING btree (cliente_id);


--
-- TOC entry 6523 (class 1259 OID 2381257)
-- Name: ix_ordemservico_fk_ordemservico_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_ordemservico_fk_ordemservico_empresa_id ON public.ordemservico USING btree (empresa_id);


--
-- TOC entry 6524 (class 1259 OID 2381258)
-- Name: ix_ordemservico_fk_ordemservico_natureza_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_ordemservico_fk_ordemservico_natureza_id ON public.ordemservico USING btree (natureza_id);


--
-- TOC entry 6525 (class 1259 OID 2381259)
-- Name: ix_ordemservico_fk_ordemservico_responsavel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_ordemservico_fk_ordemservico_responsavel_id ON public.ordemservico USING btree (responsavel_id);


--
-- TOC entry 6526 (class 1259 OID 2381260)
-- Name: ix_ordemservico_fk_ordemservico_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_ordemservico_fk_ordemservico_usuarioalteracao_id ON public.ordemservico USING btree (usuarioalteracao_id);


--
-- TOC entry 6527 (class 1259 OID 2381261)
-- Name: ix_ordemservico_fk_ordemservico_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_ordemservico_fk_ordemservico_usuariocadastro_id ON public.ordemservico USING btree (usuariocadastro_id);


--
-- TOC entry 6545 (class 1259 OID 2381262)
-- Name: ix_parametrocadastro_fk_parametrocadastro_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametrocadastro_fk_parametrocadastro_empresa_id ON public.parametrocadastro USING btree (empresa_id);


--
-- TOC entry 6556 (class 1259 OID 2381263)
-- Name: ix_parametroicms_fk_parametroicms_parametroncm_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroicms_fk_parametroicms_parametroncm_id ON public.parametroicms USING btree (parametroncm_id);


--
-- TOC entry 6557 (class 1259 OID 2381264)
-- Name: ix_parametroicms_fk_parametroicms_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroicms_fk_parametroicms_usuarioalteracao_id ON public.parametroicms USING btree (usuarioalteracao_id);


--
-- TOC entry 6558 (class 1259 OID 2381265)
-- Name: ix_parametroicms_fk_parametroicms_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroicms_fk_parametroicms_usuariocadastro_id ON public.parametroicms USING btree (usuariocadastro_id);


--
-- TOC entry 6561 (class 1259 OID 2381266)
-- Name: ix_parametroimpressao_fk_parametroimpressao_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroimpressao_fk_parametroimpressao_empresa_id ON public.parametroimpressao USING btree (empresa_id);


--
-- TOC entry 6562 (class 1259 OID 2381267)
-- Name: ix_parametroimpressao_fk_parametroimpressao_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroimpressao_fk_parametroimpressao_usuarioalteracao_id ON public.parametroimpressao USING btree (usuarioalteracao_id);


--
-- TOC entry 6563 (class 1259 OID 2381268)
-- Name: ix_parametroimpressao_fk_parametroimpressao_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroimpressao_fk_parametroimpressao_usuariocadastro_id ON public.parametroimpressao USING btree (usuariocadastro_id);


--
-- TOC entry 6588 (class 1259 OID 2381269)
-- Name: ix_parametroipi_fk_parametroipi_parametroncm_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroipi_fk_parametroipi_parametroncm_id ON public.parametroipi USING btree (parametroncm_id);


--
-- TOC entry 6589 (class 1259 OID 2381270)
-- Name: ix_parametroipi_fk_parametroipi_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroipi_fk_parametroipi_usuarioalteracao_id ON public.parametroipi USING btree (usuarioalteracao_id);


--
-- TOC entry 6590 (class 1259 OID 2381271)
-- Name: ix_parametroipi_fk_parametroipi_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroipi_fk_parametroipi_usuariocadastro_id ON public.parametroipi USING btree (usuariocadastro_id);


--
-- TOC entry 6594 (class 1259 OID 2381272)
-- Name: ix_parametroncm_fk_parametroncm_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroncm_fk_parametroncm_usuarioalteracao_id ON public.parametroncm USING btree (usuarioalteracao_id);


--
-- TOC entry 6595 (class 1259 OID 2381273)
-- Name: ix_parametroncm_fk_parametroncm_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroncm_fk_parametroncm_usuariocadastro_id ON public.parametroncm USING btree (usuariocadastro_id);


--
-- TOC entry 6600 (class 1259 OID 2381274)
-- Name: ix_parametroorcamento_fk_parametroorcamento_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroorcamento_fk_parametroorcamento_empresa_id ON public.parametroorcamento USING btree (empresa_id);


--
-- TOC entry 6601 (class 1259 OID 2381275)
-- Name: ix_parametroorcamento_fk_parametroorcamento_usuario_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroorcamento_fk_parametroorcamento_usuario_id ON public.parametroorcamento USING btree (usuario_id);


--
-- TOC entry 6604 (class 1259 OID 2381276)
-- Name: ix_parametroordemservico_fk_parametroordemservico_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroordemservico_fk_parametroordemservico_empresa_id ON public.parametroordemservico USING btree (empresa_id);


--
-- TOC entry 6612 (class 1259 OID 2381277)
-- Name: ix_parametropiscofins_fk_parametropiscofins_parametroncm_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametropiscofins_fk_parametropiscofins_parametroncm_id ON public.parametropiscofins USING btree (parametroncm_id);


--
-- TOC entry 6613 (class 1259 OID 2381278)
-- Name: ix_parametropiscofins_fk_parametropiscofins_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametropiscofins_fk_parametropiscofins_usuarioalteracao_id ON public.parametropiscofins USING btree (usuarioalteracao_id);


--
-- TOC entry 6614 (class 1259 OID 2381279)
-- Name: ix_parametropiscofins_fk_parametropiscofins_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametropiscofins_fk_parametropiscofins_usuariocadastro_id ON public.parametropiscofins USING btree (usuariocadastro_id);


--
-- TOC entry 6622 (class 1259 OID 2381280)
-- Name: ix_parametroproduto_fk_parametroproduto_cfop_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroproduto_fk_parametroproduto_cfop_id ON public.parametroproduto USING btree (cfop_id);


--
-- TOC entry 6623 (class 1259 OID 2381281)
-- Name: ix_parametroproduto_fk_parametroproduto_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroproduto_fk_parametroproduto_empresa_id ON public.parametroproduto USING btree (empresa_id);


--
-- TOC entry 6624 (class 1259 OID 2381282)
-- Name: ix_parametroproduto_fk_parametroproduto_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroproduto_fk_parametroproduto_produto_id ON public.parametroproduto USING btree (produto_id);


--
-- TOC entry 6625 (class 1259 OID 2381283)
-- Name: ix_parametroproduto_fk_parametroproduto_tipoitem_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametroproduto_fk_parametroproduto_tipoitem_id ON public.parametroproduto USING btree (tipoitem_id);


--
-- TOC entry 6634 (class 1259 OID 2381284)
-- Name: ix_parametrosempresa_cnae_fk_parametrosempresa_cnae_cnaes_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametrosempresa_cnae_fk_parametrosempresa_cnae_cnaes_id ON public.parametrosempresa_cnae USING btree (cnaes_id);


--
-- TOC entry 6630 (class 1259 OID 2381285)
-- Name: ix_parametrosempresa_fk_parametrosempresa_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametrosempresa_fk_parametrosempresa_empresa_id ON public.parametrosempresa USING btree (empresa_id);


--
-- TOC entry 6631 (class 1259 OID 2381286)
-- Name: ix_parametrosempresa_fk_parametrosempresa_regimetributario_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametrosempresa_fk_parametrosempresa_regimetributario_id ON public.parametrosempresa USING btree (regimetributario_id);


--
-- TOC entry 6638 (class 1259 OID 2381287)
-- Name: ix_parametrosimpostosnfse_fk_parametrosimpostosnfse_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametrosimpostosnfse_fk_parametrosimpostosnfse_empresa_id ON public.parametrosimpostosnfse USING btree (empresa_id);


--
-- TOC entry 6643 (class 1259 OID 2381288)
-- Name: ix_parametrotecnospeedapi_fk_parametrotecnospeedapi_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parametrotecnospeedapi_fk_parametrotecnospeedapi_empresa_id ON public.parametrotecnospeedapi USING btree (empresa_id);


--
-- TOC entry 6654 (class 1259 OID 2381289)
-- Name: ix_pedido_fk_pedido_cliente_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pedido_fk_pedido_cliente_id ON public.pedido USING btree (cliente_id);


--
-- TOC entry 6655 (class 1259 OID 2381290)
-- Name: ix_pedido_fk_pedido_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pedido_fk_pedido_empresa_id ON public.pedido USING btree (empresa_id);


--
-- TOC entry 6656 (class 1259 OID 2381291)
-- Name: ix_pedido_fk_pedido_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pedido_fk_pedido_usuarioalteracao_id ON public.pedido USING btree (usuarioalteracao_id);


--
-- TOC entry 6657 (class 1259 OID 2381292)
-- Name: ix_pedido_fk_pedido_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pedido_fk_pedido_usuariocadastro_id ON public.pedido USING btree (usuariocadastro_id);


--
-- TOC entry 6658 (class 1259 OID 2381293)
-- Name: ix_pedido_fk_pedido_vendedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pedido_fk_pedido_vendedor_id ON public.pedido USING btree (vendedor_id);


--
-- TOC entry 6662 (class 1259 OID 2381294)
-- Name: ix_pedidocompra_fk_pedidocompra_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pedidocompra_fk_pedidocompra_empresa_id ON public.pedidocompra USING btree (empresa_id);


--
-- TOC entry 6663 (class 1259 OID 2381295)
-- Name: ix_pedidocompra_fk_pedidocompra_fornecedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pedidocompra_fk_pedidocompra_fornecedor_id ON public.pedidocompra USING btree (fornecedor_id);


--
-- TOC entry 6664 (class 1259 OID 2381296)
-- Name: ix_pedidocompra_fk_pedidocompra_situacaopedido_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pedidocompra_fk_pedidocompra_situacaopedido_id ON public.pedidocompra USING btree (situacaopedido_id);


--
-- TOC entry 6665 (class 1259 OID 2381297)
-- Name: ix_pedidocompra_fk_pedidocompra_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pedidocompra_fk_pedidocompra_usuarioalteracao_id ON public.pedidocompra USING btree (usuarioalteracao_id);


--
-- TOC entry 6666 (class 1259 OID 2381298)
-- Name: ix_pedidocompra_fk_pedidocompra_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pedidocompra_fk_pedidocompra_usuariocadastro_id ON public.pedidocompra USING btree (usuariocadastro_id);


--
-- TOC entry 6667 (class 1259 OID 2381299)
-- Name: ix_pedidocompra_fk_pedidocompra_vendedorfuncionario_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pedidocompra_fk_pedidocompra_vendedorfuncionario_id ON public.pedidocompra USING btree (vendedorfuncionario_id);


--
-- TOC entry 6683 (class 1259 OID 2381300)
-- Name: ix_produto_fk_produto_csticms_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produto_fk_produto_csticms_id ON public.produto USING btree (csticms_id);


--
-- TOC entry 6684 (class 1259 OID 2381301)
-- Name: ix_produto_fk_produto_cstipi_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produto_fk_produto_cstipi_id ON public.produto USING btree (cstipi_id);


--
-- TOC entry 6685 (class 1259 OID 2381302)
-- Name: ix_produto_fk_produto_cstpiscofins_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produto_fk_produto_cstpiscofins_id ON public.produto USING btree (cstpiscofins_id);


--
-- TOC entry 6686 (class 1259 OID 2381303)
-- Name: ix_produto_fk_produto_departamento_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produto_fk_produto_departamento_id ON public.produto USING btree (departamento_id);


--
-- TOC entry 6687 (class 1259 OID 2381304)
-- Name: ix_produto_fk_produto_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produto_fk_produto_empresa_id ON public.produto USING btree (empresa_id);


--
-- TOC entry 6688 (class 1259 OID 2381305)
-- Name: ix_produto_fk_produto_estadoconsumo_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produto_fk_produto_estadoconsumo_id ON public.produto USING btree (estadoconsumo_id);


--
-- TOC entry 6689 (class 1259 OID 2381306)
-- Name: ix_produto_fk_produto_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produto_fk_produto_usuarioalteracao_id ON public.produto USING btree (usuarioalteracao_id);


--
-- TOC entry 6690 (class 1259 OID 2381307)
-- Name: ix_produto_fk_produto_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produto_fk_produto_usuariocadastro_id ON public.produto USING btree (usuariocadastro_id);


--
-- TOC entry 6696 (class 1259 OID 2381308)
-- Name: ix_produtofornecedor_fk_produtofornecedor_clientefornecedor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produtofornecedor_fk_produtofornecedor_clientefornecedor_id ON public.produtofornecedor USING btree (clientefornecedor_id);


--
-- TOC entry 6697 (class 1259 OID 2381309)
-- Name: ix_produtofornecedor_fk_produtofornecedor_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produtofornecedor_fk_produtofornecedor_produto_id ON public.produtofornecedor USING btree (produto_id);


--
-- TOC entry 6700 (class 1259 OID 2381310)
-- Name: ix_produtotabelapreco_fk_produtotabelapreco_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produtotabelapreco_fk_produtotabelapreco_produto_id ON public.produtotabelapreco USING btree (produto_id);


--
-- TOC entry 6701 (class 1259 OID 2381311)
-- Name: ix_produtotabelapreco_fk_produtotabelapreco_tabelapreco_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produtotabelapreco_fk_produtotabelapreco_tabelapreco_id ON public.produtotabelapreco USING btree (tabelapreco_id);


--
-- TOC entry 6702 (class 1259 OID 2381312)
-- Name: ix_produtotabelapreco_fk_produtotabelapreco_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produtotabelapreco_fk_produtotabelapreco_usuarioalteracao_id ON public.produtotabelapreco USING btree (usuarioalteracao_id);


--
-- TOC entry 6703 (class 1259 OID 2381313)
-- Name: ix_produtotabelapreco_fk_produtotabelapreco_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_produtotabelapreco_fk_produtotabelapreco_usuariocadastro_id ON public.produtotabelapreco USING btree (usuariocadastro_id);


--
-- TOC entry 6706 (class 1259 OID 2381314)
-- Name: ix_promocaoproduto_fk_promocaoproduto_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_promocaoproduto_fk_promocaoproduto_empresa_id ON public.promocaoproduto USING btree (empresa_id);


--
-- TOC entry 6707 (class 1259 OID 2381315)
-- Name: ix_promocaoproduto_fk_promocaoproduto_produto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_promocaoproduto_fk_promocaoproduto_produto_id ON public.promocaoproduto USING btree (produto_id);


--
-- TOC entry 6708 (class 1259 OID 2381316)
-- Name: ix_promocaoproduto_fk_promocaoproduto_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_promocaoproduto_fk_promocaoproduto_usuarioalteracao_id ON public.promocaoproduto USING btree (usuarioalteracao_id);


--
-- TOC entry 6709 (class 1259 OID 2381317)
-- Name: ix_promocaoproduto_fk_promocaoproduto_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_promocaoproduto_fk_promocaoproduto_usuariocadastro_id ON public.promocaoproduto USING btree (usuariocadastro_id);


--
-- TOC entry 6714 (class 1259 OID 2381318)
-- Name: ix_seguradora_fk_seguradora_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_seguradora_fk_seguradora_empresa_id ON public.seguradora USING btree (empresa_id);


--
-- TOC entry 6715 (class 1259 OID 2381319)
-- Name: ix_seguradora_fk_seguradora_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_seguradora_fk_seguradora_usuarioalteracao_id ON public.seguradora USING btree (usuarioalteracao_id);


--
-- TOC entry 6716 (class 1259 OID 2381320)
-- Name: ix_seguradora_fk_seguradora_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_seguradora_fk_seguradora_usuariocadastro_id ON public.seguradora USING btree (usuariocadastro_id);


--
-- TOC entry 6719 (class 1259 OID 2381321)
-- Name: ix_servico_fk_servico_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_servico_fk_servico_empresa_id ON public.servico USING btree (empresa_id);


--
-- TOC entry 6723 (class 1259 OID 2381322)
-- Name: ix_serviconfse_fk_serviconfse_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_serviconfse_fk_serviconfse_usuarioalteracao_id ON public.serviconfse USING btree (usuarioalteracao_id);


--
-- TOC entry 6724 (class 1259 OID 2381323)
-- Name: ix_serviconfse_fk_serviconfse_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_serviconfse_fk_serviconfse_usuariocadastro_id ON public.serviconfse USING btree (usuariocadastro_id);


--
-- TOC entry 6729 (class 1259 OID 2381324)
-- Name: ix_situacao_fk_situacao_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_situacao_fk_situacao_empresa_id ON public.situacao USING btree (empresa_id);


--
-- TOC entry 6730 (class 1259 OID 2381325)
-- Name: ix_situacao_fk_situacao_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_situacao_fk_situacao_usuarioalteracao_id ON public.situacao USING btree (usuarioalteracao_id);


--
-- TOC entry 6731 (class 1259 OID 2381326)
-- Name: ix_situacao_fk_situacao_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_situacao_fk_situacao_usuariocadastro_id ON public.situacao USING btree (usuariocadastro_id);


--
-- TOC entry 6734 (class 1259 OID 2381327)
-- Name: ix_situacaocheque_fk_situacaocheque_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_situacaocheque_fk_situacaocheque_empresa_id ON public.situacaocheque USING btree (empresa_id);


--
-- TOC entry 6735 (class 1259 OID 2381328)
-- Name: ix_situacaocheque_fk_situacaocheque_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_situacaocheque_fk_situacaocheque_usuarioalteracao_id ON public.situacaocheque USING btree (usuarioalteracao_id);


--
-- TOC entry 6736 (class 1259 OID 2381329)
-- Name: ix_situacaocheque_fk_situacaocheque_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_situacaocheque_fk_situacaocheque_usuariocadastro_id ON public.situacaocheque USING btree (usuariocadastro_id);


--
-- TOC entry 6739 (class 1259 OID 2381330)
-- Name: ix_statusanotacaopedido_fk_statusanotacaopedido_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_statusanotacaopedido_fk_statusanotacaopedido_empresa_id ON public.statusanotacaopedido USING btree (empresa_id);


--
-- TOC entry 6744 (class 1259 OID 2381331)
-- Name: ix_subdepartamento_fk_subdepartamento_departamento_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_subdepartamento_fk_subdepartamento_departamento_id ON public.subdepartamento USING btree (departamento_id);


--
-- TOC entry 6745 (class 1259 OID 2381332)
-- Name: ix_subdepartamento_fk_subdepartamento_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_subdepartamento_fk_subdepartamento_empresa_id ON public.subdepartamento USING btree (empresa_id);


--
-- TOC entry 6746 (class 1259 OID 2381333)
-- Name: ix_subdepartamento_fk_subdepartamento_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_subdepartamento_fk_subdepartamento_usuarioalteracao_id ON public.subdepartamento USING btree (usuarioalteracao_id);


--
-- TOC entry 6747 (class 1259 OID 2381334)
-- Name: ix_subdepartamento_fk_subdepartamento_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_subdepartamento_fk_subdepartamento_usuariocadastro_id ON public.subdepartamento USING btree (usuariocadastro_id);


--
-- TOC entry 6750 (class 1259 OID 2381335)
-- Name: ix_subserviconfse_fk_subserviconfse_serviconfse_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_subserviconfse_fk_subserviconfse_serviconfse_id ON public.subserviconfse USING btree (serviconfse_id);


--
-- TOC entry 6751 (class 1259 OID 2381336)
-- Name: ix_subserviconfse_fk_subserviconfse_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_subserviconfse_fk_subserviconfse_usuarioalteracao_id ON public.subserviconfse USING btree (usuarioalteracao_id);


--
-- TOC entry 6752 (class 1259 OID 2381337)
-- Name: ix_subserviconfse_fk_subserviconfse_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_subserviconfse_fk_subserviconfse_usuariocadastro_id ON public.subserviconfse USING btree (usuariocadastro_id);


--
-- TOC entry 6758 (class 1259 OID 2381338)
-- Name: ix_tabelaibpt_fk_tabelaibpt_estado_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tabelaibpt_fk_tabelaibpt_estado_id ON public.tabelaibpt USING btree (estado_id);


--
-- TOC entry 6761 (class 1259 OID 2381339)
-- Name: ix_tabelapreco_fk_tabelapreco_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tabelapreco_fk_tabelapreco_empresa_id ON public.tabelapreco USING btree (empresa_id);


--
-- TOC entry 6762 (class 1259 OID 2381340)
-- Name: ix_tabelapreco_fk_tabelapreco_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tabelapreco_fk_tabelapreco_usuarioalteracao_id ON public.tabelapreco USING btree (usuarioalteracao_id);


--
-- TOC entry 6763 (class 1259 OID 2381341)
-- Name: ix_tabelapreco_fk_tabelapreco_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tabelapreco_fk_tabelapreco_usuariocadastro_id ON public.tabelapreco USING btree (usuariocadastro_id);


--
-- TOC entry 6766 (class 1259 OID 2381342)
-- Name: ix_tabelapreco_usuario_fk_tabelapreco_usuario_tabelapreco_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tabelapreco_usuario_fk_tabelapreco_usuario_tabelapreco_id ON public.tabelapreco_usuario USING btree (tabelapreco_id);


--
-- TOC entry 6767 (class 1259 OID 2381343)
-- Name: ix_tabelapreco_usuario_fk_tabelapreco_usuario_usuarios_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tabelapreco_usuario_fk_tabelapreco_usuario_usuarios_id ON public.tabelapreco_usuario USING btree (usuarios_id);


--
-- TOC entry 6771 (class 1259 OID 2381344)
-- Name: ix_tara_fk_tara_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tara_fk_tara_empresa_id ON public.tara USING btree (empresa_id);


--
-- TOC entry 6774 (class 1259 OID 2381345)
-- Name: ix_taxaentrega_fk_taxaentrega_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_taxaentrega_fk_taxaentrega_empresa_id ON public.taxaentrega USING btree (empresa_id);


--
-- TOC entry 6777 (class 1259 OID 2381346)
-- Name: ix_taxaentregabairros_fk_taxaentregabairros_municipio_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_taxaentregabairros_fk_taxaentregabairros_municipio_id ON public.taxaentregabairros USING btree (municipio_id);


--
-- TOC entry 6778 (class 1259 OID 2381347)
-- Name: ix_taxaentregabairros_fk_taxaentregabairros_taxaentrega_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_taxaentregabairros_fk_taxaentregabairros_taxaentrega_id ON public.taxaentregabairros USING btree (taxaentrega_id);


--
-- TOC entry 6781 (class 1259 OID 2381348)
-- Name: ix_tipo_fk_tipo_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tipo_fk_tipo_empresa_id ON public.tipo USING btree (empresa_id);


--
-- TOC entry 6782 (class 1259 OID 2381349)
-- Name: ix_tipo_fk_tipo_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tipo_fk_tipo_usuarioalteracao_id ON public.tipo USING btree (usuarioalteracao_id);


--
-- TOC entry 6783 (class 1259 OID 2381350)
-- Name: ix_tipo_fk_tipo_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tipo_fk_tipo_usuariocadastro_id ON public.tipo USING btree (usuariocadastro_id);


--
-- TOC entry 6788 (class 1259 OID 2381351)
-- Name: ix_tipocontato_fk_tipocontato_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tipocontato_fk_tipocontato_empresa_id ON public.tipocontato USING btree (empresa_id);


--
-- TOC entry 6789 (class 1259 OID 2381352)
-- Name: ix_tipocontato_fk_tipocontato_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tipocontato_fk_tipocontato_usuarioalteracao_id ON public.tipocontato USING btree (usuarioalteracao_id);


--
-- TOC entry 6790 (class 1259 OID 2381353)
-- Name: ix_tipocontato_fk_tipocontato_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tipocontato_fk_tipocontato_usuariocadastro_id ON public.tipocontato USING btree (usuariocadastro_id);


--
-- TOC entry 6795 (class 1259 OID 2381354)
-- Name: ix_tokenintegracao_fk_tokenintegracao_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tokenintegracao_fk_tokenintegracao_usuarioalteracao_id ON public.tokenintegracao USING btree (usuarioalteracao_id);


--
-- TOC entry 6796 (class 1259 OID 2381355)
-- Name: ix_tokenintegracao_fk_tokenintegracao_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tokenintegracao_fk_tokenintegracao_usuariocadastro_id ON public.tokenintegracao USING btree (usuariocadastro_id);


--
-- TOC entry 6800 (class 1259 OID 2381356)
-- Name: ix_tributacaogeralempresa_fk_tributacaogeralempresa_cfop_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tributacaogeralempresa_fk_tributacaogeralempresa_cfop_id ON public.tributacaogeralempresa USING btree (cfop_id);


--
-- TOC entry 6801 (class 1259 OID 2381357)
-- Name: ix_tributacaogeralempresa_fk_tributacaogeralempresa_csticms_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tributacaogeralempresa_fk_tributacaogeralempresa_csticms_id ON public.tributacaogeralempresa USING btree (csticms_id);


--
-- TOC entry 6802 (class 1259 OID 2381358)
-- Name: ix_tributacaogeralempresa_fk_tributacaogeralempresa_cstipi_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tributacaogeralempresa_fk_tributacaogeralempresa_cstipi_id ON public.tributacaogeralempresa USING btree (cstipi_id);


--
-- TOC entry 6803 (class 1259 OID 2381359)
-- Name: ix_tributacaogeralempresa_fk_tributacaogeralempresa_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tributacaogeralempresa_fk_tributacaogeralempresa_empresa_id ON public.tributacaogeralempresa USING btree (empresa_id);


--
-- TOC entry 6804 (class 1259 OID 2381360)
-- Name: ix_tributacaogeralempresa_fk_tributacaogeralempresa_tipoitem_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tributacaogeralempresa_fk_tributacaogeralempresa_tipoitem_id ON public.tributacaogeralempresa USING btree (tipoitem_id);


--
-- TOC entry 6811 (class 1259 OID 2381361)
-- Name: ix_tributacaoporncm_fk_tributacaoporncm_cfop_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tributacaoporncm_fk_tributacaoporncm_cfop_id ON public.tributacaoporncm USING btree (cfop_id);


--
-- TOC entry 6812 (class 1259 OID 2381362)
-- Name: ix_tributacaoporncm_fk_tributacaoporncm_csticmsusual_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tributacaoporncm_fk_tributacaoporncm_csticmsusual_id ON public.tributacaoporncm USING btree (csticmsusual_id);


--
-- TOC entry 6813 (class 1259 OID 2381363)
-- Name: ix_tributacaoporncm_fk_tributacaoporncm_cstipiusual_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tributacaoporncm_fk_tributacaoporncm_cstipiusual_id ON public.tributacaoporncm USING btree (cstipiusual_id);


--
-- TOC entry 6814 (class 1259 OID 2381364)
-- Name: ix_tributacaoporncm_fk_tributacaoporncm_cstpiscofinsusual_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tributacaoporncm_fk_tributacaoporncm_cstpiscofinsusual_id ON public.tributacaoporncm USING btree (cstpiscofinsusual_id);


--
-- TOC entry 6815 (class 1259 OID 2381365)
-- Name: ix_tributacaoporncm_fk_tributacaoporncm_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tributacaoporncm_fk_tributacaoporncm_empresa_id ON public.tributacaoporncm USING btree (empresa_id);


--
-- TOC entry 6816 (class 1259 OID 2381366)
-- Name: ix_tributacaoporncm_fk_tributacaoporncm_tipoitem_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tributacaoporncm_fk_tributacaoporncm_tipoitem_id ON public.tributacaoporncm USING btree (tipoitem_id);


--
-- TOC entry 6820 (class 1259 OID 2381367)
-- Name: ix_unidademedida_fk_unidademedida_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_unidademedida_fk_unidademedida_usuarioalteracao_id ON public.unidademedida USING btree (usuarioalteracao_id);


--
-- TOC entry 6821 (class 1259 OID 2381368)
-- Name: ix_unidademedida_fk_unidademedida_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_unidademedida_fk_unidademedida_usuariocadastro_id ON public.unidademedida USING btree (usuariocadastro_id);


--
-- TOC entry 6825 (class 1259 OID 2381369)
-- Name: ix_usuario_fk_usuario_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_usuario_fk_usuario_empresa_id ON public.usuario USING btree (empresa_id);


--
-- TOC entry 6826 (class 1259 OID 2381370)
-- Name: ix_usuario_fk_usuario_papel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_usuario_fk_usuario_papel_id ON public.usuario USING btree (papel_id);


--
-- TOC entry 6830 (class 1259 OID 2381371)
-- Name: ix_usuariocaixa_fk_usuariocaixa_caixa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_usuariocaixa_fk_usuariocaixa_caixa_id ON public.usuariocaixa USING btree (caixa_id);


--
-- TOC entry 6831 (class 1259 OID 2381372)
-- Name: ix_usuariocaixa_fk_usuariocaixa_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_usuariocaixa_fk_usuariocaixa_empresa_id ON public.usuariocaixa USING btree (empresa_id);


--
-- TOC entry 6832 (class 1259 OID 2381373)
-- Name: ix_usuariocaixa_fk_usuariocaixa_usuario_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_usuariocaixa_fk_usuariocaixa_usuario_id ON public.usuariocaixa USING btree (usuario_id);


--
-- TOC entry 6838 (class 1259 OID 2381374)
-- Name: ix_veiculo_veiculo_fk_veiculo_veiculo_veiculocte_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_veiculo_veiculo_fk_veiculo_veiculo_veiculocte_id ON public.veiculo_veiculo USING btree (veiculocte_id);


--
-- TOC entry 6839 (class 1259 OID 2381375)
-- Name: ix_veiculo_veiculo_fk_veiculo_veiculo_veiculosvinculado_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_veiculo_veiculo_fk_veiculo_veiculo_veiculosvinculado_id ON public.veiculo_veiculo USING btree (veiculosvinculado_id);


--
-- TOC entry 6847 (class 1259 OID 2381376)
-- Name: ix_vendasorigem_fk_vendasorigem_auxiliarservico_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vendasorigem_fk_vendasorigem_auxiliarservico_id ON public.vendasorigem USING btree (auxiliarservico_id);


--
-- TOC entry 6848 (class 1259 OID 2381377)
-- Name: ix_vendasorigem_fk_vendasorigem_auxiliarvenda_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vendasorigem_fk_vendasorigem_auxiliarvenda_id ON public.vendasorigem USING btree (auxiliarvenda_id);


--
-- TOC entry 6849 (class 1259 OID 2381378)
-- Name: ix_vendasorigem_fk_vendasorigem_cupomfiscalsat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vendasorigem_fk_vendasorigem_cupomfiscalsat_id ON public.vendasorigem USING btree (cupomfiscalsat_id);


--
-- TOC entry 6850 (class 1259 OID 2381379)
-- Name: ix_vendasorigem_fk_vendasorigem_notafiscalconsumidor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vendasorigem_fk_vendasorigem_notafiscalconsumidor_id ON public.vendasorigem USING btree (notafiscalconsumidor_id);


--
-- TOC entry 6851 (class 1259 OID 2381380)
-- Name: ix_vendasorigem_fk_vendasorigem_notafiscalservico_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vendasorigem_fk_vendasorigem_notafiscalservico_id ON public.vendasorigem USING btree (notafiscalservico_id);


--
-- TOC entry 6852 (class 1259 OID 2381381)
-- Name: ix_vendasorigem_fk_vendasorigem_ordemservico_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vendasorigem_fk_vendasorigem_ordemservico_id ON public.vendasorigem USING btree (ordemservico_id);


--
-- TOC entry 6853 (class 1259 OID 2381382)
-- Name: ix_vendasorigem_fk_vendasorigem_pedido_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vendasorigem_fk_vendasorigem_pedido_id ON public.vendasorigem USING btree (pedido_id);


--
-- TOC entry 6854 (class 1259 OID 2381383)
-- Name: ix_vendasorigem_fk_vendasorigem_tipofaturamento; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vendasorigem_fk_vendasorigem_tipofaturamento ON public.vendasorigem USING btree (tipofaturamento, empresaid, numero, ambiente, serie);


--
-- TOC entry 6857 (class 1259 OID 2381384)
-- Name: ix_versaosistema_fk_versaosistema_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_versaosistema_fk_versaosistema_usuarioalteracao_id ON public.versaosistema USING btree (usuarioalteracao_id);


--
-- TOC entry 6858 (class 1259 OID 2381385)
-- Name: ix_versaosistema_fk_versaosistema_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_versaosistema_fk_versaosistema_usuariocadastro_id ON public.versaosistema USING btree (usuariocadastro_id);


--
-- TOC entry 6420 (class 1259 OID 2381386)
-- Name: liquidacaoprodutoprodutofkliquidacaoproduto_produto_produtos_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX liquidacaoprodutoprodutofkliquidacaoproduto_produto_produtos_id ON public.liquidacaoproduto_produto USING btree (produtos_id);


--
-- TOC entry 6421 (class 1259 OID 2381387)
-- Name: lqdcaoprodutoprodutofklqidacaoprodutoprodutoliquidacaoprodutoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lqdcaoprodutoprodutofklqidacaoprodutoprodutoliquidacaoprodutoid ON public.liquidacaoproduto_produto USING btree (liquidacaoproduto_id);


--
-- TOC entry 6433 (class 1259 OID 2381388)
-- Name: mdlrdoviariomdfemotoristafkmdlrodoviariomdfemotoristacondutorid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mdlrdoviariomdfemotoristafkmdlrodoviariomdfemotoristacondutorid ON public.modalrodoviariomdfe_motorista USING btree (condutor_id);


--
-- TOC entry 6441 (class 1259 OID 2381389)
-- Name: mdlrdviariomdfeveiculofkmdlrdoviariomdfeveiculoveiculoreboqueid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mdlrdviariomdfeveiculofkmdlrdoviariomdfeveiculoveiculoreboqueid ON public.modalrodoviariomdfe_veiculo USING btree (veiculoreboque_id);


--
-- TOC entry 6434 (class 1259 OID 2381390)
-- Name: mdlrdvrmdfemotoristafkmdlrdvrmdfemotoristamodalrodoviariomdfeid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mdlrdvrmdfemotoristafkmdlrdvrmdfemotoristamodalrodoviariomdfeid ON public.modalrodoviariomdfe_motorista USING btree (modalrodoviariomdfe_id);


--
-- TOC entry 6437 (class 1259 OID 2381391)
-- Name: mdlrdvrmdfvlpedagiofkmdlrdvrmdfvalepedagiomodalrodoviariomdfeid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mdlrdvrmdfvlpedagiofkmdlrdvrmdfvalepedagiomodalrodoviariomdfeid ON public.modalrodoviariomdfe_valepedagio USING btree (modalrodoviariomdfe_id);


--
-- TOC entry 6438 (class 1259 OID 2381392)
-- Name: mdlrdvromdfevalepedagiofkmdlrdvariomdfevalepedagiovalepedagioid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mdlrdvromdfevalepedagiofkmdlrdvariomdfevalepedagiovalepedagioid ON public.modalrodoviariomdfe_valepedagio USING btree (valepedagio_id);


--
-- TOC entry 6442 (class 1259 OID 2381393)
-- Name: mdlrdvromdfeveiculofkmdlrdvariomdfeveiculomodalrodoviariomdfeid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mdlrdvromdfeveiculofkmdlrdvariomdfeveiculomodalrodoviariomdfeid ON public.modalrodoviariomdfe_veiculo USING btree (modalrodoviariomdfe_id);


--
-- TOC entry 6461 (class 1259 OID 2381394)
-- Name: movimentacaocaixa_fk_movimentacaocaixa_movimentacaoextorno_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX movimentacaocaixa_fk_movimentacaocaixa_movimentacaoextorno_id ON public.movimentacaocaixa USING btree (movimentacaoextorno_id);


--
-- TOC entry 6466 (class 1259 OID 2381395)
-- Name: movimentacaocreditoentradafkmovimentacaocreditoentradaempresaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX movimentacaocreditoentradafkmovimentacaocreditoentradaempresaid ON public.movimentacaocreditoentrada USING btree (empresa_id);


--
-- TOC entry 6472 (class 1259 OID 2381396)
-- Name: movimentacaocreditosaida_fk_movimentacaocreditosaida_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX movimentacaocreditosaida_fk_movimentacaocreditosaida_empresa_id ON public.movimentacaocreditosaida USING btree (empresa_id);


--
-- TOC entry 6467 (class 1259 OID 2381397)
-- Name: mvmentacaocreditoentradafkmovimentacaocreditoentradavaletrocoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mvmentacaocreditoentradafkmovimentacaocreditoentradavaletrocoid ON public.movimentacaocreditoentrada USING btree (valetroco_id);


--
-- TOC entry 6468 (class 1259 OID 2381398)
-- Name: mvmentacaocreditoentradafkmvimentacaocreditoentradaformapagtoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mvmentacaocreditoentradafkmvimentacaocreditoentradaformapagtoid ON public.movimentacaocreditoentrada USING btree (formapagto_id);


--
-- TOC entry 6475 (class 1259 OID 2381399)
-- Name: mvmentacaocreditosaidafkmvimentacaocreditosaidacreditoclienteid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mvmentacaocreditosaidafkmvimentacaocreditosaidacreditoclienteid ON public.movimentacaocreditosaida USING btree (creditocliente_id);


--
-- TOC entry 6469 (class 1259 OID 2381400)
-- Name: mvmntacaocreditoentradafkmvimentacaocreditoentradacaixaabertoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mvmntacaocreditoentradafkmvimentacaocreditoentradacaixaabertoid ON public.movimentacaocreditoentrada USING btree (caixaaberto_id);


--
-- TOC entry 6476 (class 1259 OID 2381401)
-- Name: mvmntacaocreditosaidafkmvmntacaocreditosaidaformapagamentonfeid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mvmntacaocreditosaidafkmvmntacaocreditosaidaformapagamentonfeid ON public.movimentacaocreditosaida USING btree (formapagamentonfe_id);


--
-- TOC entry 6470 (class 1259 OID 2381402)
-- Name: mvmntcaocreditoentradafkmvmntacaocreditoentradacreditoclienteid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mvmntcaocreditoentradafkmvmntacaocreditoentradacreditoclienteid ON public.movimentacaocreditoentrada USING btree (creditocliente_id);


--
-- TOC entry 6477 (class 1259 OID 2381403)
-- Name: mvmntcaocreditosaidafkmvmntacaocreditosaidaformapagamentonfceid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mvmntcaocreditosaidafkmvmntacaocreditosaidaformapagamentonfceid ON public.movimentacaocreditosaida USING btree (formapagamentonfce_id);


--
-- TOC entry 6478 (class 1259 OID 2381404)
-- Name: mvmntcaocreditosaidafkmvmntacaocreditosaidaformapagamentonfseid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mvmntcaocreditosaidafkmvmntacaocreditosaidaformapagamentonfseid ON public.movimentacaocreditosaida USING btree (formapagamentonfse_id);


--
-- TOC entry 6471 (class 1259 OID 2381405)
-- Name: mvmntccrdtoentradafkmvmntccreditoentradadevolucaotrocaprodutoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mvmntccrdtoentradafkmvmntccreditoentradadevolucaotrocaprodutoid ON public.movimentacaocreditoentrada USING btree (devolucaotrocaproduto_id);


--
-- TOC entry 6479 (class 1259 OID 2381406)
-- Name: mvmntccrdtosaidafkmvmntccreditosaidaformapagamentocupomfiscalid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mvmntccrdtosaidafkmvmntccreditosaidaformapagamentocupomfiscalid ON public.movimentacaocreditosaida USING btree (formapagamentocupomfiscal_id);


--
-- TOC entry 6480 (class 1259 OID 2381407)
-- Name: mvmntccrdtsidafkmvmntccrdtosaidaformapagamentoauxiliarservicoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mvmntccrdtsidafkmvmntccrdtosaidaformapagamentoauxiliarservicoid ON public.movimentacaocreditosaida USING btree (formapagamentoauxiliarservico_id);


--
-- TOC entry 6481 (class 1259 OID 2381408)
-- Name: mvmntccrdtsidafkmvmntccrdtsaidaformapagamentodevolucaoprodutoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mvmntccrdtsidafkmvmntccrdtsaidaformapagamentodevolucaoprodutoid ON public.movimentacaocreditosaida USING btree (formapagamentodevolucaoproduto_id);


--
-- TOC entry 6482 (class 1259 OID 2381409)
-- Name: mvmntccreditosaidafkmvmntcocreditosaidaformapagamentoauxvendaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mvmntccreditosaidafkmvmntcocreditosaidaformapagamentoauxvendaid ON public.movimentacaocreditosaida USING btree (formapagamentoauxvenda_id);


--
-- TOC entry 6499 (class 1259 OID 2381410)
-- Name: ncm_excecao_idxunique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ncm_excecao_idxunique ON public.ncm USING btree (numero, excecao);


--
-- TOC entry 6502 (class 1259 OID 2381411)
-- Name: nfcnhcmnttrnsprtdcrfrncdnfcnhcmnttrnsprtdcrfrncdcnhcmnttrnsprtd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nfcnhcmnttrnsprtdcrfrncdnfcnhcmnttrnsprtdcrfrncdcnhcmnttrnsprtd ON public.nfconhecimentotransportedocreferenciado USING btree (conhecimentotransporte_id);


--
-- TOC entry 6343 (class 1259 OID 2381412)
-- Name: nfrmcntrconalextrafknfrmcntricionalextrainformacaonutricionalid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nfrmcntrconalextrafknfrmcntricionalextrainformacaonutricionalid ON public.informacaonutricionalextra USING btree (informacaonutricional_id);


--
-- TOC entry 6548 (class 1259 OID 2381413)
-- Name: parametro_fechamento_caixa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX parametro_fechamento_caixa ON public.parametrofechamentocaixa USING btree (empresa_id);


--
-- TOC entry 6639 (class 1259 OID 2381414)
-- Name: parametro_imposto_nfs_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX parametro_imposto_nfs_idx ON public.parametrosimpostosnfse USING btree (vigencia, empresa_id);


--
-- TOC entry 6564 (class 1259 OID 2381415)
-- Name: parametro_impressao_unicidade; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX parametro_impressao_unicidade ON public.parametroimpressao USING btree (empresa_id);


--
-- TOC entry 6581 (class 1259 OID 2381416)
-- Name: parametro_integracao_contabilidade; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX parametro_integracao_contabilidade ON public.parametrointegracaocontabilidade USING btree (empresa_id);


--
-- TOC entry 6605 (class 1259 OID 2381417)
-- Name: parametro_ordemservico; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX parametro_ordemservico ON public.parametroordemservico USING btree (empresa_id);


--
-- TOC entry 6644 (class 1259 OID 2381418)
-- Name: parametro_tecnospeed_empresa_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX parametro_tecnospeed_empresa_unique ON public.parametrotecnospeedapi USING btree (empresa_id);


--
-- TOC entry 6540 (class 1259 OID 2381419)
-- Name: parametrobeneficiofiscal_fk_parametrobeneficiofiscal_estado_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX parametrobeneficiofiscal_fk_parametrobeneficiofiscal_estado_id ON public.parametrobeneficiofiscal USING btree (estado_id);


--
-- TOC entry 6549 (class 1259 OID 2381420)
-- Name: parametrofechamentocaixa_fk_parametrofechamentocaixa_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX parametrofechamentocaixa_fk_parametrofechamentocaixa_empresa_id ON public.parametrofechamentocaixa USING btree (empresa_id);


--
-- TOC entry 6552 (class 1259 OID 2381421)
-- Name: parametroformapagamento_fk_parametroformapagamento_empresa_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX parametroformapagamento_fk_parametroformapagamento_empresa_id ON public.parametroformapagamento USING btree (empresa_id);


--
-- TOC entry 6565 (class 1259 OID 2381422)
-- Name: parametroimpressao_fk_parametroimpressao_grupoimpressaodanfe_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX parametroimpressao_fk_parametroimpressao_grupoimpressaodanfe_id ON public.parametroimpressao USING btree (grupoimpressaodanfe_id);


--
-- TOC entry 6568 (class 1259 OID 2381423)
-- Name: parametroimpressaofk_parametroimpressao_grupoimpressaopedido_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX parametroimpressaofk_parametroimpressao_grupoimpressaopedido_id ON public.parametroimpressao USING btree (grupoimpressaopedido_id);


--
-- TOC entry 6569 (class 1259 OID 2381424)
-- Name: parametroimpressaofkparametroimpressaogrupoimpressaodanfenfceid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX parametroimpressaofkparametroimpressaogrupoimpressaodanfenfceid ON public.parametroimpressao USING btree (grupoimpressaodanfenfce_id);


--
-- TOC entry 6570 (class 1259 OID 2381425)
-- Name: parametroimpressaofkparametroimpressaogrupoimpressaoorcamentoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX parametroimpressaofkparametroimpressaogrupoimpressaoorcamentoid ON public.parametroimpressao USING btree (grupoimpressaoorcamento_id);


--
-- TOC entry 6608 (class 1259 OID 2381426)
-- Name: parametroordemservicofkparametroordemservico_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX parametroordemservicofkparametroordemservico_usuariocadastro_id ON public.parametroordemservico USING btree (usuariocadastro_id);


--
-- TOC entry 6609 (class 1259 OID 2381427)
-- Name: parametroordemservicofkparametroordemservicousuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX parametroordemservicofkparametroordemservicousuarioalteracao_id ON public.parametroordemservico USING btree (usuarioalteracao_id);


--
-- TOC entry 6617 (class 1259 OID 2381428)
-- Name: parametropiscofinsfk_parametropiscofins_tabelacstspedentrada_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX parametropiscofinsfk_parametropiscofins_tabelacstspedentrada_id ON public.parametropiscofins USING btree (tabelacstspedentrada_id);


--
-- TOC entry 6618 (class 1259 OID 2381429)
-- Name: parametropiscofinsfkparametropiscofins_tabelacstspedcomercio_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX parametropiscofinsfkparametropiscofins_tabelacstspedcomercio_id ON public.parametropiscofins USING btree (tabelacstspedcomercio_id);


--
-- TOC entry 6619 (class 1259 OID 2381430)
-- Name: parametropiscofinsfkparametropiscofinstabelacstspedindustria_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX parametropiscofinsfkparametropiscofinstabelacstspedindustria_id ON public.parametropiscofins USING btree (tabelacstspedindustria_id);


--
-- TOC entry 6637 (class 1259 OID 2381431)
-- Name: parametrosempresacnaefkparametrosempresacnaeparametrosempresaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX parametrosempresacnaefkparametrosempresacnaeparametrosempresaid ON public.parametrosempresa_cnae USING btree (parametrosempresa_id);


--
-- TOC entry 6571 (class 1259 OID 2381432)
-- Name: prametroimpressaofkparametroimpressaogrupoimpressaoextratocfeid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prametroimpressaofkparametroimpressaogrupoimpressaoextratocfeid ON public.parametroimpressao USING btree (grupoimpressaoextratocfe_id);


--
-- TOC entry 6642 (class 1259 OID 2381433)
-- Name: prametrosimpostosnfsefkparametrosimpostosnfseregimetributarioid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prametrosimpostosnfsefkparametrosimpostosnfseregimetributarioid ON public.parametrosimpostosnfse USING btree (regimetributario_id);


--
-- TOC entry 6649 (class 1259 OID 2381434)
-- Name: prclpgmntdcmentofiscalfkprclpgmntdcumentofiscalformapagamentoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prclpgmntdcmentofiscalfkprclpgmntdcumentofiscalformapagamentoid ON public.parcelapagamentodocumentofiscal USING btree (formapagamento_id);


--
-- TOC entry 6652 (class 1259 OID 2381435)
-- Name: prclpgmntoordemservicofkprclpgmentoordemservicoformapagamentoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prclpgmntoordemservicofkprclpgmentoordemservicoformapagamentoid ON public.parcelapagamentoordemservico USING btree (formapagamento_id);


--
-- TOC entry 6678 (class 1259 OID 2381436)
-- Name: preferenciaemailsbackupfkpreferenciaemailsbackup_preferencia_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX preferenciaemailsbackupfkpreferenciaemailsbackup_preferencia_id ON public.preferencia_emailsbackup USING btree (preferencia_id);


--
-- TOC entry 6679 (class 1259 OID 2381437)
-- Name: prfrnciaemailsbackupfkprferenciaemailsbackuplistaemailsbackupid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prfrnciaemailsbackupfkprferenciaemailsbackuplistaemailsbackupid ON public.preferencia_emailsbackup USING btree (listaemailsbackup_id);


--
-- TOC entry 6572 (class 1259 OID 2381438)
-- Name: prmetroimpressaofkparametroimpressaogrupoimpressaovalecomprasid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmetroimpressaofkparametroimpressaogrupoimpressaovalecomprasid ON public.parametroimpressao USING btree (grupoimpressaovalecompras_id);


--
-- TOC entry 6573 (class 1259 OID 2381439)
-- Name: prmetroimpressaofkprametroimpressaogrupoimpressaoordemservicoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmetroimpressaofkprametroimpressaogrupoimpressaoordemservicoid ON public.parametroimpressao USING btree (grupoimpressaoordemservico_id);


--
-- TOC entry 6574 (class 1259 OID 2381440)
-- Name: prmtrimpressaofkprmtroimpressaogrupoimpressaotermocondicionalid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtrimpressaofkprmtroimpressaogrupoimpressaotermocondicionalid ON public.parametroimpressao USING btree (grupoimpressaotermocondicional_id);


--
-- TOC entry 6575 (class 1259 OID 2381441)
-- Name: prmtrmprssprmtrmprssgrpimpressaorelatorioresumovendasandcaixaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtrmprssprmtrmprssgrpimpressaorelatorioresumovendasandcaixaid ON public.parametroimpressao USING btree (grupoimpressaorelatorioresumovendasandcaixa_id);


--
-- TOC entry 6576 (class 1259 OID 2381442)
-- Name: prmtrmprssprmtrmprssgrupoimpressaorelatoriogerencialauxvendasid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtrmprssprmtrmprssgrupoimpressaorelatoriogerencialauxvendasid ON public.parametroimpressao USING btree (grupoimpressaorelatoriogerencialauxvendas_id);


--
-- TOC entry 6577 (class 1259 OID 2381443)
-- Name: prmtrmprssprmtrmprssogrupoimpressaorelatoriomovimentacaocaixaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtrmprssprmtrmprssogrupoimpressaorelatoriomovimentacaocaixaid ON public.parametroimpressao USING btree (grupoimpressaorelatoriomovimentacaocaixa_id);


--
-- TOC entry 6584 (class 1259 OID 2381444)
-- Name: prmtrntgracaocontabilidadefkprmtrntgracaocontabilidadeempresaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtrntgracaocontabilidadefkprmtrntgracaocontabilidadeempresaid ON public.parametrointegracaocontabilidade USING btree (empresa_id);


--
-- TOC entry 6585 (class 1259 OID 2381445)
-- Name: prmtrntgrccntabilidadefkprmtrntgrccntabilidadeusuariocadastroid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtrntgrccntabilidadefkprmtrntgrccntabilidadeusuariocadastroid ON public.parametrointegracaocontabilidade USING btree (usuariocadastro_id);


--
-- TOC entry 6586 (class 1259 OID 2381446)
-- Name: prmtrntgrccntbilidadefkprmtrntgrccntabilidadeusuarioalteracaoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtrntgrccntbilidadefkprmtrntgrccntabilidadeusuarioalteracaoid ON public.parametrointegracaocontabilidade USING btree (usuarioalteracao_id);


--
-- TOC entry 6543 (class 1259 OID 2381447)
-- Name: prmtrobeneficiofiscalfkprametrobeneficiofiscalusuariocadastroid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtrobeneficiofiscalfkprametrobeneficiofiscalusuariocadastroid ON public.parametrobeneficiofiscal USING btree (usuariocadastro_id);


--
-- TOC entry 6544 (class 1259 OID 2381448)
-- Name: prmtrobeneficiofiscalfkprmetrobeneficiofiscalusuarioalteracaoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtrobeneficiofiscalfkprmetrobeneficiofiscalusuarioalteracaoid ON public.parametrobeneficiofiscal USING btree (usuarioalteracao_id);


--
-- TOC entry 6578 (class 1259 OID 2381449)
-- Name: prmtroimpressaofkprametroimpressaogrupoimpressaoauxiliarvendaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtroimpressaofkprametroimpressaogrupoimpressaoauxiliarvendaid ON public.parametroimpressao USING btree (grupoimpressaoauxiliarvenda_id);


--
-- TOC entry 6579 (class 1259 OID 2381450)
-- Name: prmtroimpressaofkprmetroimpressaogrupoimpressaocreditoclienteid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtroimpressaofkprmetroimpressaogrupoimpressaocreditoclienteid ON public.parametroimpressao USING btree (grupoimpressaocreditocliente_id);


--
-- TOC entry 6580 (class 1259 OID 2381451)
-- Name: prmtroimpressaofkprmetroimpressaogrupoimpressaodevolucaotrocaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtroimpressaofkprmetroimpressaogrupoimpressaodevolucaotrocaid ON public.parametroimpressao USING btree (grupoimpressaodevolucaotroca_id);


--
-- TOC entry 6620 (class 1259 OID 2381452)
-- Name: prmtropiscofinsfkprmtropiscofinstabelacstspedentradaindustriaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtropiscofinsfkprmtropiscofinstabelacstspedentradaindustriaid ON public.parametropiscofins USING btree (tabelacstspedentradaindustria_id);


--
-- TOC entry 6610 (class 1259 OID 2381453)
-- Name: prmtrrdmsrvcchcklstfkprmtrrdmsrvcchcklstparametroordemservicoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prmtrrdmsrvcchcklstfkprmtrrdmsrvcchcklstparametroordemservicoid ON public.parametroordemservico_checklist USING btree (parametroordemservico_id);


--
-- TOC entry 6720 (class 1259 OID 2381454)
-- Name: servico_indice; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX servico_indice ON public.servico USING btree (codigoservico, empresa_id);


--
-- TOC entry 6725 (class 1259 OID 2381455)
-- Name: servico_nfse_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX servico_nfse_idx ON public.serviconfse USING btree (codigoservico);


--
-- TOC entry 6740 (class 1259 OID 2381456)
-- Name: statusanotacaopedido_fk_statusanotacaopedido_usuariocadastro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX statusanotacaopedido_fk_statusanotacaopedido_usuariocadastro_id ON public.statusanotacaopedido USING btree (usuariocadastro_id);


--
-- TOC entry 6743 (class 1259 OID 2381457)
-- Name: statusanotacaopedidofk_statusanotacaopedido_usuarioalteracao_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX statusanotacaopedidofk_statusanotacaopedido_usuarioalteracao_id ON public.statusanotacaopedido USING btree (usuarioalteracao_id);


--
-- TOC entry 6805 (class 1259 OID 2381458)
-- Name: trbutacaogeralempresafktributacaogeralempresausuarioalteracaoid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX trbutacaogeralempresafktributacaogeralempresausuarioalteracaoid ON public.tributacaogeralempresa USING btree (usuarioalteracao_id);


--
-- TOC entry 6808 (class 1259 OID 2381459)
-- Name: tributacaogeralempresafk_tributacaogeralempresa_cstpiscofins_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tributacaogeralempresafk_tributacaogeralempresa_cstpiscofins_id ON public.tributacaogeralempresa USING btree (cstpiscofins_id);


--
-- TOC entry 6809 (class 1259 OID 2381460)
-- Name: tributacaogeralempresafktributacaogeralempresausuariocadastroid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tributacaogeralempresafktributacaogeralempresausuariocadastroid ON public.tributacaogeralempresa USING btree (usuariocadastro_id);


--
-- TOC entry 6203 (class 1259 OID 2381461)
-- Name: uk_chave_acesso; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uk_chave_acesso ON public.documentofiscal USING btree (chaveacesso, empresa_id);


--
-- TOC entry 6863 (class 1259 OID 2381462)
-- Name: vlmnotafiscalentradafkvlumenotafiscalentradanotafiscalentradaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vlmnotafiscalentradafkvlumenotafiscalentradanotafiscalentradaid ON public.volumenotafiscalentrada USING btree (notafiscalentrada_id);


ALTER TABLE ONLY cte.cartacorrecaocte
    ADD CONSTRAINT fk_cartacorrecaocte_cte_id FOREIGN KEY (cte_id) REFERENCES cte.cte(id);


--
-- TOC entry 6867 (class 2606 OID 2381594)
-- Name: cartacorrecaocte fk_cartacorrecaocte_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cartacorrecaocte
    ADD CONSTRAINT fk_cartacorrecaocte_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 6868 (class 2606 OID 2381599)
-- Name: cartacorrecaocte fk_cartacorrecaocte_usuariocadastro_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cartacorrecaocte
    ADD CONSTRAINT fk_cartacorrecaocte_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 6869 (class 2606 OID 2381604)
-- Name: cte fk_cte_cfop_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_cfop_id FOREIGN KEY (cfop_id) REFERENCES public.cfop(id);


--
-- TOC entry 6870 (class 2606 OID 2381609)
-- Name: cte fk_cte_destinatario_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_destinatario_id FOREIGN KEY (destinatario_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6871 (class 2606 OID 2381614)
-- Name: cte fk_cte_emitente_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_emitente_id FOREIGN KEY (emitente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6872 (class 2606 OID 2381619)
-- Name: cte fk_cte_empresa_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 6873 (class 2606 OID 2381624)
-- Name: cte fk_cte_expeditor_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_expeditor_id FOREIGN KEY (expeditor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6874 (class 2606 OID 2381629)
-- Name: cte fk_cte_lote_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_lote_id FOREIGN KEY (lote_id) REFERENCES cte.lotecte(id);


--
-- TOC entry 6875 (class 2606 OID 2381634)
-- Name: cte fk_cte_modalrodoviario_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_modalrodoviario_id FOREIGN KEY (modalrodoviario_id) REFERENCES cte.modalrodoviario(id);


--
-- TOC entry 6876 (class 2606 OID 2381639)
-- Name: cte fk_cte_municipioenvio_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_municipioenvio_id FOREIGN KEY (municipioenvio_id) REFERENCES public.municipio(id);


--
-- TOC entry 6877 (class 2606 OID 2381644)
-- Name: cte fk_cte_municipioinicio_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_municipioinicio_id FOREIGN KEY (municipioinicio_id) REFERENCES public.municipio(id);


--
-- TOC entry 6878 (class 2606 OID 2381649)
-- Name: cte fk_cte_municipiotermino_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_municipiotermino_id FOREIGN KEY (municipiotermino_id) REFERENCES public.municipio(id);


--
-- TOC entry 6879 (class 2606 OID 2381654)
-- Name: cte fk_cte_recebedor_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_recebedor_id FOREIGN KEY (recebedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6880 (class 2606 OID 2381659)
-- Name: cte fk_cte_remetente_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_remetente_id FOREIGN KEY (remetente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6881 (class 2606 OID 2381664)
-- Name: cte fk_cte_tomador_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_tomador_id FOREIGN KEY (tomador_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6882 (class 2606 OID 2381669)
-- Name: cte fk_cte_usuario_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 6883 (class 2606 OID 2381674)
-- Name: cte fk_cte_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 6884 (class 2606 OID 2381679)
-- Name: cte fk_cte_usuariocadastro_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.cte
    ADD CONSTRAINT fk_cte_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 6885 (class 2606 OID 2381684)
-- Name: ctecomplementado fk_ctecomplementado_empresa_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ctecomplementado
    ADD CONSTRAINT fk_ctecomplementado_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 6886 (class 2606 OID 2381689)
-- Name: documentoanterior fk_documentoanterior_cte_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.documentoanterior
    ADD CONSTRAINT fk_documentoanterior_cte_id FOREIGN KEY (cte_id) REFERENCES cte.cte(id);


--
-- TOC entry 6887 (class 2606 OID 2381694)
-- Name: documentoanterioreletronico fk_documentoanterioreletronico_identificacaodocanterior_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.documentoanterioreletronico
    ADD CONSTRAINT fk_documentoanterioreletronico_identificacaodocanterior_id FOREIGN KEY (identificacaodocanterior_id) REFERENCES cte.identificacaodocanterior(id);


--
-- TOC entry 6888 (class 2606 OID 2381699)
-- Name: documentoanteriorpapel fk_documentoanteriorpapel_identificacaodocanterior_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.documentoanteriorpapel
    ADD CONSTRAINT fk_documentoanteriorpapel_identificacaodocanterior_id FOREIGN KEY (identificacaodocanterior_id) REFERENCES cte.identificacaodocanterior(id);


--
-- TOC entry 6889 (class 2606 OID 2381704)
-- Name: emissordocumentoanterior fk_emissordocumentoanterior_clientefornecedor_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.emissordocumentoanterior
    ADD CONSTRAINT fk_emissordocumentoanterior_clientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6890 (class 2606 OID 2381709)
-- Name: emissordocumentoanterior fk_emissordocumentoanterior_documentoanterior_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.emissordocumentoanterior
    ADD CONSTRAINT fk_emissordocumentoanterior_documentoanterior_id FOREIGN KEY (documentoanterior_id) REFERENCES cte.documentoanterior(id);


--
-- TOC entry 6891 (class 2606 OID 2381714)
-- Name: formapagamentocte fk_formapagamentocte_cte_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.formapagamentocte
    ADD CONSTRAINT fk_formapagamentocte_cte_id FOREIGN KEY (cte_id) REFERENCES cte.cte(id);


--
-- TOC entry 6892 (class 2606 OID 2381719)
-- Name: formapagamentocte fk_formapagamentocte_maquinacartao_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.formapagamentocte
    ADD CONSTRAINT fk_formapagamentocte_maquinacartao_id FOREIGN KEY (maquinacartao_id) REFERENCES public.maquinacartao(id);


--
-- TOC entry 6893 (class 2606 OID 2381724)
-- Name: formapagamentocte fk_formapagamentocte_moedaestrangeira_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.formapagamentocte
    ADD CONSTRAINT fk_formapagamentocte_moedaestrangeira_id FOREIGN KEY (moedaestrangeira_id) REFERENCES public.moeda(id);


--
-- TOC entry 6894 (class 2606 OID 2381729)
-- Name: formapagamentocte fk_formapagamentocte_movimentacaocreditosaida_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.formapagamentocte
    ADD CONSTRAINT fk_formapagamentocte_movimentacaocreditosaida_id FOREIGN KEY (movimentacaocreditosaida_id) REFERENCES public.movimentacaocreditosaida(id);


--
-- TOC entry 6895 (class 2606 OID 2381734)
-- Name: formapagamentocte fk_formapagamentocte_vale_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.formapagamentocte
    ADD CONSTRAINT fk_formapagamentocte_vale_id FOREIGN KEY (vale_id) REFERENCES public.movimentacaocreditoentrada(id);


--
-- TOC entry 6896 (class 2606 OID 2381739)
-- Name: historico_veiculo fk_historico_veiculo_empresa_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.historico_veiculo
    ADD CONSTRAINT fk_historico_veiculo_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 6897 (class 2606 OID 2381744)
-- Name: historico_veiculo fk_historico_veiculo_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.historico_veiculo
    ADD CONSTRAINT fk_historico_veiculo_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 6898 (class 2606 OID 2381749)
-- Name: historico_veiculo fk_historico_veiculo_usuariocadastro_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.historico_veiculo
    ADD CONSTRAINT fk_historico_veiculo_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 6899 (class 2606 OID 2381754)
-- Name: historico_veiculo fk_historico_veiculo_veiculo_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.historico_veiculo
    ADD CONSTRAINT fk_historico_veiculo_veiculo_id FOREIGN KEY (veiculo_id) REFERENCES cte.veiculo(id);


--
-- TOC entry 6900 (class 2606 OID 2381759)
-- Name: identificacaodocanterior fk_identificacaodocanterior_emissordocumentoanterior_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.identificacaodocanterior
    ADD CONSTRAINT fk_identificacaodocanterior_emissordocumentoanterior_id FOREIGN KEY (emissordocumentoanterior_id) REFERENCES cte.emissordocumentoanterior(id);


--
-- TOC entry 6901 (class 2606 OID 2381764)
-- Name: informacaocorrecao fk_informacaocorrecao_cartacorrecao_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.informacaocorrecao
    ADD CONSTRAINT fk_informacaocorrecao_cartacorrecao_id FOREIGN KEY (cartacorrecao_id) REFERENCES cte.cartacorrecaocte(id);


--
-- TOC entry 6902 (class 2606 OID 2381769)
-- Name: itemservico fk_itemservico_cte_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.itemservico
    ADD CONSTRAINT fk_itemservico_cte_id FOREIGN KEY (cte_id) REFERENCES cte.cte(id);


--
-- TOC entry 6903 (class 2606 OID 2381774)
-- Name: itemservicolist fk_itemservicolist_empresa_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.itemservicolist
    ADD CONSTRAINT fk_itemservicolist_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 6904 (class 2606 OID 2381779)
-- Name: lacre fk_lacre_modalrodo_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.lacre
    ADD CONSTRAINT fk_lacre_modalrodo_id FOREIGN KEY (modalrodo_id) REFERENCES cte.modalrodoviario(id);


--
-- TOC entry 6905 (class 2606 OID 2381784)
-- Name: motorista fk_motorista_empresa_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.motorista
    ADD CONSTRAINT fk_motorista_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 6906 (class 2606 OID 2381789)
-- Name: motorista fk_motorista_municipio_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.motorista
    ADD CONSTRAINT fk_motorista_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 6907 (class 2606 OID 2381794)
-- Name: motorista fk_motorista_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.motorista
    ADD CONSTRAINT fk_motorista_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 6908 (class 2606 OID 2381799)
-- Name: motorista fk_motorista_usuariocadastro_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.motorista
    ADD CONSTRAINT fk_motorista_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 6909 (class 2606 OID 2381804)
-- Name: notafiscalcte fk_notafiscalcte_cte_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.notafiscalcte
    ADD CONSTRAINT fk_notafiscalcte_cte_id FOREIGN KEY (cte_id) REFERENCES cte.cte(id);


--
-- TOC entry 6910 (class 2606 OID 2381809)
-- Name: notaprodutorcte fk_notaprodutorcte_cfop_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.notaprodutorcte
    ADD CONSTRAINT fk_notaprodutorcte_cfop_id FOREIGN KEY (cfop_id) REFERENCES public.cfop(id);


--
-- TOC entry 6911 (class 2606 OID 2381814)
-- Name: notaprodutorcte fk_notaprodutorcte_cte_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.notaprodutorcte
    ADD CONSTRAINT fk_notaprodutorcte_cte_id FOREIGN KEY (cte_id) REFERENCES cte.cte(id);


--
-- TOC entry 6912 (class 2606 OID 2381819)
-- Name: notaprodutorcte fk_notaprodutorcte_empresa_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.notaprodutorcte
    ADD CONSTRAINT fk_notaprodutorcte_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 6913 (class 2606 OID 2381824)
-- Name: obscontribuintecte fk_obscontribuintecte_cte_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.obscontribuintecte
    ADD CONSTRAINT fk_obscontribuintecte_cte_id FOREIGN KEY (cte_id) REFERENCES cte.cte(id);


--
-- TOC entry 6914 (class 2606 OID 2381829)
-- Name: obsfiscocte fk_obsfiscocte_cte_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.obsfiscocte
    ADD CONSTRAINT fk_obsfiscocte_cte_id FOREIGN KEY (cte_id) REFERENCES cte.cte(id);


--
-- TOC entry 6915 (class 2606 OID 2381834)
-- Name: ordemcoleta fk_ordemcoleta_destinatario_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoleta
    ADD CONSTRAINT fk_ordemcoleta_destinatario_id FOREIGN KEY (destinatario_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6916 (class 2606 OID 2381839)
-- Name: ordemcoleta fk_ordemcoleta_empresa_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoleta
    ADD CONSTRAINT fk_ordemcoleta_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 6917 (class 2606 OID 2381844)
-- Name: ordemcoleta fk_ordemcoleta_enderecodestinatario_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoleta
    ADD CONSTRAINT fk_ordemcoleta_enderecodestinatario_id FOREIGN KEY (enderecodestinatario_id) REFERENCES public.endereco(id);


--
-- TOC entry 6918 (class 2606 OID 2381849)
-- Name: ordemcoleta fk_ordemcoleta_enderecoremetente_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoleta
    ADD CONSTRAINT fk_ordemcoleta_enderecoremetente_id FOREIGN KEY (enderecoremetente_id) REFERENCES public.endereco(id);


--
-- TOC entry 6919 (class 2606 OID 2381854)
-- Name: ordemcoleta fk_ordemcoleta_motorista_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoleta
    ADD CONSTRAINT fk_ordemcoleta_motorista_id FOREIGN KEY (motorista_id) REFERENCES cte.motorista(id);


--
-- TOC entry 6920 (class 2606 OID 2381859)
-- Name: ordemcoleta fk_ordemcoleta_proprietario_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoleta
    ADD CONSTRAINT fk_ordemcoleta_proprietario_id FOREIGN KEY (proprietario_id) REFERENCES cte.terceiro(id);


--
-- TOC entry 6921 (class 2606 OID 2381864)
-- Name: ordemcoleta fk_ordemcoleta_remetente_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoleta
    ADD CONSTRAINT fk_ordemcoleta_remetente_id FOREIGN KEY (remetente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6922 (class 2606 OID 2381869)
-- Name: ordemcoleta fk_ordemcoleta_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoleta
    ADD CONSTRAINT fk_ordemcoleta_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 6923 (class 2606 OID 2381874)
-- Name: ordemcoleta fk_ordemcoleta_usuariocadastro_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoleta
    ADD CONSTRAINT fk_ordemcoleta_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 6924 (class 2606 OID 2381879)
-- Name: ordemcoleta fk_ordemcoleta_veiculo_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoleta
    ADD CONSTRAINT fk_ordemcoleta_veiculo_id FOREIGN KEY (veiculo_id) REFERENCES cte.veiculo(id);


--
-- TOC entry 6925 (class 2606 OID 2381884)
-- Name: ordemcoletacte fk_ordemcoletacte_modalrodo_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoletacte
    ADD CONSTRAINT fk_ordemcoletacte_modalrodo_id FOREIGN KEY (modalrodo_id) REFERENCES cte.modalrodoviario(id);


--
-- TOC entry 6926 (class 2606 OID 2381889)
-- Name: ordemcoletacte fk_ordemcoletacte_uf_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.ordemcoletacte
    ADD CONSTRAINT fk_ordemcoletacte_uf_id FOREIGN KEY (uf_id) REFERENCES public.estado(id);


--
-- TOC entry 6927 (class 2606 OID 2381894)
-- Name: outrodocumento fk_outrodocumento_cte_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.outrodocumento
    ADD CONSTRAINT fk_outrodocumento_cte_id FOREIGN KEY (cte_id) REFERENCES cte.cte(id);


--
-- TOC entry 6928 (class 2606 OID 2381899)
-- Name: quantidadecarga fk_quantidadecarga_cte_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.quantidadecarga
    ADD CONSTRAINT fk_quantidadecarga_cte_id FOREIGN KEY (cte_id) REFERENCES cte.cte(id);


--
-- TOC entry 6929 (class 2606 OID 2381904)
-- Name: seguro fk_seguro_cte_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.seguro
    ADD CONSTRAINT fk_seguro_cte_id FOREIGN KEY (cte_id) REFERENCES cte.cte(id);


--
-- TOC entry 6930 (class 2606 OID 2381909)
-- Name: terceiro fk_terceiro_empresa_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.terceiro
    ADD CONSTRAINT fk_terceiro_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 6931 (class 2606 OID 2381914)
-- Name: terceiro fk_terceiro_municipio_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.terceiro
    ADD CONSTRAINT fk_terceiro_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 6932 (class 2606 OID 2381919)
-- Name: terceiro fk_terceiro_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.terceiro
    ADD CONSTRAINT fk_terceiro_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 6933 (class 2606 OID 2381924)
-- Name: tipomedidacte fk_tipomedidacte_empresa_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.tipomedidacte
    ADD CONSTRAINT fk_tipomedidacte_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 6934 (class 2606 OID 2381929)
-- Name: veiculo fk_veiculo_empresa_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.veiculo
    ADD CONSTRAINT fk_veiculo_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 6935 (class 2606 OID 2381934)
-- Name: veiculo fk_veiculo_municipio_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.veiculo
    ADD CONSTRAINT fk_veiculo_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 6936 (class 2606 OID 2381939)
-- Name: veiculo fk_veiculo_proprietario_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.veiculo
    ADD CONSTRAINT fk_veiculo_proprietario_id FOREIGN KEY (proprietario_id) REFERENCES cte.terceiro(id);


--
-- TOC entry 6937 (class 2606 OID 2381944)
-- Name: volumeordemcoleta fk_volumeordemcoleta_ordemcoleta_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--

ALTER TABLE ONLY cte.volumeordemcoleta
    ADD CONSTRAINT fk_volumeordemcoleta_ordemcoleta_id FOREIGN KEY (ordemcoleta_id) REFERENCES cte.ordemcoleta(id);


--
-- TOC entry 6938 (class 2606 OID 2381949)
-- Name: auxiliarvenda fk_auxiliarvenda_clientefornecedor_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.auxiliarvenda
    ADD CONSTRAINT fk_auxiliarvenda_clientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6939 (class 2606 OID 2381954)
-- Name: auxiliarvenda fk_auxiliarvenda_consignacaodevolucao_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.auxiliarvenda
    ADD CONSTRAINT fk_auxiliarvenda_consignacaodevolucao_id FOREIGN KEY (consignacaodevolucao_id) REFERENCES ecf.consignacaodevolucao(id);


--
-- TOC entry 6940 (class 2606 OID 2381959)
-- Name: auxiliarvenda fk_auxiliarvenda_dependente_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.auxiliarvenda
    ADD CONSTRAINT fk_auxiliarvenda_dependente_id FOREIGN KEY (dependente_id) REFERENCES public.dependente(id);


--
-- TOC entry 6941 (class 2606 OID 2381964)
-- Name: auxiliarvenda fk_auxiliarvenda_empresa_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.auxiliarvenda
    ADD CONSTRAINT fk_auxiliarvenda_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 6942 (class 2606 OID 2381969)
-- Name: auxiliarvenda fk_auxiliarvenda_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.auxiliarvenda
    ADD CONSTRAINT fk_auxiliarvenda_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 6943 (class 2606 OID 2381974)
-- Name: auxiliarvenda fk_auxiliarvenda_usuariocadastro_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.auxiliarvenda
    ADD CONSTRAINT fk_auxiliarvenda_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 6944 (class 2606 OID 2381979)
-- Name: auxiliarvenda fk_auxiliarvenda_vendedor_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.auxiliarvenda
    ADD CONSTRAINT fk_auxiliarvenda_vendedor_id FOREIGN KEY (vendedor_id) REFERENCES public.funcionario(id);


--
-- TOC entry 6945 (class 2606 OID 2381984)
-- Name: consignacao fk_consignacao_cliente_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.consignacao
    ADD CONSTRAINT fk_consignacao_cliente_id FOREIGN KEY (cliente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6946 (class 2606 OID 2381989)
-- Name: consignacao fk_consignacao_tabelapreco_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.consignacao
    ADD CONSTRAINT fk_consignacao_tabelapreco_id FOREIGN KEY (tabelapreco_id) REFERENCES public.tabelapreco(id);


--
-- TOC entry 6947 (class 2606 OID 2381994)
-- Name: consignacao fk_consignacao_usuario_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.consignacao
    ADD CONSTRAINT fk_consignacao_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 6948 (class 2606 OID 2381999)
-- Name: consignacaodevolucao fk_consignacaodevolucao_consignacao_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.consignacaodevolucao
    ADD CONSTRAINT fk_consignacaodevolucao_consignacao_id FOREIGN KEY (consignacao_id) REFERENCES ecf.consignacao(id);


--
-- TOC entry 6949 (class 2606 OID 2382004)
-- Name: consignacaodevolucao fk_consignacaodevolucao_usuario_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.consignacaodevolucao
    ADD CONSTRAINT fk_consignacaodevolucao_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 6950 (class 2606 OID 2382009)
-- Name: cupomfiscal fk_cupomfiscal_destinatario_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.cupomfiscal
    ADD CONSTRAINT fk_cupomfiscal_destinatario_id FOREIGN KEY (destinatario_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6951 (class 2606 OID 2382014)
-- Name: cupomfiscal fk_cupomfiscal_emitente_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.cupomfiscal
    ADD CONSTRAINT fk_cupomfiscal_emitente_id FOREIGN KEY (emitente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6952 (class 2606 OID 2382019)
-- Name: cupomfiscal fk_cupomfiscal_empresa_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.cupomfiscal
    ADD CONSTRAINT fk_cupomfiscal_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 6953 (class 2606 OID 2382024)
-- Name: cupomfiscal fk_cupomfiscal_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.cupomfiscal
    ADD CONSTRAINT fk_cupomfiscal_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 6954 (class 2606 OID 2382029)
-- Name: cupomfiscal fk_cupomfiscal_usuariocadastro_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.cupomfiscal
    ADD CONSTRAINT fk_cupomfiscal_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 6955 (class 2606 OID 2382034)
-- Name: cupomfiscal fk_cupomfiscal_vendedor_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.cupomfiscal
    ADD CONSTRAINT fk_cupomfiscal_vendedor_id FOREIGN KEY (vendedor_id) REFERENCES public.funcionario(id);


--
-- TOC entry 6956 (class 2606 OID 2382039)
-- Name: duplicatarecebida fk_duplicatarecebida_duplicata_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.duplicatarecebida
    ADD CONSTRAINT fk_duplicatarecebida_duplicata_id FOREIGN KEY (duplicata_id) REFERENCES ecf.duplicata(id);


--
-- TOC entry 6957 (class 2606 OID 2382044)
-- Name: formapagamentoauxiliarvenda fk_formapagamentoauxiliarvenda_auxiliarvenda_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentoauxiliarvenda
    ADD CONSTRAINT fk_formapagamentoauxiliarvenda_auxiliarvenda_id FOREIGN KEY (auxiliarvenda_id) REFERENCES ecf.auxiliarvenda(id);


--
-- TOC entry 6958 (class 2606 OID 2382049)
-- Name: formapagamentoauxiliarvenda fk_formapagamentoauxiliarvenda_maquinacartao_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentoauxiliarvenda
    ADD CONSTRAINT fk_formapagamentoauxiliarvenda_maquinacartao_id FOREIGN KEY (maquinacartao_id) REFERENCES public.maquinacartao(id);


--
-- TOC entry 6959 (class 2606 OID 2382054)
-- Name: formapagamentoauxiliarvenda fk_formapagamentoauxiliarvenda_moedaestrangeira_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentoauxiliarvenda
    ADD CONSTRAINT fk_formapagamentoauxiliarvenda_moedaestrangeira_id FOREIGN KEY (moedaestrangeira_id) REFERENCES public.moeda(id);


--
-- TOC entry 6960 (class 2606 OID 2382059)
-- Name: formapagamentoauxiliarvenda fk_formapagamentoauxiliarvenda_movimentacaocreditosaida_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentoauxiliarvenda
    ADD CONSTRAINT fk_formapagamentoauxiliarvenda_movimentacaocreditosaida_id FOREIGN KEY (movimentacaocreditosaida_id) REFERENCES public.movimentacaocreditosaida(id);


--
-- TOC entry 6961 (class 2606 OID 2382064)
-- Name: formapagamentoauxiliarvenda fk_formapagamentoauxiliarvenda_vale_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentoauxiliarvenda
    ADD CONSTRAINT fk_formapagamentoauxiliarvenda_vale_id FOREIGN KEY (vale_id) REFERENCES public.movimentacaocreditoentrada(id);


--
-- TOC entry 6962 (class 2606 OID 2382069)
-- Name: formapagamentocreditocliente fk_formapagamentocreditocliente_maquinacartao_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentocreditocliente
    ADD CONSTRAINT fk_formapagamentocreditocliente_maquinacartao_id FOREIGN KEY (maquinacartao_id) REFERENCES public.maquinacartao(id);


--
-- TOC entry 6963 (class 2606 OID 2382074)
-- Name: formapagamentocreditocliente fk_formapagamentocreditocliente_movcredito_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentocreditocliente
    ADD CONSTRAINT fk_formapagamentocreditocliente_movcredito_id FOREIGN KEY (movcredito_id) REFERENCES public.movimentacaocreditoentrada(id);


--
-- TOC entry 6964 (class 2606 OID 2382079)
-- Name: formapagamentocupomfiscal fk_formapagamentocupomfiscal_cupomfiscal_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentocupomfiscal
    ADD CONSTRAINT fk_formapagamentocupomfiscal_cupomfiscal_id FOREIGN KEY (cupomfiscal_id) REFERENCES ecf.cupomfiscal(id);


--
-- TOC entry 6965 (class 2606 OID 2382084)
-- Name: formapagamentocupomfiscal fk_formapagamentocupomfiscal_maquinacartao_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentocupomfiscal
    ADD CONSTRAINT fk_formapagamentocupomfiscal_maquinacartao_id FOREIGN KEY (maquinacartao_id) REFERENCES public.maquinacartao(id);


--
-- TOC entry 6966 (class 2606 OID 2382089)
-- Name: formapagamentocupomfiscal fk_formapagamentocupomfiscal_moedaestrangeira_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentocupomfiscal
    ADD CONSTRAINT fk_formapagamentocupomfiscal_moedaestrangeira_id FOREIGN KEY (moedaestrangeira_id) REFERENCES public.moeda(id);


--
-- TOC entry 6967 (class 2606 OID 2382094)
-- Name: formapagamentocupomfiscal fk_formapagamentocupomfiscal_movimentacaocreditosaida_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentocupomfiscal
    ADD CONSTRAINT fk_formapagamentocupomfiscal_movimentacaocreditosaida_id FOREIGN KEY (movimentacaocreditosaida_id) REFERENCES public.movimentacaocreditosaida(id);


--
-- TOC entry 6968 (class 2606 OID 2382099)
-- Name: formapagamentocupomfiscal fk_formapagamentocupomfiscal_vale_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.formapagamentocupomfiscal
    ADD CONSTRAINT fk_formapagamentocupomfiscal_vale_id FOREIGN KEY (vale_id) REFERENCES public.movimentacaocreditoentrada(id);


--
-- TOC entry 6969 (class 2606 OID 2382104)
-- Name: itemconsignacao fk_itemconsignacao_consignacao_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemconsignacao
    ADD CONSTRAINT fk_itemconsignacao_consignacao_id FOREIGN KEY (consignacao_id) REFERENCES ecf.consignacao(id);


--
-- TOC entry 6970 (class 2606 OID 2382109)
-- Name: itemconsignacao fk_itemconsignacao_produto_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemconsignacao
    ADD CONSTRAINT fk_itemconsignacao_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 6971 (class 2606 OID 2382114)
-- Name: itemconsignacaodevolucao fk_itemconsignacaodevolucao_consignacaodevolucao_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemconsignacaodevolucao
    ADD CONSTRAINT fk_itemconsignacaodevolucao_consignacaodevolucao_id FOREIGN KEY (consignacaodevolucao_id) REFERENCES ecf.consignacaodevolucao(id);


--
-- TOC entry 6972 (class 2606 OID 2382119)
-- Name: itemconsignacaodevolucao fk_itemconsignacaodevolucao_item_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemconsignacaodevolucao
    ADD CONSTRAINT fk_itemconsignacaodevolucao_item_id FOREIGN KEY (item_id) REFERENCES ecf.itemconsignacao(id);


--
-- TOC entry 6973 (class 2606 OID 2382124)
-- Name: itemcupomfiscal fk_itemcupomfiscal_cfop_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemcupomfiscal
    ADD CONSTRAINT fk_itemcupomfiscal_cfop_id FOREIGN KEY (cfop_id) REFERENCES public.cfop(id);


--
-- TOC entry 6974 (class 2606 OID 2382129)
-- Name: itemcupomfiscal fk_itemcupomfiscal_csticms_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemcupomfiscal
    ADD CONSTRAINT fk_itemcupomfiscal_csticms_id FOREIGN KEY (csticms_id) REFERENCES public.cst(id);


--
-- TOC entry 6975 (class 2606 OID 2382134)
-- Name: itemcupomfiscal fk_itemcupomfiscal_cstpiscofins_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemcupomfiscal
    ADD CONSTRAINT fk_itemcupomfiscal_cstpiscofins_id FOREIGN KEY (cstpiscofins_id) REFERENCES public.cst(id);


--
-- TOC entry 6976 (class 2606 OID 2382139)
-- Name: itemcupomfiscal fk_itemcupomfiscal_cupomfiscal_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemcupomfiscal
    ADD CONSTRAINT fk_itemcupomfiscal_cupomfiscal_id FOREIGN KEY (cupomfiscal_id) REFERENCES ecf.cupomfiscal(id);


--
-- TOC entry 6977 (class 2606 OID 2382144)
-- Name: itemcupomfiscal fk_itemcupomfiscal_produto_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemcupomfiscal
    ADD CONSTRAINT fk_itemcupomfiscal_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 6978 (class 2606 OID 2382149)
-- Name: itemcupomfiscal fk_itemcupomfiscal_tipoitem_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemcupomfiscal
    ADD CONSTRAINT fk_itemcupomfiscal_tipoitem_id FOREIGN KEY (tipoitem_id) REFERENCES public.tipoitem(id);


--
-- TOC entry 6979 (class 2606 OID 2382154)
-- Name: itemusoconsumo fk_itemusoconsumo_ordemservico_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemusoconsumo
    ADD CONSTRAINT fk_itemusoconsumo_ordemservico_id FOREIGN KEY (ordemservico_id) REFERENCES public.ordemservico(id);


--
-- TOC entry 6980 (class 2606 OID 2382159)
-- Name: itemusoconsumo fk_itemusoconsumo_produto_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.itemusoconsumo
    ADD CONSTRAINT fk_itemusoconsumo_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 6981 (class 2606 OID 2382164)
-- Name: produtoauxiliarvenda fk_produtoauxiliarvenda_auxiliarvenda_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.produtoauxiliarvenda
    ADD CONSTRAINT fk_produtoauxiliarvenda_auxiliarvenda_id FOREIGN KEY (auxiliarvenda_id) REFERENCES ecf.auxiliarvenda(id);


--
-- TOC entry 6982 (class 2606 OID 2382169)
-- Name: produtoauxiliarvenda fk_produtoauxiliarvenda_produto_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.produtoauxiliarvenda
    ADD CONSTRAINT fk_produtoauxiliarvenda_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 6983 (class 2606 OID 2382174)
-- Name: satfiscal fk_satfiscal_empresa_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.satfiscal
    ADD CONSTRAINT fk_satfiscal_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 6984 (class 2606 OID 2382179)
-- Name: satfiscal fk_satfiscal_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.satfiscal
    ADD CONSTRAINT fk_satfiscal_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 6985 (class 2606 OID 2382184)
-- Name: satfiscal fk_satfiscal_usuariocadastro_id; Type: FK CONSTRAINT; Schema: ecf; Owner: postgres
--

ALTER TABLE ONLY ecf.satfiscal
    ADD CONSTRAINT fk_satfiscal_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 6986 (class 2606 OID 2382189)
-- Name: autorizacaoxml fk_autorizacaoxml_manifesto_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.autorizacaoxml
    ADD CONSTRAINT fk_autorizacaoxml_manifesto_id FOREIGN KEY (manifesto_id) REFERENCES manifesto.manifesto(id);


--
-- TOC entry 6987 (class 2606 OID 2382194)
-- Name: averbacaoseguromdfe fk_averbacaoseguromdfe_seguromdfe_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.averbacaoseguromdfe
    ADD CONSTRAINT fk_averbacaoseguromdfe_seguromdfe_id FOREIGN KEY (seguromdfe_id) REFERENCES manifesto.seguromdfe(id);


--
-- TOC entry 6988 (class 2606 OID 2382199)
-- Name: documentofiscalmanifesto fk_documentofiscalmanifesto_municipiodescarregamento_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.documentofiscalmanifesto
    ADD CONSTRAINT fk_documentofiscalmanifesto_municipiodescarregamento_id FOREIGN KEY (municipiodescarregamento_id) REFERENCES manifesto.municipiodescarregamento(id);


--
-- TOC entry 6989 (class 2606 OID 2382204)
-- Name: documentosfiscais fk_documentosfiscais_manifesto_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.documentosfiscais
    ADD CONSTRAINT fk_documentosfiscais_manifesto_id FOREIGN KEY (manifesto_id) REFERENCES manifesto.manifesto(id);


--
-- TOC entry 6990 (class 2606 OID 2382209)
-- Name: embarcacaocomboio fk_embarcacaocomboio_modalaquaviario_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.embarcacaocomboio
    ADD CONSTRAINT fk_embarcacaocomboio_modalaquaviario_id FOREIGN KEY (modalaquaviario_id) REFERENCES manifesto.modalaquaviario(id);


--
-- TOC entry 6991 (class 2606 OID 2382214)
-- Name: informacoesciotmdfe fk_informacoesciotmdfe_modalrodoviariomdfe_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.informacoesciotmdfe
    ADD CONSTRAINT fk_informacoesciotmdfe_modalrodoviariomdfe_id FOREIGN KEY (modalrodoviariomdfe_id) REFERENCES manifesto.modalrodoviariomdfe(id);


--
-- TOC entry 6992 (class 2606 OID 2382219)
-- Name: informacoescontratantemdfe fk_informacoescontratantemdfe_modalrodoviariomdfe_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.informacoescontratantemdfe
    ADD CONSTRAINT fk_informacoescontratantemdfe_modalrodoviariomdfe_id FOREIGN KEY (modalrodoviariomdfe_id) REFERENCES manifesto.modalrodoviariomdfe(id);


--
-- TOC entry 6993 (class 2606 OID 2382224)
-- Name: informacoesseguradoramdfe fk_informacoesseguradoramdfe_seguradora_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.informacoesseguradoramdfe
    ADD CONSTRAINT fk_informacoesseguradoramdfe_seguradora_id FOREIGN KEY (seguradora_id) REFERENCES public.seguradora(id);


--
-- TOC entry 6994 (class 2606 OID 2382229)
-- Name: informacoesseguradoramdfe fk_informacoesseguradoramdfe_seguromdfe_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.informacoesseguradoramdfe
    ADD CONSTRAINT fk_informacoesseguradoramdfe_seguromdfe_id FOREIGN KEY (seguromdfe_id) REFERENCES manifesto.seguromdfe(id);


--
-- TOC entry 6995 (class 2606 OID 2382234)
-- Name: lacresmdfe fk_lacresmdfe_manifesto_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.lacresmdfe
    ADD CONSTRAINT fk_lacresmdfe_manifesto_id FOREIGN KEY (manifesto_id) REFERENCES manifesto.manifesto(id);


--
-- TOC entry 6996 (class 2606 OID 2382239)
-- Name: lacresunidadecarga fk_lacresunidadecarga_unidadecarga_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.lacresunidadecarga
    ADD CONSTRAINT fk_lacresunidadecarga_unidadecarga_id FOREIGN KEY (unidadecarga_id) REFERENCES manifesto.unidadecarga(id);


--
-- TOC entry 6997 (class 2606 OID 2382244)
-- Name: lacresunidadetransporte fk_lacresunidadetransporte_unidadetransporte_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.lacresunidadetransporte
    ADD CONSTRAINT fk_lacresunidadetransporte_unidadetransporte_id FOREIGN KEY (unidadetransporte_id) REFERENCES manifesto.unidadetransporte(id);


--
-- TOC entry 6998 (class 2606 OID 2382249)
-- Name: manifesto fk_manifesto_emitente_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.manifesto
    ADD CONSTRAINT fk_manifesto_emitente_id FOREIGN KEY (emitente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 6999 (class 2606 OID 2382254)
-- Name: manifesto fk_manifesto_empresa_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.manifesto
    ADD CONSTRAINT fk_manifesto_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7000 (class 2606 OID 2382259)
-- Name: manifesto fk_manifesto_ufcarregamento_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.manifesto
    ADD CONSTRAINT fk_manifesto_ufcarregamento_id FOREIGN KEY (ufcarregamento_id) REFERENCES public.estado(id);


--
-- TOC entry 7001 (class 2606 OID 2382264)
-- Name: manifesto fk_manifesto_ufdescarregamento_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.manifesto
    ADD CONSTRAINT fk_manifesto_ufdescarregamento_id FOREIGN KEY (ufdescarregamento_id) REFERENCES public.estado(id);


--
-- TOC entry 7002 (class 2606 OID 2382269)
-- Name: manifesto fk_manifesto_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.manifesto
    ADD CONSTRAINT fk_manifesto_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7003 (class 2606 OID 2382274)
-- Name: manifesto fk_manifesto_usuariocadastro_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.manifesto
    ADD CONSTRAINT fk_manifesto_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7004 (class 2606 OID 2382279)
-- Name: modalaereo fk_modalaereo_manifesto_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.modalaereo
    ADD CONSTRAINT fk_modalaereo_manifesto_id FOREIGN KEY (manifesto_id) REFERENCES manifesto.manifesto(id);


--
-- TOC entry 7005 (class 2606 OID 2382284)
-- Name: modalaquaviario fk_modalaquaviario_manifesto_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.modalaquaviario
    ADD CONSTRAINT fk_modalaquaviario_manifesto_id FOREIGN KEY (manifesto_id) REFERENCES manifesto.manifesto(id);


--
-- TOC entry 7006 (class 2606 OID 2382289)
-- Name: modalferroviario fk_modalferroviario_manifesto_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.modalferroviario
    ADD CONSTRAINT fk_modalferroviario_manifesto_id FOREIGN KEY (manifesto_id) REFERENCES manifesto.manifesto(id);


--
-- TOC entry 7007 (class 2606 OID 2382294)
-- Name: modalrodoviariomdfe fk_modalrodoviariomdfe_manifesto_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.modalrodoviariomdfe
    ADD CONSTRAINT fk_modalrodoviariomdfe_manifesto_id FOREIGN KEY (manifesto_id) REFERENCES manifesto.manifesto(id);


--
-- TOC entry 7008 (class 2606 OID 2382299)
-- Name: modalrodoviariomdfe fk_modalrodoviariomdfe_veiculotracao_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.modalrodoviariomdfe
    ADD CONSTRAINT fk_modalrodoviariomdfe_veiculotracao_id FOREIGN KEY (veiculotracao_id) REFERENCES cte.veiculo(id);


--
-- TOC entry 7009 (class 2606 OID 2382304)
-- Name: municipiocarregamento fk_municipiocarregamento_manifesto_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.municipiocarregamento
    ADD CONSTRAINT fk_municipiocarregamento_manifesto_id FOREIGN KEY (manifesto_id) REFERENCES manifesto.manifesto(id);


--
-- TOC entry 7010 (class 2606 OID 2382309)
-- Name: municipiocarregamento fk_municipiocarregamento_municipio_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.municipiocarregamento
    ADD CONSTRAINT fk_municipiocarregamento_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 7011 (class 2606 OID 2382314)
-- Name: municipiodescarregamento fk_municipiodescarregamento_documentosfiscais_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.municipiodescarregamento
    ADD CONSTRAINT fk_municipiodescarregamento_documentosfiscais_id FOREIGN KEY (documentosfiscais_id) REFERENCES manifesto.documentosfiscais(id);


--
-- TOC entry 7012 (class 2606 OID 2382319)
-- Name: municipiodescarregamento fk_municipiodescarregamento_municipio_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.municipiodescarregamento
    ADD CONSTRAINT fk_municipiodescarregamento_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 7013 (class 2606 OID 2382324)
-- Name: percursomanifesto fk_percursomanifesto_estadopercorrido_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.percursomanifesto
    ADD CONSTRAINT fk_percursomanifesto_estadopercorrido_id FOREIGN KEY (estadopercorrido_id) REFERENCES public.estado(id);


--
-- TOC entry 7014 (class 2606 OID 2382329)
-- Name: percursomanifesto fk_percursomanifesto_manifesto_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.percursomanifesto
    ADD CONSTRAINT fk_percursomanifesto_manifesto_id FOREIGN KEY (manifesto_id) REFERENCES manifesto.manifesto(id);


--
-- TOC entry 7015 (class 2606 OID 2382334)
-- Name: seguromdfe fk_seguromdfe_manifesto_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.seguromdfe
    ADD CONSTRAINT fk_seguromdfe_manifesto_id FOREIGN KEY (manifesto_id) REFERENCES manifesto.manifesto(id);


--
-- TOC entry 7016 (class 2606 OID 2382339)
-- Name: terminalcarregamento fk_terminalcarregamento_modalaquaviario_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.terminalcarregamento
    ADD CONSTRAINT fk_terminalcarregamento_modalaquaviario_id FOREIGN KEY (modalaquaviario_id) REFERENCES manifesto.modalaquaviario(id);


--
-- TOC entry 7017 (class 2606 OID 2382344)
-- Name: terminaldescarregamento fk_terminaldescarregamento_modalaquaviario_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.terminaldescarregamento
    ADD CONSTRAINT fk_terminaldescarregamento_modalaquaviario_id FOREIGN KEY (modalaquaviario_id) REFERENCES manifesto.modalaquaviario(id);


--
-- TOC entry 7018 (class 2606 OID 2382349)
-- Name: unidadecarga fk_unidadecarga_unidadetransporte_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.unidadecarga
    ADD CONSTRAINT fk_unidadecarga_unidadetransporte_id FOREIGN KEY (unidadetransporte_id) REFERENCES manifesto.unidadetransporte(id);


--
-- TOC entry 7019 (class 2606 OID 2382354)
-- Name: unidadecargaaquaviario fk_unidadecargaaquaviario_modalaquaviario_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.unidadecargaaquaviario
    ADD CONSTRAINT fk_unidadecargaaquaviario_modalaquaviario_id FOREIGN KEY (modalaquaviario_id) REFERENCES manifesto.modalaquaviario(id);


--
-- TOC entry 7020 (class 2606 OID 2382359)
-- Name: unidadetransporte fk_unidadetransporte_documentofiscalmanifesto_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.unidadetransporte
    ADD CONSTRAINT fk_unidadetransporte_documentofiscalmanifesto_id FOREIGN KEY (documentofiscalmanifesto_id) REFERENCES manifesto.documentofiscalmanifesto(id);


--
-- TOC entry 7021 (class 2606 OID 2382364)
-- Name: vagaotrem fk_vagaotrem_modalferroviario_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.vagaotrem
    ADD CONSTRAINT fk_vagaotrem_modalferroviario_id FOREIGN KEY (modalferroviario_id) REFERENCES manifesto.modalferroviario(id);


--
-- TOC entry 7022 (class 2606 OID 2382369)
-- Name: valepedagio fk_valepedagio_modalrodoviariomdfe_id; Type: FK CONSTRAINT; Schema: manifesto; Owner: postgres
--

ALTER TABLE ONLY manifesto.valepedagio
    ADD CONSTRAINT fk_valepedagio_modalrodoviariomdfe_id FOREIGN KEY (modalrodoviariomdfe_id) REFERENCES manifesto.modalrodoviariomdfe(id);


--
-- TOC entry 7023 (class 2606 OID 2382374)
-- Name: adicao fk_adicao_declaracaoimportacao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.adicao
    ADD CONSTRAINT fk_adicao_declaracaoimportacao_id FOREIGN KEY (declaracaoimportacao_id) REFERENCES notafiscal.declaracaoimportacao(id);


--
-- TOC entry 7024 (class 2606 OID 2382379)
-- Name: auxiliarservico fk_auxiliarservico_caixaaberto_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.auxiliarservico
    ADD CONSTRAINT fk_auxiliarservico_caixaaberto_id FOREIGN KEY (caixaaberto_id) REFERENCES public.caixa(id);


--
-- TOC entry 7025 (class 2606 OID 2382384)
-- Name: auxiliarservico fk_auxiliarservico_empresa_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.auxiliarservico
    ADD CONSTRAINT fk_auxiliarservico_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7026 (class 2606 OID 2382389)
-- Name: auxiliarservico fk_auxiliarservico_funcionario_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.auxiliarservico
    ADD CONSTRAINT fk_auxiliarservico_funcionario_id FOREIGN KEY (funcionario_id) REFERENCES public.funcionario(id);


--
-- TOC entry 7027 (class 2606 OID 2382394)
-- Name: auxiliarservico fk_auxiliarservico_ordemservico_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.auxiliarservico
    ADD CONSTRAINT fk_auxiliarservico_ordemservico_id FOREIGN KEY (ordemservico_id) REFERENCES public.ordemservico(id);


--
-- TOC entry 7028 (class 2606 OID 2382399)
-- Name: auxiliarservico fk_auxiliarservico_prestador_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.auxiliarservico
    ADD CONSTRAINT fk_auxiliarservico_prestador_id FOREIGN KEY (prestador_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7029 (class 2606 OID 2382404)
-- Name: auxiliarservico fk_auxiliarservico_tomador_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.auxiliarservico
    ADD CONSTRAINT fk_auxiliarservico_tomador_id FOREIGN KEY (tomador_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7030 (class 2606 OID 2382409)
-- Name: cartacorrecao fk_cartacorrecao_serie; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.cartacorrecao
    ADD CONSTRAINT fk_cartacorrecao_serie FOREIGN KEY (serie, empresaid, ambiente, tipofaturamento, numero) REFERENCES notafiscal.notafiscal(serie, empresaid, ambiente, tipofaturamento, numero);


--
-- TOC entry 7031 (class 2606 OID 2382414)
-- Name: cartacorrecao fk_cartacorrecao_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.cartacorrecao
    ADD CONSTRAINT fk_cartacorrecao_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7032 (class 2606 OID 2382419)
-- Name: cartacorrecao fk_cartacorrecao_usuariocadastro_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.cartacorrecao
    ADD CONSTRAINT fk_cartacorrecao_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7033 (class 2606 OID 2382424)
-- Name: certificadodigital fk_certificadodigital_empresa_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.certificadodigital
    ADD CONSTRAINT fk_certificadodigital_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7034 (class 2606 OID 2382429)
-- Name: chaveacessoreferenciada fk_chaveacessoreferenciada_tipofaturamento; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.chaveacessoreferenciada
    ADD CONSTRAINT fk_chaveacessoreferenciada_tipofaturamento FOREIGN KEY (ambiente, tipofaturamento, numero, serie, empresaid) REFERENCES notafiscal.notafiscal(ambiente, tipofaturamento, numero, serie, empresaid);


--
-- TOC entry 7035 (class 2606 OID 2382434)
-- Name: custonfe fk_custonfe_empresa_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.custonfe
    ADD CONSTRAINT fk_custonfe_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7036 (class 2606 OID 2382439)
-- Name: custonfe fk_custonfe_tipofaturamento; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.custonfe
    ADD CONSTRAINT fk_custonfe_tipofaturamento FOREIGN KEY (tipofaturamento, empresaid, numero, ambiente, serie) REFERENCES notafiscal.notafiscal(tipofaturamento, empresaid, numero, ambiente, serie);


--
-- TOC entry 7037 (class 2606 OID 2382444)
-- Name: declaracaoexportacao fk_declaracaoexportacao_itemnotafiscal_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.declaracaoexportacao
    ADD CONSTRAINT fk_declaracaoexportacao_itemnotafiscal_id FOREIGN KEY (itemnotafiscal_id) REFERENCES notafiscal.itemnotafiscal(id);


--
-- TOC entry 7038 (class 2606 OID 2382449)
-- Name: declaracaoimportacao fk_declaracaoimportacao_estadodesembaraco_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.declaracaoimportacao
    ADD CONSTRAINT fk_declaracaoimportacao_estadodesembaraco_id FOREIGN KEY (estadodesembaraco_id) REFERENCES public.estado(id);


--
-- TOC entry 7039 (class 2606 OID 2382454)
-- Name: declaracaoimportacao fk_declaracaoimportacao_itemnotafiscal_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.declaracaoimportacao
    ADD CONSTRAINT fk_declaracaoimportacao_itemnotafiscal_id FOREIGN KEY (itemnotafiscal_id) REFERENCES notafiscal.itemnotafiscal(id);


--
-- TOC entry 7040 (class 2606 OID 2382459)
-- Name: duplicatanota fk_duplicatanota_empresa_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.duplicatanota
    ADD CONSTRAINT fk_duplicatanota_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7041 (class 2606 OID 2382464)
-- Name: duplicatanota fk_duplicatanota_serie; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.duplicatanota
    ADD CONSTRAINT fk_duplicatanota_serie FOREIGN KEY (serie, empresaid, ambiente, tipofaturamento, numero) REFERENCES notafiscal.notafiscal(serie, empresaid, ambiente, tipofaturamento, numero);


--
-- TOC entry 7042 (class 2606 OID 2382469)
-- Name: duplicatanota fk_duplicatanota_tipofaturamento; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.duplicatanota
    ADD CONSTRAINT fk_duplicatanota_tipofaturamento FOREIGN KEY (tipofaturamento, empresaid, numero, ambiente, serie) REFERENCES notafiscal.notafiscal(tipofaturamento, empresaid, numero, ambiente, serie);


--
-- TOC entry 7043 (class 2606 OID 2382474)
-- Name: duplicatapaganota fk_duplicatapaganota_duplicata_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.duplicatapaganota
    ADD CONSTRAINT fk_duplicatapaganota_duplicata_id FOREIGN KEY (duplicata_id) REFERENCES notafiscal.duplicatanota(id);


--
-- TOC entry 7044 (class 2606 OID 2382479)
-- Name: duplicatapaganota fk_duplicatapaganota_usuariocadastro_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.duplicatapaganota
    ADD CONSTRAINT fk_duplicatapaganota_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7045 (class 2606 OID 2382484)
-- Name: especievolume fk_especievolume_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.especievolume
    ADD CONSTRAINT fk_especievolume_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7046 (class 2606 OID 2382489)
-- Name: especievolume fk_especievolume_usuariocadastro_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.especievolume
    ADD CONSTRAINT fk_especievolume_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7047 (class 2606 OID 2382494)
-- Name: formapagamentoauxiliarservico fk_formapagamentoauxiliarservico_auxiliarservico_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentoauxiliarservico
    ADD CONSTRAINT fk_formapagamentoauxiliarservico_auxiliarservico_id FOREIGN KEY (auxiliarservico_id) REFERENCES notafiscal.auxiliarservico(id);


--
-- TOC entry 7048 (class 2606 OID 2382499)
-- Name: formapagamentoauxiliarservico fk_formapagamentoauxiliarservico_maquinacartao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentoauxiliarservico
    ADD CONSTRAINT fk_formapagamentoauxiliarservico_maquinacartao_id FOREIGN KEY (maquinacartao_id) REFERENCES public.maquinacartao(id);


--
-- TOC entry 7049 (class 2606 OID 2382504)
-- Name: formapagamentoauxiliarservico fk_formapagamentoauxiliarservico_moedaestrangeira_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentoauxiliarservico
    ADD CONSTRAINT fk_formapagamentoauxiliarservico_moedaestrangeira_id FOREIGN KEY (moedaestrangeira_id) REFERENCES public.moeda(id);


--
-- TOC entry 7050 (class 2606 OID 2382509)
-- Name: formapagamentoauxiliarservico fk_formapagamentoauxiliarservico_movimentacaocreditosaida_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentoauxiliarservico
    ADD CONSTRAINT fk_formapagamentoauxiliarservico_movimentacaocreditosaida_id FOREIGN KEY (movimentacaocreditosaida_id) REFERENCES public.movimentacaocreditosaida(id);


--
-- TOC entry 7051 (class 2606 OID 2382514)
-- Name: formapagamentoauxiliarservico fk_formapagamentoauxiliarservico_vale_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentoauxiliarservico
    ADD CONSTRAINT fk_formapagamentoauxiliarservico_vale_id FOREIGN KEY (vale_id) REFERENCES public.movimentacaocreditoentrada(id);


--
-- TOC entry 7052 (class 2606 OID 2382519)
-- Name: formapagamentonf fk_formapagamentonf_maquinacartao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonf
    ADD CONSTRAINT fk_formapagamentonf_maquinacartao_id FOREIGN KEY (maquinacartao_id) REFERENCES public.maquinacartao(id);


--
-- TOC entry 7053 (class 2606 OID 2382524)
-- Name: formapagamentonf fk_formapagamentonf_moedaestrangeira_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonf
    ADD CONSTRAINT fk_formapagamentonf_moedaestrangeira_id FOREIGN KEY (moedaestrangeira_id) REFERENCES public.moeda(id);


--
-- TOC entry 7054 (class 2606 OID 2382529)
-- Name: formapagamentonf fk_formapagamentonf_movimentacaocreditosaida_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonf
    ADD CONSTRAINT fk_formapagamentonf_movimentacaocreditosaida_id FOREIGN KEY (movimentacaocreditosaida_id) REFERENCES public.movimentacaocreditosaida(id);


--
-- TOC entry 7055 (class 2606 OID 2382534)
-- Name: formapagamentonf fk_formapagamentonf_tipofaturamento; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonf
    ADD CONSTRAINT fk_formapagamentonf_tipofaturamento FOREIGN KEY (tipofaturamento, empresaid, numero, ambiente, serie) REFERENCES notafiscal.notafiscal(tipofaturamento, empresaid, numero, ambiente, serie);


--
-- TOC entry 7056 (class 2606 OID 2382539)
-- Name: formapagamentonf fk_formapagamentonf_vale_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonf
    ADD CONSTRAINT fk_formapagamentonf_vale_id FOREIGN KEY (vale_id) REFERENCES public.movimentacaocreditoentrada(id);


--
-- TOC entry 7057 (class 2606 OID 2382544)
-- Name: formapagamentonfc fk_formapagamentonfc_maquinacartao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonfc
    ADD CONSTRAINT fk_formapagamentonfc_maquinacartao_id FOREIGN KEY (maquinacartao_id) REFERENCES public.maquinacartao(id);


--
-- TOC entry 7058 (class 2606 OID 2382549)
-- Name: formapagamentonfc fk_formapagamentonfc_moedaestrangeira_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonfc
    ADD CONSTRAINT fk_formapagamentonfc_moedaestrangeira_id FOREIGN KEY (moedaestrangeira_id) REFERENCES public.moeda(id);


--
-- TOC entry 7059 (class 2606 OID 2382554)
-- Name: formapagamentonfc fk_formapagamentonfc_movimentacaocreditosaida_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonfc
    ADD CONSTRAINT fk_formapagamentonfc_movimentacaocreditosaida_id FOREIGN KEY (movimentacaocreditosaida_id) REFERENCES public.movimentacaocreditosaida(id);


--
-- TOC entry 7060 (class 2606 OID 2382559)
-- Name: formapagamentonfc fk_formapagamentonfc_notafiscalconsumidor_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonfc
    ADD CONSTRAINT fk_formapagamentonfc_notafiscalconsumidor_id FOREIGN KEY (notafiscalconsumidor_id) REFERENCES notafiscal.notafiscalconsumidor(id);


--
-- TOC entry 7061 (class 2606 OID 2382564)
-- Name: formapagamentonfc fk_formapagamentonfc_vale_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonfc
    ADD CONSTRAINT fk_formapagamentonfc_vale_id FOREIGN KEY (vale_id) REFERENCES public.movimentacaocreditoentrada(id);


--
-- TOC entry 7062 (class 2606 OID 2382569)
-- Name: formapagamentonfs fk_formapagamentonfs_maquinacartao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonfs
    ADD CONSTRAINT fk_formapagamentonfs_maquinacartao_id FOREIGN KEY (maquinacartao_id) REFERENCES public.maquinacartao(id);


--
-- TOC entry 7063 (class 2606 OID 2382574)
-- Name: formapagamentonfs fk_formapagamentonfs_moedaestrangeira_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonfs
    ADD CONSTRAINT fk_formapagamentonfs_moedaestrangeira_id FOREIGN KEY (moedaestrangeira_id) REFERENCES public.moeda(id);


--
-- TOC entry 7064 (class 2606 OID 2382579)
-- Name: formapagamentonfs fk_formapagamentonfs_movimentacaocreditosaida_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonfs
    ADD CONSTRAINT fk_formapagamentonfs_movimentacaocreditosaida_id FOREIGN KEY (movimentacaocreditosaida_id) REFERENCES public.movimentacaocreditosaida(id);


--
-- TOC entry 7065 (class 2606 OID 2382584)
-- Name: formapagamentonfs fk_formapagamentonfs_notafiscalservico_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonfs
    ADD CONSTRAINT fk_formapagamentonfs_notafiscalservico_id FOREIGN KEY (notafiscalservico_id) REFERENCES notafiscal.notafiscalservico(id);


--
-- TOC entry 7066 (class 2606 OID 2382589)
-- Name: formapagamentonfs fk_formapagamentonfs_vale_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.formapagamentonfs
    ADD CONSTRAINT fk_formapagamentonfs_vale_id FOREIGN KEY (vale_id) REFERENCES public.movimentacaocreditoentrada(id);


--
-- TOC entry 7067 (class 2606 OID 2382594)
-- Name: itemauxiliarservico fk_itemauxiliarservico_auxiliarservico_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemauxiliarservico
    ADD CONSTRAINT fk_itemauxiliarservico_auxiliarservico_id FOREIGN KEY (auxiliarservico_id) REFERENCES notafiscal.auxiliarservico(id);


--
-- TOC entry 7068 (class 2606 OID 2382599)
-- Name: itemauxiliarservico fk_itemauxiliarservico_kitproduto_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemauxiliarservico
    ADD CONSTRAINT fk_itemauxiliarservico_kitproduto_id FOREIGN KEY (kitproduto_id) REFERENCES public.produto(id);


--
-- TOC entry 7069 (class 2606 OID 2382604)
-- Name: itemauxiliarservico fk_itemauxiliarservico_servico_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemauxiliarservico
    ADD CONSTRAINT fk_itemauxiliarservico_servico_id FOREIGN KEY (servico_id) REFERENCES public.servico(id);


--
-- TOC entry 7070 (class 2606 OID 2382609)
-- Name: itemauxiliarservico fk_itemauxiliarservico_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemauxiliarservico
    ADD CONSTRAINT fk_itemauxiliarservico_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7071 (class 2606 OID 2382614)
-- Name: itemauxiliarservico fk_itemauxiliarservico_usuariocadastro_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemauxiliarservico
    ADD CONSTRAINT fk_itemauxiliarservico_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7072 (class 2606 OID 2382619)
-- Name: itemnotafiscal fk_itemnotafiscal_cfop_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscal
    ADD CONSTRAINT fk_itemnotafiscal_cfop_id FOREIGN KEY (cfop_id) REFERENCES public.cfop(id);


--
-- TOC entry 7073 (class 2606 OID 2382624)
-- Name: itemnotafiscal fk_itemnotafiscal_csticms_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscal
    ADD CONSTRAINT fk_itemnotafiscal_csticms_id FOREIGN KEY (csticms_id) REFERENCES public.cst(id);


--
-- TOC entry 7074 (class 2606 OID 2382629)
-- Name: itemnotafiscal fk_itemnotafiscal_cstipi_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscal
    ADD CONSTRAINT fk_itemnotafiscal_cstipi_id FOREIGN KEY (cstipi_id) REFERENCES public.cst(id);


--
-- TOC entry 7075 (class 2606 OID 2382634)
-- Name: itemnotafiscal fk_itemnotafiscal_cstpiscofins_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscal
    ADD CONSTRAINT fk_itemnotafiscal_cstpiscofins_id FOREIGN KEY (cstpiscofins_id) REFERENCES public.cst(id);


--
-- TOC entry 7076 (class 2606 OID 2382639)
-- Name: itemnotafiscal fk_itemnotafiscal_produto_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscal
    ADD CONSTRAINT fk_itemnotafiscal_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7077 (class 2606 OID 2382644)
-- Name: itemnotafiscal fk_itemnotafiscal_serie; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscal
    ADD CONSTRAINT fk_itemnotafiscal_serie FOREIGN KEY (serie, empresaid, ambiente, tipofaturamento, numero) REFERENCES notafiscal.notafiscal(serie, empresaid, ambiente, tipofaturamento, numero);


--
-- TOC entry 7078 (class 2606 OID 2382649)
-- Name: itemnotafiscal fk_itemnotafiscal_tipoitem_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscal
    ADD CONSTRAINT fk_itemnotafiscal_tipoitem_id FOREIGN KEY (tipoitem_id) REFERENCES public.tipoitem(id);


--
-- TOC entry 7079 (class 2606 OID 2382654)
-- Name: itemnotafiscalconsumidor fk_itemnotafiscalconsumidor_cfop_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalconsumidor
    ADD CONSTRAINT fk_itemnotafiscalconsumidor_cfop_id FOREIGN KEY (cfop_id) REFERENCES public.cfop(id);


--
-- TOC entry 7080 (class 2606 OID 2382659)
-- Name: itemnotafiscalconsumidor fk_itemnotafiscalconsumidor_csticms_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalconsumidor
    ADD CONSTRAINT fk_itemnotafiscalconsumidor_csticms_id FOREIGN KEY (csticms_id) REFERENCES public.cst(id);


--
-- TOC entry 7081 (class 2606 OID 2382664)
-- Name: itemnotafiscalconsumidor fk_itemnotafiscalconsumidor_cstpiscofins_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalconsumidor
    ADD CONSTRAINT fk_itemnotafiscalconsumidor_cstpiscofins_id FOREIGN KEY (cstpiscofins_id) REFERENCES public.cst(id);


--
-- TOC entry 7082 (class 2606 OID 2382669)
-- Name: itemnotafiscalconsumidor fk_itemnotafiscalconsumidor_kitproduto_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalconsumidor
    ADD CONSTRAINT fk_itemnotafiscalconsumidor_kitproduto_id FOREIGN KEY (kitproduto_id) REFERENCES public.produto(id);


--
-- TOC entry 7083 (class 2606 OID 2382674)
-- Name: itemnotafiscalconsumidor fk_itemnotafiscalconsumidor_notafiscalconsumidor_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalconsumidor
    ADD CONSTRAINT fk_itemnotafiscalconsumidor_notafiscalconsumidor_id FOREIGN KEY (notafiscalconsumidor_id) REFERENCES notafiscal.notafiscalconsumidor(id);


--
-- TOC entry 7084 (class 2606 OID 2382679)
-- Name: itemnotafiscalconsumidor fk_itemnotafiscalconsumidor_produto_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalconsumidor
    ADD CONSTRAINT fk_itemnotafiscalconsumidor_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7085 (class 2606 OID 2382684)
-- Name: itemnotafiscalconsumidor fk_itemnotafiscalconsumidor_promocaoproduto_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalconsumidor
    ADD CONSTRAINT fk_itemnotafiscalconsumidor_promocaoproduto_id FOREIGN KEY (promocaoproduto_id) REFERENCES public.promocaoproduto(id);


--
-- TOC entry 7086 (class 2606 OID 2382689)
-- Name: itemnotafiscalconsumidor fk_itemnotafiscalconsumidor_tipoitem_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalconsumidor
    ADD CONSTRAINT fk_itemnotafiscalconsumidor_tipoitem_id FOREIGN KEY (tipoitem_id) REFERENCES public.tipoitem(id);


--
-- TOC entry 7087 (class 2606 OID 2382694)
-- Name: itemnotafiscalservico fk_itemnotafiscalservico_notafiscalservico_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalservico
    ADD CONSTRAINT fk_itemnotafiscalservico_notafiscalservico_id FOREIGN KEY (notafiscalservico_id) REFERENCES notafiscal.notafiscalservico(id);


--
-- TOC entry 7088 (class 2606 OID 2382699)
-- Name: itemnotafiscalservico fk_itemnotafiscalservico_servico_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalservico
    ADD CONSTRAINT fk_itemnotafiscalservico_servico_id FOREIGN KEY (servico_id) REFERENCES public.servico(id);


--
-- TOC entry 7089 (class 2606 OID 2382704)
-- Name: itemnotafiscalservico fk_itemnotafiscalservico_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalservico
    ADD CONSTRAINT fk_itemnotafiscalservico_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7090 (class 2606 OID 2382709)
-- Name: itemnotafiscalservico fk_itemnotafiscalservico_usuariocadastro_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemnotafiscalservico
    ADD CONSTRAINT fk_itemnotafiscalservico_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7091 (class 2606 OID 2382714)
-- Name: itemorcamento fk_itemorcamento_cstipi_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemorcamento
    ADD CONSTRAINT fk_itemorcamento_cstipi_id FOREIGN KEY (cstipi_id) REFERENCES public.cst(id);


--
-- TOC entry 7092 (class 2606 OID 2382719)
-- Name: itemorcamento fk_itemorcamento_cstpiscofins_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemorcamento
    ADD CONSTRAINT fk_itemorcamento_cstpiscofins_id FOREIGN KEY (cstpiscofins_id) REFERENCES public.cst(id);


--
-- TOC entry 7093 (class 2606 OID 2382724)
-- Name: itemorcamento fk_itemorcamento_kitproduto_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemorcamento
    ADD CONSTRAINT fk_itemorcamento_kitproduto_id FOREIGN KEY (kitproduto_id) REFERENCES public.produto(id);


--
-- TOC entry 7094 (class 2606 OID 2382729)
-- Name: itemorcamento fk_itemorcamento_orcamento_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemorcamento
    ADD CONSTRAINT fk_itemorcamento_orcamento_id FOREIGN KEY (orcamento_id) REFERENCES notafiscal.orcamento(id);


--
-- TOC entry 7095 (class 2606 OID 2382734)
-- Name: itemorcamento fk_itemorcamento_produto_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.itemorcamento
    ADD CONSTRAINT fk_itemorcamento_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7096 (class 2606 OID 2382739)
-- Name: lancamentocustonfe fk_lancamentocustonfe_custonfe_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.lancamentocustonfe
    ADD CONSTRAINT fk_lancamentocustonfe_custonfe_id FOREIGN KEY (custonfe_id) REFERENCES notafiscal.custonfe(id);


--
-- TOC entry 7097 (class 2606 OID 2382744)
-- Name: lotenfse fk_lotenfse_empresa_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.lotenfse
    ADD CONSTRAINT fk_lotenfse_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7098 (class 2606 OID 2382749)
-- Name: lotenfse fk_lotenfse_prestador_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.lotenfse
    ADD CONSTRAINT fk_lotenfse_prestador_id FOREIGN KEY (prestador_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7099 (class 2606 OID 2382754)
-- Name: lotenfse fk_lotenfse_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.lotenfse
    ADD CONSTRAINT fk_lotenfse_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7100 (class 2606 OID 2382759)
-- Name: lotenfse fk_lotenfse_usuariocadastro_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.lotenfse
    ADD CONSTRAINT fk_lotenfse_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7101 (class 2606 OID 2382764)
-- Name: manifestacaodestinatario fk_manifestacaodestinatario_empresa_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.manifestacaodestinatario
    ADD CONSTRAINT fk_manifestacaodestinatario_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7102 (class 2606 OID 2382769)
-- Name: manifestacaodestinatario fk_manifestacaodestinatario_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.manifestacaodestinatario
    ADD CONSTRAINT fk_manifestacaodestinatario_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7103 (class 2606 OID 2382774)
-- Name: manifestacaodestinatario fk_manifestacaodestinatario_usuariocadastro_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.manifestacaodestinatario
    ADD CONSTRAINT fk_manifestacaodestinatario_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7104 (class 2606 OID 2382779)
-- Name: notafiscal fk_notafiscal_destinatario_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscal
    ADD CONSTRAINT fk_notafiscal_destinatario_id FOREIGN KEY (destinatario_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7105 (class 2606 OID 2382784)
-- Name: notafiscal fk_notafiscal_emitente_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscal
    ADD CONSTRAINT fk_notafiscal_emitente_id FOREIGN KEY (emitente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7106 (class 2606 OID 2382789)
-- Name: notafiscal fk_notafiscal_empresa_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscal
    ADD CONSTRAINT fk_notafiscal_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7107 (class 2606 OID 2382794)
-- Name: notafiscal fk_notafiscal_especievolumes_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscal
    ADD CONSTRAINT fk_notafiscal_especievolumes_id FOREIGN KEY (especievolumes_id) REFERENCES notafiscal.especievolume(id);


--
-- TOC entry 7108 (class 2606 OID 2382799)
-- Name: notafiscal fk_notafiscal_lote_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscal
    ADD CONSTRAINT fk_notafiscal_lote_id FOREIGN KEY (lote_id) REFERENCES notafiscal.lotenfe(id);


--
-- TOC entry 7109 (class 2606 OID 2382804)
-- Name: notafiscal fk_notafiscal_natureza_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscal
    ADD CONSTRAINT fk_notafiscal_natureza_id FOREIGN KEY (natureza_id) REFERENCES public.cfop(id);


--
-- TOC entry 7110 (class 2606 OID 2382809)
-- Name: notafiscal fk_notafiscal_transportador_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscal
    ADD CONSTRAINT fk_notafiscal_transportador_id FOREIGN KEY (transportador_id) REFERENCES notafiscal.transportador(id);


--
-- TOC entry 7111 (class 2606 OID 2382814)
-- Name: notafiscal fk_notafiscal_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscal
    ADD CONSTRAINT fk_notafiscal_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7112 (class 2606 OID 2382819)
-- Name: notafiscal fk_notafiscal_usuariocadastro_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscal
    ADD CONSTRAINT fk_notafiscal_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7113 (class 2606 OID 2382824)
-- Name: notafiscal fk_notafiscal_veiculo_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscal
    ADD CONSTRAINT fk_notafiscal_veiculo_id FOREIGN KEY (veiculo_id) REFERENCES notafiscal.veiculo(id);


--
-- TOC entry 7114 (class 2606 OID 2382829)
-- Name: notafiscal fk_notafiscal_vendedor_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscal
    ADD CONSTRAINT fk_notafiscal_vendedor_id FOREIGN KEY (vendedor_id) REFERENCES public.usuario(id);


--
-- TOC entry 7115 (class 2606 OID 2382834)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_consignacaodevolucao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_consignacaodevolucao_id FOREIGN KEY (consignacaodevolucao_id) REFERENCES ecf.consignacaodevolucao(id);


--
-- TOC entry 7116 (class 2606 OID 2382839)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_destinatario_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_destinatario_id FOREIGN KEY (destinatario_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7117 (class 2606 OID 2382844)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_emitente_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_emitente_id FOREIGN KEY (emitente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7118 (class 2606 OID 2382849)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_empresa_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7119 (class 2606 OID 2382854)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_especievolumes_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_especievolumes_id FOREIGN KEY (especievolumes_id) REFERENCES notafiscal.especievolume(id);


--
-- TOC entry 7120 (class 2606 OID 2382859)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_lote_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_lote_id FOREIGN KEY (lote_id) REFERENCES notafiscal.lotenfce(id);


--
-- TOC entry 7121 (class 2606 OID 2382864)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_natureza_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_natureza_id FOREIGN KEY (natureza_id) REFERENCES public.cfop(id);


--
-- TOC entry 7122 (class 2606 OID 2382869)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_tabelapreco_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_tabelapreco_id FOREIGN KEY (tabelapreco_id) REFERENCES public.tabelapreco(id);


--
-- TOC entry 7123 (class 2606 OID 2382874)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_transportador_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_transportador_id FOREIGN KEY (transportador_id) REFERENCES notafiscal.transportador(id);


--
-- TOC entry 7124 (class 2606 OID 2382879)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_ufsaidapais_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_ufsaidapais_id FOREIGN KEY (ufsaidapais_id) REFERENCES public.estado(id);


--
-- TOC entry 7125 (class 2606 OID 2382884)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7126 (class 2606 OID 2382889)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_usuariocadastro_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7127 (class 2606 OID 2382894)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_veiculo_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_veiculo_id FOREIGN KEY (veiculo_id) REFERENCES notafiscal.veiculo(id);


--
-- TOC entry 7128 (class 2606 OID 2382899)
-- Name: notafiscalconsumidor fk_notafiscalconsumidor_vendedorfuncionario_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalconsumidor
    ADD CONSTRAINT fk_notafiscalconsumidor_vendedorfuncionario_id FOREIGN KEY (vendedorfuncionario_id) REFERENCES public.funcionario(id);


--
-- TOC entry 7129 (class 2606 OID 2382904)
-- Name: notafiscalservico fk_notafiscalservico_caixaaberto_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalservico
    ADD CONSTRAINT fk_notafiscalservico_caixaaberto_id FOREIGN KEY (caixaaberto_id) REFERENCES public.caixa(id);


--
-- TOC entry 7130 (class 2606 OID 2382909)
-- Name: notafiscalservico fk_notafiscalservico_empresa_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalservico
    ADD CONSTRAINT fk_notafiscalservico_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7131 (class 2606 OID 2382914)
-- Name: notafiscalservico fk_notafiscalservico_enderecotomador_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalservico
    ADD CONSTRAINT fk_notafiscalservico_enderecotomador_id FOREIGN KEY (enderecotomador_id) REFERENCES public.endereco(id);


--
-- TOC entry 7132 (class 2606 OID 2382919)
-- Name: notafiscalservico fk_notafiscalservico_funcionario_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalservico
    ADD CONSTRAINT fk_notafiscalservico_funcionario_id FOREIGN KEY (funcionario_id) REFERENCES public.funcionario(id);


--
-- TOC entry 7133 (class 2606 OID 2382924)
-- Name: notafiscalservico fk_notafiscalservico_lotenfse_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalservico
    ADD CONSTRAINT fk_notafiscalservico_lotenfse_id FOREIGN KEY (lotenfse_id) REFERENCES notafiscal.lotenfse(id);


--
-- TOC entry 7134 (class 2606 OID 2382929)
-- Name: notafiscalservico fk_notafiscalservico_prestador_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalservico
    ADD CONSTRAINT fk_notafiscalservico_prestador_id FOREIGN KEY (prestador_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7135 (class 2606 OID 2382934)
-- Name: notafiscalservico fk_notafiscalservico_tomador_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalservico
    ADD CONSTRAINT fk_notafiscalservico_tomador_id FOREIGN KEY (tomador_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7136 (class 2606 OID 2382939)
-- Name: notafiscalservico fk_notafiscalservico_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalservico
    ADD CONSTRAINT fk_notafiscalservico_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7137 (class 2606 OID 2382944)
-- Name: notafiscalservico fk_notafiscalservico_usuariocadastro_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notafiscalservico
    ADD CONSTRAINT fk_notafiscalservico_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7138 (class 2606 OID 2382949)
-- Name: notaprodutorruralreferenciada fk_notaprodutorruralreferenciada_estadoemitente_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notaprodutorruralreferenciada
    ADD CONSTRAINT fk_notaprodutorruralreferenciada_estadoemitente_id FOREIGN KEY (estadoemitente_id) REFERENCES public.estado(id);


--
-- TOC entry 7139 (class 2606 OID 2382954)
-- Name: notaprodutorruralreferenciada fk_notaprodutorruralreferenciada_tipofaturamento; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.notaprodutorruralreferenciada
    ADD CONSTRAINT fk_notaprodutorruralreferenciada_tipofaturamento FOREIGN KEY (tipofaturamento, empresaid, numero, ambiente, serie) REFERENCES notafiscal.notafiscal(tipofaturamento, empresaid, numero, ambiente, serie);


--
-- TOC entry 7140 (class 2606 OID 2382959)
-- Name: obscontribuintenfe fk_obscontribuintenfe_tipofaturamento; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.obscontribuintenfe
    ADD CONSTRAINT fk_obscontribuintenfe_tipofaturamento FOREIGN KEY (tipofaturamento, empresaid, numero, ambiente, serie) REFERENCES notafiscal.notafiscal(tipofaturamento, empresaid, numero, ambiente, serie);


--
-- TOC entry 7141 (class 2606 OID 2382964)
-- Name: orcamento fk_orcamento_cliente_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.orcamento
    ADD CONSTRAINT fk_orcamento_cliente_id FOREIGN KEY (cliente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7142 (class 2606 OID 2382969)
-- Name: orcamento fk_orcamento_empresa_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.orcamento
    ADD CONSTRAINT fk_orcamento_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7143 (class 2606 OID 2382974)
-- Name: orcamento fk_orcamento_natureza_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.orcamento
    ADD CONSTRAINT fk_orcamento_natureza_id FOREIGN KEY (natureza_id) REFERENCES public.cfop(id);


--
-- TOC entry 7144 (class 2606 OID 2382979)
-- Name: orcamento fk_orcamento_pedido_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.orcamento
    ADD CONSTRAINT fk_orcamento_pedido_id FOREIGN KEY (pedido_id) REFERENCES public.pedido(id);


--
-- TOC entry 7145 (class 2606 OID 2382984)
-- Name: orcamento fk_orcamento_tabelapreco_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.orcamento
    ADD CONSTRAINT fk_orcamento_tabelapreco_id FOREIGN KEY (tabelapreco_id) REFERENCES public.tabelapreco(id);


--
-- TOC entry 7146 (class 2606 OID 2382989)
-- Name: orcamento fk_orcamento_tipofaturamento; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.orcamento
    ADD CONSTRAINT fk_orcamento_tipofaturamento FOREIGN KEY (tipofaturamento, empresaid, numero, ambiente, serie) REFERENCES notafiscal.notafiscal(tipofaturamento, empresaid, numero, ambiente, serie);


--
-- TOC entry 7147 (class 2606 OID 2382994)
-- Name: orcamento fk_orcamento_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.orcamento
    ADD CONSTRAINT fk_orcamento_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7148 (class 2606 OID 2382999)
-- Name: orcamento fk_orcamento_usuariocadastro_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.orcamento
    ADD CONSTRAINT fk_orcamento_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7149 (class 2606 OID 2383004)
-- Name: serie fk_serie_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.serie
    ADD CONSTRAINT fk_serie_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7150 (class 2606 OID 2383009)
-- Name: serie fk_serie_usuariocadastro_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.serie
    ADD CONSTRAINT fk_serie_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7151 (class 2606 OID 2383014)
-- Name: transportador fk_transportador_municipio_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.transportador
    ADD CONSTRAINT fk_transportador_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 7152 (class 2606 OID 2383019)
-- Name: transportador fk_transportador_usuariocadastro_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.transportador
    ADD CONSTRAINT fk_transportador_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7153 (class 2606 OID 2383024)
-- Name: veiculo fk_veiculo_municipio_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.veiculo
    ADD CONSTRAINT fk_veiculo_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 7154 (class 2606 OID 2383029)
-- Name: veiculo fk_veiculo_transportador_id; Type: FK CONSTRAINT; Schema: notafiscal; Owner: postgres
--

ALTER TABLE ONLY notafiscal.veiculo
    ADD CONSTRAINT fk_veiculo_transportador_id FOREIGN KEY (transportador_id) REFERENCES notafiscal.transportador(id);


--
-- TOC entry 7203 (class 2606 OID 2383034)
-- Name: clientefornecedor_camposadicionaiscliente clientefornecedor_camposadicionaiscliente_camposadicionais_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedor_camposadicionaiscliente
    ADD CONSTRAINT clientefornecedor_camposadicionaiscliente_camposadicionais_id FOREIGN KEY (camposadicionais_id) REFERENCES public.camposadicionaiscliente(id);


--
-- TOC entry 7204 (class 2606 OID 2383039)
-- Name: clientefornecedor_camposadicionaiscliente clientefornecedor_camposadicionaiscliente_clientefornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedor_camposadicionaiscliente
    ADD CONSTRAINT clientefornecedor_camposadicionaiscliente_clientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7205 (class 2606 OID 2383044)
-- Name: clientefornecedor_historicoclientefornecedor clientefornecedorhistoricoclientefornecedorclientefornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedor_historicoclientefornecedor
    ADD CONSTRAINT clientefornecedorhistoricoclientefornecedorclientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7221 (class 2606 OID 2383049)
-- Name: conhecimentotransportedocumentoref_nfconhecimentotransportedocr cnhcmnttrnsprtdcmntrfnfcnhcmnttrnsprtdcrfcnhcmnttrnsprtdcmntrfd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conhecimentotransportedocumentoref_nfconhecimentotransportedocr
    ADD CONSTRAINT cnhcmnttrnsprtdcmntrfnfcnhcmnttrnsprtdcrfcnhcmnttrnsprtdcmntrfd FOREIGN KEY (conhecimentotransportedocumentoref_id) REFERENCES public.conhecimentotransportedocumentoref(id);


--
-- TOC entry 7222 (class 2606 OID 2383054)
-- Name: conhecimentotransportedocumentoref_nfconhecimentotransportedocr cnhcmnttrnsprtdcmntrfnfcnhcmnttrnsprtdcrferenciadontstrnsprtdsd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conhecimentotransportedocumentoref_nfconhecimentotransportedocr
    ADD CONSTRAINT cnhcmnttrnsprtdcmntrfnfcnhcmnttrnsprtdcrferenciadontstrnsprtdsd FOREIGN KEY (notastransportadas_id) REFERENCES public.nfconhecimentotransportedocreferenciado(id);


--
-- TOC entry 7155 (class 2606 OID 2383059)
-- Name: adiantamentoordemservico fk_adiantamentoordemservico_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adiantamentoordemservico
    ADD CONSTRAINT fk_adiantamentoordemservico_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7156 (class 2606 OID 2383064)
-- Name: adiantamentoordemservico fk_adiantamentoordemservico_movimentacaocreditovaleentrada_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adiantamentoordemservico
    ADD CONSTRAINT fk_adiantamentoordemservico_movimentacaocreditovaleentrada_id FOREIGN KEY (movimentacaocreditovaleentrada_id) REFERENCES public.movimentacaocreditoentrada(id);


--
-- TOC entry 7157 (class 2606 OID 2383069)
-- Name: adiantamentoordemservico fk_adiantamentoordemservico_ordemservico_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adiantamentoordemservico
    ADD CONSTRAINT fk_adiantamentoordemservico_ordemservico_id FOREIGN KEY (ordemservico_id) REFERENCES public.ordemservico(id);


--
-- TOC entry 7158 (class 2606 OID 2383074)
-- Name: adiantamentoordemservico fk_adiantamentoordemservico_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adiantamentoordemservico
    ADD CONSTRAINT fk_adiantamentoordemservico_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7159 (class 2606 OID 2383079)
-- Name: adiantamentoordemservico fk_adiantamentoordemservico_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adiantamentoordemservico
    ADD CONSTRAINT fk_adiantamentoordemservico_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7160 (class 2606 OID 2383084)
-- Name: adicionalitemdelivery fk_adicionalitemdelivery_adicional_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalitemdelivery
    ADD CONSTRAINT fk_adicionalitemdelivery_adicional_id FOREIGN KEY (adicional_id) REFERENCES public.adicionalproduto(id);


--
-- TOC entry 7161 (class 2606 OID 2383089)
-- Name: adicionalitemdelivery fk_adicionalitemdelivery_itemdelivery_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalitemdelivery
    ADD CONSTRAINT fk_adicionalitemdelivery_itemdelivery_id FOREIGN KEY (itemdelivery_id) REFERENCES public.itemdelivery(id);


--
-- TOC entry 7162 (class 2606 OID 2383094)
-- Name: adicionalitemdelivery fk_adicionalitemdelivery_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalitemdelivery
    ADD CONSTRAINT fk_adicionalitemdelivery_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7163 (class 2606 OID 2383099)
-- Name: adicionalitemdelivery fk_adicionalitemdelivery_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalitemdelivery
    ADD CONSTRAINT fk_adicionalitemdelivery_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7164 (class 2606 OID 2383104)
-- Name: adicionalproduto fk_adicionalproduto_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalproduto
    ADD CONSTRAINT fk_adicionalproduto_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7165 (class 2606 OID 2383109)
-- Name: adicionalproduto fk_adicionalproduto_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalproduto
    ADD CONSTRAINT fk_adicionalproduto_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7166 (class 2606 OID 2383114)
-- Name: adicionalproduto fk_adicionalproduto_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalproduto
    ADD CONSTRAINT fk_adicionalproduto_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7167 (class 2606 OID 2383119)
-- Name: adicionalprodutocontrole fk_adicionalprodutocontrole_adicional_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalprodutocontrole
    ADD CONSTRAINT fk_adicionalprodutocontrole_adicional_id FOREIGN KEY (adicional_id) REFERENCES public.adicionalproduto(id);


--
-- TOC entry 7168 (class 2606 OID 2383124)
-- Name: adicionalprodutocontrole fk_adicionalprodutocontrole_departamento_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalprodutocontrole
    ADD CONSTRAINT fk_adicionalprodutocontrole_departamento_id FOREIGN KEY (departamento_id) REFERENCES public.departamento(id);


--
-- TOC entry 7169 (class 2606 OID 2383129)
-- Name: adicionalprodutocontrole fk_adicionalprodutocontrole_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalprodutocontrole
    ADD CONSTRAINT fk_adicionalprodutocontrole_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7170 (class 2606 OID 2383134)
-- Name: adicionalprodutocontrole fk_adicionalprodutocontrole_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalprodutocontrole
    ADD CONSTRAINT fk_adicionalprodutocontrole_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7171 (class 2606 OID 2383139)
-- Name: adicionalprodutocontrole fk_adicionalprodutocontrole_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalprodutocontrole
    ADD CONSTRAINT fk_adicionalprodutocontrole_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7172 (class 2606 OID 2383144)
-- Name: adicionalprodutocontrole fk_adicionalprodutocontrole_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adicionalprodutocontrole
    ADD CONSTRAINT fk_adicionalprodutocontrole_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7173 (class 2606 OID 2383149)
-- Name: anexo fk_anexo_clientefornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_anexo_clientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7174 (class 2606 OID 2383154)
-- Name: anexo fk_anexo_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_anexo_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7175 (class 2606 OID 2383159)
-- Name: anexo fk_anexo_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anexo
    ADD CONSTRAINT fk_anexo_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7176 (class 2606 OID 2383164)
-- Name: anotacaopedido fk_anotacaopedido_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anotacaopedido
    ADD CONSTRAINT fk_anotacaopedido_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7177 (class 2606 OID 2383169)
-- Name: anotacaopedido fk_anotacaopedido_statusanotacaopedido_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anotacaopedido
    ADD CONSTRAINT fk_anotacaopedido_statusanotacaopedido_id FOREIGN KEY (statusanotacaopedido_id) REFERENCES public.statusanotacaopedido(id);


--
-- TOC entry 7178 (class 2606 OID 2383174)
-- Name: anotacaopedido fk_anotacaopedido_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anotacaopedido
    ADD CONSTRAINT fk_anotacaopedido_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7179 (class 2606 OID 2383179)
-- Name: anotacaopedido fk_anotacaopedido_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anotacaopedido
    ADD CONSTRAINT fk_anotacaopedido_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7180 (class 2606 OID 2383184)
-- Name: atalhobarraferramentas fk_atalhobarraferramentas_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atalhobarraferramentas
    ADD CONSTRAINT fk_atalhobarraferramentas_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7181 (class 2606 OID 2383189)
-- Name: atalhobarraferramentas fk_atalhobarraferramentas_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atalhobarraferramentas
    ADD CONSTRAINT fk_atalhobarraferramentas_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 7182 (class 2606 OID 2383194)
-- Name: backup fk_backup_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.backup
    ADD CONSTRAINT fk_backup_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7183 (class 2606 OID 2383199)
-- Name: backup fk_backup_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.backup
    ADD CONSTRAINT fk_backup_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7184 (class 2606 OID 2383204)
-- Name: backup fk_backup_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.backup
    ADD CONSTRAINT fk_backup_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7185 (class 2606 OID 2383209)
-- Name: balanca fk_balanca_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balanca
    ADD CONSTRAINT fk_balanca_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7186 (class 2606 OID 2383214)
-- Name: balanca fk_balanca_tara_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balanca
    ADD CONSTRAINT fk_balanca_tara_id FOREIGN KEY (tara_id) REFERENCES public.tara(id);


--
-- TOC entry 7187 (class 2606 OID 2383219)
-- Name: balanca fk_balanca_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balanca
    ADD CONSTRAINT fk_balanca_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7188 (class 2606 OID 2383224)
-- Name: balanca fk_balanca_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balanca
    ADD CONSTRAINT fk_balanca_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7189 (class 2606 OID 2383229)
-- Name: beneficiofiscal fk_beneficiofiscal_estado_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficiofiscal
    ADD CONSTRAINT fk_beneficiofiscal_estado_id FOREIGN KEY (estado_id) REFERENCES public.estado(id);


--
-- TOC entry 7190 (class 2606 OID 2383234)
-- Name: cadastrofacillancado fk_cadastrofacillancado_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cadastrofacillancado
    ADD CONSTRAINT fk_cadastrofacillancado_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7191 (class 2606 OID 2383239)
-- Name: cadastrofacillancado fk_cadastrofacillancado_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cadastrofacillancado
    ADD CONSTRAINT fk_cadastrofacillancado_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7192 (class 2606 OID 2383244)
-- Name: cadastrofacillancado fk_cadastrofacillancado_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cadastrofacillancado
    ADD CONSTRAINT fk_cadastrofacillancado_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7193 (class 2606 OID 2383249)
-- Name: caixa fk_caixa_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caixa
    ADD CONSTRAINT fk_caixa_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7194 (class 2606 OID 2383254)
-- Name: caixa fk_caixa_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caixa
    ADD CONSTRAINT fk_caixa_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 7195 (class 2606 OID 2383259)
-- Name: camposadicionaiscliente fk_camposadicionaiscliente_campoadicional_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camposadicionaiscliente
    ADD CONSTRAINT fk_camposadicionaiscliente_campoadicional_id FOREIGN KEY (campoadicional_id) REFERENCES public.campoadicional(id);


--
-- TOC entry 7196 (class 2606 OID 2383264)
-- Name: camposadicionaiscliente fk_camposadicionaiscliente_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camposadicionaiscliente
    ADD CONSTRAINT fk_camposadicionaiscliente_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7197 (class 2606 OID 2383269)
-- Name: camposadicionaiscliente fk_camposadicionaiscliente_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camposadicionaiscliente
    ADD CONSTRAINT fk_camposadicionaiscliente_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7198 (class 2606 OID 2383274)
-- Name: cfop fk_cfop_tipocfop_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cfop
    ADD CONSTRAINT fk_cfop_tipocfop_id FOREIGN KEY (tipocfop_id) REFERENCES public.tipocfop(id);


--
-- TOC entry 7199 (class 2606 OID 2383279)
-- Name: clientefornecedor fk_clientefornecedor_creditocliente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedor
    ADD CONSTRAINT fk_clientefornecedor_creditocliente_id FOREIGN KEY (creditocliente_id) REFERENCES public.creditocliente(id);


--
-- TOC entry 7200 (class 2606 OID 2383284)
-- Name: clientefornecedor fk_clientefornecedor_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedor
    ADD CONSTRAINT fk_clientefornecedor_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7206 (class 2606 OID 2383289)
-- Name: clientefornecedor_historicoclientefornecedor fk_clientefornecedor_historicoclientefornecedor_historicos_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedor_historicoclientefornecedor
    ADD CONSTRAINT fk_clientefornecedor_historicoclientefornecedor_historicos_id FOREIGN KEY (historicos_id) REFERENCES public.historicoclientefornecedor(id);


--
-- TOC entry 7201 (class 2606 OID 2383294)
-- Name: clientefornecedor fk_clientefornecedor_municipio_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedor
    ADD CONSTRAINT fk_clientefornecedor_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 7202 (class 2606 OID 2383299)
-- Name: clientefornecedor fk_clientefornecedor_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedor
    ADD CONSTRAINT fk_clientefornecedor_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7207 (class 2606 OID 2383304)
-- Name: clientefornecedortabelapreco fk_clientefornecedortabelapreco_clientefornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedortabelapreco
    ADD CONSTRAINT fk_clientefornecedortabelapreco_clientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7208 (class 2606 OID 2383309)
-- Name: clientefornecedortabelapreco fk_clientefornecedortabelapreco_tabelapreco_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedortabelapreco
    ADD CONSTRAINT fk_clientefornecedortabelapreco_tabelapreco_id FOREIGN KEY (tabelapreco_id) REFERENCES public.tabelapreco(id);


--
-- TOC entry 7209 (class 2606 OID 2383314)
-- Name: clientefornecedortabelapreco fk_clientefornecedortabelapreco_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedortabelapreco
    ADD CONSTRAINT fk_clientefornecedortabelapreco_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7210 (class 2606 OID 2383319)
-- Name: clientefornecedortabelapreco fk_clientefornecedortabelapreco_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientefornecedortabelapreco
    ADD CONSTRAINT fk_clientefornecedortabelapreco_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7211 (class 2606 OID 2383324)
-- Name: compromisso fk_compromisso_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compromisso
    ADD CONSTRAINT fk_compromisso_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7214 (class 2606 OID 2383329)
-- Name: compromisso_usuario fk_compromisso_usuario_compromisso_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compromisso_usuario
    ADD CONSTRAINT fk_compromisso_usuario_compromisso_id FOREIGN KEY (compromisso_id) REFERENCES public.compromisso(id);


--
-- TOC entry 7215 (class 2606 OID 2383334)
-- Name: compromisso_usuario fk_compromisso_usuario_usuarios_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compromisso_usuario
    ADD CONSTRAINT fk_compromisso_usuario_usuarios_id FOREIGN KEY (usuarios_id) REFERENCES public.usuario(id);


--
-- TOC entry 7212 (class 2606 OID 2383339)
-- Name: compromisso fk_compromisso_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compromisso
    ADD CONSTRAINT fk_compromisso_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7213 (class 2606 OID 2383344)
-- Name: compromisso fk_compromisso_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compromisso
    ADD CONSTRAINT fk_compromisso_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7216 (class 2606 OID 2383349)
-- Name: conhecimentotransportedocumentoref fk_conhecimentotransportedocumentoref_destinatario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conhecimentotransportedocumentoref
    ADD CONSTRAINT fk_conhecimentotransportedocumentoref_destinatario_id FOREIGN KEY (destinatario_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7217 (class 2606 OID 2383354)
-- Name: conhecimentotransportedocumentoref fk_conhecimentotransportedocumentoref_municipiocarga_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conhecimentotransportedocumentoref
    ADD CONSTRAINT fk_conhecimentotransportedocumentoref_municipiocarga_id FOREIGN KEY (municipiocarga_id) REFERENCES public.municipio(id);


--
-- TOC entry 7218 (class 2606 OID 2383359)
-- Name: conhecimentotransportedocumentoref fk_conhecimentotransportedocumentoref_municipiotermino_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conhecimentotransportedocumentoref
    ADD CONSTRAINT fk_conhecimentotransportedocumentoref_municipiotermino_id FOREIGN KEY (municipiotermino_id) REFERENCES public.municipio(id);


--
-- TOC entry 7219 (class 2606 OID 2383364)
-- Name: conhecimentotransportedocumentoref fk_conhecimentotransportedocumentoref_remetente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conhecimentotransportedocumentoref
    ADD CONSTRAINT fk_conhecimentotransportedocumentoref_remetente_id FOREIGN KEY (remetente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7220 (class 2606 OID 2383369)
-- Name: conhecimentotransportedocumentoref fk_conhecimentotransportedocumentoref_tomador_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conhecimentotransportedocumentoref
    ADD CONSTRAINT fk_conhecimentotransportedocumentoref_tomador_id FOREIGN KEY (tomador_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7223 (class 2606 OID 2383374)
-- Name: conta fk_conta_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conta
    ADD CONSTRAINT fk_conta_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7224 (class 2606 OID 2383379)
-- Name: conta fk_conta_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conta
    ADD CONSTRAINT fk_conta_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7225 (class 2606 OID 2383384)
-- Name: contador fk_contador_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contador
    ADD CONSTRAINT fk_contador_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7226 (class 2606 OID 2383389)
-- Name: contador fk_contador_municipio_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contador
    ADD CONSTRAINT fk_contador_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 7227 (class 2606 OID 2383394)
-- Name: contato fk_contato_clientefornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contato
    ADD CONSTRAINT fk_contato_clientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7228 (class 2606 OID 2383399)
-- Name: contato fk_contato_compromisso_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contato
    ADD CONSTRAINT fk_contato_compromisso_id FOREIGN KEY (compromisso_id) REFERENCES public.compromisso(id);


--
-- TOC entry 7229 (class 2606 OID 2383404)
-- Name: contato fk_contato_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contato
    ADD CONSTRAINT fk_contato_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7230 (class 2606 OID 2383409)
-- Name: contato fk_contato_tipo_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contato
    ADD CONSTRAINT fk_contato_tipo_id FOREIGN KEY (tipo_id) REFERENCES public.tipocontato(id);


--
-- TOC entry 7231 (class 2606 OID 2383414)
-- Name: contato fk_contato_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contato
    ADD CONSTRAINT fk_contato_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7232 (class 2606 OID 2383419)
-- Name: contato fk_contato_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contato
    ADD CONSTRAINT fk_contato_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7233 (class 2606 OID 2383424)
-- Name: contatoadicional fk_contatoadicional_clientefornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contatoadicional
    ADD CONSTRAINT fk_contatoadicional_clientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7234 (class 2606 OID 2383429)
-- Name: cotacao fk_cotacao_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cotacao
    ADD CONSTRAINT fk_cotacao_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7235 (class 2606 OID 2383434)
-- Name: cotacao fk_cotacao_moeda_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cotacao
    ADD CONSTRAINT fk_cotacao_moeda_id FOREIGN KEY (moeda_id) REFERENCES public.moeda(id);


--
-- TOC entry 7236 (class 2606 OID 2383439)
-- Name: cotacao fk_cotacao_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cotacao
    ADD CONSTRAINT fk_cotacao_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7237 (class 2606 OID 2383444)
-- Name: cotacao fk_cotacao_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cotacao
    ADD CONSTRAINT fk_cotacao_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7238 (class 2606 OID 2383449)
-- Name: creditocliente fk_creditocliente_clientefornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creditocliente
    ADD CONSTRAINT fk_creditocliente_clientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7239 (class 2606 OID 2383454)
-- Name: creditocliente fk_creditocliente_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creditocliente
    ADD CONSTRAINT fk_creditocliente_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7240 (class 2606 OID 2383459)
-- Name: delivery fk_delivery_caixaaberto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT fk_delivery_caixaaberto_id FOREIGN KEY (caixaaberto_id) REFERENCES public.caixa(id);


--
-- TOC entry 7241 (class 2606 OID 2383464)
-- Name: delivery fk_delivery_cidade_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT fk_delivery_cidade_id FOREIGN KEY (cidade_id) REFERENCES public.municipio(id);


--
-- TOC entry 7242 (class 2606 OID 2383469)
-- Name: delivery fk_delivery_cliente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT fk_delivery_cliente_id FOREIGN KEY (cliente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7243 (class 2606 OID 2383474)
-- Name: delivery fk_delivery_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT fk_delivery_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7244 (class 2606 OID 2383479)
-- Name: delivery fk_delivery_entregador_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT fk_delivery_entregador_id FOREIGN KEY (entregador_id) REFERENCES public.entregador(id);


--
-- TOC entry 7245 (class 2606 OID 2383484)
-- Name: delivery fk_delivery_tabelapreco_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT fk_delivery_tabelapreco_id FOREIGN KEY (tabelapreco_id) REFERENCES public.tabelapreco(id);


--
-- TOC entry 7246 (class 2606 OID 2383489)
-- Name: delivery fk_delivery_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT fk_delivery_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7247 (class 2606 OID 2383494)
-- Name: delivery fk_delivery_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT fk_delivery_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7248 (class 2606 OID 2383499)
-- Name: delivery fk_delivery_vendedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT fk_delivery_vendedor_id FOREIGN KEY (vendedor_id) REFERENCES public.funcionario(id);


--
-- TOC entry 7249 (class 2606 OID 2383504)
-- Name: departamento fk_departamento_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT fk_departamento_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7250 (class 2606 OID 2383509)
-- Name: departamento fk_departamento_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT fk_departamento_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7251 (class 2606 OID 2383514)
-- Name: departamento fk_departamento_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT fk_departamento_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7252 (class 2606 OID 2383519)
-- Name: dependente fk_dependente_clientefornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dependente
    ADD CONSTRAINT fk_dependente_clientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7253 (class 2606 OID 2383524)
-- Name: dependente fk_dependente_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dependente
    ADD CONSTRAINT fk_dependente_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7254 (class 2606 OID 2383529)
-- Name: devolucaotrocaproduto fk_devolucaotrocaproduto_caixaaberto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devolucaotrocaproduto
    ADD CONSTRAINT fk_devolucaotrocaproduto_caixaaberto_id FOREIGN KEY (caixaaberto_id) REFERENCES public.caixa(id);


--
-- TOC entry 7255 (class 2606 OID 2383534)
-- Name: devolucaotrocaproduto fk_devolucaotrocaproduto_cliente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devolucaotrocaproduto
    ADD CONSTRAINT fk_devolucaotrocaproduto_cliente_id FOREIGN KEY (cliente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7256 (class 2606 OID 2383539)
-- Name: devolucaotrocaproduto fk_devolucaotrocaproduto_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devolucaotrocaproduto
    ADD CONSTRAINT fk_devolucaotrocaproduto_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7257 (class 2606 OID 2383544)
-- Name: devolucaotrocaproduto fk_devolucaotrocaproduto_enderecocliente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devolucaotrocaproduto
    ADD CONSTRAINT fk_devolucaotrocaproduto_enderecocliente_id FOREIGN KEY (enderecocliente_id) REFERENCES public.endereco(id);


--
-- TOC entry 7258 (class 2606 OID 2383549)
-- Name: devolucaotrocaproduto fk_devolucaotrocaproduto_entregador_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devolucaotrocaproduto
    ADD CONSTRAINT fk_devolucaotrocaproduto_entregador_id FOREIGN KEY (entregador_id) REFERENCES public.entregador(id);


--
-- TOC entry 7259 (class 2606 OID 2383554)
-- Name: devolucaotrocaproduto fk_devolucaotrocaproduto_tabelapreco_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devolucaotrocaproduto
    ADD CONSTRAINT fk_devolucaotrocaproduto_tabelapreco_id FOREIGN KEY (tabelapreco_id) REFERENCES public.tabelapreco(id);


--
-- TOC entry 7260 (class 2606 OID 2383559)
-- Name: devolucaotrocaproduto fk_devolucaotrocaproduto_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devolucaotrocaproduto
    ADD CONSTRAINT fk_devolucaotrocaproduto_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7261 (class 2606 OID 2383564)
-- Name: devolucaotrocaproduto fk_devolucaotrocaproduto_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devolucaotrocaproduto
    ADD CONSTRAINT fk_devolucaotrocaproduto_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7262 (class 2606 OID 2383569)
-- Name: devolucaotrocaproduto fk_devolucaotrocaproduto_vendedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devolucaotrocaproduto
    ADD CONSTRAINT fk_devolucaotrocaproduto_vendedor_id FOREIGN KEY (vendedor_id) REFERENCES public.funcionario(id);


--
-- TOC entry 7263 (class 2606 OID 2383574)
-- Name: documentofiscal fk_documentofiscal_cfop_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentofiscal
    ADD CONSTRAINT fk_documentofiscal_cfop_id FOREIGN KEY (cfop_id) REFERENCES public.cfop(id);


--
-- TOC entry 7264 (class 2606 OID 2383579)
-- Name: documentofiscal fk_documentofiscal_cliente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentofiscal
    ADD CONSTRAINT fk_documentofiscal_cliente_id FOREIGN KEY (cliente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7265 (class 2606 OID 2383584)
-- Name: documentofiscal fk_documentofiscal_cte_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentofiscal
    ADD CONSTRAINT fk_documentofiscal_cte_id FOREIGN KEY (cte_id) REFERENCES public.conhecimentotransportedocumentoref(id);


--
-- TOC entry 7266 (class 2606 OID 2383589)
-- Name: documentofiscal fk_documentofiscal_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentofiscal
    ADD CONSTRAINT fk_documentofiscal_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7267 (class 2606 OID 2383594)
-- Name: documentofiscal fk_documentofiscal_fornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentofiscal
    ADD CONSTRAINT fk_documentofiscal_fornecedor_id FOREIGN KEY (fornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7268 (class 2606 OID 2383599)
-- Name: documentofiscal fk_documentofiscal_fornecimentoconsumo_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentofiscal
    ADD CONSTRAINT fk_documentofiscal_fornecimentoconsumo_id FOREIGN KEY (fornecimentoconsumo_id) REFERENCES public.fornecimentoconsumo(id);


--
-- TOC entry 7269 (class 2606 OID 2383604)
-- Name: documentofiscal fk_documentofiscal_transportador_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentofiscal
    ADD CONSTRAINT fk_documentofiscal_transportador_id FOREIGN KEY (transportador_id) REFERENCES notafiscal.transportador(id);


--
-- TOC entry 7270 (class 2606 OID 2383609)
-- Name: documentofiscal fk_documentofiscal_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentofiscal
    ADD CONSTRAINT fk_documentofiscal_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7271 (class 2606 OID 2383614)
-- Name: documentofiscal fk_documentofiscal_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentofiscal
    ADD CONSTRAINT fk_documentofiscal_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7272 (class 2606 OID 2383619)
-- Name: documentofiscal fk_documentofiscal_veiculo_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentofiscal
    ADD CONSTRAINT fk_documentofiscal_veiculo_id FOREIGN KEY (veiculo_id) REFERENCES notafiscal.veiculo(id);


--
-- TOC entry 7273 (class 2606 OID 2383624)
-- Name: duplicatanotaentrada fk_duplicatanotaentrada_notafiscalentrada_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.duplicatanotaentrada
    ADD CONSTRAINT fk_duplicatanotaentrada_notafiscalentrada_id FOREIGN KEY (notafiscalentrada_id) REFERENCES public.notafiscalentrada(id);


--
-- TOC entry 7274 (class 2606 OID 2383629)
-- Name: emailsbackup fk_emailsbackup_parametrobackup_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emailsbackup
    ADD CONSTRAINT fk_emailsbackup_parametrobackup_id FOREIGN KEY (parametrobackup_id) REFERENCES public.parametrobackup(id);


--
-- TOC entry 7275 (class 2606 OID 2383634)
-- Name: emailsbackup fk_emailsbackup_preferencia_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emailsbackup
    ADD CONSTRAINT fk_emailsbackup_preferencia_id FOREIGN KEY (preferencia_id) REFERENCES public.preferencia(id);


--
-- TOC entry 7276 (class 2606 OID 2383639)
-- Name: empresa fk_empresa_clifor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT fk_empresa_clifor_id FOREIGN KEY (clifor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7277 (class 2606 OID 2383644)
-- Name: empresa fk_empresa_municipio_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT fk_empresa_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 7278 (class 2606 OID 2383649)
-- Name: endereco fk_endereco_clientefornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT fk_endereco_clientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7279 (class 2606 OID 2383654)
-- Name: endereco fk_endereco_municipio_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT fk_endereco_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 7280 (class 2606 OID 2383659)
-- Name: entregador fk_entregador_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entregador
    ADD CONSTRAINT fk_entregador_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7281 (class 2606 OID 2383664)
-- Name: entregador fk_entregador_municipio_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entregador
    ADD CONSTRAINT fk_entregador_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 7282 (class 2606 OID 2383669)
-- Name: equipamento fk_equipamento_clientefornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipamento
    ADD CONSTRAINT fk_equipamento_clientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7283 (class 2606 OID 2383674)
-- Name: equipamento fk_equipamento_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipamento
    ADD CONSTRAINT fk_equipamento_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7284 (class 2606 OID 2383679)
-- Name: equipamento fk_equipamento_marca_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipamento
    ADD CONSTRAINT fk_equipamento_marca_id FOREIGN KEY (marca_id) REFERENCES public.marca(id);


--
-- TOC entry 7285 (class 2606 OID 2383684)
-- Name: equipamento fk_equipamento_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipamento
    ADD CONSTRAINT fk_equipamento_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7286 (class 2606 OID 2383689)
-- Name: equipamento fk_equipamento_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipamento
    ADD CONSTRAINT fk_equipamento_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7287 (class 2606 OID 2383694)
-- Name: estado fk_estado_pais_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estado
    ADD CONSTRAINT fk_estado_pais_id FOREIGN KEY (pais_id) REFERENCES public.pais(id);


--
-- TOC entry 7288 (class 2606 OID 2383699)
-- Name: fatorconversaofornecedor fk_fatorconversaofornecedor_fornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fatorconversaofornecedor
    ADD CONSTRAINT fk_fatorconversaofornecedor_fornecedor_id FOREIGN KEY (fornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7289 (class 2606 OID 2383704)
-- Name: fatorconversaofornecedor fk_fatorconversaofornecedor_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fatorconversaofornecedor
    ADD CONSTRAINT fk_fatorconversaofornecedor_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7290 (class 2606 OID 2383709)
-- Name: faturamentomensal fk_faturamentomensal_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faturamentomensal
    ADD CONSTRAINT fk_faturamentomensal_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7291 (class 2606 OID 2383714)
-- Name: formapagamentodelivery fk_formapagamentodelivery_delivery_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodelivery
    ADD CONSTRAINT fk_formapagamentodelivery_delivery_id FOREIGN KEY (delivery_id) REFERENCES public.delivery(id);


--
-- TOC entry 7292 (class 2606 OID 2383719)
-- Name: formapagamentodelivery fk_formapagamentodelivery_maquinacartao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodelivery
    ADD CONSTRAINT fk_formapagamentodelivery_maquinacartao_id FOREIGN KEY (maquinacartao_id) REFERENCES public.maquinacartao(id);


--
-- TOC entry 7293 (class 2606 OID 2383724)
-- Name: formapagamentodelivery fk_formapagamentodelivery_moedaestrangeira_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodelivery
    ADD CONSTRAINT fk_formapagamentodelivery_moedaestrangeira_id FOREIGN KEY (moedaestrangeira_id) REFERENCES public.moeda(id);


--
-- TOC entry 7294 (class 2606 OID 2383729)
-- Name: formapagamentodelivery fk_formapagamentodelivery_movimentacaocreditosaida_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodelivery
    ADD CONSTRAINT fk_formapagamentodelivery_movimentacaocreditosaida_id FOREIGN KEY (movimentacaocreditosaida_id) REFERENCES public.movimentacaocreditosaida(id);


--
-- TOC entry 7295 (class 2606 OID 2383734)
-- Name: formapagamentodelivery fk_formapagamentodelivery_vale_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodelivery
    ADD CONSTRAINT fk_formapagamentodelivery_vale_id FOREIGN KEY (vale_id) REFERENCES public.movimentacaocreditoentrada(id);


--
-- TOC entry 7296 (class 2606 OID 2383739)
-- Name: formapagamentodevolucaoproduto fk_formapagamentodevolucaoproduto_devolucaoproduto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodevolucaoproduto
    ADD CONSTRAINT fk_formapagamentodevolucaoproduto_devolucaoproduto_id FOREIGN KEY (devolucaoproduto_id) REFERENCES public.devolucaotrocaproduto(id);


--
-- TOC entry 7297 (class 2606 OID 2383744)
-- Name: formapagamentodevolucaoproduto fk_formapagamentodevolucaoproduto_maquinacartao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodevolucaoproduto
    ADD CONSTRAINT fk_formapagamentodevolucaoproduto_maquinacartao_id FOREIGN KEY (maquinacartao_id) REFERENCES public.maquinacartao(id);


--
-- TOC entry 7298 (class 2606 OID 2383749)
-- Name: formapagamentodevolucaoproduto fk_formapagamentodevolucaoproduto_moedaestrangeira_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodevolucaoproduto
    ADD CONSTRAINT fk_formapagamentodevolucaoproduto_moedaestrangeira_id FOREIGN KEY (moedaestrangeira_id) REFERENCES public.moeda(id);


--
-- TOC entry 7299 (class 2606 OID 2383754)
-- Name: formapagamentodevolucaoproduto fk_formapagamentodevolucaoproduto_movimentacaocreditosaida_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodevolucaoproduto
    ADD CONSTRAINT fk_formapagamentodevolucaoproduto_movimentacaocreditosaida_id FOREIGN KEY (movimentacaocreditosaida_id) REFERENCES public.movimentacaocreditosaida(id);


--
-- TOC entry 7300 (class 2606 OID 2383759)
-- Name: formapagamentodevolucaoproduto fk_formapagamentodevolucaoproduto_vale_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodevolucaoproduto
    ADD CONSTRAINT fk_formapagamentodevolucaoproduto_vale_id FOREIGN KEY (vale_id) REFERENCES public.movimentacaocreditoentrada(id);


--
-- TOC entry 7301 (class 2606 OID 2383764)
-- Name: formapagamentodocumentofiscal fk_formapagamentodocumentofiscal_documentofiscal_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentodocumentofiscal
    ADD CONSTRAINT fk_formapagamentodocumentofiscal_documentofiscal_id FOREIGN KEY (documentofiscal_id) REFERENCES public.documentofiscal(id);


--
-- TOC entry 7302 (class 2606 OID 2383769)
-- Name: formapagamentoordemservico fk_formapagamentoordemservico_maquinacartao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentoordemservico
    ADD CONSTRAINT fk_formapagamentoordemservico_maquinacartao_id FOREIGN KEY (maquinacartao_id) REFERENCES public.maquinacartao(id);


--
-- TOC entry 7303 (class 2606 OID 2383774)
-- Name: formapagamentoordemservico fk_formapagamentoordemservico_ordemservico_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentoordemservico
    ADD CONSTRAINT fk_formapagamentoordemservico_ordemservico_id FOREIGN KEY (ordemservico_id) REFERENCES public.ordemservico(id);


--
-- TOC entry 7304 (class 2606 OID 2383779)
-- Name: formapagamentopedido fk_formapagamentopedido_maquinacartao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentopedido
    ADD CONSTRAINT fk_formapagamentopedido_maquinacartao_id FOREIGN KEY (maquinacartao_id) REFERENCES public.maquinacartao(id);


--
-- TOC entry 7305 (class 2606 OID 2383784)
-- Name: formapagamentopedido fk_formapagamentopedido_moedaestrangeira_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentopedido
    ADD CONSTRAINT fk_formapagamentopedido_moedaestrangeira_id FOREIGN KEY (moedaestrangeira_id) REFERENCES public.moeda(id);


--
-- TOC entry 7306 (class 2606 OID 2383789)
-- Name: formapagamentopedido fk_formapagamentopedido_movimentacaocreditosaida_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentopedido
    ADD CONSTRAINT fk_formapagamentopedido_movimentacaocreditosaida_id FOREIGN KEY (movimentacaocreditosaida_id) REFERENCES public.movimentacaocreditosaida(id);


--
-- TOC entry 7307 (class 2606 OID 2383794)
-- Name: formapagamentopedido fk_formapagamentopedido_pedido_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentopedido
    ADD CONSTRAINT fk_formapagamentopedido_pedido_id FOREIGN KEY (pedido_id) REFERENCES public.pedido(id);


--
-- TOC entry 7308 (class 2606 OID 2383799)
-- Name: formapagamentopedido fk_formapagamentopedido_vale_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapagamentopedido
    ADD CONSTRAINT fk_formapagamentopedido_vale_id FOREIGN KEY (vale_id) REFERENCES public.movimentacaocreditoentrada(id);


--
-- TOC entry 7309 (class 2606 OID 2383804)
-- Name: funcionario fk_funcionario_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT fk_funcionario_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7310 (class 2606 OID 2383809)
-- Name: funcionario fk_funcionario_municipio_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT fk_funcionario_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 7311 (class 2606 OID 2383814)
-- Name: funcionario fk_funcionario_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT fk_funcionario_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7312 (class 2606 OID 2383819)
-- Name: funcionario fk_funcionario_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT fk_funcionario_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7313 (class 2606 OID 2383824)
-- Name: grupodespesareceita fk_grupodespesareceita_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupodespesareceita
    ADD CONSTRAINT fk_grupodespesareceita_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7314 (class 2606 OID 2383829)
-- Name: grupodespesareceita fk_grupodespesareceita_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupodespesareceita
    ADD CONSTRAINT fk_grupodespesareceita_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7315 (class 2606 OID 2383834)
-- Name: grupoimpressao fk_grupoimpressao_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupoimpressao
    ADD CONSTRAINT fk_grupoimpressao_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7316 (class 2606 OID 2383839)
-- Name: historicoconexaocaixa fk_historicoconexaocaixa_caixa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoconexaocaixa
    ADD CONSTRAINT fk_historicoconexaocaixa_caixa_id FOREIGN KEY (caixa_id) REFERENCES public.caixa(id);


--
-- TOC entry 7317 (class 2606 OID 2383844)
-- Name: historicoconexaocaixa fk_historicoconexaocaixa_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoconexaocaixa
    ADD CONSTRAINT fk_historicoconexaocaixa_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7318 (class 2606 OID 2383849)
-- Name: historicoconexaocaixa fk_historicoconexaocaixa_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoconexaocaixa
    ADD CONSTRAINT fk_historicoconexaocaixa_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 7319 (class 2606 OID 2383854)
-- Name: historicodescricaoproduto fk_historicodescricaoproduto_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicodescricaoproduto
    ADD CONSTRAINT fk_historicodescricaoproduto_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7320 (class 2606 OID 2383859)
-- Name: historicointegracaoproduto fk_historicointegracaoproduto_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicointegracaoproduto
    ADD CONSTRAINT fk_historicointegracaoproduto_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7321 (class 2606 OID 2383864)
-- Name: historicointegracaoproduto fk_historicointegracaoproduto_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicointegracaoproduto
    ADD CONSTRAINT fk_historicointegracaoproduto_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 7322 (class 2606 OID 2383869)
-- Name: historicoprecocompraproduto fk_historicoprecocompraproduto_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoprecocompraproduto
    ADD CONSTRAINT fk_historicoprecocompraproduto_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7323 (class 2606 OID 2383874)
-- Name: historicoprecocompraproduto fk_historicoprecocompraproduto_fornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoprecocompraproduto
    ADD CONSTRAINT fk_historicoprecocompraproduto_fornecedor_id FOREIGN KEY (fornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7324 (class 2606 OID 2383879)
-- Name: historicoprecocompraproduto fk_historicoprecocompraproduto_notaentrada_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoprecocompraproduto
    ADD CONSTRAINT fk_historicoprecocompraproduto_notaentrada_id FOREIGN KEY (notaentrada_id) REFERENCES public.notafiscalentrada(id);


--
-- TOC entry 7325 (class 2606 OID 2383884)
-- Name: historicoprecocompraproduto fk_historicoprecocompraproduto_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoprecocompraproduto
    ADD CONSTRAINT fk_historicoprecocompraproduto_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7326 (class 2606 OID 2383889)
-- Name: historicoprecocompraproduto fk_historicoprecocompraproduto_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoprecocompraproduto
    ADD CONSTRAINT fk_historicoprecocompraproduto_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7327 (class 2606 OID 2383894)
-- Name: historicoprecocompraproduto fk_historicoprecocompraproduto_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoprecocompraproduto
    ADD CONSTRAINT fk_historicoprecocompraproduto_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7328 (class 2606 OID 2383899)
-- Name: historicoprecovendaproduto fk_historicoprecovendaproduto_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoprecovendaproduto
    ADD CONSTRAINT fk_historicoprecovendaproduto_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7329 (class 2606 OID 2383904)
-- Name: historicoprecovendaproduto fk_historicoprecovendaproduto_notafiscalentrada_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoprecovendaproduto
    ADD CONSTRAINT fk_historicoprecovendaproduto_notafiscalentrada_id FOREIGN KEY (notafiscalentrada_id) REFERENCES public.notafiscalentrada(id);


--
-- TOC entry 7330 (class 2606 OID 2383909)
-- Name: historicoprecovendaproduto fk_historicoprecovendaproduto_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoprecovendaproduto
    ADD CONSTRAINT fk_historicoprecovendaproduto_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7331 (class 2606 OID 2383914)
-- Name: historicoprecovendaproduto fk_historicoprecovendaproduto_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoprecovendaproduto
    ADD CONSTRAINT fk_historicoprecovendaproduto_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7332 (class 2606 OID 2383919)
-- Name: historicoprecovendaproduto fk_historicoprecovendaproduto_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historicoprecovendaproduto
    ADD CONSTRAINT fk_historicoprecovendaproduto_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7333 (class 2606 OID 2383924)
-- Name: imagemequipamento fk_imagemequipamento_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagemequipamento
    ADD CONSTRAINT fk_imagemequipamento_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7334 (class 2606 OID 2383929)
-- Name: imagemequipamento fk_imagemequipamento_equipamento_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagemequipamento
    ADD CONSTRAINT fk_imagemequipamento_equipamento_id FOREIGN KEY (equipamento_id) REFERENCES public.equipamento(id);


--
-- TOC entry 7335 (class 2606 OID 2383934)
-- Name: imagemequipamento fk_imagemequipamento_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagemequipamento
    ADD CONSTRAINT fk_imagemequipamento_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7336 (class 2606 OID 2383939)
-- Name: imagemequipamento fk_imagemequipamento_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagemequipamento
    ADD CONSTRAINT fk_imagemequipamento_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7337 (class 2606 OID 2383944)
-- Name: impressaoetiqueta fk_impressaoetiqueta_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.impressaoetiqueta
    ADD CONSTRAINT fk_impressaoetiqueta_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7338 (class 2606 OID 2383949)
-- Name: informacaonutricional fk_informacaonutricional_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.informacaonutricional
    ADD CONSTRAINT fk_informacaonutricional_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7339 (class 2606 OID 2383954)
-- Name: informacaonutricional fk_informacaonutricional_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.informacaonutricional
    ADD CONSTRAINT fk_informacaonutricional_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7340 (class 2606 OID 2383959)
-- Name: informacaonutricional fk_informacaonutricional_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.informacaonutricional
    ADD CONSTRAINT fk_informacaonutricional_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7341 (class 2606 OID 2383964)
-- Name: informacaonutricional fk_informacaonutricional_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.informacaonutricional
    ADD CONSTRAINT fk_informacaonutricional_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7342 (class 2606 OID 2383969)
-- Name: informacaonutricionalextra fk_informacaonutricionalextra_informacaonutricional_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.informacaonutricionalextra
    ADD CONSTRAINT fk_informacaonutricionalextra_informacaonutricional_id FOREIGN KEY (informacaonutricional_id) REFERENCES public.informacaonutricional(id);


--
-- TOC entry 7343 (class 2606 OID 2383974)
-- Name: inutilizacao fk_inutilizacao_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inutilizacao
    ADD CONSTRAINT fk_inutilizacao_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7344 (class 2606 OID 2383979)
-- Name: inutilizacao fk_inutilizacao_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inutilizacao
    ADD CONSTRAINT fk_inutilizacao_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7345 (class 2606 OID 2383984)
-- Name: inutilizacao fk_inutilizacao_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inutilizacao
    ADD CONSTRAINT fk_inutilizacao_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7346 (class 2606 OID 2383989)
-- Name: itemdelivery fk_itemdelivery_delivery_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdelivery
    ADD CONSTRAINT fk_itemdelivery_delivery_id FOREIGN KEY (delivery_id) REFERENCES public.delivery(id);


--
-- TOC entry 7347 (class 2606 OID 2383994)
-- Name: itemdelivery fk_itemdelivery_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdelivery
    ADD CONSTRAINT fk_itemdelivery_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7348 (class 2606 OID 2383999)
-- Name: itemdelivery fk_itemdelivery_kitproduto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdelivery
    ADD CONSTRAINT fk_itemdelivery_kitproduto_id FOREIGN KEY (kitproduto_id) REFERENCES public.produto(id);


--
-- TOC entry 7349 (class 2606 OID 2384004)
-- Name: itemdelivery fk_itemdelivery_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdelivery
    ADD CONSTRAINT fk_itemdelivery_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7350 (class 2606 OID 2384009)
-- Name: itemdevolucaotroca fk_itemdevolucaotroca_devolucaotrocaproduto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdevolucaotroca
    ADD CONSTRAINT fk_itemdevolucaotroca_devolucaotrocaproduto_id FOREIGN KEY (devolucaotrocaproduto_id) REFERENCES public.devolucaotrocaproduto(id);


--
-- TOC entry 7351 (class 2606 OID 2384014)
-- Name: itemdevolucaotroca fk_itemdevolucaotroca_kitproduto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdevolucaotroca
    ADD CONSTRAINT fk_itemdevolucaotroca_kitproduto_id FOREIGN KEY (kitproduto_id) REFERENCES public.produto(id);


--
-- TOC entry 7352 (class 2606 OID 2384019)
-- Name: itemdevolucaotroca fk_itemdevolucaotroca_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdevolucaotroca
    ADD CONSTRAINT fk_itemdevolucaotroca_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7353 (class 2606 OID 2384024)
-- Name: itemdocumentofiscal fk_itemdocumentofiscal_cfop_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdocumentofiscal
    ADD CONSTRAINT fk_itemdocumentofiscal_cfop_id FOREIGN KEY (cfop_id) REFERENCES public.cfop(id);


--
-- TOC entry 7354 (class 2606 OID 2384029)
-- Name: itemdocumentofiscal fk_itemdocumentofiscal_cstcofins_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdocumentofiscal
    ADD CONSTRAINT fk_itemdocumentofiscal_cstcofins_id FOREIGN KEY (cstcofins_id) REFERENCES public.cst(id);


--
-- TOC entry 7355 (class 2606 OID 2384034)
-- Name: itemdocumentofiscal fk_itemdocumentofiscal_csticms_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdocumentofiscal
    ADD CONSTRAINT fk_itemdocumentofiscal_csticms_id FOREIGN KEY (csticms_id) REFERENCES public.cst(id);


--
-- TOC entry 7356 (class 2606 OID 2384039)
-- Name: itemdocumentofiscal fk_itemdocumentofiscal_cstipi_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdocumentofiscal
    ADD CONSTRAINT fk_itemdocumentofiscal_cstipi_id FOREIGN KEY (cstipi_id) REFERENCES public.cst(id);


--
-- TOC entry 7357 (class 2606 OID 2384044)
-- Name: itemdocumentofiscal fk_itemdocumentofiscal_cstpis_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdocumentofiscal
    ADD CONSTRAINT fk_itemdocumentofiscal_cstpis_id FOREIGN KEY (cstpis_id) REFERENCES public.cst(id);


--
-- TOC entry 7358 (class 2606 OID 2384049)
-- Name: itemdocumentofiscal fk_itemdocumentofiscal_documentofiscal_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdocumentofiscal
    ADD CONSTRAINT fk_itemdocumentofiscal_documentofiscal_id FOREIGN KEY (documentofiscal_id) REFERENCES public.documentofiscal(id);


--
-- TOC entry 7359 (class 2606 OID 2384054)
-- Name: itemdocumentofiscal fk_itemdocumentofiscal_naturezareceitacofins_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdocumentofiscal
    ADD CONSTRAINT fk_itemdocumentofiscal_naturezareceitacofins_id FOREIGN KEY (naturezareceitacofins_id) REFERENCES public.tabelacstsped(id);


--
-- TOC entry 7360 (class 2606 OID 2384059)
-- Name: itemdocumentofiscal fk_itemdocumentofiscal_naturezareceitapis_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdocumentofiscal
    ADD CONSTRAINT fk_itemdocumentofiscal_naturezareceitapis_id FOREIGN KEY (naturezareceitapis_id) REFERENCES public.tabelacstsped(id);


--
-- TOC entry 7361 (class 2606 OID 2384064)
-- Name: itemdocumentofiscal fk_itemdocumentofiscal_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdocumentofiscal
    ADD CONSTRAINT fk_itemdocumentofiscal_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7362 (class 2606 OID 2384069)
-- Name: itemdocumentofiscal fk_itemdocumentofiscal_tipoitem_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdocumentofiscal
    ADD CONSTRAINT fk_itemdocumentofiscal_tipoitem_id FOREIGN KEY (tipoitem_id) REFERENCES public.tipoitem(id);


--
-- TOC entry 7363 (class 2606 OID 2384074)
-- Name: itemdocumentofiscal fk_itemdocumentofiscal_unidademedida_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemdocumentofiscal
    ADD CONSTRAINT fk_itemdocumentofiscal_unidademedida_id FOREIGN KEY (unidademedida_id) REFERENCES public.unidademedida(id);


--
-- TOC entry 7364 (class 2606 OID 2384079)
-- Name: itemgrupoimpressao fk_itemgrupoimpressao_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemgrupoimpressao
    ADD CONSTRAINT fk_itemgrupoimpressao_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7365 (class 2606 OID 2384084)
-- Name: itemgrupoimpressao fk_itemgrupoimpressao_grupoimpressao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemgrupoimpressao
    ADD CONSTRAINT fk_itemgrupoimpressao_grupoimpressao_id FOREIGN KEY (grupoimpressao_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7366 (class 2606 OID 2384089)
-- Name: itemgrupoimpressao fk_itemgrupoimpressao_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemgrupoimpressao
    ADD CONSTRAINT fk_itemgrupoimpressao_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7367 (class 2606 OID 2384094)
-- Name: itemkitproduto fk_itemkitproduto_kitproduto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemkitproduto
    ADD CONSTRAINT fk_itemkitproduto_kitproduto_id FOREIGN KEY (kitproduto_id) REFERENCES public.kitproduto(id);


--
-- TOC entry 7368 (class 2606 OID 2384099)
-- Name: itemkitproduto fk_itemkitproduto_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemkitproduto
    ADD CONSTRAINT fk_itemkitproduto_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7369 (class 2606 OID 2384104)
-- Name: itemkitproduto fk_itemkitproduto_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemkitproduto
    ADD CONSTRAINT fk_itemkitproduto_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7370 (class 2606 OID 2384109)
-- Name: itemkitproduto fk_itemkitproduto_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemkitproduto
    ADD CONSTRAINT fk_itemkitproduto_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7371 (class 2606 OID 2384114)
-- Name: itemnotafiscalentrada fk_itemnotafiscalentrada_csticms_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemnotafiscalentrada
    ADD CONSTRAINT fk_itemnotafiscalentrada_csticms_id FOREIGN KEY (csticms_id) REFERENCES public.cst(id);


--
-- TOC entry 7372 (class 2606 OID 2384119)
-- Name: itemnotafiscalentrada fk_itemnotafiscalentrada_cstipi_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemnotafiscalentrada
    ADD CONSTRAINT fk_itemnotafiscalentrada_cstipi_id FOREIGN KEY (cstipi_id) REFERENCES public.cst(id);


--
-- TOC entry 7373 (class 2606 OID 2384124)
-- Name: itemnotafiscalentrada fk_itemnotafiscalentrada_cstpiscofins_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemnotafiscalentrada
    ADD CONSTRAINT fk_itemnotafiscalentrada_cstpiscofins_id FOREIGN KEY (cstpiscofins_id) REFERENCES public.cst(id);


--
-- TOC entry 7374 (class 2606 OID 2384129)
-- Name: itemnotafiscalentrada fk_itemnotafiscalentrada_notafiscalentrada_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemnotafiscalentrada
    ADD CONSTRAINT fk_itemnotafiscalentrada_notafiscalentrada_id FOREIGN KEY (notafiscalentrada_id) REFERENCES public.notafiscalentrada(id);


--
-- TOC entry 7375 (class 2606 OID 2384134)
-- Name: itemnotafiscalentrada fk_itemnotafiscalentrada_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemnotafiscalentrada
    ADD CONSTRAINT fk_itemnotafiscalentrada_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7376 (class 2606 OID 2384139)
-- Name: itemordemservico fk_itemordemservico_ordemservico_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemordemservico
    ADD CONSTRAINT fk_itemordemservico_ordemservico_id FOREIGN KEY (ordemservico_id) REFERENCES public.ordemservico(id);


--
-- TOC entry 7377 (class 2606 OID 2384144)
-- Name: itemordemservico fk_itemordemservico_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemordemservico
    ADD CONSTRAINT fk_itemordemservico_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7378 (class 2606 OID 2384149)
-- Name: itemordemservico fk_itemordemservico_responsavel_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemordemservico
    ADD CONSTRAINT fk_itemordemservico_responsavel_id FOREIGN KEY (responsavel_id) REFERENCES public.funcionario(id);


--
-- TOC entry 7379 (class 2606 OID 2384154)
-- Name: itemordemservico fk_itemordemservico_servico_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemordemservico
    ADD CONSTRAINT fk_itemordemservico_servico_id FOREIGN KEY (servico_id) REFERENCES public.servico(id);


--
-- TOC entry 7380 (class 2606 OID 2384159)
-- Name: itempedido fk_itempedido_faturaitem_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itempedido
    ADD CONSTRAINT fk_itempedido_faturaitem_id FOREIGN KEY (faturaitem_id) REFERENCES public.vendasorigem(id);


--
-- TOC entry 7381 (class 2606 OID 2384164)
-- Name: itempedido fk_itempedido_pedido_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itempedido
    ADD CONSTRAINT fk_itempedido_pedido_id FOREIGN KEY (pedido_id) REFERENCES public.pedido(id);


--
-- TOC entry 7382 (class 2606 OID 2384169)
-- Name: itempedido fk_itempedido_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itempedido
    ADD CONSTRAINT fk_itempedido_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7383 (class 2606 OID 2384174)
-- Name: itempedidocompra fk_itempedidocompra_pedidocompra_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itempedidocompra
    ADD CONSTRAINT fk_itempedidocompra_pedidocompra_id FOREIGN KEY (pedidocompra_id) REFERENCES public.pedidocompra(id);


--
-- TOC entry 7384 (class 2606 OID 2384179)
-- Name: itempedidocompra fk_itempedidocompra_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itempedidocompra
    ADD CONSTRAINT fk_itempedidocompra_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7385 (class 2606 OID 2384184)
-- Name: itempedidocompra fk_itempedidocompra_unidademedidacomercial_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itempedidocompra
    ADD CONSTRAINT fk_itempedidocompra_unidademedidacomercial_id FOREIGN KEY (unidademedidacomercial_id) REFERENCES public.unidademedida(id);


--
-- TOC entry 7386 (class 2606 OID 2384189)
-- Name: kitproduto fk_kitproduto_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kitproduto
    ADD CONSTRAINT fk_kitproduto_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7387 (class 2606 OID 2384194)
-- Name: kitproduto fk_kitproduto_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kitproduto
    ADD CONSTRAINT fk_kitproduto_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7388 (class 2606 OID 2384199)
-- Name: kitproduto fk_kitproduto_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kitproduto
    ADD CONSTRAINT fk_kitproduto_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7389 (class 2606 OID 2384204)
-- Name: kitproduto fk_kitproduto_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kitproduto
    ADD CONSTRAINT fk_kitproduto_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7390 (class 2606 OID 2384209)
-- Name: liquidacaoproduto fk_liquidacaoproduto_departamento_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidacaoproduto
    ADD CONSTRAINT fk_liquidacaoproduto_departamento_id FOREIGN KEY (departamento_id) REFERENCES public.departamento(id);


--
-- TOC entry 7391 (class 2606 OID 2384214)
-- Name: liquidacaoproduto fk_liquidacaoproduto_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidacaoproduto
    ADD CONSTRAINT fk_liquidacaoproduto_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7392 (class 2606 OID 2384219)
-- Name: liquidacaoproduto fk_liquidacaoproduto_marca_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidacaoproduto
    ADD CONSTRAINT fk_liquidacaoproduto_marca_id FOREIGN KEY (marca_id) REFERENCES public.marca(id);


--
-- TOC entry 7396 (class 2606 OID 2384224)
-- Name: liquidacaoproduto_produto fk_liquidacaoproduto_produto_liquidacaoproduto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidacaoproduto_produto
    ADD CONSTRAINT fk_liquidacaoproduto_produto_liquidacaoproduto_id FOREIGN KEY (liquidacaoproduto_id) REFERENCES public.liquidacaoproduto(id);


--
-- TOC entry 7397 (class 2606 OID 2384229)
-- Name: liquidacaoproduto_produto fk_liquidacaoproduto_produto_produtos_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidacaoproduto_produto
    ADD CONSTRAINT fk_liquidacaoproduto_produto_produtos_id FOREIGN KEY (produtos_id) REFERENCES public.produto(id);


--
-- TOC entry 7393 (class 2606 OID 2384234)
-- Name: liquidacaoproduto fk_liquidacaoproduto_subdepartamento_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidacaoproduto
    ADD CONSTRAINT fk_liquidacaoproduto_subdepartamento_id FOREIGN KEY (subdepartamento_id) REFERENCES public.subdepartamento(id);


--
-- TOC entry 7394 (class 2606 OID 2384239)
-- Name: liquidacaoproduto fk_liquidacaoproduto_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidacaoproduto
    ADD CONSTRAINT fk_liquidacaoproduto_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7395 (class 2606 OID 2384244)
-- Name: liquidacaoproduto fk_liquidacaoproduto_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidacaoproduto
    ADD CONSTRAINT fk_liquidacaoproduto_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7398 (class 2606 OID 2384249)
-- Name: maquinacartao fk_maquinacartao_contabancaria_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maquinacartao
    ADD CONSTRAINT fk_maquinacartao_contabancaria_id FOREIGN KEY (contabancaria_id) REFERENCES public.conta(id);


--
-- TOC entry 7399 (class 2606 OID 2384254)
-- Name: maquinacartao fk_maquinacartao_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maquinacartao
    ADD CONSTRAINT fk_maquinacartao_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7400 (class 2606 OID 2384259)
-- Name: maquinacartao fk_maquinacartao_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maquinacartao
    ADD CONSTRAINT fk_maquinacartao_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7401 (class 2606 OID 2384264)
-- Name: maquinacartao fk_maquinacartao_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maquinacartao
    ADD CONSTRAINT fk_maquinacartao_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7402 (class 2606 OID 2384269)
-- Name: marca fk_marca_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marca
    ADD CONSTRAINT fk_marca_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7403 (class 2606 OID 2384274)
-- Name: marca fk_marca_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marca
    ADD CONSTRAINT fk_marca_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7404 (class 2606 OID 2384279)
-- Name: marca fk_marca_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marca
    ADD CONSTRAINT fk_marca_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7405 (class 2606 OID 2384284)
-- Name: modalrodoviariomdfe_motorista fk_modalrodoviariomdfe_motorista_condutor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modalrodoviariomdfe_motorista
    ADD CONSTRAINT fk_modalrodoviariomdfe_motorista_condutor_id FOREIGN KEY (condutor_id) REFERENCES cte.motorista(id);


--
-- TOC entry 7406 (class 2606 OID 2384289)
-- Name: modalrodoviariomdfe_motorista fk_modalrodoviariomdfe_motorista_modalrodoviariomdfe_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modalrodoviariomdfe_motorista
    ADD CONSTRAINT fk_modalrodoviariomdfe_motorista_modalrodoviariomdfe_id FOREIGN KEY (modalrodoviariomdfe_id) REFERENCES manifesto.modalrodoviariomdfe(id);


--
-- TOC entry 7407 (class 2606 OID 2384294)
-- Name: modalrodoviariomdfe_valepedagio fk_modalrodoviariomdfe_valepedagio_modalrodoviariomdfe_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modalrodoviariomdfe_valepedagio
    ADD CONSTRAINT fk_modalrodoviariomdfe_valepedagio_modalrodoviariomdfe_id FOREIGN KEY (modalrodoviariomdfe_id) REFERENCES manifesto.modalrodoviariomdfe(id);


--
-- TOC entry 7408 (class 2606 OID 2384299)
-- Name: modalrodoviariomdfe_valepedagio fk_modalrodoviariomdfe_valepedagio_valepedagio_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modalrodoviariomdfe_valepedagio
    ADD CONSTRAINT fk_modalrodoviariomdfe_valepedagio_valepedagio_id FOREIGN KEY (valepedagio_id) REFERENCES manifesto.valepedagio(id);


--
-- TOC entry 7409 (class 2606 OID 2384304)
-- Name: modalrodoviariomdfe_veiculo fk_modalrodoviariomdfe_veiculo_modalrodoviariomdfe_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modalrodoviariomdfe_veiculo
    ADD CONSTRAINT fk_modalrodoviariomdfe_veiculo_modalrodoviariomdfe_id FOREIGN KEY (modalrodoviariomdfe_id) REFERENCES manifesto.modalrodoviariomdfe(id);


--
-- TOC entry 7410 (class 2606 OID 2384309)
-- Name: modalrodoviariomdfe_veiculo fk_modalrodoviariomdfe_veiculo_veiculoreboque_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modalrodoviariomdfe_veiculo
    ADD CONSTRAINT fk_modalrodoviariomdfe_veiculo_veiculoreboque_id FOREIGN KEY (veiculoreboque_id) REFERENCES cte.veiculo(id);


--
-- TOC entry 7411 (class 2606 OID 2384314)
-- Name: modulo fk_modulo_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modulo
    ADD CONSTRAINT fk_modulo_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7412 (class 2606 OID 2384319)
-- Name: moeda fk_moeda_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moeda
    ADD CONSTRAINT fk_moeda_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7413 (class 2606 OID 2384324)
-- Name: moeda fk_moeda_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moeda
    ADD CONSTRAINT fk_moeda_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7414 (class 2606 OID 2384329)
-- Name: moeda fk_moeda_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moeda
    ADD CONSTRAINT fk_moeda_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7415 (class 2606 OID 2384334)
-- Name: motorista_veiculo fk_motorista_veiculo_motorista_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motorista_veiculo
    ADD CONSTRAINT fk_motorista_veiculo_motorista_id FOREIGN KEY (motorista_id) REFERENCES cte.motorista(id);


--
-- TOC entry 7416 (class 2606 OID 2384339)
-- Name: motorista_veiculo fk_motorista_veiculo_veiculosvinculado_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motorista_veiculo
    ADD CONSTRAINT fk_motorista_veiculo_veiculosvinculado_id FOREIGN KEY (veiculosvinculado_id) REFERENCES cte.veiculo(id);


--
-- TOC entry 7417 (class 2606 OID 2384344)
-- Name: movimentacaocaixa fk_movimentacaocaixa_caixa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocaixa
    ADD CONSTRAINT fk_movimentacaocaixa_caixa_id FOREIGN KEY (caixa_id) REFERENCES public.caixa(id);


--
-- TOC entry 7418 (class 2606 OID 2384349)
-- Name: movimentacaocaixa fk_movimentacaocaixa_devolucaotrocaproduto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocaixa
    ADD CONSTRAINT fk_movimentacaocaixa_devolucaotrocaproduto_id FOREIGN KEY (devolucaotrocaproduto_id) REFERENCES public.devolucaotrocaproduto(id);


--
-- TOC entry 7419 (class 2606 OID 2384354)
-- Name: movimentacaocaixa fk_movimentacaocaixa_duplicataecf_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocaixa
    ADD CONSTRAINT fk_movimentacaocaixa_duplicataecf_id FOREIGN KEY (duplicataecf_id) REFERENCES ecf.duplicatarecebida(id);


--
-- TOC entry 7420 (class 2606 OID 2384359)
-- Name: movimentacaocaixa fk_movimentacaocaixa_duplicatanota_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocaixa
    ADD CONSTRAINT fk_movimentacaocaixa_duplicatanota_id FOREIGN KEY (duplicatanota_id) REFERENCES notafiscal.duplicatapaganota(id);


--
-- TOC entry 7421 (class 2606 OID 2384364)
-- Name: movimentacaocaixa fk_movimentacaocaixa_movimentacaoextorno_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocaixa
    ADD CONSTRAINT fk_movimentacaocaixa_movimentacaoextorno_id FOREIGN KEY (movimentacaoextorno_id) REFERENCES public.movimentacaocaixa(id);


--
-- TOC entry 7422 (class 2606 OID 2384369)
-- Name: movimentacaocaixa fk_movimentacaocaixa_serie; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocaixa
    ADD CONSTRAINT fk_movimentacaocaixa_serie FOREIGN KEY (serie, empresaid, ambiente, tipofaturamento, numero) REFERENCES notafiscal.notafiscal(serie, empresaid, ambiente, tipofaturamento, numero);


--
-- TOC entry 7423 (class 2606 OID 2384374)
-- Name: movimentacaocaixa fk_movimentacaocaixa_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocaixa
    ADD CONSTRAINT fk_movimentacaocaixa_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7424 (class 2606 OID 2384379)
-- Name: movimentacaocreditoentrada fk_movimentacaocreditoentrada_caixaaberto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditoentrada
    ADD CONSTRAINT fk_movimentacaocreditoentrada_caixaaberto_id FOREIGN KEY (caixaaberto_id) REFERENCES public.caixa(id);


--
-- TOC entry 7425 (class 2606 OID 2384384)
-- Name: movimentacaocreditoentrada fk_movimentacaocreditoentrada_creditocliente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditoentrada
    ADD CONSTRAINT fk_movimentacaocreditoentrada_creditocliente_id FOREIGN KEY (creditocliente_id) REFERENCES public.creditocliente(id);


--
-- TOC entry 7426 (class 2606 OID 2384389)
-- Name: movimentacaocreditoentrada fk_movimentacaocreditoentrada_devolucaotrocaproduto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditoentrada
    ADD CONSTRAINT fk_movimentacaocreditoentrada_devolucaotrocaproduto_id FOREIGN KEY (devolucaotrocaproduto_id) REFERENCES public.devolucaotrocaproduto(id);


--
-- TOC entry 7427 (class 2606 OID 2384394)
-- Name: movimentacaocreditoentrada fk_movimentacaocreditoentrada_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditoentrada
    ADD CONSTRAINT fk_movimentacaocreditoentrada_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7428 (class 2606 OID 2384399)
-- Name: movimentacaocreditoentrada fk_movimentacaocreditoentrada_formapagto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditoentrada
    ADD CONSTRAINT fk_movimentacaocreditoentrada_formapagto_id FOREIGN KEY (formapagto_id) REFERENCES ecf.formapagamentocreditocliente(id);


--
-- TOC entry 7429 (class 2606 OID 2384404)
-- Name: movimentacaocreditoentrada fk_movimentacaocreditoentrada_valetroco_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditoentrada
    ADD CONSTRAINT fk_movimentacaocreditoentrada_valetroco_id FOREIGN KEY (valetroco_id) REFERENCES public.movimentacaocreditoentrada(id);


--
-- TOC entry 7430 (class 2606 OID 2384409)
-- Name: movimentacaocreditosaida fk_movimentacaocreditosaida_creditocliente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditosaida
    ADD CONSTRAINT fk_movimentacaocreditosaida_creditocliente_id FOREIGN KEY (creditocliente_id) REFERENCES public.creditocliente(id);


--
-- TOC entry 7431 (class 2606 OID 2384414)
-- Name: movimentacaocreditosaida fk_movimentacaocreditosaida_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditosaida
    ADD CONSTRAINT fk_movimentacaocreditosaida_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7432 (class 2606 OID 2384419)
-- Name: movimentacaocreditosaida fk_movimentacaocreditosaida_formapagamentoauxiliarservico_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditosaida
    ADD CONSTRAINT fk_movimentacaocreditosaida_formapagamentoauxiliarservico_id FOREIGN KEY (formapagamentoauxiliarservico_id) REFERENCES notafiscal.formapagamentoauxiliarservico(id);


--
-- TOC entry 7433 (class 2606 OID 2384424)
-- Name: movimentacaocreditosaida fk_movimentacaocreditosaida_formapagamentoauxvenda_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditosaida
    ADD CONSTRAINT fk_movimentacaocreditosaida_formapagamentoauxvenda_id FOREIGN KEY (formapagamentoauxvenda_id) REFERENCES ecf.formapagamentoauxiliarvenda(id);


--
-- TOC entry 7434 (class 2606 OID 2384429)
-- Name: movimentacaocreditosaida fk_movimentacaocreditosaida_formapagamentocupomfiscal_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditosaida
    ADD CONSTRAINT fk_movimentacaocreditosaida_formapagamentocupomfiscal_id FOREIGN KEY (formapagamentocupomfiscal_id) REFERENCES ecf.formapagamentocupomfiscal(id);


--
-- TOC entry 7435 (class 2606 OID 2384434)
-- Name: movimentacaocreditosaida fk_movimentacaocreditosaida_formapagamentodevolucaoproduto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditosaida
    ADD CONSTRAINT fk_movimentacaocreditosaida_formapagamentodevolucaoproduto_id FOREIGN KEY (formapagamentodevolucaoproduto_id) REFERENCES public.formapagamentodevolucaoproduto(id);


--
-- TOC entry 7436 (class 2606 OID 2384439)
-- Name: movimentacaocreditosaida fk_movimentacaocreditosaida_formapagamentonfce_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditosaida
    ADD CONSTRAINT fk_movimentacaocreditosaida_formapagamentonfce_id FOREIGN KEY (formapagamentonfce_id) REFERENCES notafiscal.formapagamentonfc(id);


--
-- TOC entry 7437 (class 2606 OID 2384444)
-- Name: movimentacaocreditosaida fk_movimentacaocreditosaida_formapagamentonfe_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditosaida
    ADD CONSTRAINT fk_movimentacaocreditosaida_formapagamentonfe_id FOREIGN KEY (formapagamentonfe_id) REFERENCES notafiscal.formapagamentonf(id);


--
-- TOC entry 7438 (class 2606 OID 2384449)
-- Name: movimentacaocreditosaida fk_movimentacaocreditosaida_formapagamentonfse_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacaocreditosaida
    ADD CONSTRAINT fk_movimentacaocreditosaida_formapagamentonfse_id FOREIGN KEY (formapagamentonfse_id) REFERENCES notafiscal.formapagamentonfs(id);


--
-- TOC entry 7439 (class 2606 OID 2384454)
-- Name: movimentoestoque fk_movimentoestoque_clientefornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentoestoque
    ADD CONSTRAINT fk_movimentoestoque_clientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7440 (class 2606 OID 2384459)
-- Name: movimentoestoque fk_movimentoestoque_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentoestoque
    ADD CONSTRAINT fk_movimentoestoque_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7441 (class 2606 OID 2384464)
-- Name: movimentoestoque fk_movimentoestoque_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentoestoque
    ADD CONSTRAINT fk_movimentoestoque_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 7442 (class 2606 OID 2384469)
-- Name: municipio fk_municipio_estado_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT fk_municipio_estado_id FOREIGN KEY (estado_id) REFERENCES public.estado(id);


--
-- TOC entry 7443 (class 2606 OID 2384474)
-- Name: natureza fk_natureza_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.natureza
    ADD CONSTRAINT fk_natureza_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7444 (class 2606 OID 2384479)
-- Name: ncm fk_ncm_pai_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ncm
    ADD CONSTRAINT fk_ncm_pai_id FOREIGN KEY (pai_id) REFERENCES public.ncm(id);


--
-- TOC entry 7446 (class 2606 OID 2384484)
-- Name: notadestinada fk_notadestinada_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notadestinada
    ADD CONSTRAINT fk_notadestinada_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7447 (class 2606 OID 2384489)
-- Name: notadestinada fk_notadestinada_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notadestinada
    ADD CONSTRAINT fk_notadestinada_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 7448 (class 2606 OID 2384494)
-- Name: notadestinada fk_notadestinada_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notadestinada
    ADD CONSTRAINT fk_notadestinada_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7449 (class 2606 OID 2384499)
-- Name: notadestinada fk_notadestinada_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notadestinada
    ADD CONSTRAINT fk_notadestinada_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7450 (class 2606 OID 2384504)
-- Name: notafiscalentrada fk_notafiscalentrada_cliente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notafiscalentrada
    ADD CONSTRAINT fk_notafiscalentrada_cliente_id FOREIGN KEY (cliente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7451 (class 2606 OID 2384509)
-- Name: notafiscalentrada fk_notafiscalentrada_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notafiscalentrada
    ADD CONSTRAINT fk_notafiscalentrada_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7452 (class 2606 OID 2384514)
-- Name: notafiscalentrada fk_notafiscalentrada_fornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notafiscalentrada
    ADD CONSTRAINT fk_notafiscalentrada_fornecedor_id FOREIGN KEY (fornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7453 (class 2606 OID 2384519)
-- Name: notafiscalentrada fk_notafiscalentrada_natureza_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notafiscalentrada
    ADD CONSTRAINT fk_notafiscalentrada_natureza_id FOREIGN KEY (natureza_id) REFERENCES public.cfop(id);


--
-- TOC entry 7454 (class 2606 OID 2384524)
-- Name: notafiscalentrada fk_notafiscalentrada_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notafiscalentrada
    ADD CONSTRAINT fk_notafiscalentrada_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7455 (class 2606 OID 2384529)
-- Name: notafiscalentrada fk_notafiscalentrada_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notafiscalentrada
    ADD CONSTRAINT fk_notafiscalentrada_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7456 (class 2606 OID 2384534)
-- Name: notafiscalentrada fk_notafiscalentrada_usuarioedicao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notafiscalentrada
    ADD CONSTRAINT fk_notafiscalentrada_usuarioedicao_id FOREIGN KEY (usuarioedicao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7457 (class 2606 OID 2384539)
-- Name: ordemservico fk_ordemservico_cliente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordemservico
    ADD CONSTRAINT fk_ordemservico_cliente_id FOREIGN KEY (cliente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7458 (class 2606 OID 2384544)
-- Name: ordemservico fk_ordemservico_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordemservico
    ADD CONSTRAINT fk_ordemservico_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7459 (class 2606 OID 2384549)
-- Name: ordemservico fk_ordemservico_natureza_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordemservico
    ADD CONSTRAINT fk_ordemservico_natureza_id FOREIGN KEY (natureza_id) REFERENCES public.cfop(id);


--
-- TOC entry 7460 (class 2606 OID 2384554)
-- Name: ordemservico fk_ordemservico_orcamento_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordemservico
    ADD CONSTRAINT fk_ordemservico_orcamento_id FOREIGN KEY (orcamento_id) REFERENCES notafiscal.orcamento(id);


--
-- TOC entry 7461 (class 2606 OID 2384559)
-- Name: ordemservico fk_ordemservico_responsavel_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordemservico
    ADD CONSTRAINT fk_ordemservico_responsavel_id FOREIGN KEY (responsavel_id) REFERENCES public.funcionario(id);


--
-- TOC entry 7462 (class 2606 OID 2384564)
-- Name: ordemservico fk_ordemservico_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordemservico
    ADD CONSTRAINT fk_ordemservico_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7463 (class 2606 OID 2384569)
-- Name: ordemservico fk_ordemservico_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordemservico
    ADD CONSTRAINT fk_ordemservico_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7464 (class 2606 OID 2384574)
-- Name: parametrobackup fk_parametrobackup_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrobackup
    ADD CONSTRAINT fk_parametrobackup_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7465 (class 2606 OID 2384579)
-- Name: parametrobeneficiofiscal fk_parametrobeneficiofiscal_estado_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrobeneficiofiscal
    ADD CONSTRAINT fk_parametrobeneficiofiscal_estado_id FOREIGN KEY (estado_id) REFERENCES public.estado(id);


--
-- TOC entry 7466 (class 2606 OID 2384584)
-- Name: parametrobeneficiofiscal fk_parametrobeneficiofiscal_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrobeneficiofiscal
    ADD CONSTRAINT fk_parametrobeneficiofiscal_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7467 (class 2606 OID 2384589)
-- Name: parametrobeneficiofiscal fk_parametrobeneficiofiscal_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrobeneficiofiscal
    ADD CONSTRAINT fk_parametrobeneficiofiscal_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7468 (class 2606 OID 2384594)
-- Name: parametrocadastro fk_parametrocadastro_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrocadastro
    ADD CONSTRAINT fk_parametrocadastro_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7469 (class 2606 OID 2384599)
-- Name: parametrofechamentocaixa fk_parametrofechamentocaixa_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrofechamentocaixa
    ADD CONSTRAINT fk_parametrofechamentocaixa_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7470 (class 2606 OID 2384604)
-- Name: parametroformapagamento fk_parametroformapagamento_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroformapagamento
    ADD CONSTRAINT fk_parametroformapagamento_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7471 (class 2606 OID 2384609)
-- Name: parametroicms fk_parametroicms_estado_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroicms
    ADD CONSTRAINT fk_parametroicms_estado_id FOREIGN KEY (estado_id) REFERENCES public.estado(id);


--
-- TOC entry 7472 (class 2606 OID 2384614)
-- Name: parametroicms fk_parametroicms_parametroncm_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroicms
    ADD CONSTRAINT fk_parametroicms_parametroncm_id FOREIGN KEY (parametroncm_id) REFERENCES public.parametroncm(id);


--
-- TOC entry 7473 (class 2606 OID 2384619)
-- Name: parametroicms fk_parametroicms_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroicms
    ADD CONSTRAINT fk_parametroicms_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7474 (class 2606 OID 2384624)
-- Name: parametroicms fk_parametroicms_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroicms
    ADD CONSTRAINT fk_parametroicms_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7475 (class 2606 OID 2384629)
-- Name: parametroimpressao fk_parametroimpressao_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7476 (class 2606 OID 2384634)
-- Name: parametroimpressao fk_parametroimpressao_grupoimpressaoauxiliarvenda_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_grupoimpressaoauxiliarvenda_id FOREIGN KEY (grupoimpressaoauxiliarvenda_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7477 (class 2606 OID 2384639)
-- Name: parametroimpressao fk_parametroimpressao_grupoimpressaocreditocliente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_grupoimpressaocreditocliente_id FOREIGN KEY (grupoimpressaocreditocliente_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7478 (class 2606 OID 2384644)
-- Name: parametroimpressao fk_parametroimpressao_grupoimpressaodanfe_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_grupoimpressaodanfe_id FOREIGN KEY (grupoimpressaodanfe_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7479 (class 2606 OID 2384649)
-- Name: parametroimpressao fk_parametroimpressao_grupoimpressaodanfenfce_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_grupoimpressaodanfenfce_id FOREIGN KEY (grupoimpressaodanfenfce_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7480 (class 2606 OID 2384654)
-- Name: parametroimpressao fk_parametroimpressao_grupoimpressaodevolucaotroca_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_grupoimpressaodevolucaotroca_id FOREIGN KEY (grupoimpressaodevolucaotroca_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7481 (class 2606 OID 2384659)
-- Name: parametroimpressao fk_parametroimpressao_grupoimpressaoextratocfe_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_grupoimpressaoextratocfe_id FOREIGN KEY (grupoimpressaoextratocfe_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7482 (class 2606 OID 2384664)
-- Name: parametroimpressao fk_parametroimpressao_grupoimpressaoorcamento_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_grupoimpressaoorcamento_id FOREIGN KEY (grupoimpressaoorcamento_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7483 (class 2606 OID 2384669)
-- Name: parametroimpressao fk_parametroimpressao_grupoimpressaoordemservico_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_grupoimpressaoordemservico_id FOREIGN KEY (grupoimpressaoordemservico_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7484 (class 2606 OID 2384674)
-- Name: parametroimpressao fk_parametroimpressao_grupoimpressaopedido_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_grupoimpressaopedido_id FOREIGN KEY (grupoimpressaopedido_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7485 (class 2606 OID 2384679)
-- Name: parametroimpressao fk_parametroimpressao_grupoimpressaopromissoria_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_grupoimpressaopromissoria_id FOREIGN KEY (grupoimpressaopromissoria_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7486 (class 2606 OID 2384684)
-- Name: parametroimpressao fk_parametroimpressao_grupoimpressaorecibo_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_grupoimpressaorecibo_id FOREIGN KEY (grupoimpressaorecibo_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7487 (class 2606 OID 2384689)
-- Name: parametroimpressao fk_parametroimpressao_grupoimpressaotermocondicional_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_grupoimpressaotermocondicional_id FOREIGN KEY (grupoimpressaotermocondicional_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7488 (class 2606 OID 2384694)
-- Name: parametroimpressao fk_parametroimpressao_grupoimpressaovalecompras_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_grupoimpressaovalecompras_id FOREIGN KEY (grupoimpressaovalecompras_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7489 (class 2606 OID 2384699)
-- Name: parametroimpressao fk_parametroimpressao_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7490 (class 2606 OID 2384704)
-- Name: parametroimpressao fk_parametroimpressao_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT fk_parametroimpressao_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7494 (class 2606 OID 2384709)
-- Name: parametrointegracaocontabilidade fk_parametrointegracaocontabilidade_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrointegracaocontabilidade
    ADD CONSTRAINT fk_parametrointegracaocontabilidade_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7495 (class 2606 OID 2384714)
-- Name: parametrointegracaocontabilidade fk_parametrointegracaocontabilidade_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrointegracaocontabilidade
    ADD CONSTRAINT fk_parametrointegracaocontabilidade_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7496 (class 2606 OID 2384719)
-- Name: parametrointegracaocontabilidade fk_parametrointegracaocontabilidade_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrointegracaocontabilidade
    ADD CONSTRAINT fk_parametrointegracaocontabilidade_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7497 (class 2606 OID 2384724)
-- Name: parametroipi fk_parametroipi_parametroncm_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroipi
    ADD CONSTRAINT fk_parametroipi_parametroncm_id FOREIGN KEY (parametroncm_id) REFERENCES public.parametroncm(id);


--
-- TOC entry 7498 (class 2606 OID 2384729)
-- Name: parametroipi fk_parametroipi_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroipi
    ADD CONSTRAINT fk_parametroipi_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7499 (class 2606 OID 2384734)
-- Name: parametroipi fk_parametroipi_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroipi
    ADD CONSTRAINT fk_parametroipi_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7500 (class 2606 OID 2384739)
-- Name: parametroncm fk_parametroncm_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroncm
    ADD CONSTRAINT fk_parametroncm_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7501 (class 2606 OID 2384744)
-- Name: parametroncm fk_parametroncm_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroncm
    ADD CONSTRAINT fk_parametroncm_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7502 (class 2606 OID 2384749)
-- Name: parametronotificacao fk_parametronotificacao_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametronotificacao
    ADD CONSTRAINT fk_parametronotificacao_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7503 (class 2606 OID 2384754)
-- Name: parametronotificacao fk_parametronotificacao_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametronotificacao
    ADD CONSTRAINT fk_parametronotificacao_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 7504 (class 2606 OID 2384759)
-- Name: parametroorcamento fk_parametroorcamento_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroorcamento
    ADD CONSTRAINT fk_parametroorcamento_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7505 (class 2606 OID 2384764)
-- Name: parametroorcamento fk_parametroorcamento_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroorcamento
    ADD CONSTRAINT fk_parametroorcamento_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 7509 (class 2606 OID 2384769)
-- Name: parametroordemservico_checklist fk_parametroordemservico_checklist_parametroordemservico_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroordemservico_checklist
    ADD CONSTRAINT fk_parametroordemservico_checklist_parametroordemservico_id FOREIGN KEY (parametroordemservico_id) REFERENCES public.parametroordemservico(id);


--
-- TOC entry 7506 (class 2606 OID 2384774)
-- Name: parametroordemservico fk_parametroordemservico_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroordemservico
    ADD CONSTRAINT fk_parametroordemservico_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7507 (class 2606 OID 2384779)
-- Name: parametroordemservico fk_parametroordemservico_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroordemservico
    ADD CONSTRAINT fk_parametroordemservico_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7508 (class 2606 OID 2384784)
-- Name: parametroordemservico fk_parametroordemservico_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroordemservico
    ADD CONSTRAINT fk_parametroordemservico_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7510 (class 2606 OID 2384789)
-- Name: parametropiscofins fk_parametropiscofins_parametroncm_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametropiscofins
    ADD CONSTRAINT fk_parametropiscofins_parametroncm_id FOREIGN KEY (parametroncm_id) REFERENCES public.parametroncm(id);


--
-- TOC entry 7511 (class 2606 OID 2384794)
-- Name: parametropiscofins fk_parametropiscofins_tabelacstspedcomercio_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametropiscofins
    ADD CONSTRAINT fk_parametropiscofins_tabelacstspedcomercio_id FOREIGN KEY (tabelacstspedcomercio_id) REFERENCES public.tabelacstsped(id);


--
-- TOC entry 7512 (class 2606 OID 2384799)
-- Name: parametropiscofins fk_parametropiscofins_tabelacstspedentrada_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametropiscofins
    ADD CONSTRAINT fk_parametropiscofins_tabelacstspedentrada_id FOREIGN KEY (tabelacstspedentrada_id) REFERENCES public.tabelacstsped(id);


--
-- TOC entry 7513 (class 2606 OID 2384804)
-- Name: parametropiscofins fk_parametropiscofins_tabelacstspedentradaindustria_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametropiscofins
    ADD CONSTRAINT fk_parametropiscofins_tabelacstspedentradaindustria_id FOREIGN KEY (tabelacstspedentradaindustria_id) REFERENCES public.tabelacstsped(id);


--
-- TOC entry 7514 (class 2606 OID 2384809)
-- Name: parametropiscofins fk_parametropiscofins_tabelacstspedindustria_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametropiscofins
    ADD CONSTRAINT fk_parametropiscofins_tabelacstspedindustria_id FOREIGN KEY (tabelacstspedindustria_id) REFERENCES public.tabelacstsped(id);


--
-- TOC entry 7515 (class 2606 OID 2384814)
-- Name: parametropiscofins fk_parametropiscofins_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametropiscofins
    ADD CONSTRAINT fk_parametropiscofins_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7516 (class 2606 OID 2384819)
-- Name: parametropiscofins fk_parametropiscofins_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametropiscofins
    ADD CONSTRAINT fk_parametropiscofins_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7517 (class 2606 OID 2384824)
-- Name: parametroproduto fk_parametroproduto_cfop_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroproduto
    ADD CONSTRAINT fk_parametroproduto_cfop_id FOREIGN KEY (cfop_id) REFERENCES public.cfop(id);


--
-- TOC entry 7518 (class 2606 OID 2384829)
-- Name: parametroproduto fk_parametroproduto_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroproduto
    ADD CONSTRAINT fk_parametroproduto_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7519 (class 2606 OID 2384834)
-- Name: parametroproduto fk_parametroproduto_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroproduto
    ADD CONSTRAINT fk_parametroproduto_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7520 (class 2606 OID 2384839)
-- Name: parametroproduto fk_parametroproduto_tipoitem_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroproduto
    ADD CONSTRAINT fk_parametroproduto_tipoitem_id FOREIGN KEY (tipoitem_id) REFERENCES public.tipoitem(id);


--
-- TOC entry 7524 (class 2606 OID 2384844)
-- Name: parametrosempresa_cnae fk_parametrosempresa_cnae_cnaes_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrosempresa_cnae
    ADD CONSTRAINT fk_parametrosempresa_cnae_cnaes_id FOREIGN KEY (cnaes_id) REFERENCES public.cnae(id);


--
-- TOC entry 7525 (class 2606 OID 2384849)
-- Name: parametrosempresa_cnae fk_parametrosempresa_cnae_parametrosempresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrosempresa_cnae
    ADD CONSTRAINT fk_parametrosempresa_cnae_parametrosempresa_id FOREIGN KEY (parametrosempresa_id) REFERENCES public.parametrosempresa(id);


--
-- TOC entry 7521 (class 2606 OID 2384854)
-- Name: parametrosempresa fk_parametrosempresa_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrosempresa
    ADD CONSTRAINT fk_parametrosempresa_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7522 (class 2606 OID 2384859)
-- Name: parametrosempresa fk_parametrosempresa_regimetributario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrosempresa
    ADD CONSTRAINT fk_parametrosempresa_regimetributario_id FOREIGN KEY (regimetributario_id) REFERENCES public.regimetributario(id);


--
-- TOC entry 7523 (class 2606 OID 2384864)
-- Name: parametrosempresa fk_parametrosempresa_tributacaogeral_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrosempresa
    ADD CONSTRAINT fk_parametrosempresa_tributacaogeral_id FOREIGN KEY (tributacaogeral_id) REFERENCES public.tributacaogeralempresa(id);


--
-- TOC entry 7526 (class 2606 OID 2384869)
-- Name: parametrosimpostosnfse fk_parametrosimpostosnfse_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrosimpostosnfse
    ADD CONSTRAINT fk_parametrosimpostosnfse_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7527 (class 2606 OID 2384874)
-- Name: parametrosimpostosnfse fk_parametrosimpostosnfse_regimetributario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrosimpostosnfse
    ADD CONSTRAINT fk_parametrosimpostosnfse_regimetributario_id FOREIGN KEY (regimetributario_id) REFERENCES public.regimetributario(id);


--
-- TOC entry 7528 (class 2606 OID 2384879)
-- Name: parametrotecnospeedapi fk_parametrotecnospeedapi_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametrotecnospeedapi
    ADD CONSTRAINT fk_parametrotecnospeedapi_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7529 (class 2606 OID 2384884)
-- Name: parcelapagamentodocumentofiscal fk_parcelapagamentodocumentofiscal_formapagamento_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parcelapagamentodocumentofiscal
    ADD CONSTRAINT fk_parcelapagamentodocumentofiscal_formapagamento_id FOREIGN KEY (formapagamento_id) REFERENCES public.formapagamentodocumentofiscal(id);


--
-- TOC entry 7530 (class 2606 OID 2384889)
-- Name: parcelapagamentoordemservico fk_parcelapagamentoordemservico_formapagamento_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parcelapagamentoordemservico
    ADD CONSTRAINT fk_parcelapagamentoordemservico_formapagamento_id FOREIGN KEY (formapagamento_id) REFERENCES public.formapagamentoordemservico(id);


--
-- TOC entry 7531 (class 2606 OID 2384894)
-- Name: pedido fk_pedido_cliente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_pedido_cliente_id FOREIGN KEY (cliente_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7532 (class 2606 OID 2384899)
-- Name: pedido fk_pedido_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_pedido_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7533 (class 2606 OID 2384904)
-- Name: pedido fk_pedido_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_pedido_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7534 (class 2606 OID 2384909)
-- Name: pedido fk_pedido_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_pedido_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7535 (class 2606 OID 2384914)
-- Name: pedido fk_pedido_vendedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_pedido_vendedor_id FOREIGN KEY (vendedor_id) REFERENCES public.usuario(id);


--
-- TOC entry 7536 (class 2606 OID 2384919)
-- Name: pedidocompra fk_pedidocompra_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidocompra
    ADD CONSTRAINT fk_pedidocompra_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7537 (class 2606 OID 2384924)
-- Name: pedidocompra fk_pedidocompra_fornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidocompra
    ADD CONSTRAINT fk_pedidocompra_fornecedor_id FOREIGN KEY (fornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7538 (class 2606 OID 2384929)
-- Name: pedidocompra fk_pedidocompra_situacaopedido_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidocompra
    ADD CONSTRAINT fk_pedidocompra_situacaopedido_id FOREIGN KEY (situacaopedido_id) REFERENCES public.situacao(id);


--
-- TOC entry 7539 (class 2606 OID 2384934)
-- Name: pedidocompra fk_pedidocompra_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidocompra
    ADD CONSTRAINT fk_pedidocompra_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7540 (class 2606 OID 2384939)
-- Name: pedidocompra fk_pedidocompra_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidocompra
    ADD CONSTRAINT fk_pedidocompra_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7541 (class 2606 OID 2384944)
-- Name: pedidocompra fk_pedidocompra_vendedorfuncionario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidocompra
    ADD CONSTRAINT fk_pedidocompra_vendedorfuncionario_id FOREIGN KEY (vendedorfuncionario_id) REFERENCES public.funcionario(id);


--
-- TOC entry 7542 (class 2606 OID 2384949)
-- Name: preferencia fk_preferencia_cfoppadraonfc_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preferencia
    ADD CONSTRAINT fk_preferencia_cfoppadraonfc_id FOREIGN KEY (cfoppadraonfc_id) REFERENCES public.cfop(id);


--
-- TOC entry 7546 (class 2606 OID 2384954)
-- Name: preferencia_emailsbackup fk_preferencia_emailsbackup_listaemailsbackup_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preferencia_emailsbackup
    ADD CONSTRAINT fk_preferencia_emailsbackup_listaemailsbackup_id FOREIGN KEY (listaemailsbackup_id) REFERENCES public.emailsbackup(id);


--
-- TOC entry 7547 (class 2606 OID 2384959)
-- Name: preferencia_emailsbackup fk_preferencia_emailsbackup_preferencia_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preferencia_emailsbackup
    ADD CONSTRAINT fk_preferencia_emailsbackup_preferencia_id FOREIGN KEY (preferencia_id) REFERENCES public.preferencia(id);


--
-- TOC entry 7543 (class 2606 OID 2384964)
-- Name: preferencia fk_preferencia_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preferencia
    ADD CONSTRAINT fk_preferencia_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7544 (class 2606 OID 2384969)
-- Name: preferencia fk_preferencia_moedapadrao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preferencia
    ADD CONSTRAINT fk_preferencia_moedapadrao_id FOREIGN KEY (moedapadrao_id) REFERENCES public.moeda(id);


--
-- TOC entry 7545 (class 2606 OID 2384974)
-- Name: preferencia fk_preferencia_servicopadrao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preferencia
    ADD CONSTRAINT fk_preferencia_servicopadrao_id FOREIGN KEY (servicopadrao_id) REFERENCES public.servico(id);


--
-- TOC entry 7548 (class 2606 OID 2384979)
-- Name: produto fk_produto_csticms_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT fk_produto_csticms_id FOREIGN KEY (csticms_id) REFERENCES public.cst(id);


--
-- TOC entry 7549 (class 2606 OID 2384984)
-- Name: produto fk_produto_cstipi_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT fk_produto_cstipi_id FOREIGN KEY (cstipi_id) REFERENCES public.cst(id);


--
-- TOC entry 7550 (class 2606 OID 2384989)
-- Name: produto fk_produto_cstpiscofins_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT fk_produto_cstpiscofins_id FOREIGN KEY (cstpiscofins_id) REFERENCES public.cst(id);


--
-- TOC entry 7551 (class 2606 OID 2384994)
-- Name: produto fk_produto_departamento_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT fk_produto_departamento_id FOREIGN KEY (departamento_id) REFERENCES public.departamento(id);


--
-- TOC entry 7552 (class 2606 OID 2384999)
-- Name: produto fk_produto_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT fk_produto_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7553 (class 2606 OID 2385004)
-- Name: produto fk_produto_estadoconsumo_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT fk_produto_estadoconsumo_id FOREIGN KEY (estadoconsumo_id) REFERENCES public.estado(id);


--
-- TOC entry 7554 (class 2606 OID 2385009)
-- Name: produto fk_produto_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT fk_produto_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7555 (class 2606 OID 2385014)
-- Name: produto fk_produto_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT fk_produto_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7556 (class 2606 OID 2385019)
-- Name: produtofornecedor fk_produtofornecedor_clientefornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtofornecedor
    ADD CONSTRAINT fk_produtofornecedor_clientefornecedor_id FOREIGN KEY (clientefornecedor_id) REFERENCES public.clientefornecedor(id);


--
-- TOC entry 7557 (class 2606 OID 2385024)
-- Name: produtofornecedor fk_produtofornecedor_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtofornecedor
    ADD CONSTRAINT fk_produtofornecedor_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7558 (class 2606 OID 2385029)
-- Name: produtofornecedor fk_produtofornecedor_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtofornecedor
    ADD CONSTRAINT fk_produtofornecedor_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7559 (class 2606 OID 2385034)
-- Name: produtotabelapreco fk_produtotabelapreco_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtotabelapreco
    ADD CONSTRAINT fk_produtotabelapreco_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7560 (class 2606 OID 2385039)
-- Name: produtotabelapreco fk_produtotabelapreco_tabelapreco_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtotabelapreco
    ADD CONSTRAINT fk_produtotabelapreco_tabelapreco_id FOREIGN KEY (tabelapreco_id) REFERENCES public.tabelapreco(id);


--
-- TOC entry 7561 (class 2606 OID 2385044)
-- Name: produtotabelapreco fk_produtotabelapreco_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtotabelapreco
    ADD CONSTRAINT fk_produtotabelapreco_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7562 (class 2606 OID 2385049)
-- Name: produtotabelapreco fk_produtotabelapreco_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtotabelapreco
    ADD CONSTRAINT fk_produtotabelapreco_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7563 (class 2606 OID 2385054)
-- Name: promocaoproduto fk_promocaoproduto_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocaoproduto
    ADD CONSTRAINT fk_promocaoproduto_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7564 (class 2606 OID 2385059)
-- Name: promocaoproduto fk_promocaoproduto_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocaoproduto
    ADD CONSTRAINT fk_promocaoproduto_produto_id FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 7565 (class 2606 OID 2385064)
-- Name: promocaoproduto fk_promocaoproduto_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocaoproduto
    ADD CONSTRAINT fk_promocaoproduto_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7566 (class 2606 OID 2385069)
-- Name: promocaoproduto fk_promocaoproduto_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocaoproduto
    ADD CONSTRAINT fk_promocaoproduto_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7567 (class 2606 OID 2385074)
-- Name: seguradora fk_seguradora_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguradora
    ADD CONSTRAINT fk_seguradora_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7568 (class 2606 OID 2385079)
-- Name: seguradora fk_seguradora_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguradora
    ADD CONSTRAINT fk_seguradora_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7569 (class 2606 OID 2385084)
-- Name: seguradora fk_seguradora_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguradora
    ADD CONSTRAINT fk_seguradora_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7570 (class 2606 OID 2385089)
-- Name: servico fk_servico_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servico
    ADD CONSTRAINT fk_servico_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7571 (class 2606 OID 2385094)
-- Name: servico fk_servico_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servico
    ADD CONSTRAINT fk_servico_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7572 (class 2606 OID 2385099)
-- Name: serviconfse fk_serviconfse_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviconfse
    ADD CONSTRAINT fk_serviconfse_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7573 (class 2606 OID 2385104)
-- Name: serviconfse fk_serviconfse_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviconfse
    ADD CONSTRAINT fk_serviconfse_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7574 (class 2606 OID 2385109)
-- Name: situacao fk_situacao_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.situacao
    ADD CONSTRAINT fk_situacao_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7575 (class 2606 OID 2385114)
-- Name: situacao fk_situacao_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.situacao
    ADD CONSTRAINT fk_situacao_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7576 (class 2606 OID 2385119)
-- Name: situacao fk_situacao_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.situacao
    ADD CONSTRAINT fk_situacao_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7577 (class 2606 OID 2385124)
-- Name: situacaocheque fk_situacaocheque_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.situacaocheque
    ADD CONSTRAINT fk_situacaocheque_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7578 (class 2606 OID 2385129)
-- Name: situacaocheque fk_situacaocheque_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.situacaocheque
    ADD CONSTRAINT fk_situacaocheque_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7579 (class 2606 OID 2385134)
-- Name: situacaocheque fk_situacaocheque_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.situacaocheque
    ADD CONSTRAINT fk_situacaocheque_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7580 (class 2606 OID 2385139)
-- Name: statusanotacaopedido fk_statusanotacaopedido_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statusanotacaopedido
    ADD CONSTRAINT fk_statusanotacaopedido_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7581 (class 2606 OID 2385144)
-- Name: statusanotacaopedido fk_statusanotacaopedido_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statusanotacaopedido
    ADD CONSTRAINT fk_statusanotacaopedido_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7582 (class 2606 OID 2385149)
-- Name: statusanotacaopedido fk_statusanotacaopedido_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statusanotacaopedido
    ADD CONSTRAINT fk_statusanotacaopedido_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7583 (class 2606 OID 2385154)
-- Name: subdepartamento fk_subdepartamento_departamento_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subdepartamento
    ADD CONSTRAINT fk_subdepartamento_departamento_id FOREIGN KEY (departamento_id) REFERENCES public.departamento(id);


--
-- TOC entry 7584 (class 2606 OID 2385159)
-- Name: subdepartamento fk_subdepartamento_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subdepartamento
    ADD CONSTRAINT fk_subdepartamento_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7585 (class 2606 OID 2385164)
-- Name: subdepartamento fk_subdepartamento_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subdepartamento
    ADD CONSTRAINT fk_subdepartamento_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7586 (class 2606 OID 2385169)
-- Name: subdepartamento fk_subdepartamento_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subdepartamento
    ADD CONSTRAINT fk_subdepartamento_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7587 (class 2606 OID 2385174)
-- Name: subserviconfse fk_subserviconfse_serviconfse_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subserviconfse
    ADD CONSTRAINT fk_subserviconfse_serviconfse_id FOREIGN KEY (serviconfse_id) REFERENCES public.serviconfse(id);


--
-- TOC entry 7588 (class 2606 OID 2385179)
-- Name: subserviconfse fk_subserviconfse_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subserviconfse
    ADD CONSTRAINT fk_subserviconfse_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7589 (class 2606 OID 2385184)
-- Name: subserviconfse fk_subserviconfse_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subserviconfse
    ADD CONSTRAINT fk_subserviconfse_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7590 (class 2606 OID 2385189)
-- Name: tabelaibpt fk_tabelaibpt_estado_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabelaibpt
    ADD CONSTRAINT fk_tabelaibpt_estado_id FOREIGN KEY (estado_id) REFERENCES public.estado(id);


--
-- TOC entry 7591 (class 2606 OID 2385194)
-- Name: tabelapreco fk_tabelapreco_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabelapreco
    ADD CONSTRAINT fk_tabelapreco_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7594 (class 2606 OID 2385199)
-- Name: tabelapreco_usuario fk_tabelapreco_usuario_tabelapreco_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabelapreco_usuario
    ADD CONSTRAINT fk_tabelapreco_usuario_tabelapreco_id FOREIGN KEY (tabelapreco_id) REFERENCES public.tabelapreco(id);


--
-- TOC entry 7595 (class 2606 OID 2385204)
-- Name: tabelapreco_usuario fk_tabelapreco_usuario_usuarios_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabelapreco_usuario
    ADD CONSTRAINT fk_tabelapreco_usuario_usuarios_id FOREIGN KEY (usuarios_id) REFERENCES public.usuario(id);


--
-- TOC entry 7592 (class 2606 OID 2385209)
-- Name: tabelapreco fk_tabelapreco_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabelapreco
    ADD CONSTRAINT fk_tabelapreco_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7593 (class 2606 OID 2385214)
-- Name: tabelapreco fk_tabelapreco_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabelapreco
    ADD CONSTRAINT fk_tabelapreco_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7596 (class 2606 OID 2385219)
-- Name: tara fk_tara_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tara
    ADD CONSTRAINT fk_tara_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7597 (class 2606 OID 2385224)
-- Name: taxaentrega fk_taxaentrega_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxaentrega
    ADD CONSTRAINT fk_taxaentrega_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7598 (class 2606 OID 2385229)
-- Name: taxaentregabairros fk_taxaentregabairros_municipio_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxaentregabairros
    ADD CONSTRAINT fk_taxaentregabairros_municipio_id FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 7599 (class 2606 OID 2385234)
-- Name: taxaentregabairros fk_taxaentregabairros_taxaentrega_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxaentregabairros
    ADD CONSTRAINT fk_taxaentregabairros_taxaentrega_id FOREIGN KEY (taxaentrega_id) REFERENCES public.taxaentrega(id);


--
-- TOC entry 7600 (class 2606 OID 2385239)
-- Name: tipo fk_tipo_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo
    ADD CONSTRAINT fk_tipo_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7601 (class 2606 OID 2385244)
-- Name: tipo fk_tipo_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo
    ADD CONSTRAINT fk_tipo_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7602 (class 2606 OID 2385249)
-- Name: tipo fk_tipo_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo
    ADD CONSTRAINT fk_tipo_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7603 (class 2606 OID 2385254)
-- Name: tipocontato fk_tipocontato_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipocontato
    ADD CONSTRAINT fk_tipocontato_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7604 (class 2606 OID 2385259)
-- Name: tipocontato fk_tipocontato_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipocontato
    ADD CONSTRAINT fk_tipocontato_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7605 (class 2606 OID 2385264)
-- Name: tipocontato fk_tipocontato_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipocontato
    ADD CONSTRAINT fk_tipocontato_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7606 (class 2606 OID 2385269)
-- Name: tokenintegracao fk_tokenintegracao_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokenintegracao
    ADD CONSTRAINT fk_tokenintegracao_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7607 (class 2606 OID 2385274)
-- Name: tokenintegracao fk_tokenintegracao_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokenintegracao
    ADD CONSTRAINT fk_tokenintegracao_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7608 (class 2606 OID 2385279)
-- Name: tributacaogeralempresa fk_tributacaogeralempresa_cfop_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaogeralempresa
    ADD CONSTRAINT fk_tributacaogeralempresa_cfop_id FOREIGN KEY (cfop_id) REFERENCES public.cfop(id);


--
-- TOC entry 7609 (class 2606 OID 2385284)
-- Name: tributacaogeralempresa fk_tributacaogeralempresa_csticms_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaogeralempresa
    ADD CONSTRAINT fk_tributacaogeralempresa_csticms_id FOREIGN KEY (csticms_id) REFERENCES public.cst(id);


--
-- TOC entry 7610 (class 2606 OID 2385289)
-- Name: tributacaogeralempresa fk_tributacaogeralempresa_cstipi_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaogeralempresa
    ADD CONSTRAINT fk_tributacaogeralempresa_cstipi_id FOREIGN KEY (cstipi_id) REFERENCES public.cst(id);


--
-- TOC entry 7611 (class 2606 OID 2385294)
-- Name: tributacaogeralempresa fk_tributacaogeralempresa_cstpiscofins_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaogeralempresa
    ADD CONSTRAINT fk_tributacaogeralempresa_cstpiscofins_id FOREIGN KEY (cstpiscofins_id) REFERENCES public.cst(id);


--
-- TOC entry 7612 (class 2606 OID 2385299)
-- Name: tributacaogeralempresa fk_tributacaogeralempresa_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaogeralempresa
    ADD CONSTRAINT fk_tributacaogeralempresa_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7613 (class 2606 OID 2385304)
-- Name: tributacaogeralempresa fk_tributacaogeralempresa_tipoitem_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaogeralempresa
    ADD CONSTRAINT fk_tributacaogeralempresa_tipoitem_id FOREIGN KEY (tipoitem_id) REFERENCES public.tipoitem(id);


--
-- TOC entry 7614 (class 2606 OID 2385309)
-- Name: tributacaogeralempresa fk_tributacaogeralempresa_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaogeralempresa
    ADD CONSTRAINT fk_tributacaogeralempresa_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7615 (class 2606 OID 2385314)
-- Name: tributacaogeralempresa fk_tributacaogeralempresa_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaogeralempresa
    ADD CONSTRAINT fk_tributacaogeralempresa_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7616 (class 2606 OID 2385319)
-- Name: tributacaoporncm fk_tributacaoporncm_cfop_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaoporncm
    ADD CONSTRAINT fk_tributacaoporncm_cfop_id FOREIGN KEY (cfop_id) REFERENCES public.cfop(id);


--
-- TOC entry 7617 (class 2606 OID 2385324)
-- Name: tributacaoporncm fk_tributacaoporncm_csticmsusual_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaoporncm
    ADD CONSTRAINT fk_tributacaoporncm_csticmsusual_id FOREIGN KEY (csticmsusual_id) REFERENCES public.cst(id);


--
-- TOC entry 7618 (class 2606 OID 2385329)
-- Name: tributacaoporncm fk_tributacaoporncm_cstipiusual_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaoporncm
    ADD CONSTRAINT fk_tributacaoporncm_cstipiusual_id FOREIGN KEY (cstipiusual_id) REFERENCES public.cst(id);


--
-- TOC entry 7619 (class 2606 OID 2385334)
-- Name: tributacaoporncm fk_tributacaoporncm_cstpiscofinsusual_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaoporncm
    ADD CONSTRAINT fk_tributacaoporncm_cstpiscofinsusual_id FOREIGN KEY (cstpiscofinsusual_id) REFERENCES public.cst(id);


--
-- TOC entry 7620 (class 2606 OID 2385339)
-- Name: tributacaoporncm fk_tributacaoporncm_estado_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaoporncm
    ADD CONSTRAINT fk_tributacaoporncm_estado_id FOREIGN KEY (estado_id) REFERENCES public.estado(id);


--
-- TOC entry 7621 (class 2606 OID 2385344)
-- Name: tributacaoporncm fk_tributacaoporncm_tipoitem_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tributacaoporncm
    ADD CONSTRAINT fk_tributacaoporncm_tipoitem_id FOREIGN KEY (tipoitem_id) REFERENCES public.tipoitem(id);


--
-- TOC entry 7622 (class 2606 OID 2385349)
-- Name: unidademedida fk_unidademedida_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidademedida
    ADD CONSTRAINT fk_unidademedida_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7623 (class 2606 OID 2385354)
-- Name: unidademedida fk_unidademedida_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidademedida
    ADD CONSTRAINT fk_unidademedida_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7624 (class 2606 OID 2385359)
-- Name: usuario fk_usuario_caixa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT fk_usuario_caixa_id FOREIGN KEY (caixa_id) REFERENCES public.caixa(id);


--
-- TOC entry 7625 (class 2606 OID 2385364)
-- Name: usuario fk_usuario_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT fk_usuario_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7626 (class 2606 OID 2385369)
-- Name: usuario fk_usuario_papel_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT fk_usuario_papel_id FOREIGN KEY (papel_id) REFERENCES public.papel(id);


--
-- TOC entry 7627 (class 2606 OID 2385374)
-- Name: usuario fk_usuario_usuarioconexaocaixa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT fk_usuario_usuarioconexaocaixa_id FOREIGN KEY (usuarioconexaocaixa_id) REFERENCES public.usuario(id);


--
-- TOC entry 7628 (class 2606 OID 2385379)
-- Name: usuariocaixa fk_usuariocaixa_caixa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuariocaixa
    ADD CONSTRAINT fk_usuariocaixa_caixa_id FOREIGN KEY (caixa_id) REFERENCES public.caixa(id);


--
-- TOC entry 7629 (class 2606 OID 2385384)
-- Name: usuariocaixa fk_usuariocaixa_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuariocaixa
    ADD CONSTRAINT fk_usuariocaixa_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7630 (class 2606 OID 2385389)
-- Name: usuariocaixa fk_usuariocaixa_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuariocaixa
    ADD CONSTRAINT fk_usuariocaixa_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 7631 (class 2606 OID 2385394)
-- Name: usuarioempresa fk_usuarioempresa_empresa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarioempresa
    ADD CONSTRAINT fk_usuarioempresa_empresa_id FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 7632 (class 2606 OID 2385399)
-- Name: usuarioempresa fk_usuarioempresa_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarioempresa
    ADD CONSTRAINT fk_usuarioempresa_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 7633 (class 2606 OID 2385404)
-- Name: usuarioempresa fk_usuarioempresa_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarioempresa
    ADD CONSTRAINT fk_usuarioempresa_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7634 (class 2606 OID 2385409)
-- Name: usuarioempresa fk_usuarioempresa_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarioempresa
    ADD CONSTRAINT fk_usuarioempresa_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7635 (class 2606 OID 2385414)
-- Name: veiculo_veiculo fk_veiculo_veiculo_veiculocte_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.veiculo_veiculo
    ADD CONSTRAINT fk_veiculo_veiculo_veiculocte_id FOREIGN KEY (veiculocte_id) REFERENCES cte.veiculo(id);


--
-- TOC entry 7636 (class 2606 OID 2385419)
-- Name: veiculo_veiculo fk_veiculo_veiculo_veiculosvinculado_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.veiculo_veiculo
    ADD CONSTRAINT fk_veiculo_veiculo_veiculosvinculado_id FOREIGN KEY (veiculosvinculado_id) REFERENCES cte.veiculo(id);


--
-- TOC entry 7637 (class 2606 OID 2385424)
-- Name: vendasorigem fk_vendasorigem_auxiliarservico_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendasorigem
    ADD CONSTRAINT fk_vendasorigem_auxiliarservico_id FOREIGN KEY (auxiliarservico_id) REFERENCES notafiscal.auxiliarservico(id);


--
-- TOC entry 7638 (class 2606 OID 2385429)
-- Name: vendasorigem fk_vendasorigem_auxiliarvenda_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendasorigem
    ADD CONSTRAINT fk_vendasorigem_auxiliarvenda_id FOREIGN KEY (auxiliarvenda_id) REFERENCES ecf.auxiliarvenda(id);


--
-- TOC entry 7639 (class 2606 OID 2385434)
-- Name: vendasorigem fk_vendasorigem_cupomfiscalsat_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendasorigem
    ADD CONSTRAINT fk_vendasorigem_cupomfiscalsat_id FOREIGN KEY (cupomfiscalsat_id) REFERENCES ecf.cupomfiscal(id);


--
-- TOC entry 7640 (class 2606 OID 2385439)
-- Name: vendasorigem fk_vendasorigem_notafiscalconsumidor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendasorigem
    ADD CONSTRAINT fk_vendasorigem_notafiscalconsumidor_id FOREIGN KEY (notafiscalconsumidor_id) REFERENCES notafiscal.notafiscalconsumidor(id);


--
-- TOC entry 7641 (class 2606 OID 2385444)
-- Name: vendasorigem fk_vendasorigem_notafiscalservico_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendasorigem
    ADD CONSTRAINT fk_vendasorigem_notafiscalservico_id FOREIGN KEY (notafiscalservico_id) REFERENCES notafiscal.notafiscalservico(id);


--
-- TOC entry 7642 (class 2606 OID 2385449)
-- Name: vendasorigem fk_vendasorigem_ordemservico_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendasorigem
    ADD CONSTRAINT fk_vendasorigem_ordemservico_id FOREIGN KEY (ordemservico_id) REFERENCES public.ordemservico(id);


--
-- TOC entry 7643 (class 2606 OID 2385454)
-- Name: vendasorigem fk_vendasorigem_pedido_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendasorigem
    ADD CONSTRAINT fk_vendasorigem_pedido_id FOREIGN KEY (pedido_id) REFERENCES public.pedido(id);


--
-- TOC entry 7644 (class 2606 OID 2385459)
-- Name: vendasorigem fk_vendasorigem_tipofaturamento; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendasorigem
    ADD CONSTRAINT fk_vendasorigem_tipofaturamento FOREIGN KEY (tipofaturamento, empresaid, numero, ambiente, serie) REFERENCES notafiscal.notafiscal(tipofaturamento, empresaid, numero, ambiente, serie);


--
-- TOC entry 7645 (class 2606 OID 2385464)
-- Name: versaosistema fk_versaosistema_usuarioalteracao_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.versaosistema
    ADD CONSTRAINT fk_versaosistema_usuarioalteracao_id FOREIGN KEY (usuarioalteracao_id) REFERENCES public.usuario(id);


--
-- TOC entry 7646 (class 2606 OID 2385469)
-- Name: versaosistema fk_versaosistema_usuariocadastro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.versaosistema
    ADD CONSTRAINT fk_versaosistema_usuariocadastro_id FOREIGN KEY (usuariocadastro_id) REFERENCES public.usuario(id);


--
-- TOC entry 7647 (class 2606 OID 2385474)
-- Name: volumenotafiscalentrada fk_volumenotafiscalentrada_notafiscalentrada_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volumenotafiscalentrada
    ADD CONSTRAINT fk_volumenotafiscalentrada_notafiscalentrada_id FOREIGN KEY (notafiscalentrada_id) REFERENCES public.notafiscalentrada(id);


--
-- TOC entry 7445 (class 2606 OID 2385479)
-- Name: nfconhecimentotransportedocreferenciado nfconhecimentotransportedocreferenciadoconhecimentotransporteid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nfconhecimentotransportedocreferenciado
    ADD CONSTRAINT nfconhecimentotransportedocreferenciadoconhecimentotransporteid FOREIGN KEY (conhecimentotransporte_id) REFERENCES public.conhecimentotransportedocumentoref(id);


--
-- TOC entry 7491 (class 2606 OID 2385484)
-- Name: parametroimpressao parametroimpressao_grupoimpressaorelatoriogerencialauxvendas_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT parametroimpressao_grupoimpressaorelatoriogerencialauxvendas_id FOREIGN KEY (grupoimpressaorelatoriogerencialauxvendas_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7492 (class 2606 OID 2385489)
-- Name: parametroimpressao parametroimpressao_grupoimpressaorelatoriomovimentacaocaixa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT parametroimpressao_grupoimpressaorelatoriomovimentacaocaixa_id FOREIGN KEY (grupoimpressaorelatoriomovimentacaocaixa_id) REFERENCES public.grupoimpressao(id);


--
-- TOC entry 7493 (class 2606 OID 2385494)
-- Name: parametroimpressao parametroimpressaogrupoimpressaorelatorioresumovendasandcaixaid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametroimpressao
    ADD CONSTRAINT parametroimpressaogrupoimpressaorelatorioresumovendasandcaixaid FOREIGN KEY (grupoimpressaorelatorioresumovendasandcaixa_id) REFERENCES public.grupoimpressao(id);

--
-- PostgreSQL database dump complete
--

