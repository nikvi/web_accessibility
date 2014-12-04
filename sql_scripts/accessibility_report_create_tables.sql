-- Create Table: descriptions
--------------------------------------------------------------------------------
CREATE TABLE descriptions
(   
	id serial PRIMARY KEY 
	,name VARCHAR(250)  NULL 
	,title VARCHAR(250)  NULL 
	,type VARCHAR(250)  NULL 
	,summary VARCHAR(250)  NULL 
);



-- Create Table: pages
--------------------------------------------------------------------------------
CREATE TABLE pages
(
	id serial PRIMARY KEY
	,report_id INTEGER NOT NULL
	,page_url VARCHAR(250)  NULL 
	,page_title VARCHAR(250)  NULL 
	,wave_url VARCHAR(250)  NULL 
);



-- Create Table: reports
--------------------------------------------------------------------------------
CREATE TABLE reports
(
	id serial PRIMARY KEY 
	,report_date TIMESTAMP  NULL 
	,website_id INTEGER NOT NULL 
	,pages_total INTEGER NULL
	,pages_error INTEGER NULL
	,total_errors INTEGER NULL
	,total_alerts INTEGER NULL
);



-- Create Table: websites
--------------------------------------------------------------------------------
CREATE TABLE websites
(
	 id serial PRIMARY KEY 
	,website_url VARCHAR(250)  NULL 
	,website_name VARCHAR(250)  NULL 
);



-- Create Table: categories
--------------------------------------------------------------------------------
CREATE TABLE categories
(
	id serial PRIMARY KEY 
	,page_id INTEGER NOT NULL 
	,category_name VARCHAR(250)  NULL 
	,description_name VARCHAR(250)  NULL 
	,description_title VARCHAR(250)  NULL 
	,count INTEGER  NULL 
);
-- Create table submit
CREATE TABLE submits
(
	id serial PRIMARY KEY 
	, web_url  VARCHAR(250)  NOT NULL
	, report_name  VARCHAR(250)  NULL 
	, pg_urls TEXT NULL
	, email_id VARCHAR(250)  NULL 
	,submit_date TIMESTAMP  NULL
	,report_run_status VARCHAR(25) NOT NULL
);
-- Create Foreign Key: reports.website_id -> websites.id
ALTER TABLE reports ADD CONSTRAINT FK_reports_website_id_websites_id FOREIGN KEY (website_id) REFERENCES websites(id);

-- Create Foreign Key: pages.report_id -> reports.id
ALTER TABLE pages ADD CONSTRAINT FK_pages_report_id_reports_id FOREIGN KEY (report_id) REFERENCES reports(id);

-- Create Foreign Key: categories.page_id -> pages.id
ALTER TABLE categories ADD CONSTRAINT FK_categories_page_id_pages_id FOREIGN KEY (page_id) REFERENCES pages(id);

-- Created enum for report request status
#CREATE TYPE REPORT_STATUS AS ENUM ('submit', 'running', 'complete','fail');




