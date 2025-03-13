class AlterInfoStatus < ActiveRecord::Migration
  def change
    execute <<-SQL
      delete from status
      where id not in (1,4, 19, 8, 9, 5, 6, 21, 2, 27, 3, 20, 7);
      
      UPDATE STATUS 
      SET DESCRICAO = 'AGENDADO DEMONSTRAÇÃO'
      WHERE ID = 1 ;
      
      UPDATE STATUS 
      SET DESCRICAO = 'DEMONSTROU INTERESSE'
      WHERE ID = 7 ;
      
      update status
      set status_empresa = 2
      where id in (1, 7);
      
      UPDATE STATUS 
      SET DESCRICAO = 'NÃO TEM INTERESSE'
      WHERE ID = 4 ;
      
      UPDATE STATUS 
      SET DESCRICAO = 'DADOS INCOMPLETOS'
      WHERE ID = 19 ;
      
      UPDATE STATUS 
      SET DESCRICAO = 'SEM CONTATO EFETIVO'
      WHERE ID = 8 ;
      
      UPDATE STATUS 
      SET DESCRICAO = 'SISTEMA ESPECIFICO'
      WHERE ID = 9 ;
      
      update status
      set status_empresa = 3
      where id in (4, 19, 8, 9);
      
      UPDATE STATUS 
      SET DESCRICAO = 'SEM CONTATO, LIGAR MAIS UMA VEZ'
      WHERE ID = 5 ;
      
      UPDATE STATUS 
      SET DESCRICAO = 'RETORNO INICIAL'
      WHERE ID = 6;
      
      UPDATE STATUS 
      SET DESCRICAO = 'CAIU NA CONTABILIDADE'
      WHERE ID = 21;
      
      update status
      set status_empresa = 4
      where id in (5, 6, 21);
      
      UPDATE STATUS 
      SET DESCRICAO = 'FECHADO - 10 DIAS'
      WHERE ID = 2;
      
      UPDATE STATUS 
      SET DESCRICAO = 'FECHADO - 20 DIAS'
      WHERE ID = 27;
      
      UPDATE STATUS 
      SET DESCRICAO = 'FECHADO - 30 DIAS'
      WHERE ID = 3;
      
      UPDATE STATUS 
      SET DESCRICAO = 'FECHADO - EFETIVO'
      WHERE ID = 20;
      
      update status
      set status_empresa = 5
      where id in (2, 27, 3, 20);
      
      update clientes
      set status_empresa = status.status_empresa
      from status
      where clientes.status_id = status.id
        and clientes.status_id is not null;
    SQL
  end
end
