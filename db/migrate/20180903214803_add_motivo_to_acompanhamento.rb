class AddMotivoToAcompanhamento < ActiveRecord::Migration
  def change
    add_column :acompanhamentos, :motivo, :string
    add_column :acompanhamentos, :user_cancelamento_id, :int
  end
end
