class AddEmpresaToFormaPagamento < ActiveRecord::Migration
  def change
    add_reference :formas_pagamento, :empresa, index: true, foreign_key: true
  end
end
