/*
Selecionar todos os motoristas que pilotam são capazes de pilotar todos os veículos

Atende: cláusula IN, EXISTS, divisão e pelo menos 3 tabelas
*/

select idFuncionario_SPK from Motorista as M where not exists (
	select id from TipoVeiculo as TV where id not in (
		select idTipoVeiculo_FK from Pilota as P 
        where 
        TV.id = P.idTipoVeiculo_FK and 
        M.idFuncionario_SPK = P.idMotorista_FK
    )
);




/*
As operações INTERSECT e MINUS não existem no MySQL e são comumente substituídas por IN e NOT IN respectivamente.
Usaremos então a função UNION

O RH para fins de pesquisa precisa do email de 2 funcionários para cada faixa salarial.
Listar, no máximo 2 emails de funcionários para cada uma das três faixas salariais acompanhado de sua faixa salarial

Atende: Union
*/


(SELECT emailFuncionario, 1 as FaixaSalarial from Funcionario where salario BETWEEN 1000 and 10000 limit 2) 
UNION
(SELECT emailFuncionario, 2 as FaixaSalarial from Funcionario where salario BETWEEN 10001 and 20000 limit 2)
UNION
(SELECT emailFuncionario, 3 as FaixaSalarial from Funcionario where salario BETWEEN 20001 and 30000 limit 2);


/*
Liste todas as unidades que possuem gastos com funcionarios superior a 10 mil.

Para essas unidades deve ser exibido o gasto total

Como a métrica de qualidade de uma unidade é exatamente o número de transportes que partem daquela unidade,
retorne também o número de transportes que partiram daquela unidade

Atende: função de agregação, cláusula group by, having e pelo menos 3 tabelas.
*/
SELECT SQ1.idUnidade_PK, concat('R$', round(SQ1.GT, 2)), count(SQ2.idTransporte) as 'Número de Partidas' from
(
SELECT U.idUnidade_PK, sum(F.salario) as GT from Unidade as U 
	left join Funcionario as F on
		F.idUnidade_FK = U.idUnidade_PK
	group by U.idUnidade_PK
   	having sum(F.salario) >= 10000

) as SQ1 LEFT JOIN
(
SELECT T.id as idTransporte, R.idUnidadeOrigem_SPK from Transporte as T
	inner join Rota as R on
		R.id = T.idRota_FK
) as SQ2 on
SQ2.idUnidadeOrigem_SPK = SQ1.idUnidade_PK
group by SQ1.idUnidade_PK, SQ1.GT



/*
 Listar todos os produtos assim como suas quantidades para o pedido de id 1.

Atende: Pelo menos 3 tabelas
*/

Select P.nome as Produto, sum(Ct.quantidade) as Quantidade from (select * from Pedido where idPedido_PK = 1) as Pe
	inner join PedidoContainer as Pc on
    Pe.idPedido_PK = Pc.idPedido_FK
	inner join Container as C
    on Pc.idContainer_FK = C.idContainer_PK
    inner join Contem as Ct
    on Ct.idContainer_FK = C.idContainer_PK
    AND Pe.dataSolicitacao = Ct.dataInicio
    AND Pe.dataEntrega = Ct.dataFim
    inner join Produto as P
    on P.idProduto_PK = Ct.idProduto_FK
group by P.nome





