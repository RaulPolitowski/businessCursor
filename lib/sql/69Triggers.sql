
--
-- TOC entry 7648 (class 2620 OID 2381463)
-- Name: cte trigger_cte_numero; Type: TRIGGER; Schema: cte; Owner: postgres
--

CREATE TRIGGER trigger_cte_numero BEFORE INSERT ON cte.cte FOR EACH ROW EXECUTE PROCEDURE public.atualizar_numero_cte();


--
-- TOC entry 7649 (class 2620 OID 2381464)
-- Name: cte trigger_log_cte; Type: TRIGGER; Schema: cte; Owner: postgres
--

CREATE TRIGGER trigger_log_cte AFTER DELETE OR UPDATE ON cte.cte FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7650 (class 2620 OID 2381465)
-- Name: itemservicolist trigger_log_itemservicolist; Type: TRIGGER; Schema: cte; Owner: postgres
--

CREATE TRIGGER trigger_log_itemservicolist AFTER DELETE OR UPDATE ON cte.itemservicolist FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7651 (class 2620 OID 2381466)
-- Name: lotecte trigger_log_lotecte; Type: TRIGGER; Schema: cte; Owner: postgres
--

CREATE TRIGGER trigger_log_lotecte AFTER DELETE OR UPDATE ON cte.lotecte FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7652 (class 2620 OID 2381467)
-- Name: modalrodoviario trigger_log_modalrodoviario; Type: TRIGGER; Schema: cte; Owner: postgres
--

CREATE TRIGGER trigger_log_modalrodoviario AFTER DELETE OR UPDATE ON cte.modalrodoviario FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7653 (class 2620 OID 2381468)
-- Name: obscontribuintecte trigger_log_obscontribuintecte; Type: TRIGGER; Schema: cte; Owner: postgres
--

CREATE TRIGGER trigger_log_obscontribuintecte AFTER DELETE OR UPDATE ON cte.obscontribuintecte FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7654 (class 2620 OID 2381469)
-- Name: obsfiscocte trigger_log_obsfiscocte; Type: TRIGGER; Schema: cte; Owner: postgres
--

CREATE TRIGGER trigger_log_obsfiscocte AFTER DELETE OR UPDATE ON cte.obsfiscocte FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7655 (class 2620 OID 2381470)
-- Name: seguro trigger_log_seguro; Type: TRIGGER; Schema: cte; Owner: postgres
--

CREATE TRIGGER trigger_log_seguro AFTER DELETE OR UPDATE ON cte.seguro FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7656 (class 2620 OID 2381471)
-- Name: terceiro trigger_log_terceiro; Type: TRIGGER; Schema: cte; Owner: postgres
--

CREATE TRIGGER trigger_log_terceiro AFTER DELETE OR UPDATE ON cte.terceiro FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7657 (class 2620 OID 2381472)
-- Name: tipomedidacte trigger_log_tipomedidacte; Type: TRIGGER; Schema: cte; Owner: postgres
--

CREATE TRIGGER trigger_log_tipomedidacte AFTER DELETE OR UPDATE ON cte.tipomedidacte FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7658 (class 2620 OID 2381473)
-- Name: veiculo trigger_log_veiculo; Type: TRIGGER; Schema: cte; Owner: postgres
--

CREATE TRIGGER trigger_log_veiculo AFTER DELETE OR UPDATE ON cte.veiculo FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7669 (class 2620 OID 2381474)
-- Name: itemconsignacao edicaoitemconsignacaotrigger; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER edicaoitemconsignacaotrigger AFTER UPDATE ON ecf.itemconsignacao FOR EACH ROW EXECUTE PROCEDURE public.atualizaestoqueedicaoconsignacao();


--
-- TOC entry 7661 (class 2620 OID 2381475)
-- Name: consignacao movimentaatualizaestoquecancelamentoconsignacaotrigger; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER movimentaatualizaestoquecancelamentoconsignacaotrigger AFTER UPDATE ON ecf.consignacao FOR EACH ROW EXECUTE PROCEDURE public.movimentaatualizaestoquecancelamentoconsignacao();


--
-- TOC entry 7673 (class 2620 OID 2381476)
-- Name: itemconsignacaodevolucao movimentaatualizaestoquedevolucaoconsignacaotrigger; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER movimentaatualizaestoquedevolucaoconsignacaotrigger AFTER INSERT ON ecf.itemconsignacaodevolucao FOR EACH ROW EXECUTE PROCEDURE public.movimentaatualizaestoquedevolucaoconsignacao();


--
-- TOC entry 7664 (class 2620 OID 2381477)
-- Name: cupomfiscal movimentacaoestoqueaposcancelamentocupomfiscaltrigger; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER movimentacaoestoqueaposcancelamentocupomfiscaltrigger AFTER UPDATE ON ecf.cupomfiscal FOR EACH ROW EXECUTE PROCEDURE public.movimentacaoestoqueaposcancelamentocupomfiscal();


--
-- TOC entry 7665 (class 2620 OID 2381478)
-- Name: cupomfiscal movimentacaoestoqueaposemissaocupomfiscaltrigger; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER movimentacaoestoqueaposemissaocupomfiscaltrigger AFTER UPDATE ON ecf.cupomfiscal FOR EACH ROW EXECUTE PROCEDURE public.movimentacaoestoqueaposemissaocupomfiscal();


--
-- TOC entry 7670 (class 2620 OID 2381479)
-- Name: itemconsignacao movimentoestoqueconsignacaosaidatrigger; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER movimentoestoqueconsignacaosaidatrigger AFTER INSERT ON ecf.itemconsignacao FOR EACH ROW EXECUTE PROCEDURE public.movimentoestoqueconsignacaosaida();


--
-- TOC entry 7659 (class 2620 OID 2381480)
-- Name: auxiliarvenda movimentoestoquedevolucaoauxiliartrigger; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER movimentoestoquedevolucaoauxiliartrigger AFTER UPDATE ON ecf.auxiliarvenda FOR EACH ROW EXECUTE PROCEDURE public.movimentoestoquedevolucaoauxiliar();


--
-- TOC entry 7677 (class 2620 OID 2381481)
-- Name: produtoauxiliarvenda movimentoestoquesaidaauxiliartrigger; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER movimentoestoquesaidaauxiliartrigger AFTER INSERT ON ecf.produtoauxiliarvenda FOR EACH ROW EXECUTE PROCEDURE public.movimentoestoquesaidaauxiliar();


--
-- TOC entry 7671 (class 2620 OID 2381482)
-- Name: itemconsignacao remocaoitemconsignacaotrigger; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER remocaoitemconsignacaotrigger AFTER DELETE ON ecf.itemconsignacao FOR EACH ROW EXECUTE PROCEDURE public.atualizaestoqueremocaoitemconsignacao();


--
-- TOC entry 7660 (class 2620 OID 2381483)
-- Name: auxiliarvenda trigger_log_auxiliarvenda; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER trigger_log_auxiliarvenda AFTER DELETE OR UPDATE ON ecf.auxiliarvenda FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7662 (class 2620 OID 2381484)
-- Name: consignacao trigger_log_consignacao; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER trigger_log_consignacao AFTER DELETE OR UPDATE ON ecf.consignacao FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7663 (class 2620 OID 2381485)
-- Name: consignacaodevolucao trigger_log_consignacaodevolucao; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER trigger_log_consignacaodevolucao AFTER DELETE OR UPDATE ON ecf.consignacaodevolucao FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7666 (class 2620 OID 2381486)
-- Name: cupomfiscal trigger_log_cupomfiscal; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER trigger_log_cupomfiscal AFTER DELETE OR UPDATE ON ecf.cupomfiscal FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7667 (class 2620 OID 2381487)
-- Name: duplicata trigger_log_duplicata; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER trigger_log_duplicata AFTER DELETE OR UPDATE ON ecf.duplicata FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7668 (class 2620 OID 2381488)
-- Name: duplicatarecebida trigger_log_duplicatarecebida; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER trigger_log_duplicatarecebida AFTER DELETE OR UPDATE ON ecf.duplicatarecebida FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7672 (class 2620 OID 2381489)
-- Name: itemconsignacao trigger_log_itemconsignacao; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER trigger_log_itemconsignacao AFTER DELETE OR UPDATE ON ecf.itemconsignacao FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7674 (class 2620 OID 2381490)
-- Name: itemconsignacaodevolucao trigger_log_itemconsignacaodevolucao; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER trigger_log_itemconsignacaodevolucao AFTER DELETE OR UPDATE ON ecf.itemconsignacaodevolucao FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7675 (class 2620 OID 2381491)
-- Name: itemcupomfiscal trigger_log_itemcupomfiscal; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER trigger_log_itemcupomfiscal AFTER DELETE OR UPDATE ON ecf.itemcupomfiscal FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7676 (class 2620 OID 2381492)
-- Name: numeroduplicata trigger_log_numeroduplicata; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER trigger_log_numeroduplicata AFTER DELETE OR UPDATE ON ecf.numeroduplicata FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7678 (class 2620 OID 2381493)
-- Name: produtoauxiliarvenda trigger_log_produtoauxiliarvenda; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER trigger_log_produtoauxiliarvenda AFTER DELETE OR UPDATE ON ecf.produtoauxiliarvenda FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7679 (class 2620 OID 2381494)
-- Name: satfiscal trigger_log_satfiscal; Type: TRIGGER; Schema: ecf; Owner: postgres
--

CREATE TRIGGER trigger_log_satfiscal AFTER DELETE OR UPDATE ON ecf.satfiscal FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7694 (class 2620 OID 2381495)
-- Name: notafiscalconsumidor movimentacaoestoqueaposcancelamentonotaconsumidortrigger; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER movimentacaoestoqueaposcancelamentonotaconsumidortrigger AFTER UPDATE ON notafiscal.notafiscalconsumidor FOR EACH ROW EXECUTE PROCEDURE public.movimentacaoestoqueaposcancelamentonotaconsumidor();


--
-- TOC entry 7691 (class 2620 OID 2381496)
-- Name: notafiscal movimentacaoestoqueaposcancelamentonotatrigger; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER movimentacaoestoqueaposcancelamentonotatrigger AFTER UPDATE ON notafiscal.notafiscal FOR EACH ROW EXECUTE PROCEDURE public.movimentacaoestoqueaposcancelamentonota();


--
-- TOC entry 7695 (class 2620 OID 2381497)
-- Name: notafiscalconsumidor movimentacaoestoqueaposemissaonotaconsumidortrigger; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER movimentacaoestoqueaposemissaonotaconsumidortrigger AFTER UPDATE ON notafiscal.notafiscalconsumidor FOR EACH ROW EXECUTE PROCEDURE public.movimentacaoestoqueaposemissaonotaconsumidor();


--
-- TOC entry 7692 (class 2620 OID 2381498)
-- Name: notafiscal movimentacaoestoqueaposemissaonotatrigger; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER movimentacaoestoqueaposemissaonotatrigger AFTER UPDATE ON notafiscal.notafiscal FOR EACH ROW EXECUTE PROCEDURE public.movimentacaoestoqueaposemissaonota();


--
-- TOC entry 7680 (class 2620 OID 2381499)
-- Name: adicao trigger_log_adicao; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_adicao AFTER DELETE OR UPDATE ON notafiscal.adicao FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7681 (class 2620 OID 2381500)
-- Name: cartacorrecao trigger_log_cartacorrecao; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_cartacorrecao AFTER DELETE OR UPDATE ON notafiscal.cartacorrecao FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7682 (class 2620 OID 2381501)
-- Name: certificadodigital trigger_log_certificadodigital; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_certificadodigital AFTER DELETE OR UPDATE ON notafiscal.certificadodigital FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7683 (class 2620 OID 2381502)
-- Name: declaracaoimportacao trigger_log_declaracaoimportacao; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_declaracaoimportacao AFTER DELETE OR UPDATE ON notafiscal.declaracaoimportacao FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7684 (class 2620 OID 2381503)
-- Name: duplicatanota trigger_log_duplicatanota; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_duplicatanota AFTER DELETE OR UPDATE ON notafiscal.duplicatanota FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7685 (class 2620 OID 2381504)
-- Name: duplicatapaganota trigger_log_duplicatapaganota; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_duplicatapaganota AFTER DELETE OR UPDATE ON notafiscal.duplicatapaganota FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7686 (class 2620 OID 2381505)
-- Name: especievolume trigger_log_especievolume; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_especievolume AFTER DELETE OR UPDATE ON notafiscal.especievolume FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7687 (class 2620 OID 2381506)
-- Name: itemnotafiscal trigger_log_itemnotafiscal; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_itemnotafiscal AFTER DELETE OR UPDATE ON notafiscal.itemnotafiscal FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7688 (class 2620 OID 2381507)
-- Name: itemorcamento trigger_log_itemorcamento; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_itemorcamento AFTER DELETE OR UPDATE ON notafiscal.itemorcamento FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7689 (class 2620 OID 2381508)
-- Name: lotenfce trigger_log_lotenfce; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_lotenfce AFTER DELETE OR UPDATE ON notafiscal.lotenfce FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7690 (class 2620 OID 2381509)
-- Name: lotenfe trigger_log_lotenfe; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_lotenfe AFTER DELETE OR UPDATE ON notafiscal.lotenfe FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7693 (class 2620 OID 2381510)
-- Name: notafiscal trigger_log_notafiscal; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_notafiscal AFTER DELETE OR UPDATE ON notafiscal.notafiscal FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7696 (class 2620 OID 2381511)
-- Name: notafiscalconsumidor trigger_log_notafiscalconsumidor; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_notafiscalconsumidor AFTER DELETE OR UPDATE ON notafiscal.notafiscalconsumidor FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7697 (class 2620 OID 2381512)
-- Name: orcamento trigger_log_orcamento; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_orcamento AFTER DELETE OR UPDATE ON notafiscal.orcamento FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7698 (class 2620 OID 2381513)
-- Name: serie trigger_log_serie; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_serie AFTER DELETE OR UPDATE ON notafiscal.serie FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7699 (class 2620 OID 2381514)
-- Name: transportador trigger_log_transportador; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_transportador AFTER DELETE OR UPDATE ON notafiscal.transportador FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7700 (class 2620 OID 2381515)
-- Name: veiculo trigger_log_veiculo; Type: TRIGGER; Schema: notafiscal; Owner: postgres
--

CREATE TRIGGER trigger_log_veiculo AFTER DELETE OR UPDATE ON notafiscal.veiculo FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7732 (class 2620 OID 2381516)
-- Name: movimentoestoque atualizaestoqueaposentradadeprodutotrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER atualizaestoqueaposentradadeprodutotrigger AFTER INSERT ON public.movimentoestoque FOR EACH ROW EXECUTE PROCEDURE public.atualizaestoqueaposentradadeproduto();


--
-- TOC entry 7724 (class 2620 OID 2381517)
-- Name: itemordemservico atualizarreservaprodutoitemordemservicotrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER atualizarreservaprodutoitemordemservicotrigger AFTER INSERT OR DELETE OR UPDATE ON public.itemordemservico FOR EACH ROW EXECUTE PROCEDURE public.atualizarreservaproduto();


--
-- TOC entry 7726 (class 2620 OID 2381518)
-- Name: itempedido atualizarreservaprodutoitempedidotrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER atualizarreservaprodutoitempedidotrigger AFTER INSERT OR DELETE OR UPDATE ON public.itempedido FOR EACH ROW EXECUTE PROCEDURE public.atualizarreservaproduto();


--
-- TOC entry 7737 (class 2620 OID 2381519)
-- Name: ordemservico atualizarreservaprodutoordemservicotrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER atualizarreservaprodutoordemservicotrigger AFTER DELETE OR UPDATE ON public.ordemservico FOR EACH ROW EXECUTE PROCEDURE public.atualizarreservaprodutoordemservico();


--
-- TOC entry 7752 (class 2620 OID 2381520)
-- Name: pedido atualizarreservaprodutopedidotrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER atualizarreservaprodutopedidotrigger AFTER DELETE OR UPDATE ON public.pedido FOR EACH ROW EXECUTE PROCEDURE public.atualizarreservaprodutopedido();


--
-- TOC entry 7703 (class 2620 OID 2381521)
-- Name: caixa atualizarusuariocaixaabertotrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER atualizarusuariocaixaabertotrigger AFTER INSERT ON public.caixa FOR EACH ROW EXECUTE PROCEDURE public.atualizarusuariocaixaaberto();


--
-- TOC entry 7704 (class 2620 OID 2381522)
-- Name: caixa atualizarusuariocaixafechadotrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER atualizarusuariocaixafechadotrigger AFTER UPDATE ON public.caixa FOR EACH ROW EXECUTE PROCEDURE public.atualizarusuariocaixafechado();


--
-- TOC entry 7701 (class 2620 OID 2381523)
-- Name: anotacaopedido trigger_log_anotacaopedido; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_anotacaopedido AFTER DELETE OR UPDATE ON public.anotacaopedido FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7702 (class 2620 OID 2381524)
-- Name: auditoria trigger_log_auditoria; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_auditoria AFTER DELETE OR UPDATE ON public.auditoria FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7705 (class 2620 OID 2381525)
-- Name: caixa trigger_log_caixa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_caixa AFTER DELETE OR UPDATE ON public.caixa FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7706 (class 2620 OID 2381526)
-- Name: campoadicional trigger_log_campoadicional; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_campoadicional AFTER DELETE OR UPDATE ON public.campoadicional FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7707 (class 2620 OID 2381527)
-- Name: camposadicionaiscliente trigger_log_camposadicionaiscliente; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_camposadicionaiscliente AFTER DELETE OR UPDATE ON public.camposadicionaiscliente FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7708 (class 2620 OID 2381528)
-- Name: cfop trigger_log_cfop; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_cfop AFTER DELETE OR UPDATE ON public.cfop FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7709 (class 2620 OID 2381529)
-- Name: clientefornecedor trigger_log_clientefornecedor; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_clientefornecedor AFTER DELETE OR UPDATE ON public.clientefornecedor FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7710 (class 2620 OID 2381530)
-- Name: clientefornecedor_camposadicionaiscliente trigger_log_clientefornecedor_camposadicionaiscliente; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_clientefornecedor_camposadicionaiscliente AFTER DELETE OR UPDATE ON public.clientefornecedor_camposadicionaiscliente FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7711 (class 2620 OID 2381531)
-- Name: cnae trigger_log_cnae; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_cnae AFTER DELETE OR UPDATE ON public.cnae FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7712 (class 2620 OID 2381532)
-- Name: compromisso trigger_log_compromisso; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_compromisso AFTER DELETE OR UPDATE ON public.compromisso FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7713 (class 2620 OID 2381533)
-- Name: conta trigger_log_conta; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_conta AFTER DELETE OR UPDATE ON public.conta FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7714 (class 2620 OID 2381534)
-- Name: cst trigger_log_cst; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_cst AFTER DELETE OR UPDATE ON public.cst FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7715 (class 2620 OID 2381535)
-- Name: departamento trigger_log_departamento; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_departamento AFTER DELETE OR UPDATE ON public.departamento FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7716 (class 2620 OID 2381536)
-- Name: dependente trigger_log_dependente; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_dependente AFTER DELETE OR UPDATE ON public.dependente FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7717 (class 2620 OID 2381537)
-- Name: empresa trigger_log_empresa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_empresa AFTER DELETE OR UPDATE ON public.empresa FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7718 (class 2620 OID 2381538)
-- Name: estado trigger_log_estado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_estado AFTER DELETE OR UPDATE ON public.estado FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7719 (class 2620 OID 2381539)
-- Name: faturamentomensal trigger_log_faturamentomensal; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_faturamentomensal AFTER DELETE OR UPDATE ON public.faturamentomensal FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7720 (class 2620 OID 2381540)
-- Name: formapagamentoordemservico trigger_log_formapagamentoordemservico; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_formapagamentoordemservico AFTER DELETE OR UPDATE ON public.formapagamentoordemservico FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7721 (class 2620 OID 2381541)
-- Name: funcionario trigger_log_funcionario; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_funcionario AFTER DELETE OR UPDATE ON public.funcionario FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7722 (class 2620 OID 2381542)
-- Name: grupodespesareceita trigger_log_grupodespesareceita; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_grupodespesareceita AFTER DELETE OR UPDATE ON public.grupodespesareceita FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7723 (class 2620 OID 2381543)
-- Name: grupoimpressao trigger_log_grupoimpressao; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_grupoimpressao AFTER DELETE OR UPDATE ON public.grupoimpressao FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7725 (class 2620 OID 2381544)
-- Name: itemordemservico trigger_log_itemordemservico; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_itemordemservico AFTER DELETE OR UPDATE ON public.itemordemservico FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7727 (class 2620 OID 2381545)
-- Name: itempedido trigger_log_itempedido; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_itempedido AFTER DELETE OR UPDATE ON public.itempedido FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7728 (class 2620 OID 2381546)
-- Name: maquinacartao trigger_log_maquinacartao; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_maquinacartao AFTER DELETE OR UPDATE ON public.maquinacartao FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7729 (class 2620 OID 2381547)
-- Name: marca trigger_log_marca; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_marca AFTER DELETE OR UPDATE ON public.marca FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7730 (class 2620 OID 2381548)
-- Name: modulo trigger_log_modulo; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_modulo AFTER DELETE OR UPDATE ON public.modulo FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7731 (class 2620 OID 2381549)
-- Name: movimentacaocaixa trigger_log_movimentacaocaixa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_movimentacaocaixa AFTER DELETE OR UPDATE ON public.movimentacaocaixa FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7733 (class 2620 OID 2381550)
-- Name: movimentoestoque trigger_log_movimentoestoque; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_movimentoestoque AFTER DELETE OR UPDATE ON public.movimentoestoque FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7734 (class 2620 OID 2381551)
-- Name: municipio trigger_log_municipio; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_municipio AFTER DELETE OR UPDATE ON public.municipio FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7735 (class 2620 OID 2381552)
-- Name: natureza trigger_log_natureza; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_natureza AFTER DELETE OR UPDATE ON public.natureza FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7736 (class 2620 OID 2381553)
-- Name: ncm trigger_log_ncm; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_ncm AFTER DELETE OR UPDATE ON public.ncm FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7738 (class 2620 OID 2381554)
-- Name: ordemservico trigger_log_ordemservico; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_ordemservico AFTER DELETE OR UPDATE ON public.ordemservico FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7739 (class 2620 OID 2381555)
-- Name: pais trigger_log_pais; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_pais AFTER DELETE OR UPDATE ON public.pais FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7740 (class 2620 OID 2381556)
-- Name: papel trigger_log_papel; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_papel AFTER DELETE OR UPDATE ON public.papel FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7741 (class 2620 OID 2381557)
-- Name: parametrobackup trigger_log_parametrobackup; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_parametrobackup AFTER DELETE OR UPDATE ON public.parametrobackup FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7742 (class 2620 OID 2381558)
-- Name: parametroicms trigger_log_parametroicms; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_parametroicms AFTER DELETE OR UPDATE ON public.parametroicms FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7743 (class 2620 OID 2381559)
-- Name: parametroimpressao trigger_log_parametroimpressao; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_parametroimpressao AFTER DELETE OR UPDATE ON public.parametroimpressao FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7744 (class 2620 OID 2381560)
-- Name: parametroipi trigger_log_parametroipi; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_parametroipi AFTER DELETE OR UPDATE ON public.parametroipi FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7745 (class 2620 OID 2381561)
-- Name: parametroncm trigger_log_parametroncm; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_parametroncm AFTER DELETE OR UPDATE ON public.parametroncm FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7746 (class 2620 OID 2381562)
-- Name: parametronotificacao trigger_log_parametronotificacao; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_parametronotificacao AFTER DELETE OR UPDATE ON public.parametronotificacao FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7747 (class 2620 OID 2381563)
-- Name: parametropiscofins trigger_log_parametropiscofins; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_parametropiscofins AFTER DELETE OR UPDATE ON public.parametropiscofins FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7748 (class 2620 OID 2381564)
-- Name: parametroproduto trigger_log_parametroproduto; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_parametroproduto AFTER DELETE OR UPDATE ON public.parametroproduto FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7749 (class 2620 OID 2381565)
-- Name: parametrosempresa trigger_log_parametrosempresa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_parametrosempresa AFTER DELETE OR UPDATE ON public.parametrosempresa FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7750 (class 2620 OID 2381566)
-- Name: parametrosempresa_cnae trigger_log_parametrosempresa_cnae; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_parametrosempresa_cnae AFTER DELETE OR UPDATE ON public.parametrosempresa_cnae FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7751 (class 2620 OID 2381567)
-- Name: parcelapagamentoordemservico trigger_log_parcelapagamentoordemservico; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_parcelapagamentoordemservico AFTER DELETE OR UPDATE ON public.parcelapagamentoordemservico FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7753 (class 2620 OID 2381568)
-- Name: pedido trigger_log_pedido; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_pedido AFTER DELETE OR UPDATE ON public.pedido FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7754 (class 2620 OID 2381569)
-- Name: percentualcreditoicms trigger_log_percentualcreditoicms; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_percentualcreditoicms AFTER DELETE OR UPDATE ON public.percentualcreditoicms FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7755 (class 2620 OID 2381570)
-- Name: preferencia trigger_log_preferencia; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_preferencia AFTER DELETE OR UPDATE ON public.preferencia FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7756 (class 2620 OID 2381571)
-- Name: produto trigger_log_produto; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_produto AFTER DELETE OR UPDATE ON public.produto FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7757 (class 2620 OID 2381572)
-- Name: produtofornecedor trigger_log_produtofornecedor; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_produtofornecedor AFTER DELETE OR UPDATE ON public.produtofornecedor FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7758 (class 2620 OID 2381573)
-- Name: regimetributario trigger_log_regimetributario; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_regimetributario AFTER DELETE OR UPDATE ON public.regimetributario FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7759 (class 2620 OID 2381574)
-- Name: servico trigger_log_servico; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_servico AFTER DELETE OR UPDATE ON public.servico FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7760 (class 2620 OID 2381575)
-- Name: serviconfse trigger_log_serviconfse; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_serviconfse AFTER DELETE OR UPDATE ON public.serviconfse FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7761 (class 2620 OID 2381576)
-- Name: situacao trigger_log_situacao; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_situacao AFTER DELETE OR UPDATE ON public.situacao FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7762 (class 2620 OID 2381577)
-- Name: situacaocheque trigger_log_situacaocheque; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_situacaocheque AFTER DELETE OR UPDATE ON public.situacaocheque FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7763 (class 2620 OID 2381578)
-- Name: statusanotacaopedido trigger_log_statusanotacaopedido; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_statusanotacaopedido AFTER DELETE OR UPDATE ON public.statusanotacaopedido FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7764 (class 2620 OID 2381579)
-- Name: subserviconfse trigger_log_subserviconfse; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_subserviconfse AFTER DELETE OR UPDATE ON public.subserviconfse FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7765 (class 2620 OID 2381580)
-- Name: tabelacstsped trigger_log_tabelacstsped; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_tabelacstsped AFTER DELETE OR UPDATE ON public.tabelacstsped FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7766 (class 2620 OID 2381581)
-- Name: tipo trigger_log_tipo; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_tipo AFTER DELETE OR UPDATE ON public.tipo FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7767 (class 2620 OID 2381582)
-- Name: tipocfop trigger_log_tipocfop; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_tipocfop AFTER DELETE OR UPDATE ON public.tipocfop FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7768 (class 2620 OID 2381583)
-- Name: tipoitem trigger_log_tipoitem; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_tipoitem AFTER DELETE OR UPDATE ON public.tipoitem FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7769 (class 2620 OID 2381584)
-- Name: tributacaoporncm trigger_log_tributacaoporncm; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_tributacaoporncm AFTER DELETE OR UPDATE ON public.tributacaoporncm FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7770 (class 2620 OID 2381585)
-- Name: unidademedida trigger_log_unidademedida; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_unidademedida AFTER DELETE OR UPDATE ON public.unidademedida FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7771 (class 2620 OID 2381586)
-- Name: usuario trigger_log_usuario; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_usuario AFTER DELETE OR UPDATE ON public.usuario FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7772 (class 2620 OID 2381587)
-- Name: usuarioempresa trigger_log_usuarioempresa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_usuarioempresa AFTER DELETE OR UPDATE ON public.usuarioempresa FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 7773 (class 2620 OID 2381588)
-- Name: version trigger_log_version; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_version AFTER DELETE OR UPDATE ON public.version FOR EACH ROW EXECUTE PROCEDURE public.logecf();


--
-- TOC entry 6866 (class 2606 OID 2381589)
-- Name: cartacorrecaocte fk_cartacorrecaocte_cte_id; Type: FK CONSTRAINT; Schema: cte; Owner: postgres
--