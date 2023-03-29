create database library;
use library;

create table categories
(
  category_id int auto_increment primary key not null,
  name varchar(100) not null
);

create table publishers
(
  publisher_id int auto_increment primary key not null,
  name varchar(100) not null
);


create table boooks
(
  book_id int auto_increment primary key not null,
  title varchar (100) not null,
  isbn varchar (100) not null,
  published_date date not null,
  description varchar (100) not null,
  category_id int not null,
  publisher_id int not null,
  foreign key (category_id) references categories(category_id),
  foreign key (publisher_id) references publishers(publisher_id)
);
