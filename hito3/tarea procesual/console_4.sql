create database practica3;
use practica3;
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

select*
from materias;



CREATE OR REPLACE FUNCTION fibonacci(limite INT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE fib1 INT DEFAULT 0;
    DECLARE fib2 INT DEFAULT 1;
    DECLARE fib3 INT DEFAULT 0;
    DECLARE str VARCHAR(255) DEFAULT '0,1,';

    IF limite = 1 THEN
        RETURN fib1;
    ELSEIF limite = 2 THEN
        RETURN CONCAT(fib1, fib2);
    ELSE
        WHILE limite > 2 DO
            SET fib3 = fib1 + fib2;
            SET fib1 = fib2;
            SET fib2 = fib3;
            SET limite = limite - 1;
            SET str = CONCAT(str, fib3,',');
        END WHILE;
        RETURN str;
    END IF;
END;

select fibonacci(7);



set @limit=7;
CREATE OR REPLACE FUNCTION fibonacci1()
RETURNS text
DETERMINISTIC
BEGIN
    DECLARE fib1 INT DEFAULT 0;
    DECLARE fib2 INT DEFAULT 1;
    DECLARE fib3 INT DEFAULT 0;
    DECLARE str VARCHAR(255) DEFAULT '0,1,';

    IF @limit = 1 THEN
        RETURN fib1;
    ELSEIF @limit = 2 THEN
        RETURN CONCAT(fib1, fib2);
    ELSE
        WHILE @limit > 2 DO
            SET fib3 = fib1 + fib2;
            SET fib1 = fib2;
            SET fib2 = fib3;
            SET @limit = @limit - 1;
            SET str = CONCAT(str, fib3,',');
        END WHILE;
        RETURN str;
    END IF;
END;

select fibonacci1();

set @admin='JOEL';
set @admin='HEITAN';


create OR REPLACE function verificarAdmin()
RETURNS text # AQUI NO OLVIDARSE S
begin
DECLARE RESPUESTA TEXT DEFAULT '';
if @admin = 'JOEL'then set respuesta= 'Usuario Admin';
else set respuesta='Usuario invitado';
end if;
RETURN RESPUESTA; #AQUI NO AFECTA QUE FALTA LA S
end;

SELECT verificarAdmin();



select min(est.edad)
from estudiantes as est;

create or replace function example2()
returns text
begin
    declare respuesta text;

    select min(est.edad) into respuesta
    from estudiantes as est;

    return respuesta;
end;

select example2();


create or replace function example2_1()
returns text
begin
    declare respuesta text default '';
    declare limite int;
    declare x int;


    select min(est.edad) into limite             # limite vale 20
    from estudiantes as est;

    # para saber si es par  variable%2=0
    if limite%2=0 then set x=2;
    while x<=limite do          # X es variable que tiene la funcion de contar
       set respuesta= concat(respuesta,x,',');
       set x=x+2;
end while;
    else
    set x=1;
    while x<=limite do
        set x=x+2;
        set respuesta= concat(respuesta,x,',');
        end while;
     end if;
    return respuesta;
end;


select example2_1();


create or replace function vowel_count(textoAIngresar varchar(50))
returns text
begin  # dentro de un concat que retornamos directo
    return  concat(
        #concatenamos longitud del textoAIngresar (-) y la longitud reemplazando dentro del textoAIngresar la palabra 'A' que divida la misma longitud para obtener un numero y asi sucsivamente
       concat (' a: ', (LENGTH(textoAIngresar) - LENGTH(REPLACE(textoAIngresar, 'a', '')))/LENGTH('a')) ,
       concat (' e: ', (LENGTH(textoAIngresar) - LENGTH(REPLACE(textoAIngresar, 'e', '')))/LENGTH('e')) ,
       concat (' i: ', (LENGTH(textoAIngresar) - LENGTH(REPLACE(textoAIngresar, 'i', '')))/LENGTH('i')) ,
       concat (' o: ', (LENGTH(textoAIngresar) - LENGTH(REPLACE(textoAIngresar, 'o', '')))/LENGTH('o')) ,
       concat (' u: ', (LENGTH(textoAIngresar) - LENGTH(REPLACE(textoAIngresar, 'u', '')))/LENGTH('u'))
     );
end;

select vowel_count('bendito sea diabloooo');

select vowel_count(est.apellidos), est.apellidos
from estudiantes as est;



create or replace function creditoNumber(credit_number int)
RETURNS text
begin
    declare respuesta text default '';          # Y = AND     O = OR
    case
        when credit_number>50000 then set respuesta='PLATINUM'; # Si es mayor a 50000 es PLATINIUM.
        when  credit_number>=10000 AND credit_number <= 50000  THEN SET respuesta='GOLD';      #Si es mayor igual a 10000 y menor igual a 50000 es GOLD.
        when credit_number<10000 then set respuesta='SILVER';                     #○ Si es menor a 10000 es SILVER
        else set respuesta='CASO DESCONOCIDO';  #CASO POR DEFECTO
    end case;
    return respuesta;
end;

