--Report 11
-- Show ranking of each property type based on the yearly total number of sales and the ranking of each state based on the yearly total number of sales.

--Version 1 
SELECT to_char(d.sale_date,'yyyy')  as Year, s.property_type,state_name,SUM(total_amount_of_sales) as total_sales,
DENSE_RANK() over (PARTITION BY s.property_type ORDER BY SUM(total_amount_of_sales) desc)  as rank_by_type,
dense_rank() over (PARTITION BY state_name ORDER BY SUM(total_amount_of_sales) desc)  as rank_by_state
from sales_fact_v1 s,sale_dim_v1 d,type_dim_v1 t,location_dim_v1 l,postcode_dim_v1 p,state_dim_v1 s
where s.sale_id = d.sale_id and s.property_type = t.property_type and s.address_id = l.address_id 
and  l.postcode = p.postcode and p.state_code = s.state_code group by to_char(d.sale_date,'yyyy'),s.property_type, state_name
order by to_char(d.sale_date,'yyyy') ;

--Version 2
SELECT to_char(d.sale_date,'yyyy') as Year, s.property_type,state_name ,SUM(total_amount_of_sales) as total_sales,
DENSE_RANK() over (PARTITION BY s.property_type ORDER BY SUM(total_amount_of_sales) desc)  as rank_by_type,
dense_rank() over (PARTITION BY state_name ORDER BY SUM(total_amount_of_sales) desc)  as rank_by_state
from sales_fact_v2 s,sale_dim_v2 d,type_dim_v2 t,location_dim_v2 l,postcode_dim_v2 p,state_dim_v2 s
where s.sale_id = d.sale_id and s.property_type = t.property_type and s.address_id = l.address_id 
and  l.postcode = p.postcode and p.state_code = s.state_code group by to_char(d.sale_date,'yyyy'),s.property_type, state_name
order by to_char(d.sale_date,'yyyy') ;

--Report 12 
--Show ranking of property_type based on total_no_rents and ranking of states based on total_no_rents

--version 1
SELECT r.property_type ,state_name,sum(total_no_of_rent) as no_of_rents,
DENSE_RANK() over (PARTITION BY r.property_type ORDER BY sum(total_no_of_rent) desc)  as rank_by_type,
dense_rank() over (PARTITION BY state_name ORDER BY sum(total_no_of_rent) desc)  as rank_by_state
from rent_fact_v1 r,rent_dim_v1 d,type_dim_v1 t,location_dim_v1 l,postcode_dim_v1 p,state_dim_v1 s
where r.rent_id = d.rent_id and r.property_type = t.property_type and r.address_id = l.address_id 
and l.postcode = p.postcode and p.state_code = s.state_code group by r.property_type, state_name;


--version 2
SELECT r.property_type ,state_name,sum(total_no_of_rent) as no_of_rents,
DENSE_RANK() over (PARTITION BY r.property_type ORDER BY sum(total_no_of_rent) desc)  as rank_by_type,
dense_rank() over (PARTITION BY state_name ORDER BY sum(total_no_of_rent) desc)  as rank_by_state
from rent_fact_v2 r,rent_dim_v2 d,type_dim_v2 t,location_dim_v2 l,postcode_dim_v2 p,state_dim_v2 s
where r.rent_id = d.rent_id and r.property_type = t.property_type and r.address_id = l.address_id 
and l.postcode = p.postcode and p.state_code = s.state_code group by r.property_type, state_name;

