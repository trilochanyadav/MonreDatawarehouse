-- Report 1  Top K 

--For version 1(High Aggregation)
--Question – Display the ranking of  agents having top rental fees from houses property type.
Select  * from ( select r.property_type, r.agent_id, sum(TOTAL_RENTAL_FEE) as total_fees,
DENSE_RANK() Over (Order By Sum(TOTAL_RENTAL_FEE) desc) AS Rank_num
From RENT_fact_v1 r,type_dim_v1 t,agent_dim_v1 a
where r.property_type like 'House'
and r.property_type = t.property_type 
and r.agent_id = a.agent_id
Group By r.property_type, r.agent_id) where Rank_num < 11;

--For version 2(Low Aggregation)
--Question – Display the ranking of  agents having top rental fees from houses property type.
Select  * from ( select r.property_type, r.agent_id, sum(TOTAL_RENTAL_FEE) as total_fees,
DENSE_RANK() Over (Order By Sum(TOTAL_RENTAL_FEE) desc) AS Rank_num
From RENT_fact_v2 r,type_dim_v2 t,agent_dim_v2 a
where r.property_type like 'House'
and r.property_type = t.property_type 
and r.agent_id = a.agent_id
Group By r.property_type, r.agent_id) where Rank_num < 11;

--Report 2 Top n% 

--For Version 1
SELECT ag.office_id,ag.client_id,total_earning,Percent_Rank FROM ( select ag.office_id,ag.agent_id ,sum(total_agent_earning) as total_earning, 
PERCENT_RANK() Over (Order By Sum(TOTAL_agent_earning) desc) AS Percent_Rank
FROM agent_fact_v1 ag,agent_office_dim_v1 o, agent_dim_v1 a
where ag.office_id = o.office_id and 
ag.agent_id = a.agent_id 
group by ag.office_id,ag.agent_id) ag
where percent_rank > 0.9 
order by percent_rank desc;

--For Versio 2

 
--Report 3 Show All
--Question- Show the total number of female clients in each budget range .
--For Version 1
select c.budgetid,gender,count(total_no_clients) from client_fact_v1 c,budget_dim_v1,client_dim_v1  where c.budgetid = budget_dim_v1.budgetid
and c.client_id = client_dim_v1.client_id and client_dim_v1.gender like 'Female' group by
c.budgetid,gender;

--For Version 2
--Question- Show the total number of female clients in each budget range .
select c.budgetid,gender,count(total_no_clients) from client_fact_v2 c,budget_dim_v2,client_dim_v2  where c.budgetid = budget_dim_v2.budgetid
and c.client_id = client_dim_v2.client_id and client_dim_v2.gender like 'Female' group by
c.budgetid,gender;