create database procesual_hito4;
use procesual_hito4;

create table departamento
(
    id_dep int primary key not null,
    nombre varchar(50)
);

create table provincia
(
    id_prov int primary key not null,

    nombre varchar(50),
    id_dep int,
    foreign key (id_dep) references departamento(id_dep)
);

create table proyecto
(
    id_proy int primary key,
    nombreProy varchar(100),
    tipoProy varchar(30)
);
create table persona
(
    id_per int primary key not null,
    nombre varchar(20),
    apellidos varchar(50),
    fecha_nac date,
    edad int,
    email varchar(50),

    id_dep int,
    id_prov int,
    foreign key (id_dep) references departamento (id_dep),
    foreign key (id_prov) references provincia (id_prov),
    sexo char(1)
);

create table detalle_proyecto
(
    id_dp int primary key not null,

    id_proy int,
    id_per int,
    foreign key (id_proy) references  proyecto (id_proy),
    foreign key (id_per) references  persona (id_per)
);

insert into departamento
values(1,'El alto'),
      (2,'Santa Cruz'),
      (3,'Cochabamba');

insert into provincia
values (1,'provincia 1',1),
       (2,'provincia 2',2),
       (3,'provincia 3',3);

insert into persona
values(2,'Maria','Gustamante', '2000-10-10', 30, 'maria@gmail.com', 1, 1, 'F'),
      (1,'Joao','Salazar', '2000-10-10', 20, 'joao@gmail.com', 1, 1, 'M'),
      (3,'Pedro','Alvez', '2000-10-10', 40, 'pedro@gmail.com', 3, 3, 'M');

insert into proyecto
values(1,'proyecto1','tipo1'),
      (2,'proyecto2','tipo2'),
      (3,'proyecto3','tipo3');

insert into detalle_proyecto
values (1,1,1),
       (2,2,2),
       (3,3,3);

# 10.Crear una función que sume los valores de la serie Fibonacci.
# ○ El objetivo es sumar todos los números de la serie fibonacci desde una
# cadena.
# ○ Es decir usted tendrá solo la cadena generada con los primeros N números
# de la serie fibonacci y a partir de ellos deberá sumar los números de esa
# serie.
# ○ Ejemplo: suma_serie_fibonacci(mi_metodo_que_retorna_la_serie(10))
# ■ Note que previamente deberá crear una función que retorne una
# cadena con la serie fibonacci hasta un cierto valor.
# 1. Ejemplo: 0,1,1,2,3,5,8,.......
# ■ Luego esta función se deberá pasar como parámetro a la función que
# suma todos los valores de esa serie generada.

create function serie_fibonacci (n int)
returns varchar(255)
begin
declare serie varchar(255);
declare n1 int;
declare n2 int;
declare n3 int;

set n1 = 0;
set n2 = 1;
set serie = concat(n1, ',', n2);

while n > 2 do
  set n3 = n1 + n2;
  set serie = concat(serie, ',', n3);
  set n1 = n2;
  set n2 = n3;
  set n = n - 1;
end while;

return serie;
end;


select serie_Fibonacci(10);

#suma de la serie fibonnaci
create function suma_serie_fibonacci (serie varchar(255))
returns int
begin
declare total int default 0;
declare n int default 0;

while length(serie) > 0 do
  set n = substring_index(serie, ',', 1);
  set serie = substring(serie, length(n) + 2);
  set total = total + n;
end while;

return total;
end;


select suma_serie_fibonacci(serie_Fibonacci(10)) as 'suma de la serie fibonacci';

# 11. Manejo de vistas
# ■ La consulta de la vista debe reflejar como campos:
# 1. nombres y apellidos concatenados
# 2. la edad
# 3. fecha de nacimiento.
# 4. Nombre del proyecto
# ○ Obtener todas las personas del sexo femenino 'F' que hayan nacido en el
# departamento de El Alto en donde la fecha de nacimiento sea:
# 1. fecha_nac = '2000-10-10'

create or replace view persona_view as
SELECT CONCAT(pe.nombre,' ',pe.apellidos) as nombres_completo,pe.edad,pe.fecha_nac,proy.nombreProy
from persona as pe
inner join detalle_proyecto dp on pe.id_per = dp.id_per
inner join proyecto proy on dp.id_proy = proy.id_proy
inner join departamento d on pe.id_dep = d.id_dep
where pe.sexo = 'F' and d.nombre = 'El Alto' and pe.fecha_nac = '2000-10-10';

select * from persona_view;

# 12.Manejo de TRIGGERS I.
# ○ Crear TRIGGERS Before or After para INSERT y UPDATE aplicado a la tabla
# PROYECTO
# ■ Debera de crear 2 triggers minimamente.
# ○ Agregar un nuevo campo a la tabla PROYECTO.
# ■ El campo debe llamarse ESTADO
# 6
# ○ Actualmente solo se tiene habilitados ciertos tipos de proyectos.
# ■ EDUCACION, FORESTACION y CULTURA
# ○ Si al hacer insert o update en el campo tipoProy llega los valores
# EDUCACION, FORESTACIÓN o CULTURA, en el campo ESTADO colocar el valor
# ACTIVO. Sin embargo se llegar un tipo de proyecto distinto colocar
# INACTIVO
# ○ Adjuntar el código SQL generado y una imagen de su correcto
# funcionamiento


alter table proyecto add estado varchar(10);

CREATE or replace TRIGGER estado_proyecto
BEFORE INSERT ON proyecto
FOR EACH ROW
BEGIN
IF NEW.tipoProy = 'EDUCACION' or NEW.tipoProy = 'FORESTACION' or NEW.tipoProy = 'CULTURA' THEN
  SET NEW.estado = 'ACTIVO';
ELSE
  SET NEW.estado = 'INACTIVO';
END IF;
END;

INSERT INTO proyecto (id_proy,nombreProy,tipoProy) VALUES (5,'proyecto5','Learning');
SELECT * FROM proyecto;

# 13.Manejo de Triggers II.
# ○ El trigger debe de llamarse calculaEdad.
# ○ El evento debe de ejecutarse en un BEFORE INSERT.
# ○ Cada vez que se inserta un registro en la tabla PERSONA, el trigger debe de
# calcular la edad en función a la fecha de nacimiento.
# ○ Adjuntar el código SQL generado y una imagen de su correcto
# funcionamiento.

create or replace trigger agregar_edad
before insert on persona
for each row
    begin
        set new.edad= timestampdiff(year,new.fecha_nac,curdate());
    end;

INSERT INTO persona (id_per,nombre,apellidos,sexo,fecha_nac,id_dep) VALUES (4,'persona4','persona4','M','1990-10-10',1);


select *from persona;

# 14.Manejo de TRIGGERS III.
# ○ Crear otra tabla con los mismos campos de la tabla persona(Excepto el
# primary key id_per).
# ■ No es necesario que tenga PRIMARY KEY.
# ○ Cada vez que se haga un INSERT a la tabla persona estos mismos valores
# deben insertarse a la tabla copia.
# ○ Para resolver esto deberá de crear un trigger before insert para la tabla
# PERSONA.
# ○ Adjuntar el código SQL generado y una imagen de su correcto
# funcionamiento.
create table copia_persona
(
  nombre varchar(20),
  apellidos varchar(50),
  fecha_nac date,
  edad int,
  email varchar(50),
  id_dep int not null ,
  id_prov int not null,
  sexo varchar(1),
  foreign key (id_prov) references  provincia(id_prov),
  foreign key (id_dep) references departamento(id_dep)
);
drop table copia_persona;

create or replace trigger copiar_persona
before insert on persona
for each row
    begin
        insert into copia_persona(nombre, apellidos, fecha_nac, edad, email, id_dep, id_prov, sexo)
        values(new.nombre,new.apellidos,new.fecha_nac,new.edad,new.email,new.id_dep,new.id_prov,new.sexo);
    end;

insert into persona (id_per,id_prov,nombre,apellidos,sexo,fecha_nac,id_dep) values (5,3,'persona5','persona5','m','1990-10-10',2);


select*from copia_persona;



#crear una consulta con todas las tablas en una vista
# ○ La vista debe de mostrar los siguientes campos:
# 1. nombres y apellidos concatenados
# 1. Nombre del departamento
# 2. detalle del proyecto
# 3. provincia
# 4. Nombre del proyecto

create or replace view todas_las_tablas as
select
    concat(persona.nombre,persona.apellidos) as nombre_y_apellidos,
    persona.edad as edad,
    departamento.nombre as departamento,
    provincia.nombre as provincia,
    concat(proyecto.nombreproy,': ',tipoproy) as proyecto

from persona
inner join departamento on persona.id_dep = departamento.id_dep
inner join provincia on persona.id_prov = provincia.id_prov
inner join detalle_proyecto on persona.id_per = detalle_proyecto.id_per
inner join proyecto on detalle_proyecto.id_proy = proyecto.id_proy;

select * from (todas_las_tablas);
