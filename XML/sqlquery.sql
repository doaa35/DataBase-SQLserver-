Display all the data from the Employee table (HumanResources Schema) 
--As an XML document “Use XML Raw”. “Use Adventure works DB” 
--A)	Elements
--B)	Attributes

select * from HumanResources.employee
for xml raw('employee'),elements,root('employees')


Display Each Department Name with its instructors. “Use ITI DB”
--A)	Use XML Auto
--B)	Use XML Path

select dept_name ,ins_name 
from instructor,Department
where instructor.dept_id=Department.dept_id
for xml auto

select dept_name "@department" ,ins_name "instructor" 
from instructor,Department
where instructor.dept_id=Department.dept_id
for xml path('employee')





declare @docs xml ='<customers>
              <customer FirstName="Bob" Zipcode="91126">
                     <order ID="12221">Laptop</order>
              </customer>
              <customer FirstName="Judy" Zipcode="23235">
                     <order ID="12221">Workstation</order>
              </customer>
              <customer FirstName="Howard" Zipcode="20009">
                     <order ID="3331122">Laptop</order>
              </customer>
              <customer FirstName="Mary" Zipcode="12345">
                     <order ID="555555">Server</order>
              </customer>
       </customers>'

	   declare @hdocs int
	   exec sp_xml_preparedocument @hdocs output , @docs
	   select * from 
	   openxml(@hdocs,'//customer')
	   with(c_name varchar(max) '@FirstName',

	   zip_code int '@Zipcode',
	   order_id int 'order/@ID',
	   orders varchar(max) 'order'
	   )

	   exec sp_xml_removedocument @hdocs


	   
--4.Create a stored procedure to show the number of students per department.[use ITI DB] 
create proc students 
as
select Dept_Name as 'department' ,count(st_id)
from student s INNER JOIN Department d
ON s.Dept_Id=d.Dept_Id
group by (Dept_Name)


students


--5.Create a stored procedure that will check
--for the # of employees in the project p1 if
--they are more than 3 print message to the user
--“'The number of employees in the project p1 is
--3 or more'” if they are less display a message
--to the user “'The following employees work for
--the project p1'” in addition to the first name 
--and last name of each one. [Company DB] 
use [SD32-Company]
create proc num_emp
as
declare @x int
select @x=count(emp_no)
from hr.employee e inner join  works_on w
on e.emp_no= w.empno and  projectno='p1'

if (@x>=3)
select 'The number of employees in the project p1 is 3 or more'
else 
select 'The following employees work for the project p1',' '
union
select emp_fname ,emp_lname
from hr.employee e inner join  works_on w
on e.emp_no= w.empno and  projectno='p1'


num_emp


--6.	Create a stored procedure that will be used in case
--there is an old employee has left the project and a new 
--one become instead of him. The procedure should take 3
--parameters (old Emp. number, new Emp. number and the 
--project number) and it will be used to update works_on
--table. [Company DB]




-----------------------------------
create proc employee @new_id int ,@projectno varchar(max),@old_id int 
as 
update works_on set empno=@new_id,projectno=@projectno
where empno=@old_id

employee 5,p2,1
--7.	Create an Audit table with the following structure 
--ProjectNo 	UserName 	ModifiedDate 	Budget_Old 
--Budget_New 
--p2 	Dbo 	2008-01-31	95000 	200000 

create table history
(
projectno varchar(max),
username varchar (max),
ModifiedDate  date,
Budget_Old  int,
Budget_New  int

)
create trigger t1
on company.project
for update 
as
if update(projectno)
begin
declare  @pronum varchar(max),@bold int,@bnew int
select @pronum=projectno  from inserted
select @bnew=budget   from inserted
select @bold=budget   from deleted
insert into history values(@pronum,suser_name(),getdate(),@bold,@bnew)
end


update company.project set projectno='p3',projectname='new' ,budget=5000 where projectno='p3'

--8.Create a trigger to prevent anyone from inserting a new 
--record in the Department table [ITI DB]
--“Print a message for user to tell him that he can’t
--insert a new record in that table”

create trigger t2 
on company.department
instead of insert
as
select 'can’t insert a new record in that table'


insert into COMPANY.Department values('d5','sales','NY')



--Create a trigger that prevents the insertion Process
--for Employee table in March [Company DB].
create trigger t3
on hr.employee 
after  insert
as
if (format(getdate(),'MMMM') = 'November')
begin
SELECT' YOU CANNOT INSERT IN November'
delete from hr.employee where emp_no=(select emp_no from inserted)
end





--10. Create a trigger that prevents users from altering
--any table in Company DB.

CREATE TRIGGER t4 
ON DATABASE 
FOR ALTER_TABLE 
AS 
 PRINT 'you can not alter' 
 ROLLBACK;
 
-- DISABLE TRIGGER ALL
--ON DATABASE ;

 drop trigger t4
 alter table works_on add  newc int;

 --11.Create a trigger on student table after insert to
 --add Row in Student Audit table
 --(Server User Name , Date, Note) where note will be 
 --“[username] Insert New Row with Key=[Key Value] 
 --in table [table name]”

 create table student_audit
 (
 server_username varchar(50),
 datee date,
 note varchar(50)
 )

 create trigger st_audit
 on student
 after insert 
 as
 declare @x int
 select  @x =st_id from inserted
 insert into student_audit

 values(suser_name(),getdate(),@x)
 --12.	 Create a trigger on student table instead of delete to add Row in Student Audit table (Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”
 create trigger st_audit2
 on student
 instead of delete  
 as
 declare @x int
 select  @x =st_id from inserted
 insert into student_audit

 values(suser_name(),getdate(),@x)


 
 )

