--1. 학번, 학생명, 학과명 조회
-- 학과 지정이 안된 학생은 존재하지 않는다.
select S.student_no 학번, S.student_name 학생명,
            D.department_name 학과명
from tb_student S
    join tb_department D
        on S.department_no = D.department_no;

--2. 수업번호, 수업명, 교수번호, 교수명 조회
select C.class_no 수업번호, C.class_name 수업명,
            CP.professor_no 교수번호,
            P.professor_name 교수명
from tb_class C
    left join tb_class_professor CP
        on C.class_no =  CP.class_no
    left join tb_professor P
        on CP.professor_no = P.professor_no;

--3. 송박선 학생의 모든 학기 과목별 점수를 조회(학기, 학번, 학생명, 수업명, 점수)
select G.term_no 학기,
            S.student_no 학번,
            S.student_name 학생명,
            C.class_name 수업명,
            G.point 점수
from tb_student S
    left join tb_grade G
        on S.student_no = G.student_no
    left join tb_class C
        on G.class_no = C.class_no
where S.student_name like '송박선'
order by 1;

--4. 학생별 전체 평점(소수점이하 첫째자리 버림) 조회 (학번, 학생명, 평점)
--같은 학생이 여러학기에 걸쳐 같은 과목을 이수한 데이터 있으나, 전체 평점으로 계산함.
select S.student_no,
            S.student_name,
            trunc(avg(G.point), 1)
from tb_student S
    join tb_grade G
        on S.student_no = G.student_no
group by S.student_no, S.student_name;

--5. 교수번호, 교수명, 담당학생명수 조회
-- 단, 5명 이상을 담당하는 교수만 출력
select P.professor_no 교수번호, P.professor_name 교수명,
            count(*) 담당학생명수
from tb_professor P
    join tb_student S
        on P.professor_no = S.coach_professor_no
group by P.professor_no, P.professor_name
having count(*) >= 5
order by 3;

select *
from tb_student
where coach_professor_no = 'P102'