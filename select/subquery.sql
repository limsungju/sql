-- 단일행 연산

-- ex1) (현재 Fai Bale이 근무하는 부서)에서 근무하는 (직원의 사번, 전체 이름)을 출력해보세요.

-- sol1-1)
select de.dept_no
  from dept_emp de, employees e
 where de.emp_no = e.emp_no
   and de.to_date = '9999-01-01'
   and concat(e.first_name, ' ', e.last_name) = 'Fai Bale';
   
-- sol1-2)
select e.emp_no, concat(e.first_name, ' ', e.last_name)
  from dept_emp de, employees e
 where de.emp_no = e.emp_no
   and de.to_date = '9999-01-01'
   and de.dept_no = 'd004';
   
-- subquery를 사용
select e.emp_no, concat(e.first_name, ' ', e.last_name)
  from dept_emp de, employees e
 where de.emp_no = e.emp_no
   and de.to_date = '9999-01-01'
   and de.dept_no = (select de.dept_no
					   from dept_emp de, employees e
					  where de.emp_no = e.emp_no
                        and de.to_date = '9999-01-01'
						and concat(e.first_name, ' ', e.last_name) = 'Fai Bale');

-- 서브쿼리는 괄호로 묶여야함
-- 서브쿼리 내에 order by 금지
-- group by 절 외에 거의 모든 절에서 사용가능(from절, where절에 많이 사용)
-- where 절인 경우,
-- 1) 단일행 연산자: =, >, <, >=, <=, <>


-- 실습문제1) 현재 전체사원의 평균 연봉보다 적은 급여를 받는 사원의 이름, 급여를 나타내세요.
  select concat(e.first_name, ' ', e.last_name) as '이름', s.salary
    from employees e, salaries s
   where e.emp_no = s.emp_no
     and s.to_date = '9999-01-01'
     and s.salary < (select avg(s.salary)
					 from salaries s
                    where s.to_date = '9999-01-01');

-- 실습문제2) 현재 가장적은 평균 급여를 받고 있는 직책에 대해서 평균 급여를 구하세요.
  select t.title, avg(s.salary)
    from salaries s, titles t
   where s.emp_no = t.emp_no
     and s.to_date = '9999-01-01'
     and t.to_date = s.to_date
group by t.title
order by avg(s.salary) asc
   limit 0, 1;

-- Top-K 를 사용
  select t.title, avg(s.salary)
    from salaries s, titles t
   where s.emp_no = t.emp_no
     and s.to_date = '9999-01-01'
     and t.to_date = s.to_date
group by t.title
  having round(avg(s.salary)) = (select round(avg(s.salary)) as avg_salary
                                   from salaries s, titles t
								  where s.emp_no = t.emp_no
                                    and s.to_date = '9999-01-01'
                                    and t.to_date = s.to_date
                               group by t.title
							   order by avg(s.salary) asc
								  limit 0, 1);
                                  
-- from절 서브쿼리 및 집계
  select t.title, avg(s.salary)
    from salaries s, titles t
   where s.emp_no = t.emp_no
     and s.to_date = '9999-01-01'
     and t.to_date = s.to_date
group by t.title
  having round(avg(s.salary)) = (select min(a.avg_salary)
								   from (select round(avg(s.salary)) as avg_salary
                                           from salaries s, titles t
                                          where s.emp_no = t.emp_no
                                            and s.to_date = '9999-01-01'
                                            and t.to_date = s.to_date
									   group by t.title) as a);

-- 방법3: join으로 만 풀기(굳이 서브쿼리를 쓸 필요가 없다)
  select t.title, avg(s.salary)
    from salaries s, titles t
   where s.emp_no = t.emp_no
     and s.to_date = '9999-01-01'
     and t.to_date = s.to_date
group by t.title
order by avg(s.salary) asc
   limit 0, 1;

-- where 절인 경우
-- 2) 다중(복수)행 연산자 : in, not in, any, all
--    2-1) any 사용법
--       1. =any : in 과 완전동일
--       2. >any, >=any : 최소값
--       3. <any, <=any : 최대값
--       4. <>any, !=any : !=all 과 동일
--    2-2) all 사용법
--       1. =all
--       2. >all, >=all : 최대값
--       3. <all, <=all : 최소값

-- ex1) 현재 급여가 50000 이상인 직원 이름 출력
-- join으로 해결
select concat(e.first_name, ' ', e.last_name)
  from employees e, salaries s
 where e.emp_no = s.emp_no
   and s.to_date = '9999-01-01'
   and s.salary >= '50000';
   
-- in
select concat(first_name, ' ', last_name)
  from employees
 where emp_no in (select emp_no
                   from salaries
                  where to_date = '9999-01-01'
                    and salary >= '50000');

-- =any
select concat(first_name, ' ', last_name)
  from employees
 where emp_no =any (select emp_no
                   from salaries
                  where to_date = '9999-01-01'
                    and salary >= '50000');

-- ex2) 각 부서별로 최고월급을 받는 직원의 이름과 월급출력
-- 방법 1: where절에 서브쿼리를 사용
  select concat(e.first_name, ' ', e.last_name) as '이름', de.dept_no, s.salary 
    from employees e, salaries s, dept_emp de
   where e.emp_no = s.emp_no
     and e.emp_no = de.emp_no
     and s.to_date = '9999-01-01'
     and de.to_date = '9999-01-01'
     and (de.dept_no, s.salary) =any (select de.dept_no, max(s.salary) as max_salary 
                                    from employees e, salaries s, dept_emp de
								   where e.emp_no = s.emp_no
									 and e.emp_no = de.emp_no
                                     and s.to_date = '9999-01-01'
                                     and de.to_date = '9999-01-01'
								group by de.dept_no);

-- 방법 2: from절에 서브쿼리를 사용
  select concat(e.first_name, ' ', e.last_name) as '이름', de.dept_no, s.salary 
    from employees e, salaries s, dept_emp de,  (select de.dept_no, max(s.salary) as max_salary 
                                                   from employees e, salaries s, dept_emp de
	                                              where e.emp_no = s.emp_no
									                and e.emp_no = de.emp_no
                                                    and s.to_date = '9999-01-01'
                                                    and de.to_date = '9999-01-01'
											   group by de.dept_no) as a
   where e.emp_no = s.emp_no
     and e.emp_no = de.emp_no
     and de.dept_no = a.dept_no
     and s.to_date = '9999-01-01'
     and de.to_date = '9999-01-01'
     and s.salary = a.max_salary;
