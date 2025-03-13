class Empresa < ActiveRecord::Base
  belongs_to :cidade
  has_and_belongs_to_many :users

  validates :cnpj, uniqueness: true

  scope :ativas, -> { where(ativo: true).order(:id) }

  accepts_nested_attributes_for :cidade

  def criar_registros_necessarios
    Formapagamento.create(descricao: 'Boleto - À Vista', parcelado: false, empresa_id: self.id)
    Formapagamento.create(descricao: 'Boleto - Parcelado', parcelado: true, empresa_id: self.id)

    ActiveRecord::Base.connection.execute("insert into jobs (job, empresa_id, filas) values (1, #{self.id}, '{1}')")
    ActiveRecord::Base.connection.execute("insert into jobs (job, empresa_id, filas) values (2, #{self.id}, '{2}')")
    ActiveRecord::Base.connection.execute("insert into jobs (job, empresa_id, filas) values (3, #{self.id}, '{3}')")
    ActiveRecord::Base.connection.execute("insert into jobs (job, empresa_id, filas) values (4, #{self.id}, '{4}')")
    ActiveRecord::Base.connection.execute("insert into jobs (job, empresa_id, filas) values (5, #{self.id}, '{5}')")

    Parametro.create(tipo_fila: 1, senha_master: 'q27pptz8', tempo_inerte: 5, empresa_id: self.id)

    Pacote.replicar_pacote_empresa_origem_destino(1, self.id)
  end
end
