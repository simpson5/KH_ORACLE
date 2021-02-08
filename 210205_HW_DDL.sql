-- 1. 계열 정보를 저장핛 카테고리 테이블을 맊들려고 핚다. 다음과 같은 테이블을 작성하시오.
 create table TB_CATEGORY (
    name varchar2(10),
    use_yn char(1) default 'Y'
 );
 
 -- 2. 과목 구분을 저장핛 테이블을 맊들려고 핚다. 다음과 같은 테이블을 작성하시오.
 create table TB_CLASS_TYPE (
    no varchar(5),
    name varchar(10),
    constraint pk_tb_class_type_name primary key(no)
 );
 
-- 3. TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY 를 생성하시오.
--  (KEY 이름을 생성하지 않아도 무방함. 맊일 KEY 이를 지정하고자 핚다면 이름은 본인이 알아서 적당핚 이름을 사용핚다.)
alter table TB_CATEGORY
add constraints pk_tb_category_name primary key(name);

-- 4. TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.

alter table TB_CLASS_TYPE
modify name varchar(10) not null;

-- 5. 두 테이블에서 컬럼 명이 NO 인 것은 기존 타입을 유지하면서 크기는 10 으로, 컬럼명이
-- NAME 인 것은 마찪가지로 기존 타입을 유지하면서 크기 20 으로 변경하시오.
 
 alter table TB_CLASS_TYPE
--  modify name varchar(20);
 modify no varchar(10);
 
 alter table TB_CATEGORY
 modify name varchar(20);
-- modify no varchar(10);
 
 -- 6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 각 TB_ 를 제외핚 테이블 이름이 앞에 붙은 형태로 변경핚다.
alter table TB_CLASS_TYPE
rename column no to class_type_no;

alter table TB_CATEGORY
rename column name to CATEGORY_NAME;

-- 7. TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이 변경하시오.
 alter table TB_CATEGORY
 rename constraint pk_tb_category_name to PK_CATEGORY_NAME;
 
-- 8. 다음과 같은 INSERT 문을 수행핚다.
INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT;
 
-- 9.TB_DEPARTMENT 의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모
-- 값으로 참조하도록 FOREIGN KEY 를 지정하시오. 이 때 KEY 이름은
-- FK_테이블이름_컬럼이름으로 지정핚다. (ex. FK_DEPARTMENT_CATEGORY )

alter table TB_DEPARTMENT
add constraint FK_DEPARTMENT_CATEGORY foreign key(CATEGORY) references TB_CATEGORY(CATEGORY_NAME);
                                 
select *                                                                                                                                    
from TB_DEPARTMENT;

select *
from TB_CATEGORY;

-- 10. 춘 기술대학교 학생들의 정보맊이 포함되어 있는 학생일반정보 VIEW 를 맊들고자 핚다. 아래 내용을 참고하여 적젃핚 SQL 문을 작성하시오.

-- chun 계정에 권한이 없더라 ㅠㅜ...
create view view_student
as
select student_no,
            student_name,
            student_address
from tb_student;

-- 11. 춘 기술대학교는 1 년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행핚다.
-- 이를 위해 사용핛 학생이름, 학과이름, 담당교수이름 으로 구성되어 있는 VIEW 를 맊드시오.
-- 이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오 (단, 이 VIEW 는 단순 SELECT
-- 맊을 핛 경우 학과별로 정렬되어 화면에 보여지게 맊드시오.)

create view view_interview
as
select student_name 이름,
            (
            select department_name
            from tb_department
            where department_no = S.department_no
            ) 학과,
            nvl((
            select professor_name
            from tb_professor
            where professor_no = S.coach_professor_no
            ), '없음') 지도교수
from tb_student S;

-- 12. 모든 학과의 학과별 학생 수를 확인핛 수 있도록 적젃핚 VIEW 를 작성해 보자.
create view view_student_cnt
as
select (
            select department_name
            from tb_department
            where department_no = S.department_no
            ) 학과,
            count(*) 학생수
from tb_student S
group by department_no;

select *
from view_student_cnt;

-- 13. 위에서 생성핚 학생일반정보 View 를 통해서 학번이 A213046 인 학생의 이름을 본인 이름으로 변경하는 SQL 문을 작성하시오.

update view_student
set student_name = '심슨'
where student_no = 'A213046';

select *
from view_student
where student_no = 'A213046';

-- 14. 13 번에서와 같이 VIEW 를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW 를 어떻게 생성해야 하는지 작성하시오.
create or replace view view_student
as
select student_no,
            student_name,
            student_address
from tb_student
with read only;

-- 15. 춘 기술대학교는 매년 수강신청 기갂맊 되면 특정 인기 과목들에 수강 신청이 몰려
-- 문제가 되고 있다. 최근 3 년을 기준으로 수강인원이 가장 맋았던 3 과목을 찾는 구문을
-- 작성해보시오.
select *
from tb_class;

select *
from tb_grade
where substr(term_no,1,4) > 2006
order by 1 desc;

create or replace view view_class_cnt
as
select class_no 과목번호,
            (
            select class_name
            from tb_class
            where class_no = G.class_no
            ) 과목명,
            count(*) 누적수강생수
from tb_grade G
where substr(term_no,1,4) > 2004
group by class_no
order by 누적수강생수 desc, 과목번호;

select *
from view_class_cnt;

select *
from view_class_cnt
where rownum between 1 and 5;
