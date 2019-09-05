-- 문제1.
-- 현재 평균 연봉보다 많은 월급을 받는 직원은 몇 명이나 있습니까?
  select count(*) as '평균보다 많이 받는 직원 수'
    from employees e, salaries s
   where e.emp_no = s.emp_no
     and s.to_date = '9999-01-01'
     and s.salary > (select avg(salary)
                       from salaries
				      where to_date = '9999-01-01');

-- 문제2. 
-- 현재, 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서, 연봉을 조회하세요. 단 조회결과는 연봉의 내림차순으로 정렬되어 나타나야 합니다. 
select e.emp_no as '사번', concat(e.first_name, ' ', e.last_name) as '이름', d.dept_name as '부서', s.salary as '연봉'
  from employees e, salaries s, dept_emp de, departments d
 where e.emp_no = s.emp_no
   and e.emp_no = de.emp_no
   and de.dept_no = d.dept_no
   and s.to_date = '9999-01-01'
   and de.to_date = '9999-01-01'
   and (d.dept_name, s.salary) =any (select d.dept_name as '부서', max(s.salary) as max_salary
                                       from employees e, salaries s, dept_emp de, departments d
                                      where e.emp_no = s.emp_no
                                        and e.emp_no = de.emp_no
									    and de.dept_no = d.dept_no
									    and de.dept_no = d.dept_no
									    and s.to_date = '9999-01-01'
									    and de.to_date = '9999-01-01'
								   group by dept_name)
group by s.salary desc;

-- 문제3.
-- 현재, 자신의 부서 평균 급여보다 연봉(salary)이 많은 사원의 사번, 이름과 연봉을 조회하세요 
select e.emp_no as '사번', concat(e.first_name, ' ', e.last_name) as '이름', s.salary as '연봉'
  from employees e, salaries s, dept_emp de, (select de.dept_no, avg(s.salary) as salary
															   from employees e, salaries s, dept_emp de
															  where e.emp_no = s.emp_no
															    and e.emp_no = de.emp_no
																and s.to_date = '9999-01-01'
																and de.to_date = '9999-01-01'
														   group by de.dept_no) as avg_salary
 where e.emp_no = s.emp_no
   and e.emp_no = de.emp_no
   and de.dept_no = avg_salary.dept_no
   and s.to_date = '9999-01-01'
   and de.to_date = '9999-01-01'
   and s.salary > avg_salary.salary;

-- 문제4.
-- 현재, 사원들의 사번, 이름, 매니저 이름, 부서 이름으로 출력해 보세요.
select e.emp_no as '사번', concat(e.first_name, ' ', e.last_name) as '이름', d.dept_name as '부서', manager.mn as '매니저'
  from employees e, dept_emp de, departments d ,(select d.dept_no as mdn, concat(e.first_name, ' ', e.last_name) as mn
												   from employees e, dept_manager dm, departments d
												  where e.emp_no = dm.emp_no
												    and dm.dept_no = d.dept_no
												    and dm.to_date = '9999-01-01'
											   group by d.dept_no) as manager
 where e.emp_no = de.emp_no
   and de.dept_no = d.dept_no
   and d.dept_no = manager.mdn
   and de.to_date = '9999-01-01';

-- 매니저 출력
-- select dm.emp_no, d.dept_name, concat(e.first_name, ' ', e.last_name)
--   from employees e, dept_manager dm, departments d
--  where e.emp_no = dm.emp_no
--    and dm.dept_no = d.dept_no
--    and dm.to_date = '9999-01-01'
--  group by d.dept_no;


-- 문제5.
-- 현재, 평균연봉이 가장 높은 부서의 사원들의 사번, 이름, 직책, 연봉을 조회하고 연봉 순으로 출력하세요.
select e.emp_no as '사번', concat(e.first_name, ' ', e.last_name) as '이름', t.title as '직책', s.salary as '연봉' 
 from employees e, titles t, salaries s, dept_emp de
where e.emp_no = t.emp_no
  and e.emp_no = s.emp_no
  and e.emp_no = de.emp_no
  and t.to_date = '9999-01-01'
  and s.to_date = '9999-01-01'
  and de.to_date = '9999-01-01'
  and de.dept_no = (select de.dept_no
                     from employees e, salaries s, dept_emp de
                    where e.emp_no = s.emp_no
                      and e.emp_no = de.emp_no
                      and s.to_date = '9999-01-01'
                      and de.to_date = '9999-01-01'
                 group by de.dept_no
                 order by avg(s.salary) desc
					limit 1)
order by '연봉' desc;


-- 문제6.
-- 평균 연봉이 가장 높은 부서는?
select d.dept_name as '평균 연봉이 가장 높은 부서'
from departments d
where d.dept_no = (select dept_no
                     from employees e, salaries s, dept_emp de
                    where e.emp_no = s.emp_no
                      and e.emp_no = de.emp_no
                      and s.to_date = '9999-01-01'
                      and de.to_date = '9999-01-01'
                 group by de.dept_no
                 order by avg(s.salary) desc
                    limit 1);

-- 문제7.
-- 평균 연봉이 가장 높은 직책?
select t.title as '평균 연봉이 가장 높은 직책'
  from employees e, salaries s, titles t
 where e.emp_no = s.emp_no
   and e.emp_no = t.emp_no
   and s.to_date = '9999-01-01'
   and t.to_date = '9999-01-01'
group by t.title
order by avg(s.salary) desc
   limit 1;


-- 문제8.
-- 현재 자신의 매니저보다 높은 연봉을 받고 있는 직원은?
-- 부서이름, 사원이름, 연봉, 매니저 이름, 메니저 연봉 순으로 출력합니다.
select d.dept_name, concat(e.first_name, ' ', e.last_name), s.salary, manager.mname, manager.msalary
  from employees e, salaries s, dept_emp de, departments d, (select d.dept_name as mdept_name, concat(e.first_name, ' ', e.last_name) as mname, s.salary as msalary
															   from employees e, salaries s, dept_manager dm, departments d
															  where e.emp_no = dm.emp_no
																and e.emp_no = s.emp_no
																and dm.dept_no = d.dept_no
																and s.to_date = '9999-01-01'
																and dm.to_date = '9999-01-01'
														   group by d.dept_no) as manager
 where e.emp_no = s.emp_no
   and e.emp_no = de.emp_no
   and de.dept_no = d.dept_no
   and d.dept_name = manager.mdept_name
   and s.to_date = '9999-01-01'
   and de.to_date = '9999-01-01'
   and s.salary > manager.msalary;