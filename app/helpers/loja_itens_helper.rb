module LojaItensHelper
	def self.get_vendas_pendentes_vendedor
		sql = "
			SELECT users.name as vendedor, COUNT(li.user_id) as qtd
			FROM loja_itens li
			INNER JOIN users ON users.id = li.user_id
			WHERE (
				(li.status = 'DISPONIVEL' OR (li.id IS NULL AND li.status IS NULL))
			)
			GROUP BY users.id
			ORDER BY qtd DESC;
		";
	end
end