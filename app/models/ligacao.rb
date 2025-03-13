class Ligacao < ActiveRecord::Base
  belongs_to :agendamento_retorno
  belongs_to :user
  belongs_to :empresa
  belongs_to :cliente
  belongs_to :escritorio
  belongs_to :status_ligacao
  belongs_to :status_cliente, class_name: 'Status'

  def tempo_ligacao
    "#{ (data_fim - data_inicio).round(0) unless data_fim.nil?} seg."
  end

  ransacker :data_inicio do
    Arel::Nodes::SqlLiteral.new("date(data_inicio)")
  end
end
