create database defensa_hito4_2023;
use defensa_hito4_2023;

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

create table audit_proyectos
(
    nombre_proy_anterior varchar(30),
    nombre_proy_posterior varchar(30),
    tipo_proy_anterior varchar(30),
    tipo_proy_posterior varchar(30),
    operation varchar(30),
    userId varchar(30),
    hostName varchar(30)
);

create trigger audit_proyects_insert
before update on proyecto
for each row
begin
    insert into audit_proyectos
    values(old.nombreProy, new.nombreProy, old.tipoProy, new.tipoProy, 'update', user(), @@hostName);
end;

update proyecto
set nombreProy='proyecto3'
where id_proy=1;

select * from proyecto;

create trigger audit_proyects_delete
after delete on proyecto
for each row
begin
    insert into audit_proyectos
    values(old.nombreProy, null, old.tipoProy, null, 'delete', user(), @@hostName);
end;

update proyecto
set nombreProy='proyecto'
where id_proy=1;
select * from proyecto;

create trigger audit_proyects_after
after insert on proyecto
for each row
begin
    insert into audit_proyectos
    values(null, new.nombreProy, null, new.tipoProy, 'insert', user(), @@hostName);
end;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - -- --- --- ---
create view reporte_proyectos as
select concat(p.nombre,' ',p.apellidos) as fullname,
       pr.nombreProy as desc_proyecto,
       d.nombre as departamento,
       case d.nombre
           when 'El alto' then 'EAT'
           when 'Santa Cruz' then 'SCZ'
           when 'Cochabamba' then 'CBB'
       end as cod_dep

from persona p
         inner join detalle_proyecto dp on p.id_per = dp.id_per
         inner join proyecto pr on dp.id_proy = pr.id_proy
         inner join departamento d on p.id_dep = d.id_dep;

select * from reporte_proyectos;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - -- -- -- -- -- -- -- -- -- - - - - -- - - - - -- - - -- - - -- - -

#crear un trigger para la tabla proyectos
#el trigger debe evitar que sse inserten en la tabla siempre y cuando
#el tipo de proyecto sea forestacion
#ademas
#si es dia de la inserccion es miercoles
#si el mes de junio
#mostrar un mensaje de error
#NO SE ADMITE INSERCIONES DEL TIPO FORESTACION

create or replace trigger tr_proyecto
before insert on proyecto
for each row
begin
    if new.tipoProy = 'FORESTACION5' then
        if dayname(now()) = 'Wednesday' and month(now()) = 6 then
            signal sqlstate '45000' set message_text = 'No se admite inserciones del tipo FORESTACION';
        end if;
    end if;
end;

insert into proyecto values(6,'proyecto4','FORESTACION5');
insert into proyecto values(8,'proyecto5','recoleccion de basura4');
select * from proyecto;
-- -- -- --- -- -- -- -- --- --- -- --- -- -- -- -- -- -- -- ---
#crear una funcion con el nombre diccionario
#diccionario de dia de la semanas
#si el dia de la semana es wadnesday retornar miercoles
#si el dia de la semana es monday retornar lunes
#si el dia de la semana es sunday retornar domingo
#si el dia de la semana es saturday retornar sabado

create or replace function diccionario()
returns text
begin
    declare d1 text;
    if dayname(now()) = 'Wednesday' then
        set d1 = 'Miercoles';
    elseif dayname(now()) = 'Monday' then
        set d1 = 'Lunes';
    elseif dayname(now()) = 'Sunday' then
        set d1 = 'Domingo';
    elseif dayname(now()) = 'Saturday' then
        set d1 = 'Sabado';
    end if;
    return d1;
end;

select diccionario('Sunday');

CREATE FUNCTION dicc(day TEXT)
    RETURNS TEXT
    BEGIN
        DECLARE d1 TEXT;

        IF LOWER(day) = 'monday' THEN
            SET d1 = 'Lunes';

            ELSEIF LOWER(day) = 'tuesday' THEN
            SET d1 = 'Martes';

            ELSEIF LOWER(day) = 'wednesday' THEN
            SET d1 = 'Miercoles';

            ELSEIF LOWER(day) = 'thursday' THEN
            SET d1 = 'Jueves';

            ELSEIF LOWER(day) = 'friday' THEN
            SET d1 = 'Viernes';

            ELSEIF LOWER(day) = 'saturday' THEN
            SET d1 = 'Sabado';

            ELSEIF LOWER(day) = 'sunday' THEN
            SET d1 = 'Domingo';

        end if;
    RETURN d1;

    END;


