class AddMsgWhatsToParametro < ActiveRecord::Migration
  def change
    add_column :parametros, :msg_whats, :string
  end
end
