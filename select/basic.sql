-- select 기본
select first_name,
	  last_name,
      gender,
      hire_date
	from employees;
    
-- concat
select concat(first_name, ' ', last_name),
	   gender,
       hire_date
	from employees;
    
    
-- alias -> as
-- 생략 가능
select concat(first_name, ' ', last_name) as name,
	   gender,
       hire_date
	from employees;