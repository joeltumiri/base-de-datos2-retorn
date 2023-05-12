create database defensa_hito3_2023;
use defensa_hito3_2023;

CREATE OR REPLACE FUNCTION COMPARA_CADENA(CADENA VARCHAR(55))
RETURNS VARCHAR(55)
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE vocal CHAR(1);
    DECLARE v_output VARCHAR(255) DEFAULT '';

    while length(cadena) > 0 DO
        SET vocal = SUBSTRING(CADENA, i, 1);
        IF vocal REGEXP '[a,e,i,o,u,A,E,I,O,U,0-9]' = 0 THEN
            SET v_output = CONCAT(v_output, vocal);
        END IF;
        SET i = i + 1;
    END WHILE;

    RETURN v_output;
END;

SELECT COMPARA_CADENA('mundo 12345');

create table clientes(
    id_client integer auto_increment not null primary key,
    fullname varchar(20),
    lastname varchar(20),
    age int,
    genero char(1)
);

insert into clientes (fullname, lastname, age, genero)
values('PEDRO','MENDOZA GUTIERREZ',22,'V'),
      ('LORENA','MIRANDA SALAZAR',19,'M'),
      ('RODRIGO','LENIN MENDOAZA',24,'V');


create or replace function edad_maxima()
returns text
begin
    declare respuesta text;

    select max(cli.age) into respuesta
    from clientes as cli;

    return respuesta;
end;

select min(cli.age)
from clientes as cli;

create or replace function edad_maxima()
returns text
begin
    declare respuesta text default '';
    declare limite int;
    declare x int;


    select min(cli.age) into limite # mi limite es 21
    from clientes as cli;

    # para saber si es par  variable%2=0
    if limite%2=0 then set x=2;
    while x<=limite do
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

select edad_maxima();
--
set @limit=7;  # set  @nombre de la variable   = asignacion valor(int o varchar)
create or replace function fibonacci1()
RETURNS text          #text nos permite adimitir numeros y textos
DETERMINISTIC
BEGIN
    DECLARE fib1 INT DEFAULT 0;
    DECLARE fib2 INT DEFAULT 1;
    DECLARE fib3 INT DEFAULT 0;
    DECLARE str VARCHAR(255) DEFAULT '0,1,';    # valor por defecto 0,1,

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
            SET str = CONCAT(str, fib3,','); #llama str
        END WHILE;
        RETURN str;
    END IF;
END;

select fibonacci1();


CREATE OR REPLACE FUNCTION reemplaza_palabras(cadena_principal VARCHAR(55), valor_a_reemplazar VARCHAR(55), nuevo_valor VARCHAR(55))
RETURNS VARCHAR(55)
BEGIN
    DECLARE resultado VARCHAR(55);

    SET resultado = REPLACE(cadena_principal, valor_a_reemplazar, nuevo_valor);

    RETURN resultado;
END;

SELECT reemplaza_palabras('UNIFRANZ, UNIFRANZ', 'UNIFRANZ', 'UNIVALLE');





CREATE OR REPLACE FUNCTION CADENA(cadena TEXT)
RETURNS text

BEGIN
     DECLARE mensaje text default '';
      SET mensaje=reverse(cadena);
 RETURN mensaje;
END;

SELECT CADENA('HOLA');

CREATE OR REPLACE FUNCTION invertir_cadena(cadena_original TEXT)
RETURNS TEXT

BEGIN
    DECLARE posicion INT DEFAULT 1;
    DECLARE cadena_invertida TEXT DEFAULT "";

    WHILE posicion <= CHAR_LENGTH(cadena_original) DO
        SET cadena_invertida = CONCAT(SUBSTRING(cadena_original, posicion, 1), cadena_invertida);
        SET posicion = posicion + 1;
    END WHILE;

    RETURN cadena_invertida;
END;
SELECT invertir_cadena('HOLA');



CREATE PROCEDURE sumFibonacci(IN str TEXT, OUT sum INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE val INT;
    DECLARE total INT DEFAULT 0;

    WHILE i <= CHAR_LENGTH(str) DO
        SET val = SUBSTRING_INDEX(SUBSTRING_INDEX(str, ', ', i), ', ', -1);
        SET total = total + val;
        SET i = i + 1;
    END WHILE;

    SET sum = total;
END;

DELIMITER ;

CALL sumFibonacci('0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ', @sum);


