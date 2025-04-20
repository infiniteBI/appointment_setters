/* this is imitation of real word data that was provided in a interview  */

select *
from apptsettlers.branchoffice;


alter table apptsettlers.employee
change column Emp_ID employee_id VARCHAR(50) NOT NULL;
alter table apptsettlers.employee
change column Emp_Name employee_name VARCHAR(50) NOT NULL;




-- let's get the office with the most appointment

select o.location, count(a.appt_type) as total_appt
from apptsettlers.branchoffice o join apptsettlers.appointments a on  o.office_id = a.office_id
group by o.location
order by total_appt desc

-- we can use CTE to get the same data
WITH appt_total AS (
					select 
						o.office_id, o.location, 
							count(a.appt_type) over(partition by o.office_id) as total_appt
					from apptsettlers.branchoffice o 
						join apptsettlers.appointments a on  o.office_id = a.office_id
)

select location, total_appt
from appt_total
group by location, total_appt
order by total_appt desc;

-- let's see total appointment made by type of appt

select appt_type, count(appt_type) as total_appt
from apptsettlers.appointments 
group by appt_type
order by total_appt desc;

-- let's see who schedule the most appt
select
e.employee_name, count(a.appt_type) as total_appt
from apptsettlers.appointments a
	join apptsettlers.employee e on e.employee_id = a.employee_id
group by e.employee_name
order by total_appt desc;

select
	dense_rank() over(order by count(a.appt_type)desc) as emp_rank, e.employee_name, count(a.appt_type) as total_appt
from apptsettlers.appointments a
	join apptsettlers.employee e on e.employee_id = a.employee_id
group by e.employee_name
order by total_appt desc;

select
	row_number() over(order by count(a.appt_type)desc) as emp_rank, e.employee_name, count(a.appt_type) as total_appt
from apptsettlers.appointments a
	join apptsettlers.employee e on e.employee_id = a.employee_id
group by e.employee_name
order by total_appt desc;

-- let's show how many appt each offices missing to reach their goal

WITH appt_total AS (
					select 
						o.office_id, o.location, 
							count(a.appt_type) over(partition by o.office_id) as total_appt
					from apptsettlers.branchoffice o 
						join apptsettlers.appointments a on  o.office_id = a.office_id
)

select location, total_appt, (total_appt - 100) as missing_to_100
from appt_total
group by location, total_appt
order by total_appt desc;

-- each employee is assigned to a supervisor, let's see which supervisor has most employee

select Supervisor,count(employee_name) as total_employee, sum(hrs_worked) as total_emp_hrs
from apptsettlers.employee
group by Supervisor
order by total_emp_hrs desc

-- let's which supervisor team has most appt made

select e.Supervisor, count(a.appt_type) as total_appt
from apptsettlers.employee e 
	join apptsettlers.appointments a on e.employee_id = a.employee_id
group by Supervisor
order by total_appt desc

-- let's see total appt by supersisor's team by location
select e.Supervisor, o.location, count(appt_type) as total_appt
from apptsettlers.employee e
	join apptsettlers.appointments a on e.employee_id = a.employee_id
    join apptsettlers.branchoffice o on  o.office_id = a.office_id
group by e.Supervisor, o.location
order by total_appt desc
