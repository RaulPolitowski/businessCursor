class Cliente < ActiveRecord::Base
    include PublicActivity::Model

    belongs_to :cidade
    belongs_to :cnae
    belongs_to :escritorio
    belongs_to :empresa
    belongs_to :status
    belongs_to :user_atendimento, class_name: 'User'
    belongs_to :user_negociacao, class_name: 'User'
    belongs_to :tipo_fechamento
    has_many :contatos
    has_many :ligacoes
    has_many :cnae_clientes
    has_many :propostas
    has_many :campanha_envios
    has_one :sistema_terceiros, class_name: 'SistemaTerceiro'
    has_one :fila_empresa
    has_one :negociacao
    has_one :fechamento
    has_one :implantacao
    has_one :acompanhamento
    has_many :pergunta_cliente_respostas
    has_many :anexos, foreign_key: 'anexo_id'


    validates_uniqueness_of :cnpj, :allow_blank => true, :scope => :empresa_id
    validates_uniqueness_of :nire, :allow_blank => true, :scope => :empresa_id

    accepts_nested_attributes_for :cnae, :cidade, :escritorio, :empresa, :status
    accepts_nested_attributes_for :contatos, :allow_destroy => true

    scope :completo, -> { where(ativo: true).where.not(cnpj: nil, razao_social: nil, endereco: nil) }
    scope :incompleto, -> { where(ativo: true).where("((cnpj is null and razao_social is not null) or (cnpj is not null and razao_social is null) or (cnpj is not null and razao_social is not null and endereco is null)) ").order(data_licenca: :asc) }
    scope :incompleto_nire, -> { where(ativo: true).where("((cnpj is null and razao_social is not null) or (cnpj is not null and (razao_social is null))) and nire is not null").order(data_licenca: :asc) }
    scope :cnae_blacklist, -> { joins(' left join cnaes c on clientes.cnae_id = c.id ' +
                                          ' left join cnae_clientes cc on cc.cliente_id = clientes.id ' +
                                          ' left join cnaes ca on cc.cnae_id = ca.id').where('(ca.blacklist is false or c.blacklist is false)') }
    scope :para_ligacao, -> { where(' ((telefone is not null and char_length(telefone) > 0) or (telefone2 is not null and char_length(telefone2) > 0)) ') }
    scope :sem_escritorio, -> { where(escritorio_id: nil) }
    scope :telefone, ->(telefone) { joins('left join contatos on contatos.cliente_id = clientes.id').joins('left join telefones on telefones.contato_id = contatos.id').where("substring(NULLIF(regexp_replace(clientes.telefone, '\\D','','g'), ''), 0, 12) = ? or substring(NULLIF(regexp_replace(clientes.telefone2, '\\D','','g'), ''), 0, 12) = ? or substring(NULLIF(regexp_replace(telefones.telefone, '\\D','','g'), ''), 0, 12) = ?", telefone.gsub(/[^0-9]/, ''), telefone.gsub(/[^0-9]/, ''), telefone.gsub(/[^0-9]/, '')) }
    scope :cliente_escritorios, ->(empresa) { joins(' left join cnaes c on clientes.cnae_id = c.id ' +
                                                        ' left join cnae_clientes cc on cc.cliente_id = clientes.id ' +
                                                        ' left join cnaes ca on cc.cnae_id = ca.id ').where(" (c.codigo like '692%' or ca.codigo like '692%') and clientes.status_id is null and clientes.empresa_id in(#{empresa}) ") }
    scope :fila_principal_empresa, ->(empresa) {
        select('distinct clientes.*').joins('inner join fila_empresas on fila_empresas.cliente_id = clientes.id')
            .where('fila_empresas.empresa_id = ? and fila_empresas.numero_fila in(0,1,2,3,4,15)', empresa) }
    scope :abertos_recentemente, -> { where(ativo: true).where("(clientes.data_licenca between current_date - interval '12 months' and current_date)") }

    ransacker :telefone do
        Arel::Nodes::SqlLiteral.new("regexp_replace(clientes.telefone , '[^0-9]*', '', 'g')")
    end

    ransacker :telefone2 do
        Arel::Nodes::SqlLiteral.new("regexp_replace(clientes.telefone2 , '[^0-9]*', '', 'g') ")
    end

    def cadastro_completo?
        razao_social.present? && cnpj.present? && endereco.present?
    end

    def cpf_formatado
        return '' if cpf.nil?
        cpf.gsub(/(\d{3})(\d{3})(\d{3})(\d{2})/, '\1.\2.\3-\4')
    end

    def responsavel
        contact = contatos.first
        contact.nome unless contact.nil?
    end

    def algum_telefone
        telefone || telefone2
    end

    def formato_correto_telefone
        telefone_formatado = algum_telefone.gsub(/\D/, '')
        telefone_formatado = telefone_formatado[0..1] + '9' + telefone_formatado[2..-1] if telefone_formatado.size < 11
        telefone_formatado = '55' + telefone_formatado
        telefone_formatado
    end

    def telefones_preferenciais
        telefones = Hash.new
        telefones = telefones.merge({telefone => [telefone_preferencial, telefone_enviado_whats]})
        telefones = telefones.merge({telefone2 => [telefone2_preferencial, telefone2_enviado_whats]})

        contatos.each do |contato|
            contato.telefones.each do |telefone|
                begin
                    telefones = telefones.merge({telefone => [preferencial, enviado_whats]})
                rescue

                end
            end
        end
        return telefones
    end

    def self.get_all_activities cliente_id
        act = Array.new
        negociacao = Negociacao.find_by_cliente_id cliente_id

        if negociacao.present?
            activities = PublicActivity::Activity.where(recipient_id: negociacao.id, recipient_type: "Negociacao").order("created_at desc")
            activities.each do |activity|
                act << activity
            end
        end

        implantacao = Implantacao.find_by_cliente_id cliente_id

        if implantacao.present?
            activities = PublicActivity::Activity.where(recipient_id: implantacao.id, recipient_type: "Implantacao").order("created_at desc")
            activities.each do |activity|
                act << activity
            end
        end

        acompanhamento = Acompanhamento.find_by_cliente_id cliente_id

        if acompanhamento.present?
            activities = PublicActivity::Activity.where(recipient_id: acompanhamento.id, recipient_type: "Acompanhamento").order("created_at desc")
            activities.each do |activity|
                act << activity
            end
        end

        return act;
    end

    def atualizarTelefoneContatos(foneNovo, contato)
        begin
            fone = foneNovo.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '')

            if telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').eql? fone
                return
            end
            if telefone2.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').eql? fone
                return
            end

            contatos.each do |cont|
                if cont.telefone && (cont.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').eql? fone)
                    return
                end

                cont.telefones.each do |tel|
                    if tel.telefone.gsub('-', '').gsub('(', '').gsub(')', '').gsub( ' ', '').gsub('/', '').eql? fone
                        return
                    end
                end
            end

            contatos.create(nome: contato, telefone: foneNovo)
        rescue
            return
        end
    end

    def all_telefones
        telefones = {}

        if telefone.present?
            if contatos[0].present? && contatos[0].telefone.nil?
                telefones[telefone] = {identificador: 'telefone',contato:  contatos[0].nome, telefone: telefone, whats: telefone_enviado_whats, preferencial: telefone_preferencial}
            else
                telefones[telefone] = {identificador: 'telefone',contato: 'Empresa', telefone: telefone, whats: telefone_enviado_whats, preferencial: telefone_preferencial}
            end
        end

        if telefone2.present?
            if contatos[1].present? && contatos[1].telefone.nil?
                telefones[telefone2] = {identificador: 'telefone2',contato: contatos[1].nome, telefone: telefone2, whats: telefone2_enviado_whats, preferencial: telefone2_preferencial}
            else
                telefones[telefone2] = {identificador: 'telefone2',contato: 'Empresa', telefone: telefone2, whats: telefone2_enviado_whats, preferencial: telefone2_preferencial}
            end
        end

        
        if contatos.present?
            contatos.each do |contato|
                if contato.telefone.present?
                    telefones[contato.telefone] = {identificador:"contato-#{contato.id}",contato: contato.nome, telefone: contato.telefone, whats: contato.telefone_whats, preferencial: contato.telefone_preferencial}
                end
                contato.telefones.each do |tele|
                    if tele.preferencial?
                        telefones[tele.telefone]= {identificador:"telefone-#{tele.id}",contato: contato.nome, telefone: tele.telefone, whats: tele.enviado_whats, preferencial: tele.preferencial}
                    end
                end
            end
        end
        telefones
    end

    def self.dias_sem_uso(cnpj)
      begin
        company = Api::Company.find_by_cnpj cnpj

        #return 'Sem Info.' unless company.last_login.present?
        return nil unless company.last_login.present?

        ((Time.current - company.last_login).round / 1.day).to_i
      rescue StandardError
        'Sem Info.'
      end
    end

    def ultimo_login
        company = Api::Company.find_by_cnpj cnpj
        return company.last_login || company.created_at
    end

    def registrar_proxima_pesquisa data
        qtd_pesquisas = Pesquisa.where(cliente_id: id, empresa: empresa_id).count

        if qtd_pesquisas == 0
            data = data + 30.days
        else
            data = data + 1.year
        end

        update(proxima_pesquisa: data)
    end

    def sistema_api
        return Cliente.sistema_api_cnpj(cnpj)
    end

    def self.sistema_api_cnpj(cnpj)
        begin
            company = Api::Company.find_by_cnpj cnpj
            return human_system(company.system)
        rescue
            return "SEM INFO."
        end
    end

    def self.human_system(sistema)
        if sistema.present?
            case sistema.upcase
                when /EMISSOR/
                    return "EMISSOR"
                when /LIGHT/
                    return "LIGHT"
                when /MANAGER/
                    return "MANAGER"
                when /GOURMET/
                    return "GOURMET"
                when /ATHUS/
                    return "ATHUS"
                when /FISCAL/
                    return "FISCAL/CONTÁBIL/RH"
                when /PRO VENDAS/
                    return "PRÓ VENDAS"
                when /VENDAS/
                    return "PRÓ VENDAS"
            end
        end
        return "SEM INFO."
    end
end
