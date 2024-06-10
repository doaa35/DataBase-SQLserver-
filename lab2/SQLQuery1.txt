use Company_SD

--1
select * from Employee

--2
select fname, lname, Salary, Dno 
from Employee

--3
select Pname, Plocation, Dnum
from Project

--4
select CONCAT(fname, ' ', lname) [full name], Salary*1.1 [ANNUAL COMM]
from Employee

--5
select SSN, CONCAT(fname, ' ', lname) [full name] 
from Employee
where Salary>1000

--6
select SSN, CONCAT(fname, ' ', lname) [full name] 
from Employee
where (Salary*1.1)>10000

--7
select CONCAT(fname, ' ', lname) [full name], salary
from Employee
where Sex= 'f'

--8
select Dnum, Dname
from Departments
where MGRSSN = 968574

--9
select Pnumber,Pname, Plocation
from Project
where Dnum= 10