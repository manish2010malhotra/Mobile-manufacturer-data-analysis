--SQL Advance Case Study
SELECT * FROM DIM_LOCATION
SELECT * FROM DIM_CUSTOMER
SELECT * FROM DIM_DATE
SELECT * FROM DIM_MANUFACTURER
SELECT * FROM DIM_MODEL
SELECT * FROM FACT_TRANSACTIONS

--Q1--BEGIN 
select distinct State from (
select l1.State , sum (quantity) as cnt , year (f1.Date) as year from DIM_LOCATION as L1
join FACT_TRANSACTIONS as F1
on L1.IDLocation = f1.IDLocation
where year (f1.Date) >= 2005
group by l1.State , year(f1.Date) ) as A
	
--Q1--END

--Q2--BEGIN
select top 1 state , count(*) as cnt from DIM_LOCATION as L1
join FACT_TRANSACTIONS as f1
on l1.IDLocation = f1.IDLocation
join DIM_MODEL as M1 
on f1.IDModel = M1.IDModel
join DIM_MANUFACTURER as M2	
on m1.IDManufacturer = m2.IDManufacturer
where Country ='US' and Manufacturer_Name = 'Samsung'
group by State
order by cnt desc
	
--Q2--END

--Q3--BEGIN      
	
select idmodel ,state, zipcode ,count(*) as total_trans
from FACT_TRANSACTIONS as F1
join DIM_LOCATION as l1
on f1.IDLocation =l1.IDLocation
group by idmodel ,state, zipcode 

--Q3--END

--Q4--BEGIN
select top 1 model_name , min(unit_price) as min_price from DIM_MODEL
group by Model_Name
order by min_price 

--Q4--END

--Q5--BEGIN

select m1.IDModel ,avg(totalprice) as avg_price , sum(quantity) as total_qty from FACT_TRANSACTIONS as F1
join DIM_MODEL as m1
on f1.IDModel = m1.IDModel
join DIM_MANUFACTURER as m2 
on m1.IDManufacturer = m2.IDManufacturer
where manufacturer_name in (select top 5 manufacturer_name from FACT_TRANSACTIONS as f1
                              join DIM_MODEL as m1
                              on f1.IDModel = m1.IDModel
                              join DIM_MANUFACTURER as m2 
                              on m1.IDManufacturer = m2.IDManufacturer
                              group by Manufacturer_Name
                              order by sum(totalprice) desc)
group by m1.IDModel
order by avg_price desc

--Q5--END

--Q6--BEGIN

select customer_name , avg(totalprice) as avg_price  from DIM_CUSTOMER as t1
join FACT_TRANSACTIONS as t2
on t1.IDCustomer = t2.IDCustomer
where year(Date) = 2009
group by Customer_Name
having AVG(TotalPrice)> 500


--Q6--END
SELECT top (1) * FROM DIM_LOCATION
SELECT top (1) * FROM DIM_CUSTOMER
SELECT top (1) * FROM DIM_DATE
SELECT top (1) * FROM DIM_MANUFACTURER
SELECT top (1) * FROM DIM_MODEL
SELECT top 1 * FROM FACT_TRANSACTIONS

	
--Q7--BEGIN  
select * from (
select top 5 idmodel from fact_transactions 
where year (date ) = 2008 
group by IDmodel, year (date ) 
order by Sum(quantity) desc
) as A
intersect
select * from (
select top 5 idmodel from fact_transactions 
where year (date) = 2009
group by idmodel,year(date)
order by sum(quantity)desc
)  as C

--Q7--END	

--Q8--BEGIN

select * from (
select top 1 * from (
select top 2 manufacturer_name, year(date) as year,sum(totalprice)as sales from FACT_TRANSACTIONS as t1
join DIM_MODEL as t2
on t1.IDModel = t2.IDModel
join DIM_MANUFACTURER as t3
on t2.IDManufacturer = t3.IDManufacturer
where YEAR(date) = 2009
group by Manufacturer_Name,YEAR(date)
order by sales desc
) as A
order by sales asc
) as C
union
select * from (
select top 1 * from (
select top 2 manufacturer_name ,year(date) as year ,  sum(totalprice) as sales from fact_transactions as t1
join DIM_MODEL as t2
on t1.IDModel=t2.IDModel
join DIM_MANUFACTURER as t3
on t2.IDManufacturer = t3.IDManufacturer
where year(date)=2010
group by Manufacturer_Name,YEAR(date)
order by sales desc
) as A
order by sales asc
) as D

--Q8--END
--Q9--BEGIN
	
select Manufacturer_Name name from FACT_TRANSACTIONS as t1
join DIM_MODEL as t2
on t1.IDModel = t2.IDModel
join DIM_MANUFACTURER as t3
on t2.IDManufacturer = t3.IDManufacturer
where year(date)=2010
group by Manufacturer_Name
except
select Manufacturer_Name from FACT_TRANSACTIONS as T1
join DIM_MODEL as t2
on t1.IDModel = t2.IDModel
join DIM_MANUFACTURER as t3
on t2.IDManufacturer = t3.IDManufacturer
where year(date) = 2009
group by Manufacturer_Name

--Q9--END

--Q10--BEGIN
	
select * , (( avg_price - lag_price)/lag_price) as percentage from (
select * , LAG(avg_price,1) over(partition by idcustomer order by year ) as lag_price from (

select Idcustomer, year(date) as year,AVG(totalprice) as avg_price, sum(quantity)as qty from FACT_TRANSACTIONS
where IDCustomer in ( select top 10 IDCustomer from FACT_TRANSACTIONS
						group by IDCustomer
						order by sum(totalprice)desc)
group by IDCustomer,YEAR(date)
) as A
) as B

 
















--Q10--END
	