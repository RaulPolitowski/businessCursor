class CreateStatusImplantacaoAcompanhamentoCliente < ActiveRecord::Migration
  def change
   execute <<-SQL
        INSERT INTO public.status(id, descricao, created_at, updated_at, tipo, fechamento, status_empresa, tipo_status, descartada)
        VALUES (40,'AGUARDADO IMPLANTAÇÃO', current_date, current_date, null, false, 5, 2, false);
        INSERT INTO public.status(id, descricao, created_at, updated_at, tipo, fechamento, status_empresa, tipo_status, descartada)
        VALUES (41,'IMPLANTAÇÃO EM ANDAMENTO', current_date, current_date, null, false, 6, 2, false);
        INSERT INTO public.status(id, descricao, created_at, updated_at, tipo, fechamento, status_empresa, tipo_status, descartada)
        VALUES (42,'DESISTENTE', current_date, current_date, null, false, 7, 2, false);
        INSERT INTO public.status(id, descricao, created_at, updated_at, tipo, fechamento, status_empresa, tipo_status, descartada)
        VALUES (43,'IMPLANTAÇÃO CONCLUÍDA', current_date, current_date, null, false, 8, 2, false);
        INSERT INTO public.status(id, descricao, created_at, updated_at, tipo, fechamento, status_empresa, tipo_status, descartada)
        VALUES (44,'EM ACOMPANHAMENTO', current_date, current_date, null, false, 9, 2, false);
        INSERT INTO public.status(id, descricao, created_at, updated_at, tipo, fechamento, status_empresa, tipo_status, descartada)
        VALUES (45,'DESISTENTE', current_date, current_date, null, false, 7, 2, false);
        INSERT INTO public.status(id, descricao, created_at, updated_at, tipo, fechamento, status_empresa, tipo_status, descartada)
        VALUES (46,'EFETIVAÇÃO CONCLUÍDA', current_date, current_date, null, false, 10, 2, false);
    SQL
  end
end
