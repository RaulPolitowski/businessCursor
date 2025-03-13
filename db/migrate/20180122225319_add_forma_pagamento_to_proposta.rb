class AddFormaPagamentoToProposta < ActiveRecord::Migration
  def change
    add_reference :propostas, :formas_pagamento, index: true
  end
end
