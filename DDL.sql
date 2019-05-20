drop database if exists transportadora;

create database transportadora;

use transportadora;

drop table if exists Produto;
create table Produto(
	id INT auto_increment not null primary key,
    descricao varchar(100) not null
);

drop table if exists Container;
create table Container(
	id INT auto_increment not null primary key,
	marca varchar(100),
    capacidade int,
    dt_aquisicao date,
    dt_expiracao date
);

drop table if exists Produto_Container;
create table Produto_Container (
	id_produto int not null,
    id_container int not null,
    dt_inicio date,
    dt_fim date,
    quantidade int,
    
    primary key (id_produto, id_container, dt_inicio)
);
alter table Produto_Container add constraint foreign key (id_produto) references Produto(id);
alter table Produto_Container add constraint foreign key (id_container) references Container(id);



