class AlterColumnProposta < ActiveRecord::Migration
  def change
    execute <<-SQL
      alter table propostas alter column valor_implantacao type numeric(14,2) using replace(replace(valor_implantacao, '.', ''), ',', '.')::numeric(14,2);
      alter table propostas alter column valor_mensalidade type numeric(14,2);
    SQL

  end
end
