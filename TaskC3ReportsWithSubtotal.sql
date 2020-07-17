--Report 4
--What are the sub-total and total rental fees from each suburb, time period, and property type? (Using Cube) 

--For Version 1
SELECT DISTINCT L.SUBURB,TO_CHAR(R.RENT_START_DATE,'MMYYYY') AS TIME_PERIOD ,F.PROPERTY_TYPE,SUM(TOTAL_RENTAL_FEE) AS TOTAL_RENTAL_FEE
FROM RENT_FACT_V1 F,ADDRESS L  ,RENT_DIM_V1 R,TYPE_DIM_V1 T 
where F.ADDRESS_ID = L.ADDRESS_ID AND F.PROPERTY_TYPE = T.PROPERTY_TYPE 
and f.rent_id = r.rent_id
GROUP BY CUBE( L.SUBURB,TO_CHAR(R.RENT_START_DATE,'MMYYYY'),F.PROPERTY_TYPE)
ORDER BY L.SUBURB;

--For Version 2
SELECT DISTINCT L.SUBURB,TO_CHAR(R.RENT_START_DATE,'MMYYYY') AS TIME_PERIOD ,F.PROPERTY_TYPE,SUM(TOTAL_RENTAL_FEE) AS TOTAL_RENTAL_FEE
FROM RENT_FACT_V2 F,ADDRESS L  ,RENT_DIM_V2 R,TYPE_DIM_V2 T 
where F.ADDRESS_ID = L.ADDRESS_ID AND F.PROPERTY_TYPE = T.PROPERTY_TYPE 
and f.rent_id = r.rent_id
GROUP BY CUBE( L.SUBURB,TO_CHAR(R.RENT_START_DATE,'MMYYYY'),F.PROPERTY_TYPE)
ORDER BY L.SUBURB;

--Report 5
--What are the sub-total and total rental fees from each suburb, time period, and property type? (Using Cube) 

--For Version 1
SELECT DISTINCT L.SUBURB,TO_CHAR(R.RENT_START_DATE,'MMYYYY') AS TIME_PERIOD ,F.PROPERTY_TYPE,SUM(TOTAL_RENTAL_FEE) AS TOTAL_RENTAL_FEE
FROM RENT_FACT_V1 F,ADDRESS L  ,RENT_DIM_V1 R,TYPE_DIM_V1 T 
where F.ADDRESS_ID = L.ADDRESS_ID AND F.PROPERTY_TYPE = T.PROPERTY_TYPE 
and f.rent_id = r.rent_id
GROUP BY CUBE( L.SUBURB,TO_CHAR(R.RENT_START_DATE,'MMYYYY')),F.PROPERTY_TYPE
ORDER BY L.SUBURB;

--For Version 2
SELECT DISTINCT L.SUBURB,TO_CHAR(R.RENT_START_DATE,'MMYYYY') AS TIME_PERIOD ,F.PROPERTY_TYPE,SUM(TOTAL_RENTAL_FEE) AS TOTAL_RENTAL_FEE
FROM RENT_FACT_V2 F,ADDRESS L  ,RENT_DIM_V2 R,TYPE_DIM_V2 T 
where F.ADDRESS_ID = L.ADDRESS_ID AND F.PROPERTY_TYPE = T.PROPERTY_TYPE 
and f.rent_id = r.rent_id
GROUP BY CUBE( L.SUBURB,TO_CHAR(R.RENT_START_DATE,'MMYYYY')),F.PROPERTY_TYPE
ORDER BY L.SUBURB;

--Report 6
--What are the total number of male and female agents in each agent office ?
--For Version 1
SELECT DECODE(GROUPING(f.office_id),1,'f.office_id',f.office_id)As office_id,DECODE(GROUPING(n.office_name),1,'n.office_name',n.office_name)as office_name,DECODE(GROUPING(a.GENDER),1,'All Genders',a.GENDER) AS GENDER,COUNT(Total_No_Agent) AS No_Of_Agents from 
agent_fact_v2 f ,agent_office_dim_v2 o,office_dim_v2 n,agent_dim_v2 a
where f.office_id = o.office_id and o.office_id = n.office_id and f.agent_id = a.agent_id 
group by rollup (f.OFFICE_ID,n.OFFICE_NAME,a.GENDER);

--What are the total number of male and female agents in each agent office ?
--For Version 2
SELECT DECODE(GROUPING(f.office_id),1,'f.office_id',f.office_id)As office_id,DECODE(GROUPING(n.office_name),1,'n.office_name',n.office_name)as office_name,DECODE(GROUPING(a.GENDER),1,'All Genders',a.GENDER) AS GENDER,COUNT(Total_No_Agent) AS No_Of_Agents from 
agent_fact_v1 f ,agent_office_dim_v1 o,office_dim_v1 n,agent_dim_v1 a
where f.office_id = o.office_id and o.office_id = n.office_id and f.agent_id = a.agent_id 
group by rollup (f.OFFICE_ID,n.OFFICE_NAME,a.Gender)
order by f.office_id;


--Report 7 
--What are the total number of properties sold in each state,postcode ?

--For Version 1
SELECT p.state_code,l.postcode,f.address_id,sum(total_no_of_sale) as total_properties_sold from sales_fact_v1 f,location_dim_v1 l,postcode_dim_v1 p,state_dim_v1 s 
where f.address_id = l.address_id and l.postcode = p.postcode and p.state_code = s.state_code 
group by rollup (p.state_code,l.postcode),f.address_id ;

--For Version 2
SELECT p.state_code,l.postcode,f.address_id,sum(total_no_of_sale) as total_properties_sold from sales_fact_v2 f,location_dim_v2 l,postcode_dim_v2 p,state_dim_v2 s 
where f.address_id = l.address_id and l.postcode = p.postcode and p.state_code = s.state_code 
group by rollup (p.state_code,l.postcode),f.address_id ;

