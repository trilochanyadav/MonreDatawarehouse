--Report 8 
--What is the total number of clients and cumulative number of clients with a high budget in each year?
--For Version 1
select year,sum(no_of_clients)as total_clients,sum(sum(no_of_clients))over (order by Year rows unbounded preceding) AS Cumulative_Clients  from 
(SELECT TO_CHAR(v.VISIT_DATE,'YYYY') As Year,sum(total_visits) as no_of_clients
from visit_fact_v1 v,client_fact_v1 a ,client_dim_v1 c,budget_dim_v1 b ,visit_dim_v1
where a.client_id = c.client_id and a.budgetid = b.budgetid and b.budgetid like 'High' and v.client_id = c.client_id and v.visit_date = visit_dim_v1.visit_date 
group by TO_CHAR(v.VISIT_DATE,'YYYY'),b.budgetid
union
SELECT TO_CHAR(rent_dim_v1.rent_start_DATE,'YYYY') As Year,count(r.client_id) as no_of_clients
from rent_fact_v1 r,client_fact_v1 a ,client_dim_v1 c,budget_dim_v1 b ,rent_dim_v1
where a.client_id = c.client_id and a.budgetid = b.budgetid and b.budgetid like 'High' and r.client_id = c.client_id and r.rent_id = rent_dim_v1.rent_id 
group by TO_CHAR(rent_dim_v1.rent_start_DATE,'YYYY'),b.budgetid
union 
SELECT TO_CHAR(sale_dim_v1.sale_DATE,'YYYY') As Year ,count(s.client_id) as no_of_clients
from sales_fact_v1 s,client_fact_v1 a ,client_dim_v1 c,budget_dim_v1 b ,sale_dim_v1
where a.client_id = c.client_id and a.budgetid = b.budgetid and b.budgetid like 'High' and s.client_id = c.client_id and s.sale_id = sale_dim_v1.sale_id 
group by TO_CHAR(sale_dim_v1.sale_DATE,'YYYY'),b.budgetid) group by year; 

--For Version 2
select year,sum(no_of_clients)as total_clients,sum(sum(no_of_clients))over (order by Year rows unbounded preceding) AS Cumulative_Clients  from 
(SELECT TO_CHAR(v.VISIT_DATE,'YYYY') As Year,sum(total_visits) as no_of_clients
from visit_fact_v2 v,client_fact_v2 a ,client_dim_v2 c,budget_dim_v2 b ,visit_dim_v2
where a.client_id = c.client_id and a.budgetid = b.budgetid and b.budgetid like 'High' and v.client_id = c.client_id and v.visit_date = visit_dim_v2.visit_date 
group by TO_CHAR(v.VISIT_DATE,'YYYY'),b.budgetid
union
SELECT TO_CHAR(rent_dim_v2.rent_start_DATE,'YYYY') As Year,count(r.client_id) as no_of_clients
from rent_fact_v2 r,client_fact_v2 a ,client_dim_v2 c,budget_dim_v2 b ,rent_dim_v2
where a.client_id = c.client_id and a.budgetid = b.budgetid and b.budgetid like 'High' and r.client_id = c.client_id and r.rent_id = rent_dim_v2.rent_id 
group by TO_CHAR(rent_dim_v2.rent_start_DATE,'YYYY'),b.budgetid
union 
SELECT TO_CHAR(sale_dim_v2.sale_DATE,'YYYY') As Year ,count(s.client_id) as no_of_clients
from sales_fact_v2 s,client_fact_v2 a ,client_dim_v2 c,budget_dim_v2 b ,sale_dim_v2
where a.client_id = c.client_id and a.budgetid = b.budgetid and b.budgetid like 'High' and s.client_id = c.client_id and s.sale_id = sale_dim_v2.sale_id 
group by TO_CHAR(sale_dim_v2.sale_DATE,'YYYY'),b.budgetid) group by year; 


--Report -9 
-- What is the total number of sales for each suburb and cumulative sales for each suburb?

--For Version 1
SELECT l.suburb,to_char(sale_date,'Mon') as year ,sum(total_no_of_sale) as monthly_no_sales ,
sum(sum(total_no_of_sale)) over (partition by l.suburb order by l.suburb,to_char(sale_date,'Mon') rows unbounded preceding) As Cumulative_Sales
from sales_fact_v1 s,sale_dim_v1 d,location_dim_v1 l where 
s.address_id = l.address_id and s.sale_id = d.sale_id
group by l.suburb,to_char(sale_date,'Mon');

--For Version 2
SELECT l.suburb,to_char(sale_date,'Mon') as year ,sum(total_no_of_sale) as monthly_no_sales ,
sum(sum(total_no_of_sale)) over (partition by l.suburb order by l.suburb,to_char(sale_date,'Mon') rows unbounded preceding) As Cumulative_Sales
from sales_fact_v2 s,sale_dim_v2 d,location_dim_v2 l where 
s.address_id = l.address_id and s.sale_id = d.sale_id
group by l.suburb,to_char(sale_date,'Mon');


--Report 10 
--Q Show the number of properties added by each month and year and cumulative number of properties added ?


--For Version 1
SELECT TO_CHAR(property_date_added,'MM') as Month,TO_CHAR(property_date_added,'YYYY') as Year ,sum(total_no_properties) as total_properties_added,
sum(sum(total_no_properties)) over (order by  TO_CHAR(property_date_added,'YYYY'),TO_CHAR(property_date_added,'MM') rows unbounded preceding) AS Cumulative_Prop_Added
from advert_fact_v1 ,property_dim_v1 where 
advert_fact_v1.property_id = property_dim_v1.property_id 
group by TO_CHAR(property_date_added,'YYYY'),TO_CHAR(property_date_added,'MM')
order by  TO_CHAR(property_date_added,'YYYY'),TO_CHAR(property_date_added,'MM');

--For Version 2
SELECT TO_CHAR(property_date_added,'MM') as Month,TO_CHAR(property_date_added,'YYYY') as Year ,sum(total_no_properties) as total_properties_added,
sum(sum(total_no_properties)) over (order by  TO_CHAR(property_date_added,'YYYY'),TO_CHAR(property_date_added,'MM') rows unbounded preceding) AS Cumulative_Prop_Added
from advert_fact_v2 ,property_dim_v2 where 
advert_fact_v2.property_id = property_dim_v2.property_id 
group by TO_CHAR(property_date_added,'YYYY'),TO_CHAR(property_date_added,'MM')
order by  TO_CHAR(property_date_added,'YYYY'),TO_CHAR(property_date_added,'MM');

