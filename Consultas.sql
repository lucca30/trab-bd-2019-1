/*
Consulta 1

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
Consulta 2

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
Consulta 3

Liste todas as unidades que possuem gastos com funcionarios superior a 10 mil.

Para essas unidades deve ser exibido o gasto total

Como a métrica de qualidade de uma unidade é exatamente o número de transportes que partem daquela unidade,
retorne também o número de transportes que partiram daquela unidade

Atende: função de agregação, cláusula group by, having e pelo menos 3 tabelas.
*/
SELECT SQ1.idUnidade_PK as 'Id Unidade', concat('R$', round(SQ1.GT, 2)) as 'Gasto Total', count(SQ2.idTransporte) as 'Número de Partidas' from
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
Consulta 4

Listar todos os containeres do pedido 1 que ainda não possuem 1 transporte que o
leve para a unidade de destino
 
*/



/*
Consulta 5

Listar todos os pedidos que sofreram um acidente

*/

select distinct P.idPedido_PK from Pedido as P
	inner join PedidoContainerProduto as PCP on
		PCP.idPedido = P.idPedido_PK
	inner join TransporteContainer as TC on
		TC.idContainer_FK = PCP.idContainer
	inner join Transporte as T on
		T.id = TC.idTransporte_FK
        
	where T.idAcidente_FK is not null;


/*
Consulta 6

Dada a chegada do transporte de ID 1 na sua unidade de destino, liste  a localização de 
todos os lotes disponíveis nessa data
*/

select concat('Armazém ', idArmazem_PK, ', setor ', setor, ', posição ', posicao) as 'Localização' from
(select R.idUnidadeDestino_SPK as 'Unidade', dataFim from Transporte as T 
	left join Rota as R 
		on R.id = T.idRota_FK
where T.id = 1) as SQ1
	left join Armazem as A on
		A.idUnidade_FK = SQ1.Unidade
	left join Lote as L on
		L.idArmazem_FK = A.idArmazem_PK
	left join Estoca as E on
		E.idLote_SPK = L.idLote_PK
	where E.dataEstoc <> SQ1.dataFim
;

/*
Consulta 7

Listar todos os caminhos de uma unidade A para uma unidade B que possuem rotas para todos os tipos de 
veículo disponíveis
*/

/*
Consulta 8

Listar os motoristas que já conduziram por todos os pares de caminhos A-B possíveis segundo a 
tabela rota. Observe que ele não precisa ter conduzido todos os tipos de veículo (pois rota possui veículo
em sua composição).
*/

/*
Consulta 9

Listar a quantidade de lotes que existem em cada uma das unidades. (Lembrando que cada unidade possui
vários Armazéns e os Armazéns possuem vários lotes)

*/
select U.idUnidade_PK as Unidade , count(L.idLote_PK) as 'Total de Lotes' from Unidade as U 
	left join Armazem as A on
		A.idUnidade_FK = U.idUnidade_PK
	inner join Lote as L on
		L.idArmazem_FK = A.idArmazem_PK
	group by U.idUnidade_PK
;




/*
Consulta 10

Listar, para cada acidente, o nome e o total de vezes que ele foi coberto e o total de vezes que ele ocorreu	

*/

select nome, Ocorridos, count(idAcidente_PK) as Cobertos from
	(select A.idAcidente_PK, A.nome, count(T.id) as Ocorridos from Acidente as A 
		left join Transporte as T 
			on A.idAcidente_PK = T.idAcidente_FK 
		group by A.nome, A.idAcidente_PK) as SQ1 
		left join Cobre as C
			on SQ1.idAcidente_PK = C.idAcidente_SPK 
		group by nome, Ocorridos
    
