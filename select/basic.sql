-- select 기본
-- ex1) employees 테이블에서 직원의 이름,  성별, 입사일을 출력
select first_name, 
   last_name,
    gender,
    hire_date
from employees;

-- concat
-- ex2) employees 테이블에서 직원의 전체이름,  성별, 입사일을 출력
select concat (first_name, ' ', last_name),
    gender,
    hire_date
from employees;

-- alias -> as
-- 생략 가능
-- ex3) employees 테이블에서 직원의 이름,  성별, 입사일을 출력
select concat (first_name, ' ', last_name) as 이름,
    gender as 성별,
    hire_date as '입사 날짜'
from employees;

-- 중복 제거 distinct()
-- ex4) titles 테이블에서 직급은 어떤 것들이 있는지 직급이름을 한 번씩만 출력
select distinct(title) from titles;

-- order by
-- ex5) employees 테이블에서 직원의 전체이름,  성별, 입사일을  입사일 순으로 출력
select concat (first_name, ' ', last_name) as 이름,
    gender as 성별,
    hire_date as '입사 날짜'
from employees
order by hire_date desc;

-- ex6) salaries 테이블에서 2001년 월급을 가장 높은순으로 사번, 월급순으로 출력
select emp_no, salary
  from salaries
where from_date like '2001%'
order by salary desc;

-- where (조건절)
-- ex7) employees 테이블에서 1991년 이전에 입사한 직원의 이름, 성별, 입사일을 출력
select concat(first_name, ' ', last_name) as 이름,
	   gender as 성별,
       hire_date as '입사 날짜'
  from employees
where hire_date <'1991-01-01'
order by hire_date desc;

-- ex8) employees 테이블에서 1989년 이전에 입사한 여직원의 이름, 입사일을 출력
  select concat(first_name, ' ', last_name) as 이름,
	   gender as 성별,
       hire_date as '입사 날짜'
    from employees
  where hire_date <'1989-01-01'
    and gender = 'f'
order by hire_date desc;

-- ex9) dept_emp 테이블에서 부서 번호가 d005나 d009에 속한 사원의 사번, 부서번호 출력
-- in은 or와 같다.
select emp_no, dept_no
  from dept_emp
where dept_no in ('d005', 'd009');

-- Like 검색
-- ex10 employees 테이블에서 1989년에 입사한 직원의 이름, 입사일을 출력
  select concat(first_name, ' ', last_name) as 이름,
       hire_date as '입사 날짜'
    from employees
  where hire_date like '1989%'
  -- where hire_date <= '1989-12-31'
  	-- and hire_date >= '1989-01-01'
order by hire_date desc;





