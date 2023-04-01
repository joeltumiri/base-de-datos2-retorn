create database pollos_copa;
use pollos_copa;

create table cliente
(
id_cliente int auto_increment primary key not null,
fullname varchar(50),
lastname varchar(50),
edad int,
domicilio varchar(50)
);

create table pedido
(
id_pedido int auto_increment primary key not null,
articulo varchar(50) not null,
costo float(50) not null,
fecha date
);

create table detalle_pedido
(
id_detalle_pedido int auto_increment primary key not null,
id_cliente int not null,
id_pedido int not null,
foreign key (id_cliente) references cliente(id_cliente),
foreign key (id_pedido) references pedido(id_pedido)
);

insert into cliente(fullname, lastname, edad, domicilio)
values('joel','tumiri',23,'ceja'),
      ('roberto','mamani',23,'av buenos aires');

insert into pedido(articulo, costo, fecha)
values('broaster',22.0,'2023-05-02'),
      ('milanesa',23.0,'2023-05-02');

insert into detalle_pedido(id_cliente, id_pedido)
values(1,1),
      (2,2);

-- cliente que realizo un pedido el 2023
select cli.fullname,ped.costo
from cliente as cli
inner join detalle_pedido as de on cli.id_cliente = de.id_cliente
inner join pedido ped on de.id_cliente = ped.id_pedido
where ped.fecha like ('2023%');

select ped.articulo
from pedido as ped
where ped.articulo = 'milanesa' and costo = ('23.0');


create database tareaHito2;
use tareaHito2;

create table estudiantes
(
    id_est    int auto_increment primary key not null,
    nombres   varchar(50),
    apellidos varchar(50),
    edad      int(11),
    gestion   int(11),
    fono      int(11),
    email     varchar(100),
    direccion varchar(100),
    sexo      varchar(10)
);

create table materias
(
    id_mat     int auto_increment primary key not null,
    nombre_mat varchar(100),
    cod_mat    varchar(100)
);

create table inscripcion
(
    id_ins   int auto_increment primary key not null,
    semestre varchar(20),
    gestion  int(11),

    id_est   int                            not null,
    id_mat   int                            not null,

    foreign key (id_est) references estudiantes (id_est),
    foreign key (id_mat) references materias (id_mat)
);

INSERT INTO estudiantes (nombres, apellidos, edad, fono, email, direccion, sexo)
VALUES ('Miguel', 'Gonzales Veliz', 20, 2832115, 'miguel@gmail.com', 'Av. 6 de Agosto', 'masculino'),
       ('Sandra', 'Mavir Uria', 25, 2832116, 'sandra@gmail.com', 'Av. 6 de Agosto', 'femenino'),
       ('Joel', 'Adubiri Mondar', 30, 2832117, 'joel@gmail.com', 'Av. 6 de Agosto', 'masculino'),
       ('Andrea', 'Arias Ballesteros', 21, 2832118, 'andrea@gmail.com', 'Av. 6 de Agosto', 'femenino'),
       ('Santos', 'Montes Valenzuela', 24, 2832119, 'santos@gmail.com', 'Av. 6 de Agosto', 'masculino');

INSERT INTO materias (nombre_mat, cod_mat)
VALUES ('Introduccion a la Arquitectura', 'ARQ-101'),
       ('Urbanismo y Diseno', 'ARQ-102'),
       ('Dibujo y Pintura Arquitectonico', 'ARQ-103'),
       ('Matematica discreta', 'ARQ-104'),
       ('Fisica Basica', 'ARQ-105');

INSERT INTO inscripcion (semestre, gestion, id_est, id_mat)
values ('1er Semestre', 2018, 1, 1),
       ('2do Semestre', 2018, 1, 2),
       ('1er Semestre', 2019, 2, 4),
       ('2do Semestre', 2019, 2, 3),
       ('2do Semestre', 2020, 3, 3),
       ('3er Semestre', 2020, 3, 1),
       ('4to Semestre', 2021, 4, 4),
       ('5to Semestre', 2021, 5, 5);

-- Mostrar los nombres y apellidos de los estudiantes inscritos en la
-- materia ARQ-105, adicionalmente mostrar el nombre de la materia.
-- Deberá de crear una función que reciba dos parámetros y esta
-- función deberá ser utilizada en la cláusula WHERE.

select est.nombres, est.apellidos, mat.cod_mat, mat.nombre_mat
from estudiantes as est
inner join inscripcion i on est.id_est = i.id_est
inner join materias mat on i.id_mat = mat.id_mat
where mat.cod_mat = 'ARQ-105';

-- creando funcion
create or replace function compara_materias(cod_mat varchar(20), nombre_mat varchar(20))
returns boolean
begin
    declare respuesta boolean;
    if cod_mat = nombre_mat
    then
        set respuesta = 50;
        end if;
    return respuesta;
end;

select est.nombres, est.apellidos, mat.cod_mat, mat.nombre_mat
from estudiantes as est
inner join inscripcion as ins on est.id_est = ins.id_est
inner join materias as mat on ins.id_mat = mat.id_mat
where compara_materias(mat.cod_mat,  'ARQ-104');

select *
from estudiantes as est
inner join inscripcion as ins on est.id_est = ins.id_est
where est.sexo = 'masculino'  and est.edad >= 23;

-- Crear una función que permita obtener el promedio de las edades del género
-- masculino o femenino de los estudiantes inscritos en la asignatura ARQ-104

select avg(est.edad) as promedio_masculino,
       est.sexo as generos
from estudiantes as est
inner join inscripcion as ins on est.id_est = ins.id_est
inner join materias as mat on ins.id_mat = mat.id_mat
where sexo = 'masculino';

create or replace function prom_edades(cod_mat varchar(20), sexo varchar(20)) -- <- parametros
returns int
begin
    declare avgEDAD int default 30;
    select avg(est.edad) into avgEDAD
from estudiantes as est
      inner join inscripcion as ins on est.id_est = ins.id_est
      inner join materias as mat on ins.id_mat = mat.id_mat
where est.sexo = sexo and mat.cod_mat = cod_mat;
    return avgEDAD;
end;

select prom_edades('ARQ-104', 'masculino') AS promedio;
-- 15
create or replace function concaten(pep1 varchar(20), pep2 varchar(20), pep3 varchar(20))
returns varchar(60)
begin
    declare resultado varchar(60);
    set resultado = concat(pep1, ' ', pep2, ' ', pep3);
    return resultado;
end;

select concaten('joel','tumiri','23');

create or replace function concate(pep1 varchar(20), pep2 varchar(20), pep3 varchar(20))
returns varchar(60)
begin
    declare resultado varchar(60);
    set resultado = (pep1 + pep2 + pep3);
    return resultado;
end;
select concate(5,5,10);
