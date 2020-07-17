---Deleting duplicate tables

Drop table Advertisement cascade constraints purge;
Drop table Person cascade constraints purge;
Drop table Address cascade constraints purge;
Drop table Postcode cascade constraints purge;
Drop table office cascade constraints PURGE;
Drop table State cascade constraints purge;
Drop table Agent cascade constraints purge;
Drop table Agent_Office cascade constraints purge;
Drop table Visit cascade constraints purge;
Drop table client cascade constraints purge;
Drop table Sale cascade constraints purge;
Drop table Rent cascade constraints purge;
Drop table client_wish cascade constraints purge;
Drop table feature cascade constraints purge;
Drop table property_feature cascade constraints purge;
Drop table property cascade constraints purge;
Drop table Property_Advert cascade constraints purge;


---Data Exploration For Person Table



SELECT * FROM  MONRE.PERSON; 

SELECT PERSON_ID ,COUNT(*)  FROM MONRE.PERSON GROUP BY PERSON_ID HAVING COUNT(*) > 1;

SELECT ADDRESS_ID  FROM MONRE.PERSON WHERE ADDRESS_ID NOT IN (Select  DISTINCT ADDRESS_ID FROM MONRE.ADDRESS);

SELECT * FROM MONRE.PERSON WHERE ADDRESS_ID = 13205;

--Data Cleaning 
-- Creating Person Table
CREATE TABLE PERSON AS SELECT DISTINCT * FROM MONRE.PERSON WHERE PERSON_ID <> 7001; 

SELECT COUNT(*) FROM PERSON;

SELECT * FROM PERSON WHERE PERSON_ID = 7000;

---Data Exploration For Address Table
SELECT ADDRESS_ID ,COUNT(*)  FROM MONRE.ADDRESS GROUP BY ADDRESS_ID HAVING COUNT(*) > 1;

--Creating Address Table 
CREATE TABLE ADDRESS AS SELECT DISTINCT * FROM MONRE.ADDRESS;

--Data Exploration For Postcode Table 
SELECT POSTCODE FROM MONRE.POSTCODE WHERE STATE_CODE NOT IN (SELECT DISTINCT STATE_CODE FROM MONRE.STATE);

--Creating Postcode Table 
CREATE TABLE POSTCODE  AS SELECT DISTINCT * FROM MONRE.POSTCODE;

--Data Exploration For State Table 
SELECT * FROM MONRE.STATE;

--Data Cleaning and Creating State Table 
CREATE TABLE STATE AS SELECT * FROM MONRE.STATE WHERE STATE_CODE IS NOT NULL;

SELECT * FROM STATE;

--Data Exploration For Agent Table 
SELECT COUNT(*) FROM MONRE.AGENT;

SELECT COUNT(DISTINCT PERSON_ID) FROM MONRE.AGENT;

SELECT PERSON_ID FROM MONRE.AGENT WHERE SALARY < 0;

--Data Cleaning and Creating Agent Table 
CREATE TABLE AGENT AS SELECT DISTINCT * FROM MONRE.AGENT WHERE SALARY >= 0;

SELECT PERSON_ID FROM AGENT WHERE SALARY < 0;

--Data Exploration For Agent_Office Table

SELECT COUNT(*) FROM MONRE.AGENT_OFFICE WHERE PERSON_ID = 6844 OR PERSON_ID = 6000 ;

CREATE TABLE AGENT_OFFICE AS SELECT * FROM MONRE.AGENT_OFFICE;

--Creating Office Table
CREATE TABLE OFFICE AS SELECT * FROM MONRE.OFFICE;

--Exploring Visit Table

SELECT * FROM MONRE.VISIT WHERE CLIENT_PERSON_ID NOT IN (SELECT PERSON_ID FROM MONRE.CLIENT);

SELECT * FROM MONRE.VISIT WHERE AGENT_PERSON_ID NOT IN (SELECT PERSON_ID FROM MONRE.AGENT);

--Creating Visit Table

CREATE TABLE VISIT AS SELECT * FROM MONRE.VISIT WHERE CLIENT_PERSON_ID <> 6000;

SELECT * FROM VISIT WHERE CLIENT_PERSON_ID = 5902;

--Exploring Client Table 
SELECT  * FROM MONRE.CLIENT WHERE MIN_BUDGET > MAX_BUDGET;

SELECT  * FROM MONRE.CLIENT WHERE PERSON_ID NOT IN(SELECT PERSON_ID FROM MONRE.PERSON);
--Creating Client table 
CREATE TABLE CLIENT AS SELECT * FROM MONRE.CLIENT WHERE MIN_BUDGET <= MAX_BUDGET AND PERSON_ID <> 7000;

SELECT  * FROM CLIENT WHERE MIN_BUDGET > MAX_BUDGET;

SELECT  * FROM CLIENT WHERE PERSON_ID = 7000;


--Exploring Sale Table 
SELECT * FROM MONRE.SALE WHERE AGENT_PERSON_ID NOT IN( SELECT PERSON_ID FROM MONRE.AGENT);

SELECT * FROM MONRE.SALE WHERE CLIENT_PERSON_ID NOT IN( SELECT PERSON_ID FROM MONRE.CLIENT);

SELECT * FROM MONRE.SALE WHERE PROPERTY_ID NOT IN(SELECT PROPERTY_ID FROM MONRE.PROPERTY);

SELECT * FROM MONRE.SALE WHERE SALE_DATE > SYSDATE;

SELECT * FROM MONRE.SALE WHERE PRICE < 0;

--Creating Sale table
CREATE TABLE SALE AS SELECT * FROM MONRE.SALE;

--Exploring Rent Table
SELECT * FROM MONRE.RENT WHERE RENT_START_DATE > RENT_END_DATE;

SELECT * FROM MONRE.RENT WHERE AGENT_PERSON_ID NOT IN (SELECT PERSON_ID FROM MONRE.AGENT);

SELECT * FROM MONRE.RENT WHERE CLIENT_PERSON_ID NOT IN (SELECT PERSON_ID FROM MONRE.CLIENT);

--Creating Table Rent
CREATE TABLE RENT AS SELECT * FROM MONRE.RENT WHERE RENT_START_DATE < RENT_END_DATE;

SELECT * FROM RENT WHERE RENT_START_DATE > RENT_END_DATE;

--Exploring Feature ,Property Feature and Client Wish 

SELECT *  FROM MONRE.CLIENT_WISH WHERE PERSON_ID NOT IN (SELECT PERSON_ID FROM MONRE.CLIENT);
SELECT * FROM MONRE.CLIENT_WISH WHERE FEATURE_CODE NOT IN (SELECT FEATURE_CODE FROM MONRE.FEATURE);

SELECT COUNT(*) FROM MONRE.FEATURE;

SELECT * FROM MONRE.PROPERTY_FEATURE WHERE PROPERTY_ID NOT IN (SELECT PROPERTY_ID FROM MONRE.PROPERTY);


--Creating tables client_wish , feature and property_feature
CREATE TABLE CLIENT_WISH AS SELECT * FROM MONRE.CLIENT_WISH;
CREATE TABLE FEATURE AS SELECT * FROM MONRE.FEATURE;
CREATE TABLE PROPERTY_FEATURE AS SELECT * FROM MONRE.PROPERTY_FEATURE;


--Exploring Property Table
SELECT PROPERTY_ID , COUNT(*) FROM  MONRE.PROPERTY GROUP BY PROPERTY_ID HAVING COUNT(*) > 1;

-- Creating Property Table

CREATE TABLE PROPERTY AS SELECT DISTINCT * FROM MONRE.PROPERTY;

SELECT PROPERTY_ID , COUNT(*) FROM PROPERTY GROUP BY PROPERTY_ID HAVING COUNT(*) > 1;

--Exploring Property Advert and Advertisement table
SELECT PROPERTY_ID FROM MONRE.PROPERTY_ADVERT WHERE PROPERTY_ID NOT IN (SELECT PROPERTY_ID FROM MONRE.PROPERTY);

SELECT ADVERT_ID FROM MONRE.PROPERTY_ADVERT WHERE ADVERT_ID NOT IN (SELECT ADVERT_ID FROM MONRE.ADVERTISEMENT);

SELECT * FROM MONRE.PROPERTY_ADVERT WHERE COST < 0;

SELECT COUNT(*) FROM MONRE.ADVERTISEMENT;

SELECT COUNT(DISTINCT ADVERT_ID) FROM MONRE.ADVERTISEMENT;

--Creating Table Property_Advert
CREATE TABLE PROPERTY_ADVERT AS SELECT * FROM MONRE.PROPERTY_ADVERT;
--Creating Table Advertisement
CREATE TABLE ADVERTISEMENT AS SELECT * FROM MONRE.ADVERTISEMENT;