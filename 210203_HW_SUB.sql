-- 1. 학생 이름, 주소지
select student_name 이름, student_address 주소지
from tb_student
order by 1;

-- 2.휴학중인 학생의 이름과 주민번호
select student_name 이름, student_ssn 주민번호
from tb_student
where absence_yn = 'Y'
order by 2 desc;

-- 3. 주소지가 강원도나 경기도인 학생들 중 1900 년대 학번을 가진 학생들의 이름과 학번,
-- 주소를 이름의 오름차순으로 화면에 출력하시오. 단, 출력헤더에는 "학생이름","학번",
-- "거주지 주소" 가 출력되도록 한다.
select  student_name 이름,
            student_no 학번,
            student_address 주소
from tb_student
where (student_address like '경기도%'
    or student_address like '강원도%')
     and  extract(year from entrance_date) < 2000;
     
-- 4. 현재 법학과 교수 중 가장 나이가 맋은 사람부터 이름을 확인핛 수 있는 SQL 문장을
-- 작성하시오. (법학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 내도록 하자)
select professor_name, professor_ssn
from tb_professor
where department_no = (
                                select department_no
                                from tb_department
                                where department_name = '법학과'
                                )
order by professor_ssn;

-- 5. 2004 년 2 학기에 'C3118100' 과목을 수강핚 학생들의 학점을 조회하려고 핚다. 학점이
-- 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을
-- 작성해보시오.

select student_no,
            (
            select point
            from tb_grade
            where term_no = '200402' and class_no = 'C3118100' and student_no = S.student_no
            ) point
from tb_student S
where student_no in (
                             select student_no
                             from tb_grade
                             where term_no = '200402' and class_no = 'C3118100'
                             )
order by point desc, 1;
                             
-- 6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL
-- 문을 작성하시오.
select student_no 학번,
            student_name 이름,
            (
            select department_name
            from tb_department
            where department_no = S.department_no
            )학과이름
from tb_student S
order by 2;
-- 7

select class_name 과목명,
            (
            select department_name
            from tb_department
            where department_no = C.department_no
            ) 학과명
from tb_class C;

-- 8. 과목별 교수 이름을 찾으려고 핚다. 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오
select class_name 과목명,
            (
            select professor_name
            from tb_professor
            where professor_no = (
                                            select professor_no
                                            from tb_class_professor
                                            where class_no = C.class_no
                                            )
            ) 교수이름
from tb_class C;

select C.class_name 과목명,
            P.professor_name 교수명
from tb_class C
    join tb_class_professor CP
        on C.class_no = CP.class_no
    join tb_professor P
        on CP.professor_no = P.professor_no;

--9. 8 번의 결과 중 ‘인문사회’ 계열에 속핚 과목의 교수 이름을 찾으려고 핚다. 이에
--해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.

select C.class_name 과목명,
            P.professor_name 교수명
from tb_class C
    join tb_class_professor CP
        on C.class_no = CP.class_no
    join tb_professor P
        on CP.professor_no = P.professor_no
where C.department_no in (
                                        select department_no
                                        from tb_department
                                        where category = '인문사회'
                                        );

-- 10. ‘음악학과’ 학생들의 평점을 구하려고 핚다. 음악학과 학생들의 "학번", "학생 이름",
-- "젂체 평점"을 출력하는 SQL 문장을 작성하시오. (단, 평점은 소수점 1 자리까지맊
-- 반올림하여 표시핚다.)         
select student_no 학번,
            student_name 이름,
            round((
            select avg(point)
            from tb_grade
            where student_no = S.student_no
            ), 1)평점
from tb_student S
where department_no = (
                                    select department_no
                                    from tb_department
                                    where department_name = '음악학과'
                                    );

-- 11. 학번이 A313047 인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 젂달하기
-- 위핚 학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 이때 사용핛 SQL 문을
-- 작성하시오. 단, 출력헤더는 ‚학과이름‛, ‚학생이름‛, ‚지도교수이름‛으로
-- 출력되도록 핚다.

select (
            select department_name
            from tb_department
            where department_no = S.department_no
            ) 학과,
            student_name 이름,
            (
            select professor_name
            from tb_professor
            where professor_no = S.coach_professor_no
            ) 지도교수
from tb_student S
where student_no = 'A313047';

-- 12. 2007 년도에 '인간관계론' 과목을 수강핚 학생을 찾아 학생이름과 수강학기름 표시하는 SQL 문장을 작성하시오.
select student_name 이름
from tb_student S
where student_no in (
                                select student_no
                                from tb_grade
                                where substr(term_no,1,4) = '2007'
                                    and class_no = (
                                                            select class_no
                                                            from tb_class
                                                            where class_name = '인간관계론'
                                                            )
                                );

select student_name 이름,
            G.term_no 수강학기
from tb_student S
    join tb_grade G
        on S.student_no = G.student_no
    join tb_class C
        on G.class_no = C.class_no
where substr(G.term_no,1,4) = '2007'         
    and C.class_name = '인간관계론';
    
--13. 예체능 계열 과목 중 과목 담당교수를 핚 명도 배정받지 못핚 과목을 찾아 그 과목
--이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.
select class_name 과목명,
            (
            select department_name
            from tb_department
            where department_no = C.department_no
            ) 학과
from tb_class C
where department_no in (
                                    select department_no
                                    from tb_department
                                    where category = '예체능'
                                    )
and class_no not in(select class_no
                            from tb_class_professor
                            );
                            
--14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 핚다. 학생이름과
--지도교수 이름을 찾고 맊일 지도 교수가 없는 학생일 경우 "지도교수 미지정‛으로
--표시하도록 하는 SQL 문을 작성하시오. 단, 출력헤더는 ‚학생이름‛, ‚지도교수‛로
--표시하며 고학번 학생이 먼저 표시되도록 핚다.

select student_name 이름,
            nvl((
            select professor_name
            from tb_professor
            where professor_no = S.coach_professor_no
            ), '교수미지정') 지도교수
from tb_student S
where department_no = (
                                    select department_no
                                    from tb_department
                                    where department_name = '서반아어학과'
                                    )
order by student_no;

--15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과
--이름, 평점을 출력하는 SQL 문을 작성하시오.
select student_no 학번,
            student_name 이름,
            (
            select department_name
            from tb_department
            where department_no = S.department_no
            ) 학과,
            (
            select avg(point)
            from tb_grade
            where student_no = S.student_no
            ) 평점
from tb_student S
where absence_yn = 'N'
    and 4 <= (
                    select avg(point)
                    from tb_grade
                    where student_no = S.student_no
                    );

-- 16. 홖경조경학과 젂공과목들의 과목 별 평점을 파악핛 수 있는 SQL 문을 작성하시오 

select class_no, avg(point)
from tb_grade
where class_no in (
                            select class_no
                            from tb_class
                            where department_no = (
                                                                select department_no
                                                                from tb_department
                                                                where department_name = '환경조경학과'
                                                                )
                            and class_type like '전공%'
                            )
group by class_no;

--17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 SQL 문을 작성하시오.
select *
from tb_student
where department_no = (
                                    select department_no
                                    from tb_student
                                    where student_name = '최경희'
                                    );
                                    
--18. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL 문을 작성하시오.                                    
with tb_korean as
(
select student_name 이름,
            student_no 학번
from tb_student
where department_no = (
                                    select department_no
                                    from tb_department
                                    where department_name = '국어국문학과'
                                    )
), tb_korean_point as
(
select K.이름, K.학번, avg(point) 평점
from tb_korean K
    join tb_grade G
        on K.학번 = G.student_no
group by K.이름, K.학번
)
select *
from tb_korean_point K
where not exists(
                        select 1
                        from tb_korean_point
                        where 평점 > K.평점
                        );

--19. 춘 기술대학교의 "홖경조경학과"가 속핚 같은 계열 학과들의 학과 별 젂공과목 평점을
--파악하기 위핚 적젃핚 SQL 문을 찾아내시오. 단, 출력헤더는 "계열 학과명",
--"젂공평점"으로 표시되도록 하고, 평점은 소수점 핚 자리까지맊 반올림하여 표시되도록
--핚다.
with tb_no_dept as
(
select student_no,
            (
             select department_name
             from tb_department
             where department_no = S.department_no
                and category = (
                                        select category
                                        from tb_department
                                        where department_name = '환경조경학과'
                                        )
             ) 학과
from tb_student S
)
select ND.학과,
            round(avg(G.point), 1) 평점
from tb_grade G
    join tb_no_dept ND
        on G.student_no = nd.student_no
group by ND.학과;

