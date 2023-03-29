create database universidad;
use universidad;
create table estudiante
(
    id_est integer auto_increment primary key not null,
    nombre varchar (100) not null,
    apellido varchar (100) not null,
    edad int not null,
    fono int not null,
    email varchar (100) not null
);
describe estudiante;
insert into estudiante (nombre, apellido, edad, fono, email)
values ('juan', 'aruquipa', 12, 234347, 'velas1@email.com'),
       ('carlos', 'pedro', 13, 2343478, 'velas2@email.com'),
       ('marcos', 'montes', 16, 23434789, 'velas3@email.com');

insert into estudiante (nombre, apellido, edad, fono, email)
value('juan', 'aruquipa', 12, 234347, 'velas1@email.com');

-- insertar datos en en la columna
-- en caso de olvidar de insertar datos
update estudiante
set nombre = 'milenca'
where nombre = 'juan';

-- borrar datos de la columna
-- borra todos los datos riesgo
DELETE FROM estudiante
WHERE estado_civil;

-- borrar columnas
alter table estudiante
drop column estado_civil;

describe estudiante;



-- permite poner por datos por default
alter table estudiante
add column direccion varchar (100) default 'el alto';

alter table estudiante
drop column estado_civil;

alter table estudiante
add column estado_civil varchar (100) default 'solteros';

alter table estudiante
drop column direccion;

    select * from estudiante;

describe estudiante; -- es para ver que tablas tenemos

-- permite agregar nuevos cambios a una tabla
alter table estudiante
add column fax varchar (10),
add column genero varchar (10);

#mostrar los registros dea quellos estudiantes
#que su nombre sea igual a 'juan'
select *
from estudiante as est
where est.nombre =  'milenca';


select est.nombre
from estudiante as est
where est.edad <= 12;

describe estudiantes;

#mostrar todos los registros (nombres, apellidos y edad)
#el cual la edad sea mayor a 18
select
    est.nombre,
    est.apellido as 'apellidos de la persona',
    est.edad
from estudiante as est
where est.edad > 12;

#mostrar todos los registros donde cuyo
#ID sea PAR (o impar)
select est.*
from estudiante as est
where est.id_est % 2 = 0;




create table estudiantes
(
    id_est integer auto_increment primary key not null,
    nombres varchar(100) not null,
    apellidos varchar(100) not null,
    edad int not null,
    fono int not null,
    email varchar(100) not null
);

insert into estudiantes (nombres, apellidos, edad, fono, email)
values ('juan', 'aruquipa', 12, 234347, 'velas1@email.com'),
       ('carlos', 'pedro', 12, 2343478, 'velas2@email.com'),
       ('mrcos', 'montes', 12, 23434789, 'velas3@email.com');

SELECT COUNT(*)
FROM estudiantes;



create table materias
(
    id_mat int auto_increment primary key not null,
    nombre_mat varchar(100) not null,
    cod_mat varchar(100) not null
);

create table inscripcion
(
  id_ins int auto_increment primary key not null,
  id_est int not null,
  id_mat int not null,
  foreign key (id_est) references estudiantes(id_est),
  foreign key (id_mat) references materias(id_mat)
);




