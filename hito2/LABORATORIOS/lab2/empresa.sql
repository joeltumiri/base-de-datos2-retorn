create database empresa;
use empresa;

create table empleado
(
    id_empl int auto_increment primary key not null,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    edad varchar(50) not null,
    fono int not null,
    email varchar (100)not null
);

create table area
(
    id_ci int auto_increment primary key not null,
    ocupacion varchar (100) not null
);

create table empresa
(
  nit_emp int auto_increment primary key not null,
  nombre varchar(100) not null

);

insert into empleado(nombre, apellido, edad, fono, email)
values ('maria', 'rosita', 23, 7916383, 'maria@gmail.com'),
       ('pedro', 'perez', 32, 6895449, 'pedroperez@gmail.com'),
       ('daniel', 'loza', 34, 7869556, 'danielloza@gmail.com');

insert into area(ocupacion)
values('secretario'),
      ('contador'),
      ('marketing');

insert into empresa(nombre)
values ('Supermarker');










