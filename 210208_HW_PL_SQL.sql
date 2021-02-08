-- @실습문제 : tb_number 테이블에 난수 100개(0 ~ 999)를 저장하는 익명 블럭을 생성하세요
-- 실행시마다 생성된 모든 난수의 합을 콘솔에 출력할 것.

create table tb_number(
    id number, --pk sequnce 객체로부터 채번
    num number, --난수
    reg_date date default sysdate,
    constraints pk_tb_number_id primary key(id)
);

create sequence seq_number_id
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 20;

declare
    rnd number;
    sum1 number := 0;
begin
    for n in 1..100 loop
        rnd := trunc(dbms_random.value(0, 1000));
        insert into tb_number (id, num)
        values(seq_number_id.nextval, rnd);
        sum1 := sum1 + rnd;
    end loop;
    
     dbms_output.put_line('합계 : ' || sum1);
end;
/

-- sum을 못쓰냐?

drop table tb_number;
drop sequence seq_number_id;

select *
from tb_number;
