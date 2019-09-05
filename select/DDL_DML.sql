-- DDL
create table user(
	no int unsigned not null auto_increment, -- auto_increment 자동으로 숫자 1씩 증가
    email varchar(100) not null default 'NO EMAIL',
    passwd varchar(64) not null,
    name varchar(25),
    dept_name varchar(25),
    
    primary key(no)
);

select * from user where passwd = password('1234');

-- insert
insert into user values(null, 'kickscar@gmail.com', password('1234'), '경진이', '인사팀');
insert into user(email, passwd) values('kickscar2@gmail.com', password('1234'));
insert into user(passwd) values(password('1234'));
insert into user(passwd, email) values(password('1234'), 'kickscar3@gmail.com');

desc user;

-- alter table
alter table user add juminbunho char(13) not null after no; -- after 칼럼 : 칼럼뒤에 추가
alter table user drop juminbunho;
alter table user add join_date datetime default now();
alter table user change email email varchar(200) not null default 'NO EMAIL';
alter table user change dept_name department_name varchar(25);
alter table user rename user2;
drop table user2;

-- update(DML)
update user
   set email = 'kickscar4@gmail.com',
       name = '경진아 일하자'
 where no = 3;

-- delete(DML)
delete
  from user
 where no = 4;

select * from user;