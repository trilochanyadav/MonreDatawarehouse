--Dropping all previous tables 
DROP TABLE FEATURE_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE PROPERTY_DIM_TEMP_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE PROPERTY_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE CATEGORY_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE SCALE_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE RENT_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE LOCATION_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE POSTCODE_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE STATE_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE TYPE_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE TIME_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE SEASON_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE BUDGET_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE AGENT_OFFICE_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE OFFICE_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE AGENT_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE SALE_DIM_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE CLIENT_DIM_V1 CASCADE CONSTRAINTS PURGE;

DROP TABLE ADVERT_FACT_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE CLIENTTEMPFACT_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE CLIENT_FACT_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE VISITTEMPFACT_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE VISIT_FACT_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE AGENT_FACT_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE TEMPRENTFACT_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE RENT_FACT_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE TEMPSALESFACT_V1 CASCADE CONSTRAINTS PURGE;
DROP TABLE SALES_FACT_V1 CASCADE CONSTRAINTS PURGE;
--
DROP TABLE FEATURE_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE PROPERTY_FEATURE_BRIDGE CASCADE CONSTRAINTS PURGE;
DROP TABLE PROPERTY_DIM_TEMP_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE PERIOD_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE RENT_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE LOCATION_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE POSTCODE_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE STATE_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE CATEGORY_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE SCALE_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE TYPE_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE TIME_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE SEASON_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE BUDGET_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE AGENT_OFFICE_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE OFFICE_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE AGENT_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE SALE_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE CLIENT_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE Property_Dim_v2 CASCADE CONSTRAINTS PURGE;
DROP TABLE CLIENT_WISH_DIM_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE VISIT_DIM_V2 CASCADE CONSTRAINTS PURGE;

DROP TABLE ADVERT_FACT_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE CLIENTTEMPFACT CASCADE CONSTRAINTS PURGE;
DROP TABLE CLIENT_FACT_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE VISITTEMPFACT CASCADE CONSTRAINTS PURGE;
DROP TABLE VISIT_FACT_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE AGENT_FACT_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE TEMPRENTFACT CASCADE CONSTRAINTS PURGE;
DROP TABLE RENT_FACT_V2 CASCADE CONSTRAINTS PURGE;
DROP TABLE TEMPSALESFACT CASCADE CONSTRAINTS PURGE;
DROP TABLE SALES_FACT_V2 CASCADE CONSTRAINTS PURGE;


--Creating Version 1 Star Schema
--Creating Feature Dimension
CREATE TABLE Feature_Dim_V1 AS
SELECT * FROM monre.FEATURE;
--Creating Property Dimension



CREATE TABLE Property_Dim_temp_v1 AS 
SELECT property.PROPERTY_ID,PROPERTY_DATE_ADDED,count(f.property_id) as no_of_features,NVL(LISTAGG (F.Feature_code, '_') Within Group (Order By f.feature_code),'No Features')  As PropertyFeatureList,
property_no_of_bedrooms FROM PROPERTY full outer join property_feature f on  property.property_id = f.property_id
group by property.PROPERTY_ID,PROPERTY_DATE_ADDED,property_no_of_bedrooms ;


alter table Property_Dim_temp_v1  add(CategoryID VARCHAR(20));
alter table Property_Dim_temp_v1 add(ScaleID VARCHAR(20));

UPDATE Property_Dim_temp_v1
set ScaleID = 
(case when property_no_of_bedrooms <= 1 then 'Extra Small' 
  when property_no_of_bedrooms >= 2 and property_no_of_bedrooms < 3  then 'Small'
  when property_no_of_bedrooms >= 3 and property_no_of_bedrooms <= 6 then 'Medium'
  when property_no_of_bedrooms >= 6 and property_no_of_bedrooms <= 10 then 'Large'
  when property_no_of_bedrooms > 10  then 'Extra Large' end);


UPDATE Property_Dim_temp_v1
set CategoryID = 
(case when no_of_features >= 0 and no_of_features <= 9 then 'Very Basic' 
  when no_of_features >= 10 and no_of_features <= 20 then 'Standard' 
  when no_of_features > 20  then 'Luxurious' end);

CREATE TABLE Property_Dim_v1 as select * from Property_Dim_temp_v1;
--Creating Table PropertyCategory Dimension

--This table defines property category based on number of features it has
CREATE TABLE Category_Dim_v1 
( CategoryID VARCHAR(15) ,
  Cat_Feature_Range VARCHAR(15));
  
--Populating PropertyCategory Dimension
INSERT INTO Category_Dim_V1 VALUES('Very Basic','0-10');
INSERT INTO Category_Dim_V1 VALUES('Standard','10-20');
INSERT INTO Category_Dim_V1 VALUES('Luxurious','More Than 20');


-- Creating Table Scale Dimension
--This table specifies the Property Scale based on Property Size
CREATE TABLE Scale_Dim_V1
( ScaleID VARCHAR(15) ,
  ScaleRange VARCHAR(15));

--Populating ScaleDim 
INSERT INTO Scale_Dim_V1 VALUES('Extra Small','0-1');
INSERT INTO Scale_Dim_V1 VALUES('Medium','3-6');
INSERT INTO Scale_Dim_V1 VALUES('Large','6-10');
INSERT INTO Scale_Dim_V1 VALUES('Extra Large','More Than 10');

--Creating Rental Dimension
CREATE TABLE RENT_DIM_V1 AS 
SELECT RENT_ID,PROPERTY_ID,RENT_START_DATE,RENT_END_DATE FROM RENT;

ALTER TABLE RENT_DIM_V1 ADD(RENTPERIODID VARCHAR(20));

UPDATE RENT_DIM_V1 SET RENTPERIODID = 'Short' WHERE ((RENT_END_DATE - RENT_START_DATE) > 0 AND (RENT_END_DATE - RENT_START_DATE)  < 180);
UPDATE RENT_DIM_V1 SET RENTPERIODID = 'Medium' WHERE ((RENT_END_DATE - RENT_START_DATE) >= 180 AND (RENT_END_DATE - RENT_START_DATE)  < 365);
UPDATE RENT_DIM_V1 SET RENTPERIODID = 'Short' WHERE ((RENT_END_DATE - RENT_START_DATE) >= 365);

--Creating Location Dimension
CREATE TABLE LOCATION_Dim_V1 AS
SELECT * FROM ADDRESS;

--Creating Table PostCode Dimension
CREATE TABLE POSTCODE_Dim_V1 AS
SELECT * FROM POSTCODE;

--Creating Table State Dimension
CREATE TABLE STATE_Dim_V1 AS
SELECT * FROM State;

--Creating Type Dimension
--This table defines Property type like Apartment / House
CREATE TABLE Type_Dim_V1 AS 
SELECT DISTINCT PROPERTY_TYPE FROM PROPERTY;

--Creating TimeDim 
--this table stores advertisement month and year for properties
CREATE TABLE TIME_DIM_V1 AS 
SELECT DISTINCT TO_CHAR(property_date_added,'YYYY') AS Year FROM PROPERTY;

--Creating Table SEASON  Dimension 
--This table contains Season  data 


CREATE TABLE SEASON_DIM_V1 
(SeasonID VARCHAR(20),
SeasonDesc VARCHAR(20));

CREATE TABLE VISIT_DIM_V1 AS SELECT 
VISIT_DATE ,TO_CHAR(Visit_date,'Day') As VisitDay,TO_CHAR(Visit_date,'Mon') As Month,TO_CHAR(Visit_date,'YYYY') As Year from VISIT;



--Populating Season Dimension
INSERT INTO SEASON_DIM_V1 VALUES('Spring','Sep,Oct,Nov');
INSERT INTO SEASON_DIM_V1 VALUES('Summer','Dec,Jan,Feb');
INSERT INTO SEASON_DIM_V1 VALUES('Autumn','Mar,Apr,May');
INSERT INTO SEASON_DIM_V1 VALUES('Winter','Jun,Jul,Aug');



--Creating ClientBudget Dimension 
CREATE TABLE BUDGET_DIM_V1
( BUDGETID VARCHAR(20),
BUDGETRANGE VARCHAR(20));

--Populating Budget_dimesion
INSERT INTO BUDGET_DIM_V1 VALUES('Low','0-1000');
INSERT INTO BUDGET_DIM_V1 VALUES('Medium','1001-100000');
INSERT INTO BUDGET_DIM_V1 VALUES('High','100001- 10000000');



--Creating Agent_Office DImension
CREATE TABLE AGENT_OFFICE_DIM_V1 AS 
SELECT distinct OFFICE_ID,count(person_id) no_of_agents  FROM AGENT_OFFICE group by office_id;

alter table agent_office_dim_v1 add(Office_Size Varchar(20));

UPDATE agent_office_dim_v1
set Office_Size = 
(case when no_of_agents  >= 0 and  no_of_agents <= 3 then 'Small' 
  when  no_of_agents >= 4 or no_of_agents <= 12 then 'Medium' 
  when no_of_agents > 12 then 'Big'  end);


-- Creating Office Dimension
CREATE TABLE OFFICE_DIM_V1 AS
SELECT * FROM OFFICE;


--Creating Agent Dimension 
CREATE TABLE AGENT_DIM_V1 AS 
SELECT AGENT.PERSON_ID AS AGENT_ID,SALARY,GENDER FROM AGENT LEFT JOIN PERSON ON AGENT.PERSON_ID = PERSON.PERSON_ID;


--Creating Sale Dimension

CREATE TABLE SALE_DIM_V1 AS SELECT 
SALE_ID,SALE_DATE,PROPERTY_ID,PRICE FROM SALE WHERE CLIENT_PERSON_ID IS NOT NULL;



--Creating Client Dimension 
CREATE TABLE CLIENT_DIM_V1 AS SELECT CLIENT.PERSON_ID AS CLIENT_ID,GENDER,NVL(LISTAGG (W.Feature_code, '_') Within Group (Order By W.feature_code),'No Wishes')  As ClientListAgg  
FROM  CLIENT LEFT JOIN PERSON ON CLIENT.PERSON_ID = PERSON.PERSON_ID  LEFT JOIN CLIENT_WISH W ON client.person_id = W.person_id
group by CLIENT.PERSON_ID ,GENDER ;


--Creating FACT TABLES NOW
-- Creating Advert_Fact_V1 
-- This table contains aggeregate values for property advertisements
CREATE TABLE ADVERT_FACT_V1 AS
SELECT TO_CHAR(property_date_added,'YYYY') As Year,property_id , Count(property_id) AS Total_No_Properties 
from property group by TO_CHAR(property_date_added,'YYYY') ,property_id;


--Creating Temp Fact For Client
CREATE TABLE CLIENTTEMPFACT_v1 AS SELECT PERSON_ID AS CLIENT_ID ,MAX_BUDGET FROM CLIENT;

ALTER TABLE CLIENTTEMPFACT_v1 ADD(BUDGETID VARCHAR(20));

UPDATE CLIENTTEMPFACT_v1 
set BudgetID = 
(case when Max_budget >= 0 and Max_Budget <= 1000 then 'Low' 
  when max_budget >= 1001 and max_budget <= 100000 then 'Medium' 
  when max_budget >= 100001 and max_budget <= 10000000 then 'High' end);
  
  
--Creating Client fact
CREATE TABLE CLIENT_FACT_V1 AS 
SELECT BUDGETID,CLIENT_ID ,COUNT(CLIENT_ID) AS TOTAL_NO_CLIENTS FROM CLIENTTEMPFACT_V1 GROUP BY BUDGETID,CLIENT_ID; 

--Creating Visit Temp fact
--Creating Visit Temp fact
CREATE TABLE VISITTEMPFACT_v1 AS 
SELECT VISIT_DATE,PROPERTY_ID,CLIENT_PERSON_ID AS CLIENT_ID FROM VISIT;

ALTER TABLE VISITTEMPFACT_v1 ADD(SEASONID VARCHAR(20));

UPDATE VISITTEMPFACT_v1 
set SeasonID = 
(case when to_char(visit_date,'mm') >= 9 and to_char(visit_date,'mm') <= 11 then 'Spring' 
  when to_char(visit_date,'mm') >= 12 or to_char(visit_date,'mm') <= 02 then 'Summer' 
  when to_char(visit_date,'mm') >= 3 and to_char(visit_date,'mm') <= 5 then 'Autumn' 
  when to_char(visit_date,'mm') >= 6 and to_char(visit_date,'mm') <= 8 then 'Winter' end);

--creating  visitfact table
CREATE TABLE VISIT_FACT_V1 AS 
SELECT SEASONID,VISIT_DATE,PROPERTY_ID,CLIENT_ID,COUNT(*) AS TOTAL_VISITS FROM VISITTEMPFACT_v1  GROUP BY SEASONID,VISIT_DATE,PROPERTY_ID,CLIENT_ID;


--Creating Agent Fact Table
CREATE TABLE AGENT_FACT_V1 AS
SELECT OFFICE_ID,agent.person_id as agent_id,count(agent.person_id) as total_no_agent,sum(salary) as total_agent_earning from 
agent full outer join agent_office  on agent.person_id = agent_office.person_id group by office_id,agent.person_id;

--Creating Temp Rental Fact Table 
CREATE TABLE TEMPRENTFACT_v1 AS 
SELECT property.property_id,rent_id,property.address_id,property_type,rent.agent_person_id as agent_id , rent.client_person_id  as client_id ,
sum(price) as total_rental_fee,count(rent_id) as total_no_of_rent
from property ,rent where property.property_id = rent.rent_id 
group by property.property_id,rent_id,property.address_id,property_type,rent.agent_person_id,rent.client_person_id ;

--Creating rent fact version 2 (low aggregation)
CREATE TABLE RENT_FACT_V1 AS SELECT * FROM TEMPRENTFACT_v1;


 --Creating Temp Sales fact Table
CREATE TABLE TEMPSALESFACT_v1 AS
SELECT property.property_id,sale_id,property.address_id,property_type,sale.agent_person_id as agent_id , sale.client_person_id  as client_id,sum(price) as total_amount_of_sales,count(sale_id) as total_no_of_sale
from property,sale where property.property_id = sale.property_id
and sale.client_person_id is not null
group by property.property_id,sale_id,property.address_id,property_type,sale.agent_person_id  , sale.client_person_id;

CREATE TABLE SALES_FACT_V1 AS SELECT * FROM TEMPSALESFACT_v1;




--Creating Verion 2  Level 0 Star Schema 
--Creating Feature Dimension
CREATE TABLE Feature_Dim_V2 AS
SELECT * FROM monre.FEATURE;

--Creating Property Bridge Table
CREATE TABLE Property_Feature_Bridge AS
SELECT * FROM PROPERTY_FEATURE;

--Creating Property Dimension


CREATE TABLE Property_Dim_temp_v2 AS 
SELECT property.PROPERTY_ID,PROPERTY_DATE_ADDED,count(property_feature.property_id) as no_of_features,property_no_of_bedrooms FROM 
PROPERTY full outer join property_feature on  property.property_id = property_feature.property_id
group by property.PROPERTY_ID,PROPERTY_DATE_ADDED,property_no_of_bedrooms ;


alter table Property_Dim_temp_v2  add(CategoryID VARCHAR(20));
alter table Property_Dim_temp_v2 add(ScaleID VARCHAR(20));

UPDATE Property_Dim_temp_v2
set ScaleID = 
(case when property_no_of_bedrooms <= 1 then 'Extra Small' 
  when property_no_of_bedrooms >= 2 and property_no_of_bedrooms < 3  then 'Small'
  when property_no_of_bedrooms >= 3 and property_no_of_bedrooms <= 6 then 'Medium'
  when property_no_of_bedrooms >= 6 and property_no_of_bedrooms <= 10 then 'Large'
  when property_no_of_bedrooms > 10  then 'Extra Large' end);


UPDATE Property_Dim_temp_v2
set CategoryID = 
(case when no_of_features >= 0 and no_of_features <= 9 then 'Very Basic' 
  when no_of_features >= 10 and no_of_features <= 20 then 'Standard' 
  when no_of_features > 20  then 'Luxurious' end);

CREATE TABLE Property_Dim_v2 as select * from Property_Dim_temp_v2;
CREATE TABLE PERIOD_DIM_V2 (
RENTPERIODID VARCHAR(20) ,
PERIODDESC VARCHAR(20));
INSERT INTO PERIOD_DIM_V2 VALUES('Short','0-6');
INSERT INTO PERIOD_DIM_V2 VALUES('Medium','6-12');
INSERT INTO PERIOD_DIM_V2 VALUES('Long','More than 12');

--Creating Rental Dimension
CREATE TABLE RENT_DIM_V2 AS 
SELECT RENT_ID,PROPERTY_ID,RENT_START_DATE,RENT_END_DATE FROM RENT;

ALTER TABLE RENT_DIM_V2 ADD(RENTPERIODID VARCHAR(20));

UPDATE RENT_DIM_V2 SET RENTPERIODID = 'Short' WHERE ((RENT_END_DATE - RENT_START_DATE) > 0 AND (RENT_END_DATE - RENT_START_DATE)  < 180);
UPDATE RENT_DIM_V2 SET RENTPERIODID = 'Medium' WHERE ((RENT_END_DATE - RENT_START_DATE) >= 180 AND (RENT_END_DATE - RENT_START_DATE)  < 365);
UPDATE RENT_DIM_V2 SET RENTPERIODID = 'Short' WHERE ((RENT_END_DATE - RENT_START_DATE) >= 365);

--Creating Location Dimension
CREATE TABLE LOCATION_Dim_V2 AS
SELECT * FROM ADDRESS;

--Creating Table PostCode Dimension
CREATE TABLE POSTCODE_Dim_V2 AS
SELECT * FROM POSTCODE;

--Creating Table State Dimension
CREATE TABLE STATE_Dim_V2 AS
SELECT * FROM State;

--Creating Table PropertyCategory Dimension
--This table defines property category based on number of features it has
CREATE TABLE Category_Dim_v2 
( CategoryID VARCHAR(15) ,
  Cat_Feature_Range VARCHAR(15));
  
--Populating PropertyCategory Dimension
INSERT INTO Category_Dim_V2 VALUES('Very Basic','0-10');
INSERT INTO Category_Dim_V2 VALUES('Standard','10-20');
INSERT INTO Category_Dim_V2 VALUES('Luxurious','More Than 20');



-- Creating Table Scale Dimension
--This table specifies the Property Scale based on Property Size
CREATE TABLE Scale_Dim_V2
( ScaleID VARCHAR(15) ,
  ScaleRange VARCHAR(15));

--Populating ScaleDim 
INSERT INTO Scale_Dim_V2 VALUES('Extra Small','0-1');
INSERT INTO Scale_Dim_V2 VALUES('Medium','3-6');
INSERT INTO Scale_Dim_V2 VALUES('Large','6-10');
INSERT INTO Scale_Dim_V2 VALUES('Extra Large','More Than 10');

--Creating Type Dimension
--This table defines Property type like Apartment / House
CREATE TABLE Type_Dim_V2 AS 
SELECT DISTINCT PROPERTY_TYPE FROM PROPERTY;

--Creating TimeDim 
--this table stores advertisement month and year for properties
CREATE TABLE TIME_DIM_V2 AS 
SELECT DISTINCT TO_CHAR(property_date_added,'MMYYYY') AS TimeID , TO_CHAR(property_date_added,'Mon') AS Month ,TO_CHAR(property_date_added,'YYYY') AS Year FROM PROPERTY;

--Creating Table SEASON  Dimension 
--This table contains Season  data 


CREATE TABLE SEASON_DIM_V2 
(SeasonID VARCHAR(20),
SeasonDesc VARCHAR(20));


--Populating Season Dimension
INSERT INTO SEASON_DIM_V2 VALUES('Spring','Sep,Oct,Nov');
INSERT INTO SEASON_DIM_V2 VALUES('Summer','Dec,Jan,Feb');
INSERT INTO SEASON_DIM_V2 VALUES('Autumn','Mar,Apr,May');
INSERT INTO SEASON_DIM_V2 VALUES('Winter','Jun,Jul,Aug');



--Creating ClientBudget Dimension 
CREATE TABLE BUDGET_DIM_V2
( BUDGETID VARCHAR(20),
BUDGETRANGE VARCHAR(20));

--Populating Budget_dimesion
INSERT INTO BUDGET_DIM_V2 VALUES('Low','0-1000');
INSERT INTO BUDGET_DIM_V2 VALUES('Medium','1001-100000');
INSERT INTO BUDGET_DIM_V2 VALUES('High','100001- 10000000');



--Creating Agent_Office DImension
CREATE TABLE AGENT_OFFICE_DIM_V2 AS 
SELECT distinct OFFICE_ID,count(person_id) no_of_agents  FROM AGENT_OFFICE group by office_id;

alter table agent_office_dim_v2 add(Office_Size Varchar(20));

UPDATE agent_office_dim_v2
set Office_Size = 
(case when no_of_agents  >= 0 and  no_of_agents <= 3 then 'Small' 
  when  no_of_agents >= 4 or no_of_agents <= 12 then 'Medium' 
  when no_of_agents > 12 then 'Big'  end);


-- Creating Office Dimension
CREATE TABLE OFFICE_DIM_V2 AS
SELECT * FROM OFFICE;

--Creating Agent Dimension 
CREATE TABLE AGENT_DIM_V2 AS 
SELECT AGENT.PERSON_ID AS AGENT_ID,SALARY,GENDER FROM AGENT,PERSON WHERE AGENT.PERSON_ID = PERSON.PERSON_ID;

--Creating Ssle Dimension

CREATE TABLE SALE_DIM_V2 AS SELECT 
SALE_ID,SALE_DATE,PROPERTY_ID,PRICE FROM SALE WHERE CLIENT_PERSON_ID IS NOT NULL;


--Creating Client Dimension 
CREATE TABLE CLIENT_DIM_V2 AS SELECT CLIENT.PERSON_ID AS CLIENT_ID,GENDER  FROM  CLIENT left join PERSON on CLIENT.PERSON_ID = PERSON.PERSON_ID;

--Creating Client WIsh Table


--Creating Visit_DIM_V2
CREATE TABLE VISIT_DIM_V2 AS SELECT 
VISIT_DATE ,TO_CHAR(Visit_date,'Day') As VisitDay,TO_CHAR(Visit_date,'Mon') As Month,TO_CHAR(Visit_date,'YYYY') As Year from VISIT;



--Creating FACT TABLES NOW
-- Creating Advert_Fact_V2 
-- This table contains aggeregate values for property advertisements
CREATE TABLE ADVERT_FACT_V2 AS
SELECT TO_CHAR(property_date_added,'MMYYY') As TimeID,property_id , Count(property_id) AS Total_No_Properties 
from property group by TO_CHAR(property_date_added,'MMYYY') ,property_id;


--Creating Temp Fact For Client
CREATE TABLE CLIENTTEMPFACT AS SELECT PERSON_ID AS CLIENT_ID ,MAX_BUDGET FROM CLIENT;

ALTER TABLE CLIENTTEMPFACT ADD(BUDGETID VARCHAR(20));

UPDATE CLIENTTEMPFACT 
set BudgetID = 
(case when Max_budget >= 0 and Max_Budget <= 1000 then 'Low' 
  when max_budget >= 1001 and max_budget <= 100000 then 'Medium' 
  when max_budget >= 100001 and max_budget <= 10000000 then 'High' end);
  
--Creating Client fact
CREATE TABLE CLIENT_FACT_V2 AS 
SELECT BUDGETID,CLIENT_ID ,COUNT(CLIENT_ID) AS TOTAL_NO_CLIENTS FROM CLIENTTEMPFACT GROUP BY BUDGETID,CLIENT_ID; 





--Creating Visit Temp fact
CREATE TABLE VISITTEMPFACT AS 
SELECT VISIT_DATE,PROPERTY_ID,CLIENT_PERSON_ID AS CLIENT_ID FROM VISIT;

ALTER TABLE VISITTEMPFACT ADD(SEASONID VARCHAR(20));

UPDATE VISITTEMPFACT 
set SeasonID = 
(case when to_char(visit_date,'mm') >= 9 and to_char(visit_date,'mm') <= 11 then 'Spring' 
  when to_char(visit_date,'mm') >= 12 or to_char(visit_date,'mm') <= 02 then 'Summer' 
  when to_char(visit_date,'mm') >= 3 and to_char(visit_date,'mm') <= 5 then 'Autumn' 
  when to_char(visit_date,'mm') >= 6 and to_char(visit_date,'mm') <= 8 then 'Winter' end);

--creating  visitfact table
CREATE TABLE VISIT_FACT_V2 AS 
SELECT SEASONID,VISIT_DATE,PROPERTY_ID,CLIENT_ID,COUNT(*) AS TOTAL_VISITS FROM VISITTEMPFACT  GROUP BY SEASONID,VISIT_DATE,PROPERTY_ID,CLIENT_ID;
SELECT * FROM VISIT_FACT_V2;

--Creating Agent Fact Table
CREATE TABLE AGENT_FACT_V2 AS
SELECT OFFICE_ID,agent.person_id as agent_id,count(agent.person_id) as total_no_agent,sum(salary) as total_agent_earning from 
agent full outer join agent_office  on agent.person_id = agent_office.person_id group by office_id,agent.person_id;


--Creating Temp Rental Fact Table 
CREATE TABLE TEMPRENTFACT AS 
SELECT property.property_id,rent_id,property.address_id,property_type,rent.agent_person_id as agent_id , rent.client_person_id  as client_id ,
sum(price) as total_rental_fee,count(rent_id) as total_no_of_rent
from property ,rent where property.property_id = rent.rent_id 
group by property.property_id,rent_id,property.address_id,property_type,rent.agent_person_id,rent.client_person_id ;

--Creating rent fact version 2 (low aggregation)
CREATE TABLE RENT_FACT_V2 AS SELECT * FROM TEMPRENTFACT;


 --Creating Temp Sales fact Table
CREATE TABLE TEMPSALESFACT AS
SELECT property.property_id,sale_id,property.address_id,property_type,sale.agent_person_id as agent_id , sale.client_person_id  as client_id,sum(price) as total_amount_of_sales,count(sale_id) as total_no_of_sale
from property,sale where property.property_id = sale.property_id
and sale.client_person_id is not null
group by property.property_id,sale_id,property.address_id,property_type,sale.agent_person_id  , sale.client_person_id;

CREATE TABLE SALES_FACT_V2 AS SELECT * FROM TEMPSALESFACT;


