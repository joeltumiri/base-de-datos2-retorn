create database hito4_2023;
use hito4_2023;

create table numeros
(
  numero BIGINT PRIMARY KEY NOT NULL ,
  cuadrado BIGINT,
  cubo BIGINT,
  raiz_cuadrada REAL
);

insert into numeros (numero) VALUES (2);

SELECT * FROM numeros;


create or replace trigger tr_completa_datos
before insert on numeros
for each row
begin
      declare valor_cuadrado BIGINT;
    declare valor_cubo BIGINT;
    declare valor_raiz REAL;

    SET valor_raiz = sqrt(NEW.numero);
    SET valor_cuadrado = power(NEW.numero, 2);
    SET valor_cubo = power(NEW.numero, 3);

    SET NEW.cuadrado = valor_cuadrado;
    SET NEW.cubo = valor_cubo;
    SET NEW.raiz_cuadrada = valor_raiz;
end;


insert into numeros (numero) VALUES (4);
SELECT * FROM numeros;
show triggers;
# eliminar todos los registros de la tabla numeros
# agregar un nuevo campo(suma_total REAL) a la tabla numeros. (esta columna debe reflejar la suma de todas
# las columnas), es decir (numero, cuadrado, cubo y raiz)
# el resultado deberia ser el siguiente (registro insertado numero 2)

delete from numeros;

ALTER TABLE numeros ADD suma_total REAL;

CREATE OR REPLACE TRIGGER suma_total
BEFORE INSERT ON numeros
FOR EACH ROW
BEGIN
   SET NEW.suma_total = NEW.numero + NEW.cuadrado + NEW.cubo + NEW.raiz_cuadrada;
END;

INSERT INTO numeros (numero) VALUES (2);

SELECT * FROM numeros;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
drop table usuarios;
create table usuarios
(
  id_usu int auto_increment key not null,
  nombres varchar(30) not null,
  apellidos varchar(30) not null,
  fecha_nac date not  null,
  edad int not null,
  correo varchar(30) not null,
  password varchar(50)

);

insert into usuarios (nombres, apellidos, edad, correo)
values ('william','barra',70,'user8@gmail.com');
select * from usuarios;

create trigger genera_password
before insert on usuarios
for each row                             #before despues
begin
    set new.password = 'pass-123';
end;
#no se puede modificar un registro desde un trigger
#cuando seesta insertando
CREATE OR REPLACE TRIGGER gen_pass
    BEFORE INSERT
    ON usuarios
    FOR EACH ROW
    BEGIN
        DECLARE nom,app TEXT;
        SET nom = (SELECT nombres FROM usuarios);
        SET app = (SELECT apellidos FROM usuarios);

        SET NEW.nombres = (SELECT SUBSTR(new.nombres,1,2));
        SET NEW.apellidos = (SELECT SUBSTR(new.apellidos,1,2));
        SET NEW.password = CONCAT(NEW.nombres,NEW.apellidos,NEW.edad);
        SET NEW.apellidos = app;
        SET NEW.nombres = nom;

    END;

insert into  usuarios(nombres, apellidos, edad, correo) values
('joel', 'condori', 23, 'joel@gmail.com');

drop trigger gen_pass;
drop table usuarios;
drop trigger tr_clacula_pass_edad;


create trigger tr_clacula_pass_edad
before insert on
usuarios
for each row
    begin
        set NEW.password = lower(concat(
            substring(new.nombres, 1, 2),
            substring(new.apellidos, 1, 2),
            substring(new.correo, 1, 2)

            ));
end;

select timestampdiff(year, '2001-01-06', curdate());

-- esto me permite ver la fecha en que debemos insertar la fecha por determinado
select current_date;









# crear un trigger para la tabla usuarios
# si tiene el password tiene mas de 10 caracteres
# caso contrario generar el password
# tomar los 2 ultimos coracteres del nombre apelliod y la edad
create trigger password_trigger
before insert on usuarios
for each row
begin
    if char_length(NEW.password) < 10
        then
        set NEW.password = concat(
            substring(new.nombres, -2),
            substring(new.apellidos, -2), new.edad);
    end if;
end;

create trigger tr_usuarios_mantenimiento
    before insert
    on usuarios
    for each row
    begin
        declare dia_de_la_semana text default '';
        set dia_de_la_semana = dayname(current_date);
        if dia_de_la_semana = 'wednesday'
            then
            signal  sqlstate '45000'
            set  message_text = 'base de datos en mantenimiento';
        end if;
    end;

alter table usuarios
add column nacionalidad varchar(30);

create table usuarios_rrhh
(
    id_usr integer primary key not null,
    nombre_completo varchar(50) not null,
    fecha_nac date not null,
    correo varchar(100) not null,
    password varchar(100)
);


insert into usuarios_rrhh(id_usr, nombre_completo, fecha_nac, correo, password)
values (123456, 'joel tumiri', '2001-01-06', 'joeltumiri@gmail.com', '123456');


select current_date;
select now();
select user();
#permite ver el nombre de la maquina
select @@hostname;
#permiete ver todas las variables de base de datos
show variables;

create table audit_usuarios_rrhh
(
    fecha_mod text not null,
    usuarios_log text not null,
    hostname text not null,
    accion text not null,


    id_usr text not null,
    nombre_completo text not null,
    password text not null
);

create trigger tr_audit_usuarios
    after delete
    on audit_usuarios_rrhh
    for each row
    begin
    declare id_usuario text;
    declare nombres text;
    declare usr_password text;

    set id_usuario = old.id_usr;
    set nombres = old.nombre_completo;
    set usr_password = old.password;

    insert into audit_usuarios_rrhh(fecha_mod, usuarios_log, hostname, accion, id_usr, nombre_completo, password)
        select now(), user(), @@hostname, 'delete', id_usuario, nombres, usr_password;
end;

select * from usuarios_rrhh;
select * from audit_usuarios_rrhh;

CREATE OR REPLACE TABLE audit_usuarios_rrhh(

    fecha_mod TEXT NOT NULL,
    usuario_log TEXT NOT NULL,
    hostname TEXT NOT NULL,
    accion TEXT NOT NULL,

    id_usu TEXT NOT NULL,
    nombre_complet TEXT NOT NULL,
    password TEXT NOT NULL

);

SELECT * FROM audit_usuarios_rrhh;

CREATE OR REPLACE TRIGGER tr_audit_usuarios_rrhh
    AFTER DELETE
    ON audit_usuarios_rrhh
    FOR EACH ROW
    BEGIN

        DECLARE id_us, nom, pass TEXT;

        SET id_us = OLD.id_usr;
        SET nom = OLD.nombre_completo;
        SET pass = OLD.password;

        INSERT INTO audit_usuarios_rrhh(fecha_mod, usuario_log, hostname, accion, id_usu, nombre_complet, password)
            SELECT NOW(), USER(), @@HOSTNAME,'DELETE',id_us,nom,pass;

        END;

CREATE OR REPLACE TRIGGER tr_audit_usuarios_rrhh_ins
    AFTER INSERT
    ON audit_usuarios_rrhh
    FOR EACH ROW
    BEGIN

        DECLARE id_us, nom, pass TEXT;

        SET id_us = NEW.id_usr;
        SET nom = NEW.nombre_completo;
        SET pass = NEW.password;

        INSERT INTO audit_usuarios_rrhh(fecha_mod, usuario_log, hostname, accion, id_usu, nombre_complet, password)
            SELECT NOW(), USER(), @@HOSTNAME,'INSERT',id_us,nom,pass;

        END;



CREATE OR REPLACE TRIGGER tr_audit
    AFTER UPDATE
    ON audit_usuarios_rrhh
    FOR EACH ROW
    BEGIN

        DECLARE antes TEXT DEFAULT CONCAT(OLD.id_usr,' - ',OLD.nombre_completo,' - ',OLD.hostname);
        DECLARE despues TEXT DEFAULT CONCAT(NEW.id_usr,' - ',NEW.nombre_completo,' - ',NEW.hostname);

        CALL inserta_datos(
            NOW(),
            USER(),
            @@HOSTNAME,
            'UPDATE',
            antes,
            despues
            );

        END;


CREATE PROCEDURE inserta_datos(fecha TEXT, usuario TEXT, hostname TEXT, accion TEXT, antes TEXT, despues TEXT)
BEGIN

    INSERT INTO audit_usuarios_rrhh(fecha_mod, usuario_log, hostname, accion, id_usu, nombre_complet, password)
        VALUES (fecha,usuario, hostname,accion,antes,despues);

END;