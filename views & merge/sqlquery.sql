--1
create view stddata 
as 
select concat_ws(' ',st_fname,st_lname) as [full name],crs_name
from Student s inner join Stud_Course stc
on s.St_Id=stc.St_Id
inner join Course c
on c.Crs_Id=stc.Crs_Id and grade>50

select *from stddata

--2
alter view insdata
with encryption
as
select ins_name as mangername,crs_name as topicname
from Instructor i,Department d,Ins_Course ic,Course c
where i.Ins_Id=d.Dept_Manager and i.Ins_Id=ic.Ins_Id and c.Crs_Id=ic.Crs_Id

select*from insdata

--3
create view dbo.inamedep
WITH
SCHEMABINDING
as
  select ins_name,dept_name
   from dbo.Instructor i inner join dbo.Department d
   on d.Dept_Id=i.Dept_Id and d.Dept_Name in ('sd','java')

  select*from dbo.inamedep

--4
create view v1 
as
	select *from Student where St_Address in ('alex','cairo')
	with check option

--5
Create table #emp
         (
          ename varchar(20),
          etask varchar(20)
          )

--6
create view pnum
 as
select count(essn) as numofemp,p.Pname
	from Project p ,Works_for w
	where p.Pnumber=w.Pno
	group by p.Pname

select *from pnum

--7
create table tlast
		  (
		  userid int primary key,
		  tamount int
		  )
		  insert into tlast values(1,4000),(4,2000),(2,10000)
		  create table tdaliy
		  (
		  userid int primary key,
		  tamount int
		  )
	insert into tdaliy values(1,1000),(2,2000),(3,1000)

merge into tlast as l
using tdaliy as d
on l.userid=d.userid
 when matched then
  update set l.tamount=d.tamount
  when not matched by source then delete;

  select*from tlast

--8
create view v_clerk
as
select ssn,Pnumber,[MGRStart Date]
from Employee e inner join Departments d
on  e.SSN=d.MGRSSN
inner join Project p
on d.Dnum=p.Dnum and job='clerk'

select *from v_clerk

		 --
--8
create view v_without_budget
as
select p.City,p.Dnum,p.Plocation,p.Pname,p.Pnumber from Project p

select * from v_without_budget	

--9
create view v_count 
as
select pname,count(job) as numofjobs
from Project p,Departments d
where d.Dnum=p.Dnum
group by Pname

select *from v_count

--10
create view v_project_p2
as
select count(SSN)
from v_clerk where Pname='p2'

select*from v_project_p2

--11
alter view v_without_budget
as
select p.City,p.Dnum,p.Plocation,p.Pname,p.Pnumber from Project p
where Pname in ('p1','p2')

select * from v_without_budget	

--12
drop view v_count
drop view v_clerk

--13
alter view dep2
as
select Lname, count(ssn) as numbers from
Employee e,Departments d
where d.Dnum=e.Dno and d.Dname='dp2'
group by Lname

select lname from dep2

--14
select lname from dep2 where lname like '%j%'

--15
alter view v_dept(dname,dnum)
as
select dname,dnum
from Departments

select * from v_dept


--16
insert into v_dept(dname,dnum)
values('development','p4')

--17
alter view v_2006_check(empno,projectn,edate)
as
select empno,projectno,enter_date
from works_on where enter_date between '1-1-2006'and'12-31-2006'
with check option


select * from v_2006_check