-- curdate(), current_date =>  yyyy, MM, DD
select curdate(), current_date;

-- curtime(), current_time => hh, mm, ss
select curtime(), current_time;

-- now(), sysdate(), current_timestamp => yyyy, MM, dd, hh, mm, ss
select now(), sysdate(), current_timestamp();

-- now() vs sysdate()
-- now()는 쿼리가 시작할때 시간
-- sysdate()는 sysdate()가 쿼리가 출력될때 시간
-- sleep을 걸어주게 되면 now()는 같은 시간이 출력되지만,
-- sysdate()는 시간 차이가 생기게 된다.
select now(), sleep(2), now();
select sysdate(), sleep(2), sysdate();

-- date_format
select date_format(now(), '%Y년 %m월 %d일 %h시 %i분 %s초');
select date_format(sysdate(), '%y-%c-%e %h:%i:%s');

-- period_diff(p1, p2)
-- : YYMM, YYYYMM으로 표기되는 p1과 p2의 차이의 개월을 반환한다.
-- ex) 직원들의 근무 개월 수 구하기
select concat(first_name, ' ', last_name) as 'name',
	   period_diff(date_format(curdate(), '%Y%m'),
       date_format(hire_date, '%Y%m'))
  from employees;
  
-- date_add = adddate
-- date_sub = subdate
-- (date, INTERVAL expr type)
-- : 날짜 date에 type 형식(year, month, day)으로 지정한 expr값을 더하거나 뺀다.
-- ex) 각 직원들의 6개월 후 근무 평가일
select concat(first_name, ' ', last_name) as 'name',
	   hire_date,
       date_add(hire_date, INTERVAL 6 month)
  from employees;
  
-- cast
select now(), cast(now() as date), cast(now() as datetime);

select cast(1-2 as unsigned);

select cast(cast(1-2 as unsigned) as signed);
