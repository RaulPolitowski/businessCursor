module ContratosHelper
    def self.contrato_tags
        return [{ descricao: 'Razão social', valor: 'razao_social' }, 
               { descricao: 'CNPJ', valor: 'cnpj' },
               { descricao: 'Nome Fantasia', valor: 'nome_fantasia'},
               { descricao: 'CNAE', valor: 'cnae_id'},
            #    { descricao: 'Endereço', valor: 'endereco'},
            #    { descricao: 'Número', valor: 'numero_endereco'},
            #    { descricao: 'Complemento', valor: 'complemento'},
            #    { descricao: 'Bairro', valor: 'bairro'},
               { descricao: 'Cidade', valor: 'cidade_id'},
               { descricao: 'Tipo de mensalidade', valor: 'tipo_mensalidade'},
               { descricao: 'Valor da mensalidade', valor: 'valor_mensalidade'},
               { descricao: 'Tipo de implantação', valor: 'tipo_implantacao'},
               { descricao: 'Valor da implantação', valor: 'valor_implantacao'},
               { descricao: 'Quantidade de parcelas', valor: 'qtde_parcela'},
               { descricao: 'Valor das parcelas', valor: 'valor_parcelas'},
               { descricao: 'Forma de pagamento', valor: 'formas_pagamento_id'},
               { descricao: 'Quantidade de Maquinas', valor: 'qtd_maquinas'},
               { descricao: 'Sistema ofertado', valor: 'sistema'},
               { descricao: 'Contato na empresa', valor: 'nome_contato'},
               { descricao: 'Contato na Empresa Assinatura', valor: 'nome_contato_assinatura'},
               # { descricao: 'Contato função', valor: 'funcao'},
               { descricao: 'Data atual', valor: 'data_atual'},
               { descricao: 'Mensalidade por extenso', valor: 'mensalidade_extenso'},
               { descricao: 'Implantação por extenso', valor: 'implantacao_extenso'},
               { descricao: 'Meses fidelidade', valor: 'meses_fidelidade'},
               { descricao: 'Fidelidade por extenso', valor: 'meses_fidelidade_extenso'},
               { descricao: 'Dia de vencimento', valor: 'dia_vencimento_mensalidade'},
               { descricao: 'German Tech Sistemas', valor: 'german_tech'},
               { descricao: 'Cpf contratante', valor: 'cpf_contratante'},
            ]
        
    end


    def self.conversao(cliente, proposta)
        pagamento = Formapagamento.find_by_id proposta.formas_pagamento_id
        cnpj = ApplicationHelper.mascara_cnpj(cliente.cnpj)
        contato = Contato.find_by_cliente_id cliente.id
        #quando pegava o primeiro contato sendo socio admin... agora tem uma coluna especifica cad cliente
        # nome_resp = nil
        # funcao_resp = nil
        # if contato.present?
        #     nome_resp = contato.nome
            
        #     if contato.funcao.present?
        #         aux = contato.funcao.split('-') 
        #         funcao_resp = aux[1].present? ? aux[1] : aux 
        #     else
        #         funcao_resp = ""
        #     end
        # else
        #     nome_resp = ''
        #     funcao_resp = ''
        # end

        qtd_parcela = proposta.qtde_parcela.present? ? proposta.qtde_parcela : 0
        value_parcela = proposta.valor_parcelas.present? ? ActionController::Base.helpers.number_to_currency(proposta.valor_parcelas, :unit => "R$ ", :separator => ",", :delimiter => ".") : "R$ 0,00"

        valor_extenso_impl = nil
        if (proposta.valor_implantacao.eql? 0) || (proposta.valor_implantacao.eql? nil)
            valor_extenso_impl = "zero"
        else
            valor_extenso_impl = Extenso.numero(proposta.valor_implantacao.to_i)
        end

        meses_fidelidade_extenso = "zero"
        if proposta.meses_fidelidade != 0 && proposta.meses_fidelidade != nil
            meses_fidelidade_extenso = Extenso.numero(proposta.meses_fidelidade.to_i)
        end

        dia_vencimento = (proposta.data_primeira_mensalidade.present? ? proposta.data_primeira_mensalidade.day.to_s.rjust(2, '0') : '05')
        dia_vencimento_mensalidade = "#{dia_vencimento} (#{Extenso.numero(dia_vencimento.to_i)})"

        return { razao_social: cliente.razao_social,
                 cnpj: cnpj,
                 nome_fantasia: cliente.nome_fantasia,
                 porte: cliente.porte,
                 cnae_id: cliente.cnae.descricao,
                #  endereco: cliente.endereco,
                #  numero_endereco: cliente.numero_endereco,
                #  complemento: cliente.complemento,
                #  bairro: cliente.bairro,
                #  cep: cliente.cep,
                 cidade_id: cliente.cidade.descricao_completa,
                 tipo_mensalidade: proposta.tipo_mensalidade,
                 valor_mensalidade: ActionController::Base.helpers.number_to_currency(proposta.valor_mensalidade, :unit => "R$ ", :separator => ",", :delimiter => "."),
                 tipo_implantacao: proposta.tipo_implantacao,
                 valor_implantacao: ActionController::Base.helpers.number_to_currency(proposta.valor_implantacao, :unit => "R$ ", :separator => ",", :delimiter => "."),
                 qtde_parcela: qtd_parcela,
                 valor_parcelas: value_parcela,
                 formas_pagamento_id: (pagamento.present? ? pagamento.descricao : ""),
                 qtd_maquinas: proposta.qtd_maquinas ? proposta.qtd_maquinas : 3,
                 sistema: proposta.pacote.sistema.nome,
                 # funcao: funcao_resp,
                 data_atual:  (I18n.l Date.today, :format => :long),
                 mensalidade_extenso:  Extenso.numero(proposta.valor_mensalidade.to_i),
                 implantacao_extenso:  valor_extenso_impl,
                 nome_contato: cliente.socio_admin.strip,
                 nome_contato_assinatura: "
                                    <span style='display: inline-block; word-break: break-word; width: 300px; text-align: center;'>
                                        #{cliente.socio_admin}
                                    </span>
                                ",
                 german_tech: "
                 <span style='position: absolute;'>
                    GERMAN TECH TECNOLOGIA LTDA
                 </span>",
                 meses_fidelidade: proposta.meses_fidelidade,
                 meses_fidelidade_extenso: meses_fidelidade_extenso,
                 dia_vencimento_mensalidade: dia_vencimento_mensalidade,
                 cpf_contratante: cliente.cpf_formatado || '-'
                }
    end
    
end
