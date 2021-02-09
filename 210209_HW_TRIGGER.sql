-- @실습문제
-- emp_copy에서 사원을 삭제할 경우, emp_copy_del 테이블로 데이터를 이전시키는 trigger를 생성하세요.
-- quit_date에 현재 날짜를 기록할 것
create table emp_copy_del
as
select E.*
from emp_copy2 E
where 1 = 2;

-- 1. copy2 에서 삭제가 실행될 경우 copy3의 있는 데이터를 emp_copy_del 옮긴다.
-- 2. emp_copy_del의 정보를 변경
-- 3. copy3 데이터 삭제
create or replace trigger trig_emp_quit
    before
    delete on emp_copy2
    for each row
declare
    v_name emp_copy2.emp_name%type;
    v_emp emp_copy2%rowtype;
begin
    v_name := :old.emp_name;
    dbms_output.put_line(v_name || ' 퇴사함...');
    -- 1. 데이터 이동
    insert into emp_copy_del
    select *
    from emp_copy3
    where emp_name = v_name;
    -- 2. 데이터 변경
    update emp_copy_del
    set quit_date = sysdate, quit_yn = 'Y'
    where emp_name = v_name;
    -- 3. 백업(?) 데이터 삭제
    delete emp_copy3
    where emp_name = v_name;
end;
/

delete emp_copy2
where emp_id = 201;

select *
from emp_copy_del;

select *
from emp_copy2;

select *
from emp_copy3;

-- 실패 1
-- 삭제 후 행 삽입이 불가하다... why?
create or replace trigger trig_emp_quit
    before
    delete on emp_copy2
    for each row
declare
    v_name emp_copy2.emp_name%type;
    v_emp emp_copy2%rowtype;
begin
    v_name := :old.emp_name;
    dbms_output.put_line(v_name || ' 퇴사함...');
    update emp_copy2
    set quit_date = sysdate, quit_yn = 'Y'
    where emp_name = v_name;
    insert into emp_copy_del
    select *
    from emp_copy2
    where emp_name = v_name;
end;
/

delete emp_copy2
where emp_id = 201;

-- 실패 2
-- 업데이트 후 행 삽입후 삭제도 불가...
create or replace trigger trig_emp_quit
    before
    update on emp_copy2
    for each row
declare
    v_name emp_copy2.emp_name%type;
begin
    v_name := :old.emp_name;
    dbms_output.put_line(v_name || ' 퇴사함...');
    insert into emp_copy_del
    select *
    from emp_copy2
    where emp_name = v_name;
    delete emp_copy2
    where emp_name = v_name;
end;
/

update emp_copy2
set quit_date = sysdate, quit_yn = 'Y'
where emp_id = 200;

-- 실패3
-- rowtype으로 행을 복사하고 그 행을 다시 넣기
create or replace trigger trig_emp_quit
    before
    delete on emp_copy2
    for each row
declare
    v_name emp_copy2.emp_name%type;
    v_emp emp_copy2%rowtype;
begin
    v_name := :old.emp_name;
    dbms_output.put_line(v_name || ' 퇴사함...');
    update emp_copy2
    set quit_date = sysdate, quit_yn = 'Y'
    where emp_name = v_name;
    select *
    into v_emp
    from emp_copy2
    where emp_name = v_name;
    insert into emp_copy_del (emp_name, emp_no)
    values (v_emp.emp_name, v_emp.emp_no);
end;
/

delete emp_copy2
where emp_id = 201;