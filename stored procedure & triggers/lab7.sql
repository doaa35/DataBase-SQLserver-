--1
use iti

alter proc getStd
as
	select count(st_id), Dept_Name
	from student inner join Department
	on Department.Dept_Id=student.dept_id
	group by Dept_Name


getStd

--2
use Company_SD

alter proc getNum
as
	declare @num int
	select @num= count(ssn)
			from Employee inner join Works_for 
			on ssn = essn and pno = 100
	if @num >3 
	select 'The number of employees in the project p1 is 3 or more'
	else select'The previous employees work for the project p1'
			union
			select CONCAT_WS(' ', fname, lname)
			from Employee inner join Works_for 
			on ssn = essn and pno = 100
				
getnum	

--3
create proc updateEmp @old int, @new int, @pnum int
as
	update Works_for
		set essn = @new
	where pno = @pnum and essn = @old


updateEmp 102672, 669955, 100

--4
alter table project add budget int

create table auidt(
		ProjectNo int,
		UserName varchar(20),
		ModifiedDate date,
		Budget_Old int,
		Budget_New int
)

create trigger tr1
on project 
after update
as
	if update(budget)
		begin
			declare @new int, @pno int, @old int
			
			select @new = budget, @pno= Pnumber  from inserted
			
			select @old = budget from deleted
			
			insert into auidt
			values( @pno, suser_name(), getdate(),@old, @new)
		
		end

update Project
	set budget = 5000
	where Pnumber = 100

update Project
	set budget = 2500
	where Pnumber = 200

--5
create trigger trig
on departments
instead of insert
as
	select 'Not allowed'

insert into Departments(Dnum, Dname) values (100, 'DDD')

--6
create trigger trig1
on employee
after insert
as
	if format(getdate(), 'MMMM')= 'march'
		select 'Not allowed'
	else
		insert into Employee
		select * from inserted

--7
use iti

create table stAuidt(
		UserName varchar(20),
		ModifiedDate date,
		note varchar(max)
)

alter trigger trig2
on student
after insert
as
	declare @note varchar(max)
	select @note=concat_ws(' ',SUSER_NAME(),'Insert New Row with Key=',st_id, 'in table student')
		from Student
	
	insert into stAuidt values(SUser_NAME(), getdate(), @note)

insert into Student(st_id) values(1133)

--8
alter trigger trig3
on student
instead of delete
as
	select 'not allowed'

	declare @note varchar(max)
	select @note=concat_ws(' ','try to delete Row with Key=',st_id)
		from Student
	
	insert into stAuidt values(SUser_NAME(), getdate(), @note)

delete from student where St_Id = 1133 
