Create database if not exists apple_db;

use apple_db;

create table sales 
	(
    sales_id varchar(15) primary key,
    sale_date varchar(20),
    store_id varchar(10),
	product_id varchar(10),
	quantity int
    );

SHOW GLOBAL VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'D:/Projects/SQL Project/Apple Retail Store Analysis/sales.csv' 
INTO TABLE sales
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

SET SQL_SAFE_UPDATES = 1;

alter table sales
modify sale_date date;

ALTER TABLE warranty
MODIFY claim_date DATE;

alter table sales
add constraint
foreign key (Store_ID) references stores(Store_ID)
on update cascade
on delete cascade;

alter table sales
add constraint
foreign key (product_id) references products(Product_ID)
on update cascade
on delete cascade;

alter table products
add constraint
foreign key (Category_ID) references category(Category_ID)
on update cascade
on delete cascade;

alter table warranty
add constraint
foreign key (Sales_ID) references sales(Sales_ID)
on update cascade
on delete cascade;

select * from sales;
select * from products order by Price;
select * from stores;
select * from warranty;
select * from category;

# now the data set is ready to analysis

# Easy to Medium (10 Questions)

#1. Find the number of stores in each country.
select 
	Country, 
    Count(Store_ID) as total_store
from stores
group by Country;


#2. Calculate the total number of units sold by each store.
select 
	a.Store_ID, 
    Store_Name, 
    Sum(a.quantity) as sold_units
from sales as a
left join stores as b
on a.store_id=b.Store_ID
group by a.Store_ID
order by a.Store_ID ASC;


#3. Identify how many sales occurred in December 2023.
select Count(Sales_ID) as sales_Dec23
from sales
where sale_date between '2023-12-01' and '2023-12-31';


#4. Determine how many stores have never had a warranty claim filed.
select 
	store_id, 
    Count(Claim_ID) as claim_filed
from sales as s
left join warranty as w 
on s.Sales_ID = w.Sales_ID
group by store_id
having Count(w.Claim_ID) = 0;
 
 
#5. Calculate the percentage of warranty claims marked as "Rejected".
select Round(Count(*)*100/(select Count(*) from warranty),2) as Percentage_Warrantry_Rejected
from warranty
where repair_status = "Rejected";


#6. Identify which store had the highest total units sold in the last year.
select 
	store_id, 
    Sum(quantity) as sold_units
from sales
group by store_id
order by Sum(quantity) DESC
limit 1;


#7. Count the number of unique products sold in the last year.
select 
	distinct Product_Name, 
    Sum(quantity) as sold_units
from sales as s 
left join products as p 
on s.product_id = p.Product_ID
where sale_date between '2024-01-01' and '2024-12-31'
group by 1;


#8. Find the average price of products in each category.
select 
	c.Category_ID, 
    c.category_name, 
    avg(Price) as Avg_Price
from products as p 
join category as c
on c.Category_ID = p.Category_ID
group by 1,2;


#9. How many warranty claims were filed in 2020?
select Count(Claim_ID) as claim_2020
from warranty 
where claim_date between '2020-01-01' and '2023-12-31';


#10. For each store, identify the best-selling day based on highest quantity sold.
select * 
from 
	(
    select 
		store_id, 
        DAYNAME(sale_date) AS day_name, 
        sum(quantity) as unit_sold, 
        Rank() over(partition by store_id order by sum(quantity)) as Rank_
	from sales
	group by store_id, DAYNAME(sale_date)
    ) as table1
where Rank_ = 1;


# Medium to Hard (5 Questions)

#1. Identify the least selling product in each country based on total units sold.
select *
from 
	(
    select 
		p.Product_Name, 
        Country, 
        Sum(quantity)as Total_unit_sold ,
        rank() over (partition by Country  order by Sum(quantity)) as rank_
	from  sales as s
    join stores as st
    on s.store_id= st.Store_ID
    join products as p
	on s.product_id = p.Product_ID
	group by  p.Product_Name, Country, year(sale_date)
    ) as table2
where rank_ = 1;


#2. Calculate how many warranty claims were filed within 180 days of a product sale.
select *, Datediff(claim_date, sale_date)
from warranty as w 
left join sales as s 
on w.Sales_ID = s.Sales_ID
where  Datediff(claim_date, sale_date) between 0 and 180; 


#3. Determine how many warranty claims were filed for products launched in the last two years.
select 
	p.Product_ID, 
    Product_Name, 
    Count(w.Claim_ID)
from warranty as w 
left join sales as s 
on w.Sales_ID = s.Sales_ID
join products as p 
on s.product_id = p.Product_ID
where Launch_Date between '2024-03-01' and '2024-12-31'
group by p.Product_ID,Product_Name 
order by p.Product_ID;


#4. List the months in the last three years where sales exceeded 5,000 units in the USA.
select 
	monthname(sale_date) as Months,
    year(sale_date) Year,
    Sum(quantity) as units_sold, 
    Country
from sales as s
join stores as st
on s.store_id= st.Store_ID
where Country = "United States"
group by monthname(sale_date),year(sale_date)
having Sum(quantity) > 5000
order by 1,2; 


#5. Identify the product category with the most warranty claims filed in the last two years.
select 
	Category_ID, 
    Count(Claim_ID)
from warranty as w 
left join sales as s 
on w.Sales_ID = s.Sales_ID
join products as p 
on s.product_id = p.Product_ID
where claim_date between '2024-03-01' and '2024-12-31'
group by Category_ID
order by 2;

# Complex (5 Questions)

#1. Determine the percentage chance of receiving warranty claims after each purchase for each country.
select 
	Country,
    sum(s.quantity), 
    Count(w.Claim_ID), 
    Count(w.Claim_ID)*100/sum(s.quantity) as Percentage 
from sales as s 
left join warranty as w 
on s.Sales_ID = w.Sales_ID 
join stores as st 
on s.store_id = st.Store_ID 
group by Country 
order by 4;

 
#2. Analyze the year-by-year growth ratio for each store.
with yearly_sale 
	as 
		( 
        select 
			st.Store_ID, 
            Store_Name, 
            Year(sale_date) as year, 
            sum(s.quantity * p.Price) as Total_sale 
		from sales as s 
        join stores as st 
        on s.store_id = st.Store_ID 
        join products as p 
        on s.product_id= p.Product_ID 
        group by 1,2,3 
        order by 2 
        ), 
groth_rate 
	as 
		( 
        select 
			Store_Name, 
            year,
            lag(Total_sale,1) over(partition by Store_Name order by year) as previous_year_sale,
            Total_sale 
		from yearly_sale 
        ) 
        
select *, round( (Total_sale - previous_year_sale)/previous_year_sale ,2)as growth_rate 
from groth_rate 
where previous_year_sale is not null;


#3. Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.
select 
	case 
		when p.Price < 500 then 'Less Expensive'
		when p.price between 501 and 1000 then 'Mid Range'
		else 'Expensive'
	end as Price_Category, 
    Count(w.Claim_ID) as Claim_Count
from warranty as w 
left join sales as s 
on w.Sales_ID = s.Sales_ID
join products as p 
on s.product_id = p.Product_ID
group by 1;


#4. Identify the store with the highest percentage of "Completed" claims relative to total claims filed.

with Paid_repaired
as(
Select 
	st.Store_ID as Store_ID, 
    st.Store_Name as Store_Name, 
    Count(w.Claim_ID) as Completed_Repair
from warranty as w
join sales as s 
on w.Sales_ID=s.Sales_ID
join stores as st 
on s.store_id = st.Store_ID
where w.repair_status = 'Completed'
group by 1,2),

total_repaired 
as (
Select 
	st.Store_ID as Store_Id, 
	st.Store_Name as Store_Name, 
	Count(w.Claim_ID) as total_claims
from warranty as w
join sales as s 
on w.Sales_ID=s.Sales_ID
join stores as st 
on s.store_id = st.Store_ID
group by 1,2)

select pr.Store_ID, 
	tr.Store_Name,
    Completed_Repair,
    total_claims , 
    Completed_Repair*100 / total_claims as percentage 
from Paid_repaired as pr
join total_repaired as tr
on pr.Store_ID = tr.Store_ID
order by 5 DESC
limit 1;

#5. Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.
with monthly_sale
as 
	(
    select 
		s.store_id as Store_ID, 
        year(sale_date) as Year, 
        month(sale_date) as Month, 
        sum(s.quantity * p.Price) as total_revenue
from sales as s 
join products as p
on s.product_id = p.Product_ID
group by 1,2,3)

select 
	Store_ID,
    Year,
    Month,
    total_revenue, 
    sum(total_revenue) over (Partition by Store_ID order by Year, Month) as Running_Total
from monthly_sale;

#6. Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.
with table1
as
	(
	select 
		p.Product_Name as Name,
		case 
			when datediff(sale_date, Launch_Date) between 0 and 180 then '0-6 Month'
            when datediff(sale_date, Launch_Date) between 181 and 365 then '6-12 Month'
            when datediff(sale_date, Launch_Date) between 366 and 546 then '12-18 Month'
            when datediff(sale_date, Launch_Date) > 546 then '18+ Month' 
		end 
		as periods, 
	Sum(quantity) as sold_unit
	from sales as s
	join products as p
	on s.product_id = p.Product_ID
	group by 1,2
	order by 1,2
	)

select Name,periods,sold_unit
from table1
where periods is not null;
