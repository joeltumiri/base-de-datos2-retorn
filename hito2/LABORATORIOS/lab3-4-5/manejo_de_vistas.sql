create database hito_2v2;
use hito_2v2;

create table usuarios
(
    id_usuario int auto_increment primary key,
    nombres varchar(50) not null,
    apellidos varchar(50) not null,
    edad int not null,
    email varchar (100) not null
);

insert into usuarios (nombres, apellidos, edad, email)
values ('maria', 'perez', 20, 'mariaperez@gmail.com'),
       ('daniel', 'mamani', 34, 'danielmamani@gmail.com'),
       ('miguel', 'torres', 45, 'migueltorres@gmail.com');

select*
from usuarios as us;

##mostrar los usuarios mayores a 30 años
alter view mayores_a_30 as
select us.nombres, us.apellidos, us.edad, us.email
from usuarios as us
where us.edad > 30;

select m30.*
from mayores_a_30 as m30;

# modificar la vista anterior
# para que muestre los siguientes campos
# FULLNAME = nombre y apellidos
# EDAD_USUARIO = la edad del usuario
# EMAIL_USUARIO = email del usuario
alter view mayores_a_30 as
select
         CONCAT(us.nombres, ' ' ,us.apellidos) AS FULLNAME,
                us.edad AS EDAD_USUARIO,
                us.email AS EMAIL_USUARIO
from usuarios AS us
where us.edad > 30;
#

# a la vista creada anteriormente
# mostrar aquellos usuarios que en su apellido tenga
# la letra m
# %% hace que busque el numero o letra insertado del registro


select ma.FULLNAME,
       ma.EDAD_USUARIO,
       ma.EMAIL_USUARIO
FROM mayores_a_30 AS ma
WHERE ma.FULLNAME LIKE '%s%';




