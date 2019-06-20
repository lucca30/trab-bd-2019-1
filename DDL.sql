CREATE SCHEMA IF NOT EXISTS BD120191 ;
USE BD120191; 

SET FOREIGN_KEY_CHECKS=0; 

drop table if exists 
    TransporteContainer,
    PedidoTransporte,
	PessoaFisica,
    PessoaJuridica,
    Cliente,
	Armazem,
	Seguradora,
    Acidente,
    Unidade,
    Pedido,
    Rota,
    TipoVeiculo,
    Funcionario,
    Lote,
    Veiculo,
    Container,
    Produto,
    Motorista,
    Estoquista,
    Pilota,
    Transporte,
    Cobre,
    Estoca,
    Contem,
    PedidoContainer;

SET FOREIGN_KEY_CHECKS=1;

/*____________________________CRIAÇÃO DAS TABELAS______________________________*/

/*OBSERVAÇÃO IMPORTANTE: as definições de chaves estrangeiras estão no final do script,
na parte "DEFINIÇÃO DE CHAVES ESTRANGEIRAS" */

CREATE TABLE PessoaFisica(

/*Função: guardar as informações específicas do cliente que
	 é cadastrado como pessoa física(cpf e RG, por exemplo).*/

cpf VARCHAR(11) UNIQUE,
rg VARCHAR(9) UNIQUE,

/*Chave estrangeira, que aponta para a instância 
	de Cliente que é criada no momento do cadastro*/
idCliente_SPK INT,
PRIMARY KEY (idCliente_SPK)
);

CREATE TABLE PessoaJuridica (
/*Função: guardar as informações específicas do cliente que
	 é cadastrado como pessoa jurídica(cnpj e razão social, por exemplo).*/

cnpj VARCHAR(14) UNIQUE,
razaoSocial VARCHAR(30),

/*Chave estrangeira, que aponta para a instância 
	de Cliente que é criada no momento do cadastro*/
idCliente_SPK INT 
);

CREATE TABLE Cliente (
/*Função: guardar as informações gerais de um cliente
			(email, endereço, telefone, etc)*/
idCliente_PK INT PRIMARY KEY,
cep VARCHAR(8),
emailCliente VARCHAR(60),

/*Checa se o email do cliente está no formato x@y.z */
CONSTRAINT CHK_emailCliente
	CHECK(emailCliente LIKE '%_@_%._%'),

nome VARCHAR(30),
endereco VARCHAR(30),
telefone VARCHAR(11)
);

CREATE TABLE Armazem (
/*Função: guardar as informações fisicas e de disponibilidade de um armazém.*/
idArmazem_PK INT NOT NULL,
idUnidade_FK INT NOT NULL,
PRIMARY KEY (idArmazem_PK)
);

CREATE TABLE Seguradora (
/*Função: guardar as informações de uma seguradora, que pode ou não 
			cobrir acidentes que podem acontecer com pedidos que são 
					transportados pela empresa;*/


idSeguradora_PK INT PRIMARY KEY,
emailSeguradora VARCHAR(60),

/*Checa se o email da seguradora está no formato x@y.z */
CONSTRAINT CHK_emailSeguradora
	CHECK(emailSeguradora LIKE '%_@_%._%'),

cnpj VARCHAR(14) UNIQUE,
razaoSocial VARCHAR(60),
nome VARCHAR(60),
telefone VARCHAR(11)
);

CREATE TABLE Acidente (
/*Função: guarda informações sobre acidentes em transportes realizados pela empresa*/

idAcidente_PK INT PRIMARY KEY,
descricao VARCHAR(600),
nome VARCHAR(100)
);

CREATE TABLE Unidade (
/*Função: guardar as informações sobre cada unidade da empresa
			(email,telefone, etc)*/

idUnidade_PK INT PRIMARY KEY NOT NULL,

emailUnidade VARCHAR(60),

/*Checa se o email da unidade está no formato x@y.z */
CONSTRAINT CHK_emailUnidade
	CHECK(emailUnidade LIKE '%_@_%._%'),

endereco VARCHAR(30),
cep VARCHAR(8),
telefone VARCHAR(11)
);

CREATE TABLE Pedido (
/*Função: guardar as informações sobre um pedido
			(qual cliente solicitou,datas de solicitação e entrega,
					 qual o destinatário, etc)*/

idPedido_PK INT PRIMARY KEY,
dataEntrega DATE,
dataSolicitacao DATE,

/*Impede que a data da entrega aconteça antes que o pedido tenha sido solicitado*/ 
CONSTRAINT CHK_dataEntrega
	CHECK(dataSolicitacao <= dataEntrega),

idUnidadeOrigem_FK INT,
idUnidadeDestino_FK INT,
/*Chave estrangeira, indica qual cliente solicitou esse pedido*/
idCliente_FK INT
);

CREATE TABLE Rota (
/*Função: indica que há um caminho entre as unidadeOrigem e unidadeDestino*/

id INT,

/*Chave estrangeira, aponta para a unidade de origem*/
idUnidadeOrigem_SPK INT,

/*Chave estrangeira, aponta para a unidade de destino*/
idUnidadeDestino_SPK INT,

idTipoVeiculo_FK INT,

PRIMARY KEY (id)
);

CREATE TABLE TipoVeiculo (

id INT,
nome VARCHAR(50),
numMaxContainers INT, 

PRIMARY KEY (id)

);

CREATE TABLE Funcionario (
/*Função: guarda infos. gerais sobre um funcionário(email, 
			matricula, departamento, endereço, etc)*/
idFuncionario_PK INT PRIMARY KEY,
emailFuncionario VARCHAR(60),
/*Checa se o email do funcionário está no formato x@y.z */
CONSTRAINT CHK_emailFuncionario
	CHECK(emailFuncionario LIKE '%_@_%._%'),
dataContratacao DATE,
salario float,
endereco VARCHAR(30),
rg VARCHAR(9) UNIQUE,
telefone VARCHAR(11),
dataNascimento DATE,

/*Impede que a data de nascimento do funcionário esteja posterior a 
		data de sua contratação*/
CONSTRAINT CHK_dataContratacao
	CHECK(dataNascimento < dataContratacao),

/*Chave estrangeira, indica qual unidade o funcionário trabalha*/
idUnidade_FK INT
);

CREATE TABLE Lote (
/*Função: guarda informações sobre um espaço específico no armazem
		(cada "vaga" no "estacionamento")*/
idLote_PK INT NOT NULL PRIMARY KEY,
setor INT,
posicao INT,

/*Chave estrangeira, indica a qual armazem esse lote pertence*/
idArmazem_FK INT NOT NULL
);

CREATE TABLE Veiculo (
/*Função: guarda infos. gerais sobre um veiculo da empresa(carga maxima em quilos, 
			numero máximo de containers, tipo do veículo, localização, unidade de origem, etc)*/
idVeiculo_PK INT PRIMARY KEY,
fabricante VARCHAR(20),
dataAquisicao DATE,

idTipoVeiculo_FK INT
);

CREATE TABLE Container (
/*Função: guarda infos. sobre um container da empresa(caracteristicas fisicas, 
			status, vida util em meses, lotação atual, etc)*/

idContainer_PK INT PRIMARY KEY,
dataAquisicao DATE,

/* Vida util em meses */
vidaUtil INT
);

CREATE TABLE Produto (
/*Função: guarda infos. sobre um produto que está sendo transportado(descrição, 
			caracteristicas fisicas, pedido a qual o produto pertence, etc)*/
idProduto_PK INT PRIMARY KEY,
descricao VARCHAR(500),
nome VARCHAR(100) unique
/*Chave estrangeira, indica qual pedido o produto pertence*/
);

CREATE TABLE Motorista (
idFuncionario_SPK INT UNIQUE NOT NULL PRIMARY KEY
);

CREATE TABLE Estoquista (
idFuncionario_SPK INT UNIQUE NOT NULL PRIMARY KEY
);

CREATE TABLE Pilota (
idMotorista_FK INT, 
idTipoVeiculo_FK INT,
PRIMARY KEY(idMotorista_FK, idTipoVeiculo_FK)
);

CREATE TABLE TransporteContainer (
    idTransporte_FK INT,
    idContainer_FK INT,
    PRIMARY KEY (idTransporte_FK, idContainer_FK)
);

CREATE TABLE Transporte (
/*Função: guarda info. de qual veiculo transporta qual container, e em qual data*/

id INT,

idRota_FK INT,

idAcidente_FK INT,

idVeiculo_FK INT,

idMotorista_FK INT,

dataInicio DATE,
dataFim DATE,

/*Impede que a data de inicio do tranporte seja posterior a data de termino*/
CONSTRAINT CHK_dataInicio
	CHECK(dataInicio <= dataFim),

PRIMARY KEY(id)
);

CREATE TABLE Cobre (
/*Função: guarda info. de qual segurado cobriu qual pedido e em qual tipo de acidente*/

/*Chave estrangeira, indica qual pedido foi o pedido coberto*/
idPedido_SPK INT,

/*Chave estrangeira, indica qual foi o tipo de acidente*/
idAcidente_SPK INT,

/*Chave estrangeira, indica qual a seguradora que cobriu o pedido*/
idSeguradora_SPK INT,

PRIMARY KEY(idPedido_SPK,idAcidente_SPK,idSeguradora_SPK)
);

CREATE TABLE Estoca (
/*Função: guarda info. de quando um container foi alocado e em qual lote.*/

dataEstoc DATETIME,

/*Chave estrangeira, indica em qual lote o container foi alocado*/
idLote_SPK INT,

/*Chave estrangeira, indica qual container está transportando*/
idContainer_SPK INT,

PRIMARY KEY(idLote_SPK,idContainer_SPK)
);

CREATE TABLE Contem (
/*Função: guarda info. de qual container contém qual produto.*/

/*Chave estrangeira, indica o produto que está sendo transportado*/
idProduto_FK INT,

/*Chave estrangeira, indica o container que está transportando*/
idContainer_FK INT,

dataInicio DATE,
dataFim DATE,
quantidade INT,

CONSTRAINT CHK_dataInicio
	CHECK(dataInicio <= dataFim),


PRIMARY KEY (idProduto_FK, idContainer_FK, dataInicio, dataFim)
);

CREATE TABLE PedidoTransporte (
    idPedido_FK INT,
    idTransporte_FK INT,
    PRIMARY KEY(idPedido_FK, idTransporte_FK)
);

CREATE TABLE PedidoContainer (
	idPedido_FK INT,
    idContainer_FK INT,
    PRIMARY KEY(idPedido_FK, idContainer_FK)
);

/*_________________________DEFINIÇÃO DE CHAVES ESTRANGEIRAS_________________________________*/

/*Chaves estrangeiras da tabela PessoaFisica*/
ALTER TABLE PessoaFisica ADD FOREIGN KEY(idCliente_SPK) REFERENCES Cliente (idCliente_PK);

/*Chaves estrangeiras da tabela PessoaJuridica*/
ALTER TABLE PessoaJuridica ADD FOREIGN KEY(idCliente_SPK) REFERENCES Cliente (idCliente_PK);

/*Chaves estrangeiras da tabela Armazem*/
ALTER TABLE Armazem ADD FOREIGN KEY(idUnidade_FK) REFERENCES Unidade (idUnidade_PK);

/*Chaves estrangeiras da tabela Veiculo*/
ALTER TABLE Veiculo ADD FOREIGN KEY(idTipoVeiculo_FK) REFERENCES TipoVeiculo(id);

/*Chaves estrangeiras da tabela Cobre*/
ALTER TABLE Cobre ADD FOREIGN KEY(idPedido_SPK) REFERENCES Pedido(idPedido_PK);
ALTER TABLE Cobre ADD FOREIGN KEY(idAcidente_SPK) REFERENCES Acidente(idAcidente_PK);
ALTER TABLE Cobre ADD FOREIGN KEY(idSeguradora_SPK) REFERENCES Seguradora(idSeguradora_PK);

/*Chaves estrangeiras da tabela Pedido*/
ALTER TABLE Pedido ADD FOREIGN KEY(idCliente_FK) REFERENCES Cliente (idCliente_PK);
ALTER TABLE Pedido ADD FOREIGN KEY(idUnidadeOrigem_FK) REFERENCES Unidade (idUnidade_PK);
ALTER TABLE Pedido ADD FOREIGN KEY(idUnidadeDestino_FK) REFERENCES Unidade (idUnidade_PK);


/*Chaves estrangeiras da tabela Rota*/
ALTER TABLE Rota ADD FOREIGN KEY(idUnidadeOrigem_SPK) REFERENCES Unidade (idUnidade_PK);
ALTER TABLE Rota ADD FOREIGN KEY(idUnidadeDestino_SPK) REFERENCES Unidade (idUnidade_PK);

/*Chaves estrangeiras da tabela Funcionario*/
ALTER TABLE Funcionario ADD FOREIGN KEY(idUnidade_FK) REFERENCES Unidade (idUnidade_PK);

/*Chaves estrangeiras da tabela Lote*/
ALTER TABLE Lote ADD FOREIGN KEY(idArmazem_FK) REFERENCES Armazem (idArmazem_PK);

/*Chaves estrangeiras da tabela Motorista*/
ALTER TABLE Motorista ADD FOREIGN KEY(idFuncionario_SPK) REFERENCES Funcionario (idFuncionario_PK);

ALTER TABLE Estoquista ADD FOREIGN KEY(idFuncionario_SPK) REFERENCES Funcionario (idFuncionario_PK);


ALTER TABLE Pilota ADD foreign key (idMotorista_FK) REFERENCES Motorista (idFuncionario_SPK);
ALTER TABLE Pilota ADD foreign key (idTipoVeiculo_FK) REFERENCES TipoVeiculo (id);

/*Chaves estrangeiras da tabela Contem*/
ALTER TABLE Contem ADD FOREIGN KEY(idProduto_FK) REFERENCES Produto (idProduto_PK);
ALTER TABLE Contem ADD FOREIGN KEY(idContainer_FK) REFERENCES Container (idContainer_PK);

/*Chaves estrangeiras da tabela PedidoTransporte*/
ALTER TABLE PedidoTransporte ADD foreign key(idPedido_FK) references Pedido(idPedido_PK);
ALTER TABLE PedidoTransporte ADD foreign key(idTransporte_FK) references Transporte(id);

ALTER TABLE PedidoContainer ADD foreign key(idPedido_FK) references Pedido(idPedido_PK);
ALTER TABLE PedidoContainer ADD foreign key(idContainer_FK) references Container(idContainer_PK);

/*Chaves estrangeiras da tabela Transporte*/
ALTER TABLE Transporte ADD FOREIGN KEY(idRota_FK) REFERENCES Rota (id);
ALTER TABLE Transporte ADD FOREIGN KEY(idAcidente_FK) REFERENCES Acidente (idAcidente_PK);
ALTER TABLE Transporte ADD FOREIGN KEY(idVeiculo_FK) REFERENCES Veiculo (idVeiculo_PK);
ALTER TABLE Transporte ADD FOREIGN KEY(idMotorista_FK) REFERENCES Motorista (idFuncionario_SPK);



/*Chaves estrangeiras da tabela Transporte Container*/
ALTER TABLE TransporteContainer ADD foreign key(idTransporte_FK) references Transporte(id);
ALTER TABLE TransporteContainer ADD FOREIGN KEY(idContainer_FK) references Container(idContainer_PK);