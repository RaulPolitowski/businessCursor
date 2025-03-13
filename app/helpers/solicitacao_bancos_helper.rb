module SolicitacaoBancosHelper

  def self.parametro_impressao_insert
    "INSERT INTO public.parametroimpressao (
                                            empresa_id,
                                              tipo_impressora_nfce,
                                              tipo_impressora_auxiliar_venda,
                                              tipo_impressora_auxiliar_servico,
                                              tipo_impressora_credito_cliente,
                                              tipo_impressora_devolucao_troca,
                                              tipo_impressora_extrato_cfe,
                                              tipo_impressora_orcamento,
                                              tipo_impressora_ordem_servico,
                                              tipo_impressora_pedido,
                                              tipo_impressora_relatorio_movimentacao_caixa,
                                              tipo_impressora_termo_condicional, tipo_impressora_vale_compra,
                                              imprimir_automaticamente_nfce,
                                              imprimir_automaticamente_nfe,
                                              imprimir_automaticamente_auxiliar_venda,
                                              imprimir_automaticamente_extrato_cfe,
                                              imprimir_automaticamente_credito_cliente,
                                              imprimir_automaticamente_devolucao_troca,
                                              imprimir_automaticamente_orcamento,
                                              imprimir_automaticamente_ordem_servico,
                                              imprimir_automaticamente_pedido,
                                              imprimir_automaticamente_relatorio_gerencial,
                                              imprimir_automaticamente_relatorio_movimentacao_caixa,
                                              imprimir_automaticamente_relatorio_vale,
                                              imprimir_automaticamente_resumos,
                                              imprimir_automaticamente_termo_condicional,
                                              imprimir_canhoto_pedido,
                                              imprimir_codigo_barras_ordem_servico,
                                              margem_left_nfce, margem_left_termo_condicional,
                                              margem_left_auxiliar_venda,
                                              margem_left_pedido,
                                              margem_left_ordem_servico,
                                              margem_left_relatorio_movimentacao_caixa,
                                              margem_left_devolucao_troca,
                                              margem_left_credito_cliente,
                                              margem_left_orcamento,
                                              margem_left_extrato_cfe,
                                              margem_left_vale_compra,
                                              margem_left_relatorio_resumo_caixa,
                                              margem_left_auxiliar_servico,
                                              gerar_relatorio_detalhamento_vendas,
                                              gerar_relatorio_pedido_matricial,
                                              mensagem_termo_pedido,
                                              acionar_guilhotina_automaticamente
                                          )
    SELECT
    empresa_id,
    'IMPRESSAO_80MM',
      'IMPRESSAO_80MM',
      'IMPRESSAO_A4',
      'IMPRESSAO_A4',
      'IMPRESSAO_A4',
      'IMPRESSAO_80MM',
      'IMPRESSAO_A4',
      'IMPRESSAO_A4',
      'IMPRESSAO_A4',
      'IMPRESSAO_80MM',
      'IMPRESSAO_A4',
      'IMPRESSAO_A4',
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      false,
      false,
      'autorizo a execuÃ§Ã£o do(s) serviÃ§o(s) nas condiÃ§Ãµes acima discriminadas.',
      true
    FROM preferencia
    JOIN empresa ON preferencia.empresa_id = empresa.id
    WHERE 0 = (SELECT count(id) FROM parametroimpressao)
    ORDER BY empresa.id;"
  end

  def self.parametro_backup_insert
    "INSERT INTO public.parametrobackup (
    empresa_id,
    backup_antes_atualizacao,
    bkp_apenas_xml,
    bkp_email_contabilidade,
    bkp_documentos_fiscais_automatico_mes,
    enviar_nfe_compra,
    guardar_bkp_ftp,
    limitar_quantidade_total_diretorio,
    limitar_tamanho_diretorio,
    limite_em_giga,
    limite_em_mega,
    quantidade_total_diretorio,
    tamanho_maximo_diretorio,
    emailcontabilidade,
    hora_backup_documentos_fiscais,
    preferencia_id,
    encaminhar_xml_completo)

    SELECT
    empresa_id,
    false,
    false,
    true,
    true,
    false,
    true,
    false,
    false,
    false,
    false,
    NULL,
    2,
    null,
    '00:00:00',
    preferencia.id,
    false
    FROM preferencia
    JOIN empresa ON preferencia.empresa_id = empresa.id
    WHERE 0 = (SELECT count(id) FROM parametrobackup)
    ORDER BY empresa.id; "
  end

  def self.parametro_notificacao
    "INSERT INTO parametronotificacao (layoutnotficacao, transparencianotificacao, temponotificacao, usuario_id, empresa_id)
    SELECT 'PRETO', true, 15, usuario.id, empresa.id
    FROM usuario
    JOIN empresa ON usuario.empresa_id = empresa.id
    WHERE 0 = (SELECT count(id) FROM parametronotificacao)
    ORDER BY
    usuario.id, empresa.id; "
  end

  def self.permissao_usuario_empresa
    "INSERT INTO usuarioempresa (usuario_id, empresa_id)
    SELECT usuario.id, empresa.id FROM usuario JOIN empresa ON TRUE
    WHERE 0 = (SELECT count(id) FROM usuarioempresa)
        ORDER BY empresa.id, usuario.id; "
  end

  def self.modulo_insert(modulo, empresa)
    "INSERT INTO public.modulo(modulo, empresa_id) VALUES ('#{modulo}',#{empresa});"
  end

end
