create database biblioteca;
use biblioteca;

create table autor
(
  id int auto_increment primary key,
  nombre varchar(50) not null,
  nacionalidad varchar(50) not null,
  fecha_nacimiento date
);

create table usuario
(
  id int auto_increment primary key,
  nombre varchar(50)not null,
  email varchar(100) not null,
  fecha_nacimento date,
  direccion varchar (100)
);

create table libro
(
  id int auto_increment primary key,
  titulo varchar(100) not null,
  isbn varchar(20),
  fecha_publicacion date,
  autor_id int,
  foreign key (autor_id) references autor(id)
);

create table prestamo
(
  id int auto_increment primary key,
  fecha_inicio date not null,
  fecha_fin date not null,
  libro_id int references libro(id) on delete cascade,
  usuario_id int references usuario(id) on delete cascade
);

create table categoria
(
  id int auto_increment primary key,
  nombre varchar(50)not null
);

create table libro_categoria
(
  id int auto_increment primary key,
  libro_id int references libro (id)on delete cascade,
  categoria_id int references categoria (id)on delete cascade
);

INSERT INTO autor (nombre, nacionalidad, fecha_nacimiento) VALUES
('Gabriel Garcia Marquez', 'Colombiano', '1927-03-06'),
('Mario Vargas Llosa', 'Peruano', '1936-03-28'),
('Pablo Neruda', 'Chileno', '1904-07-12'),
('Octavio Paz', 'Mexicano', '1914-03-31'),
('Jorge Luis Borges', 'Argentino', '1899-08-24');

INSERT INTO libro (titulo, isbn, fecha_publicacion, autor_id) VALUES
('Cien años de soledad', '978-0307474728', '1967-05-30', 1),
('La ciudad y los perros', '978-8466333867', '1962-10-10', 2),
('Veinte poemas de amor y una canción desesperada', '978-0307477927', '1924-08-14', 3),
('El laberinto de la soledad', '978-9681603011', '1950-01-01', 4),
('El Aleph', '978-0307950901', '1949-06-30', 5);
-- poner en registro el aleph II en registro

INSERT INTO usuario (nombre, email, fecha_nacimento, direccion) VALUES
('Juan Perez', 'juan.perez@gmail.com', '1985-06-20', 'Calle Falsa 123'),
('Maria Rodriguez', 'maria.rodriguez@hotmail.com', '1990-03-15', 'Av. Siempreviva 456'),
('Pedro Gomez', 'pedro.gomez@yahoo.com', '1982-12-10', 'Calle 7ma 789'),
('Laura Sanchez', 'laura.sanchez@gmail.com', '1995-07-22', 'Av. Primavera 234'),
('Jorge Fernandez', 'jorge.fernandez@gmail.com', '1988-04-18', 'Calle Real 567');

INSERT INTO prestamo (fecha_inicio, fecha_fin, libro_id, usuario_id) VALUES
('2022-01-01', '2022-01-15', 1, 1),
('2022-01-03', '2022-01-18', 2, 2),
('2022-01-05', '2022-01-20', 3, 3),
('2022-01-07', '2022-01-22', 4, 4),
('2022-01-09', '2022-01-24', 5, 5);


INSERT INTO categoria (nombre) VALUES
('Novela'),
('Poesía'),
('Ensayo'),
('Ciencia Ficción'),
('Historia');


INSERT INTO libro_categoria (libro_id, categoria_id) VALUES
(1, 1),
(1, 3),
(2, 1),
(2, 5),
(3, 2),
(4, 3),
(5, 4);



alter table libro
add column paginas int default 20,
add column editorial varchar (50) default 'Don Bosco';

--
select*
from libro;

select*
    from autor;

select*
from categoria;

-- mostrar todos los libros de los autores
-- de nacionalidad Argentina
select*
from autor as au
inner join libro as lib on au.id = lib.autor_id
where au.nacionalidad = 'Argentino';

-- mostrar los libros de la categoria ciencia ficcion
create view libros_ciencia_ficcion as
select lib.titulo as libro,
       cat.nombre as categoria
from libro_categoria as lc
inner join libro as lib on lc.libro_id = lib.id
inner join categoria as cat on lc.categoria_id = cat.id
where cat.nombre = 'Ciencia Ficcion';

--
create or replace view bookContenet as
select lib.titulo as titleBook,
       lib.editorial as editorialBook,
       lib.paginas as pagesBook,
       (
        CASE
        WHEN lib.paginas > 10 AND lib.paginas <= 30 THEN 'contenido basico'
        WHEN lib.paginas > 30 AND lib.paginas <= 80 THEN 'contenido mediano'
        WHEN lib.paginas > 80 AND lib.paginas <= 150 THEN 'contenido superior'
        ELSE 'contenido avanzado'
            END
       )AS typecontentBook
from libro as lib;

# de acuerdo a la vista creada
# CONTAR cuantos libros son de contenido medio
select count(typecontentBook)
from bookContenet
where typeContentBook = 'contenido mediano';


create view book_and_autor as
select concat(lib.titulo,' - ', lib.editorial,' - ', cat.nombre) as book_detail,
       concat(au.nombre,' - ', au.nacionalidad) as autor_detail
from libro as lib
inner join autor as au on lib.autor_id = au.id
inner join libro_categoria as lc on lib.id = lc.libro_id
inner join categoria as cat on cat.id = lc.categoria_id;

-- dea cuerdo a la vista creada generar la siguiente
-- si en el book_datail esta la editorial NOVA
-- generar una columna que diga "EN VENTA"
-- casa contrario colocar "EN PROCESO"
SELECT *,
(
    CASE
        WHEN b.book_detail LIKE '%NOVA%' THEN 'EN VENTA'
        ELSE  'EN PROCESO'
    END
) AS Promocion
FROM book_and_autor as b;
-- -- -- --
create view autores_peru_historia as
    select c.nombre as category,
           a.nombre as name,
           a.nacionalidad as nacionality
from libro as lib
inner join libro_categoria lc on lib.id = lc.libro_id
inner join categoria c on lc.categoria_id = c.id
inner join autor a on lib.autor_id = a.id
where c.nombre = 'historia' and a.nacionalidad = 'peruano';

select*
from autores_peru_historia;


-- funcion que retorna mi nombre
create or replace function fullname()
returns varchar(50)
begin
return 'joel reynaldo condori tumiri';
end;

select fullname();

create or replace function numero()
returns int
begin
return 14;
end;

select numero();

-- crear una funcion que reciba un parametro
-- de tipo cadena

create or replace function getNombreCompleto(nombres varchar(30))
returns varchar (30)
begin
    return nombres;
end;


select getNombreCompleto('joel');

-- crear funcion que sume 3 nuemros
-- funcion recibe tres parametros de tipo int
create or replace function SUMA(num1 int, num2 int, num3 int)
returns int
begin
    return num1+ num2+ num3;
end;

select SUMA(5,5,5);

--
create or replace function SUMA(num1 int, num2 int, num3 int)
returns int
begin
    declare respuesta int;
    set respuesta = num1+num2+num3;

    return respuesta;
end;

select SUMA(5,5,5);
--
create or replace function operaciones(a int, b int, c varchar(30))
    returns int
    begin
        declare r int;

        if (c = 'sumar') then
            set r = a + b;
        end if;
        if (c = 'restar') then
            set r = a - b;
        end if;
        if (c = 'multiplicar') then
            set r = a * b;
        end if;
        if (c = 'dividir') then
            set r = a / b;
        end if;
        return r;
    end;
select operaciones(5,5, 'sumar');
select operaciones(5,5,'restar');
select operaciones(5,5,'multiplicar');
select operaciones(5,5,'dividir');

--
create function valida_historia_peru
    (cat varchar(30),
    nac varchar (30))

returns bool
    begin
        declare respuesta bool default false;
        if cat = 'historia'and nac = 'peruano' then
        set respuesta = true;
    end if;

        return respuesta;
        end;